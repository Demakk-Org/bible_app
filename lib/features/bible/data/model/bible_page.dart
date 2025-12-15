import 'package:bible_app/features/bible/domain/entity/bible_page_model.dart';

class BiblePage implements BiblePageModel {
  BiblePage({
    required this.book,
    required this.chapter,
    required this.scrollToVerse,
    this.verse,
  });

  @override
  final int book;

  @override
  final int chapter;

  @override
  final int? verse;

  @override
  final bool scrollToVerse;

  BiblePage copyWith({
    int? book,
    int? chapter,
    int? verse,
    bool? scrollToVerse,
  }) {
    return BiblePage(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      scrollToVerse: scrollToVerse ?? this.scrollToVerse,
    );
  }

  @override
  String toString() {
    return 'BiblePage ( '
        ' book: $book, '
        ' chapter: $chapter, '
        ' verse: $verse, '
        ' scrollToVerse: $scrollToVerse)';
  }
}
