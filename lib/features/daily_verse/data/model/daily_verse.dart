import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/features/daily_verse/domain/entity/daily_verse_model.dart';

part 'daily_verse.g.dart';

@HiveType(typeId: 0)
class DailyVerse extends HiveObject implements DailyVerseModel {
  DailyVerse({
    required this.id,
    required this.text,
    required this.book,
    required this.chapter,
    required this.createdAt,
    required this.displayDate,
    required this.reference,
    required this.tag,
    required this.verse,
  });

  factory DailyVerse.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt'];

    final DateTime createdAt;
    if (createdAtRaw is String) {
      createdAt = DateTime.parse(createdAtRaw);
    } else {
      throw const FormatException('Unknown createdAt format');
    }

    return DailyVerse(
      id: json['id'] as String,
      text: json['text'] as String,
      book: json['book'] as int,
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      reference: json['reference'] as String,
      displayDate: DateTime(
        (json['display_date'] as Map<String, dynamic>)['year'] as int,
        (json['display_date'] as Map<String, dynamic>)['month'] as int,
        (json['display_date'] as Map<String, dynamic>)['day'] as int,
      ),
      tag: json['tag'] as String,
      createdAt: createdAt,
    );
  }

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String text;
  @override
  @HiveField(2)
  final int book;
  @override
  @HiveField(3)
  final int chapter;
  @override
  @HiveField(4)
  final DateTime createdAt;
  @override
  @HiveField(5)
  final DateTime displayDate;
  @override
  @HiveField(6)
  final String reference;
  @override
  @HiveField(8)
  final String tag;
  @override
  @HiveField(9)
  final int verse;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'book': book,
    'chapter': chapter,
    'verse': verse,
    'reference': reference,
    'display_date': {
      'year': displayDate.year,
      'month': displayDate.month,
      'day': displayDate.day,
    },
    'tag': tag,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'Text: $text, '
        'Book: $book, '
        'Chapter: $chapter, '
        'Verse: $verse, '
        'Reference: $reference, '
        'Tag: $tag, '
        'CreatedAt: $createdAt';
  }
}
