import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/features/bible/domain/entity/verse_model.dart';

part 'verse.g.dart';

@HiveType(typeId: 21)
class Verse extends HiveObject implements VerseModel {
  Verse({
    required this.bookName,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      bookName: json['book_name'] as String,
      book: json['book'] as int,
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      text: json['text'] as String,
    );
  }
  @HiveField(1)
  @override
  final String bookName;

  @HiveField(2)
  @override
  final int book;

  @HiveField(3)
  @override
  final int chapter;

  @HiveField(4)
  @override
  final int verse;

  @HiveField(5)
  @override
  final String text;

  Map<String, dynamic> toJson() {
    return {
      'book_name': bookName,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }

  @override
  String getReference() {
    return '$bookName $chapter:$verse';
  }

  @override
  String toString() {
    return 'Verse('
        'bookName: $bookName, '
        'book: $book, '
        'chapter: $chapter, '
        'verse: $verse, '
        'text: $text)';
  }
}
