import 'package:bible_app/features/bible/presentation/ui/bookmark/bookmark_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';

class BookmarkedVersesScreen extends StatelessWidget {
  const BookmarkedVersesScreen({super.key});

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

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final verse = bookmarks[index];
              final reference =
                  '${verse.bookName} ${verse.chapter}:${verse.verse}';

              return BookmarkCard(verse: verse, reference: reference);
            },
          );
        },
      ),
    );
  }
}
