import 'package:bible_app/features/bible/presentation/ui/bookmark/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/bible_section.dart';
import 'package:bible_app/features/bible/presentation/ui/search_drawer_view.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/select_bible_view.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/verse_block.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVerseSelecting = false;
  List<Verse> selectedVerses = [];

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void resetSelection() {
    setState(() {
      isVerseSelecting = false;
      selectedVerses = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const SearchDrawerView(),
      body: BlocBuilder<BibleBloc, BibleState>(
        builder: (context, state) {
          final bible = state.currentBible;
          final currentPage = state.currentPage;
          final verses =
              bible?.verses
                  .where(
                    (v) =>
                        v.book == currentPage.book &&
                        v.chapter == currentPage.chapter,
                  )
                  .toList() ??
              [];

          final versesBlock = _buildVerses(
            verses,
            state.bookmarkedVerses ?? [],
          );
          final chapter = _titleBlock(currentPage.chapter);
          const topPadding = SizedBox(height: 20);
          const bottomPadding = SizedBox(height: 60);

          final pageContent = [
            topPadding,
            chapter,
            ...versesBlock,
            bottomPadding,
          ];

          return Column(
            children: [
              _BibleAppBar(
                bible: bible!,
                currentPage: currentPage,
                searchCallbackFn: _openDrawer,
              ),
              if (!state.isSelectingBible)
                BibleSection(
                  pageContent: pageContent,
                  isVerseSelecting: isVerseSelecting,
                  selectedVerses: selectedVerses,
                  resetSelection: resetSelection,
                ),
              if (state.isSelectingBible) const SelectBibleView(),
            ],
          );
        },
      ),
    );
  }

  Widget _titleBlock(int chapter) {
    return Text(
      'Chapter $chapter',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        height: 22 / 24,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.bold,
        color: AppColors.baseBlack,
      ),
    );
  }

  List<VerseBlock> _buildVerses(
    List<Verse> verses,
    List<Verse> bookmarkedVerses,
  ) {
    return verses.map((verse) {
      final isBookmarked = bookmarkedVerses
          .where(
            (v) =>
                v.bookName == verse.bookName &&
                v.chapter == verse.chapter &&
                v.verse == verse.verse,
          )
          .isNotEmpty;
      return VerseBlock(
        isSelected: selectedVerses.contains(verse),
        isBookmarked: isBookmarked,
        verse: verse,
        onLongPress: () {
          setState(() {
            if (!isVerseSelecting) {
              isVerseSelecting = true;
              selectedVerses.add(verse);
            }
          });
        },
        onTap: () {
          if (!isVerseSelecting) return;
          setState(() {
            if (selectedVerses.contains(verse)) {
              selectedVerses.remove(verse);
            } else {
              selectedVerses.add(verse);
            }

            if (selectedVerses.isEmpty) {
              isVerseSelecting = false;
            }
          });
        },
      );
    }).toList();
  }
}

class _BibleAppBar extends StatelessWidget {
  const _BibleAppBar({
    required this.bible,
    required this.currentPage,
    required this.searchCallbackFn,
  });

  final Bible bible;
  final BiblePage currentPage;
  final VoidCallback searchCallbackFn;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    final bookName = bible.verses
        .firstWhere((v) => v.book == currentPage.book)
        .bookName;
    final isSelectingBible = bibleBloc.state.isSelectingBible;
    return Container(
      padding: const EdgeInsets.only(top: 45, left: 22, right: 22, bottom: 8.3),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (bibleBloc.state.isRedirected)
            IconButton.filled(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.baseWhite),
            ),
            child: Row(
              spacing: 10,
              children: [
                _CurrentBibleInfo(
                  label: '$bookName ${currentPage.chapter}',
                  callback: () {
                    if (bibleBloc.state.isSelectingBible) {
                      bibleBloc.closeBibleSelectView();
                      return;
                    }
                    BibleNavigationRoute().push<void>(context);
                  },
                  isActive: !isSelectingBible,
                ),
                Container(
                  height: 25,
                  width: 1,
                  decoration: const BoxDecoration(color: AppColors.baseWhite),
                ),
                _CurrentBibleInfo(
                  label: bible.shortName,
                  callback: bibleBloc.openBibleSelectView,
                  isActive: isSelectingBible,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BookmarkButton(),
                IconButton.filled(
                  onPressed: () {
                    searchCallbackFn();
                    bibleBloc.closeBibleSelectView();
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentBibleInfo extends StatelessWidget {
  const _CurrentBibleInfo({
    required this.label,
    required this.callback,
    required this.isActive,
  });

  final String label;
  final VoidCallback callback;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          height: 22 / 16,
          fontFamily: 'JosefinSans',
          color: isActive
              ? AppColors.baseWhite
              : AppColors.baseWhite.withAlpha(127),
        ),
      ),
    );
  }
}
