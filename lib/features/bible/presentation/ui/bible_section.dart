import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/common/utils/share.dart';
import 'package:bible_app/common/widgets/contained_icon_button.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/verse_block.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BibleSection extends StatefulWidget {
  const BibleSection({
    required this.pageContent,
    required this.isVerseSelecting,
    required this.selectedVerses,
    required this.resetSelection,
    super.key,
  });

  final List<Widget> pageContent;
  final bool isVerseSelecting;
  final List<Verse> selectedVerses;
  final VoidCallback resetSelection;

  @override
  State<BibleSection> createState() => _BibleSectionState();
}

class _BibleSectionState extends State<BibleSection> {
  final GlobalKey _shareKey = GlobalKey();
  final ItemScrollController itemScrollController = ItemScrollController();

  Future<void> _scrollToVerse() async {
    final bibleBloc = context.read<BibleBloc>();
    final state = bibleBloc.state;
    final currentPage = state.currentPage;

    AppLogger.info(
      'scrolling to verse ${currentPage.verse ?? 'top'}',
      name: 'BibleSection: _scrollToVerse',
    );

    if (currentPage.scrollToVerse) {
      if (currentPage.verse == null) return;
      await itemScrollController
          .scrollTo(
            index: currentPage.verse! + 1,
            duration: const Duration(milliseconds: 500),
          )
          .then((_) {
            bibleBloc.changeChapter(
              BiblePage(
                book: currentPage.book,
                chapter: currentPage.chapter,
                scrollToVerse: true,
              ),
            );
          });
    }
  }

  void _scrollToTop() {
    itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final currentPage = state.currentPage;

        final chapterCount =
            state.currentBible?.verses
                .where((v) => v.book == currentPage.book && v.verse == 1)
                .length ??
            1;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToVerse();
        });

        return Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildSelectedVersesImageWidget(
                  widget.selectedVerses,
                  _shareKey,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  itemBuilder: (context, index) => widget.pageContent[index],
                  itemCount: widget.pageContent.length,
                ),
              ),
              if (currentPage.chapter > 1)
                Positioned(
                  bottom: 16,
                  left: 12,
                  child: _chapterNavigator(() {
                    bibleBloc.changeChapter(
                      state.currentPage.copyWith(
                        chapter: state.currentPage.chapter - 1,
                        scrollToVerse: false,
                      ),
                    );
                    widget.resetSelection();
                    _scrollToTop();
                  }, Icons.chevron_left),
                ),
              if (state.currentPage.chapter < chapterCount)
                Positioned(
                  bottom: 16,
                  right: 12,
                  child: _chapterNavigator(() {
                    bibleBloc.changeChapter(
                      currentPage.copyWith(
                        chapter: currentPage.chapter + 1,
                        scrollToVerse: false,
                      ),
                    );
                    widget.resetSelection();
                    _scrollToTop();
                  }, Icons.chevron_right),
                ),
              if (widget.isVerseSelecting)
                Positioned(
                  bottom: 16,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.baseWhite,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          spacing: 15,
                          children: [
                            ContainedIconButton(
                              action: () async {
                                await shareCapturedWidget(_shareKey);
                                widget.resetSelection();
                              },
                              icon: Icons.share_outlined,
                            ),
                            ContainedIconButton(
                              action: () async {
                                await bibleBloc.setVersesAsBookMark(
                                  widget.selectedVerses,
                                );
                                widget.resetSelection();

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'The verse/s has/ve been bookmarked',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: Icons.bookmark_outline,
                            ),
                            ContainedIconButton(
                              action: () {
                                final bookName =
                                    widget.selectedVerses.first.bookName;
                                final chapter =
                                    widget.selectedVerses.first.chapter;
                                final versesFrom = '$bookName $chapter';
                                final versesToCopy = widget.selectedVerses
                                    .map((v) => '${v.verse} ${v.text}')
                                    .join('\n');
                                Clipboard.setData(
                                  ClipboardData(
                                    text: '$versesFrom: $versesToCopy',
                                  ),
                                );
                              },
                              icon: Icons.copy,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedVersesImageWidget(
    List<Verse> selectedVerses,
    GlobalKey shareKey,
  ) {
    return RepaintBoundary(
      key: shareKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: selectedVerses.map((verse) {
          return VerseBlock(verse: verse, onLongPress: () {}, onTap: () {});
        }).toList(),
      ),
    );
  }

  Widget _chapterNavigator(VoidCallback callbackFn, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.baseWhite,
        shape: BoxShape.circle,
      ),
      child: ContainedIconButton(action: callbackFn, icon: icon),
    );
  }
}
