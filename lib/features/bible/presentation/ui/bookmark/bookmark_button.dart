import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      buildWhen: (previous, current) =>
          previous.bookmarkedVerses != current.bookmarkedVerses,
      builder: (context, state) {
        final count = state.bookmarkedVerses?.length ?? 0;
        final label = count > 99 ? '99+' : count.toString();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: AppColors.baseWhite),
              highlightColor: AppColors.baseWhite,
              onPressed: () {
                BookmarksRoute().push(context);
              },
              icon: const Icon(
                Icons.bookmark_outline,
                color: AppColors.baseBlack,
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
