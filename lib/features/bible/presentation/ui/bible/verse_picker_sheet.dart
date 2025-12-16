import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';

class VersePickerSheet extends StatefulWidget {
  const VersePickerSheet({super.key});

  static Future<Verse?> show(BuildContext context) {
    return showModalBottomSheet<Verse?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.baseWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const VersePickerSheet(),
    );
  }

  @override
  State<VersePickerSheet> createState() => _VersePickerSheetState();
}

class _VersePickerSheetState extends State<VersePickerSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, bibleState) {
        final verses = bibleState.currentBible?.verses ?? <Verse>[];
        final books = verses
            .where((v) => v.chapter == 1 && v.verse == 1)
            .toList();
        var selectedBook = books.isNotEmpty ? (bibleState.currentPage.book) : 1;
        var selectedChapter = bibleState.currentPage.chapter;
        var selectedVerse = 1;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final chapters = verses
                .where((v) => v.book == selectedBook && v.verse == 1)
                .map((v) => v.chapter)
                .toList();
            if (!chapters.contains(selectedChapter) && chapters.isNotEmpty) {
              selectedChapter = chapters.first;
            }
            final chapterVerses = verses
                .where(
                  (v) => v.book == selectedBook && v.chapter == selectedChapter,
                )
                .map((v) => v.verse)
                .toList();
            if (!chapterVerses.contains(selectedVerse) &&
                chapterVerses.isNotEmpty) {
              selectedVerse = chapterVerses.first;
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview of currently selected verse
                    Builder(
                      builder: (context) {
                        final matching = verses
                            .where(
                              (v) =>
                                  v.book == selectedBook &&
                                  v.chapter == selectedChapter &&
                                  v.verse == selectedVerse,
                            )
                            .toList();
                        final selected = matching.isNotEmpty
                            ? matching.first
                            : null;
                        final previewText = selected?.text ?? '';
                        final previewRef = selected != null
                            ? '${selected.bookName} ${selected.chapter}:${selected.verse}'
                            : '';
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (previewText.isNotEmpty)
                                Text(
                                  previewText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    fontFamily: 'JosefinSans',
                                    color: AppColors.baseBlack,
                                  ),
                                ),
                              if (previewRef.isNotEmpty)
                                const SizedBox(height: 8),
                              if (previewRef.isNotEmpty)
                                Text(
                                  previewRef,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'JosefinSans',
                                    color: AppColors.baseBlack,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          // Books
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final book = books[index];
                                  final isSelected = book.book == selectedBook;
                                  return InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        selectedBook = book.book;
                                        final newChapters = verses
                                            .where(
                                              (v) =>
                                                  v.book == selectedBook &&
                                                  v.verse == 1,
                                            )
                                            .map((v) => v.chapter)
                                            .toList();
                                        selectedChapter = newChapters.isNotEmpty
                                            ? newChapters.first
                                            : 1;
                                        final newVerses = verses
                                            .where(
                                              (v) =>
                                                  v.book == selectedBook &&
                                                  v.chapter == selectedChapter,
                                            )
                                            .map((v) => v.verse)
                                            .toList();
                                        selectedVerse = newVerses.isNotEmpty
                                            ? newVerses.first
                                            : 1;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 8,
                                      ),
                                      color: !isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: Text(
                                        book.bookName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemCount: books.length,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Chapters
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final chapterNum = chapters[index];
                                  final isSelected =
                                      chapterNum == selectedChapter;
                                  return InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        selectedChapter = chapterNum;
                                        final newVerses = verses
                                            .where(
                                              (v) =>
                                                  v.book == selectedBook &&
                                                  v.chapter == selectedChapter,
                                            )
                                            .map((v) => v.verse)
                                            .toList();
                                        selectedVerse = newVerses.isNotEmpty
                                            ? newVerses.first
                                            : 1;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      color: !isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: Text(
                                        chapterNum.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemCount: chapters.length,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Verses
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final verseNum = chapterVerses[index];
                                  final isSelected = verseNum == selectedVerse;
                                  return InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        selectedVerse = verseNum;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      color: !isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: Text(
                                        verseNum.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemCount: chapterVerses.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            final matching = verses
                                .where(
                                  (v) =>
                                      v.book == selectedBook &&
                                      v.chapter == selectedChapter &&
                                      v.verse == selectedVerse,
                                )
                                .toList();
                            if (matching.isEmpty) return;
                            final selected = matching.first;
                            Navigator.of(context).pop(selected);
                          },
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
