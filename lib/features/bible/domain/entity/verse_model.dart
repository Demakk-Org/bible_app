abstract class VerseModel {
  VerseModel({
    required this.bookName,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });
  final String bookName;
  final int book;
  final int chapter;
  final int verse;
  final String text;
}
