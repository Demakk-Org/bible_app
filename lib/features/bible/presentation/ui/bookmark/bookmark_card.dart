import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    required this.verse,
    required this.reference,
    super.key,
  });

  final Verse verse;
  final String reference;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();

    return Material(
      color: AppColors.baseWhite,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        title: Text(
          verse.text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'JosefinSans'),
        ),
        subtitle: Text(
          reference,
          style: const TextStyle(
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            bibleBloc.removeBookmark(verse);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Removed $reference')),
            );
          },
          icon: const Icon(Icons.delete_outline, size: 20),
        ),
        onTap: () {
          final newPage = BiblePage(
            book: verse.book,
            chapter: verse.chapter,
            verse: verse.verse,
            scrollToVerse: true,
          );
          bibleBloc.changeChapter(newPage);
          BibleRoute().go(context);
        },
      ),
    );
  }
}