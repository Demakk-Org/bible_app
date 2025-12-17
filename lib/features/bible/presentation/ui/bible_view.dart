import 'package:bible_app/features/bible/presentation/ui/bible_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/bible_section.dart';
import 'package:bible_app/features/bible/presentation/ui/search_drawer_view.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/select_bible_view.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/verse_block.dart';
import 'package:bible_app/features/tutorial/presentation/cubit/tutorial_cubit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _bookChapterPickerKey = GlobalKey();
  final GlobalKey _bookmarksButtonKey = GlobalKey();
  final GlobalKey _searchButtonKey = GlobalKey();
  final GlobalKey _versesListKey = GlobalKey();
  final GlobalKey _shareVerseButtonKey = GlobalKey();
  final GlobalKey _bookmarkVerseButtonKey = GlobalKey();
  final GlobalKey _copyVerseButtonKey = GlobalKey();

  bool _tutorialShown = false;

  bool isVerseSelecting = false;
  List<Verse> selectedVerses = [];
  // todo(melkatole1): move this to a bloc

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void resetSelection() {
    setState(() {
      isVerseSelecting = false;
      selectedVerses = [];
    });
  }

  void _showBibleTutorial(List<Verse> verses) {
    final tutorialCubit = context.read<TutorialCubit>();

    if (!isVerseSelecting && verses.isNotEmpty) {
      setState(() {
        isVerseSelecting = true;
        selectedVerses = [verses.first];
      });
    }

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'book_chapter_picker',
        keyTarget: _bookChapterPickerKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              'Tap here to change the book and chapter.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'bookmarks',
        keyTarget: _bookmarksButtonKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              'View your bookmarked verses here.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'search',
        keyTarget: _searchButtonKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              'Search for verses and jump directly to results.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'verses',
        keyTarget: _versesListKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Long-press a verse to start selecting. Then you can share, bookmark, or copy selected verses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'verse_share',
        keyTarget: _shareVerseButtonKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              'After long-pressing a verse, use this button to share the selected verse(s).',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'verse_bookmark',
        keyTarget: _bookmarkVerseButtonKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              'Bookmark the selected verse(s) so you can find them later.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'verse_copy',
        keyTarget: _copyVerseButtonKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              'Copy the selected verse(s) to your clipboard.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      hideSkip: false,
      textSkip: 'SKIP',
      paddingFocus: 8,
      opacityShadow: 0.8,
      onFinish: () {
        tutorialCubit.completeBibleTutorial();
        resetSelection();
      },
      onSkip: () {
        tutorialCubit.completeBibleTutorial();
        resetSelection();
        return true;
      },
    ).show(context: context);
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

          if (!_tutorialShown && bible != null && !state.isSelectingBible) {
            final tutorialState = context.read<TutorialCubit>().state;
            if (tutorialState.showBibleTutorial) {
              _tutorialShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _showBibleTutorial(verses);
              });
            }
          }

          return Column(
            children: [
              BibleAppBar(
                searchCallbackFn: _openDrawer,
                bookChapterPickerKey: _bookChapterPickerKey,
                bookmarksButtonKey: _bookmarksButtonKey,
                searchButtonKey: _searchButtonKey,
              ),
              if (!state.isSelectingBible)
                KeyedSubtree(
                  key: _versesListKey,
                  child: BibleSection(
                    pageContent: pageContent,
                    isVerseSelecting: isVerseSelecting,
                    selectedVerses: selectedVerses,
                    resetSelection: resetSelection,
                    shareButtonKey: _shareVerseButtonKey,
                    bookmarkButtonKey: _bookmarkVerseButtonKey,
                    copyButtonKey: _copyVerseButtonKey,
                  ),
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
