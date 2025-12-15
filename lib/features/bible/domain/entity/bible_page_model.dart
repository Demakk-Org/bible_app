abstract class BiblePageModel {
  BiblePageModel({
    required this.book,
    required this.chapter,
    this.verse,
    this.scrollToVerse,
  });
  final int book;
  final int chapter;
  final int? verse;
  final bool? scrollToVerse;
}
