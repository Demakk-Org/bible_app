import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';

enum Size { small, medium, large }

class SearchDisplayGroupedByBook extends StatelessWidget {
  const SearchDisplayGroupedByBook({required this.verses, super.key});

  final List<Verse> verses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          verses.first.bookName,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        10.hh,
        Row(
          children: [
            13.ww,
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  border: const Border(
                    left: BorderSide(width: 5, color: AppColors.primary),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: verses
                      .map((verse) => SearchPreviewVerse(verse: verse))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

int referenceSize(Size size) {
  switch (size) {
    case Size.small:
      return 10;
    case Size.medium:
      return 12;
    case Size.large:
      return 14;
  }
}

int textSize(Size size) {
  switch (size) {
    case Size.small:
      return 12;
    case Size.medium:
      return 14;
    case Size.large:
      return 16;
  }
}

int gapSize(Size size) {
  switch (size) {
    case Size.small:
      return 2;
    case Size.medium:
      return 5;
    case Size.large:
      return 10;
  }
}

class SearchPreviewVerse extends StatelessWidget {
  const SearchPreviewVerse({
    required this.verse,
    this.highlightVerse = true,
    this.isRedirected = false,
    this.size = Size.medium,
    super.key,
  });

  final Verse verse;
  final bool highlightVerse;
  final bool isRedirected;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    final query = bibleBloc.state.searchFilter?.query ?? '';
    final isBookMarked =
        bibleBloc.state.bookmarkedVerses?.any(
          (v) =>
              v.bookName == verse.bookName &&
              v.chapter == verse.chapter &&
              v.verse == verse.verse,
        ) ??
        false;
    final highlightedText = buildHighlightedText(
      verse.text,
      query,
      highlightVerse,
    );

    if (bibleBloc.state.isRedirected != isRedirected) {
      bibleBloc.changeIsRedirectedStatus(isRedirected);
    }

    return GestureDetector(
      onTap: () {
        final newPage = BiblePage(
          book: verse.book,
          chapter: verse.chapter,
          verse: verse.verse,
          scrollToVerse: true,
        );

        bibleBloc.changeChapter(newPage);

        if (!isRedirected) {
          Navigator.pop(context);
        } else {
          BibleRoute().push<void>(context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(),
            child: highlightedText,
          ),
          gapSize(size).hh,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${verse.bookName} ${verse.chapter}:${verse.verse}',
                style: TextStyle(
                  fontSize: referenceSize(size).toDouble(),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              InkWell(
                onTap: () {
                  bibleBloc.setVersesAsBookMark([verse]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verse added to bookmarks'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: Center(
                    child: Icon(
                      isBookMarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text buildHighlightedText(
    String fullText,
    String query,
    bool highlightVerse,
  ) {
    final parts = fullText.split(' ');
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: textSize(size).toDouble(),
          fontFamily: 'Poppins',
          color: AppColors.baseBlack,
        ),
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            TextSpan(
              text: parts[i],
              style:
                  (parts[i].toLowerCase().contains(
                        query.trim().toLowerCase(),
                      ) &&
                      highlightVerse)
                  ? const TextStyle(backgroundColor: Color(0xFF5CA9D0))
                  : null,
            ),
            if (i < parts.length - 1) const TextSpan(text: ' '),
          ],
        ],
      ),
    );
  }
}
