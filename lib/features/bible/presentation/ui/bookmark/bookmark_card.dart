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
    super.key,
    this.tileKey,
    this.deleteButtonKey,
  });

  final Verse verse;
  final GlobalKey? tileKey;
  final GlobalKey? deleteButtonKey;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();

    final currentBible = bibleBloc.state.currentBible;
    Verse displayVerse = verse;
    if (currentBible != null) {
      try {
        displayVerse = currentBible.getVerse(
          book: verse.book,
          chapter: verse.chapter,
          verse: verse.verse,
        );
      } on StateError {
        displayVerse = verse;
      }
    }

    return Material(
      color: AppColors.baseWhite,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        key: tileKey,
        title: Text(
          displayVerse.text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'JosefinSans'),
        ),
        subtitle: Text(
          displayVerse.getReference(),
          style: const TextStyle(
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton.filled(
          key: deleteButtonKey,
          style: IconButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            minimumSize: const Size(32, 32),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            bibleBloc.removeBookmark(verse);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Removed ${displayVerse.getReference()}')),
            );
          },
          icon: const Icon(Icons.delete_outline, size: 18),
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
