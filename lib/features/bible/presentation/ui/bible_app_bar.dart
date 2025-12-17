import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/bookmark/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BibleAppBar extends StatelessWidget {
  const BibleAppBar({
    required this.searchCallbackFn,
    required this.bookChapterPickerKey,
    required this.bookmarksButtonKey,
    required this.searchButtonKey,
    super.key,
  });

  final VoidCallback searchCallbackFn;
  final GlobalKey bookChapterPickerKey;
  final GlobalKey bookmarksButtonKey;
  final GlobalKey searchButtonKey;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final bible = state.currentBible!;
        final currentPage = state.currentPage;
        final bookName = bible.verses
            .firstWhere((v) => v.book == currentPage.book)
            .bookName;
        final isSelectingBible = state.isSelectingBible;
        return Container(
          padding: const EdgeInsets.only(
            top: 45,
            left: 22,
            right: 22,
            bottom: 8.3,
          ),
          decoration: BoxDecoration(color: AppColors.primary),
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
              KeyedSubtree(
                key: bookChapterPickerKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1.5,
                  ),
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
                        decoration: const BoxDecoration(
                          color: AppColors.baseWhite,
                        ),
                      ),
                      _CurrentBibleInfo(
                        label: bible.shortName,
                        callback: bibleBloc.openBibleSelectView,
                        isActive: isSelectingBible,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSelectingBible)
                      IconButton.filled(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Feature is not ready at the moment',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                      )
                    else ...[
                      KeyedSubtree(
                        key: bookmarksButtonKey,
                        child: const BookmarkButton(),
                      ),
                      KeyedSubtree(
                        key: searchButtonKey,
                        child: IconButton.filled(
                          onPressed: () {
                            searchCallbackFn();
                            bibleBloc.closeBibleSelectView();
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
