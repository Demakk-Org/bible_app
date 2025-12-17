import 'package:bible_app/features/bible/presentation/ui/bookmark/bookmark_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/tutorial/presentation/cubit/tutorial_cubit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BookmarkedVersesScreen extends StatefulWidget {
  const BookmarkedVersesScreen({super.key});

  @override
  State<BookmarkedVersesScreen> createState() => _BookmarkedVersesScreenState();
}

class _BookmarkedVersesScreenState extends State<BookmarkedVersesScreen> {
  final GlobalKey _firstBookmarkTileKey = GlobalKey();
  final GlobalKey _firstBookmarkDeleteKey = GlobalKey();

  bool _tutorialShown = false;

  void _showBookmarksTutorial() {
    final tutorialCubit = context.read<TutorialCubit>();

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'bookmark_tap',
        keyTarget: _firstBookmarkTileKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              'Tap a bookmark to jump to that verse in the Bible.',
              textAlign: TextAlign.center,
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
        identify: 'bookmark_delete',
        keyTarget: _firstBookmarkDeleteKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            child: const Text(
              'Use this button to remove a bookmark.',
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
      onFinish: tutorialCubit.completeBookmarksTutorial,
      onSkip: () {
        tutorialCubit.completeBookmarksTutorial();
        return true;
      },
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.baseWhite,
      ),
      body: BlocBuilder<BibleBloc, BibleState>(
        builder: (context, state) {
          final bookmarks = state.bookmarkedVerses ?? const <Verse>[];

          if (bookmarks.isEmpty) {
            return Center(
              child: Text(
                'No bookmarked verses yet.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontFamily: "Poppins"),
              ),
            );
          }

          final tutorialState = context.read<TutorialCubit>().state;
          if (!_tutorialShown && tutorialState.showBookmarksTutorial) {
            _tutorialShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (bookmarks.isEmpty) return;
              _showBookmarksTutorial();
            });
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final verse = bookmarks[index];

              return BookmarkCard(
                verse: verse,
                tileKey: index == 0 ? _firstBookmarkTileKey : null,
                deleteButtonKey: index == 0 ? _firstBookmarkDeleteKey : null,
              );
            },
          );
        },
      ),
    );
  }
}
