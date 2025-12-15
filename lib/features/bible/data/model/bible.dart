import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/domain/entity/bible_model.dart';

part 'bible.g.dart';

@HiveType(typeId: 23)
class Bible extends HiveObject implements BibleModel {
  Bible({
    required this.id,
    required this.name,
    required this.shortName,
    required this.language,
    required this.moduleVersion,
    required this.verses,
    required this.adapterHint,
  });

  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String shortName;

  @HiveField(3)
  @override
  final String language;

  @HiveField(4)
  @override
  final String moduleVersion;

  @HiveField(5)
  @override
  final List<Verse> verses;

  @HiveField(6)
  @override
  final String? adapterHint;

  List<Map<String, dynamic>> getBookList({
    BibleType? bookType = BibleType.all,
  }) {
    final oldTestamentBooks = Map<String, int>.from({'start': 1, 'end': 39});
    final newTestamentBooks = Map<String, int>.from({'start': 40, 'end': 66});

    final allBookList = verses
        .where((v) => v.chapter == 1 && v.verse == 1)
        .toList();

    final filteredBookList = allBookList
        .map(
          (v) =>
              Map<String, dynamic>.from({'book': v.book, 'name': v.bookName}),
        )
        .toList();
    if (bookType == BibleType.oldTestament) {
      return filteredBookList
          .where(
            (v) =>
                (v['book'] as int) >= oldTestamentBooks['start']! &&
                (v['book'] as int) <= oldTestamentBooks['end']!,
          )
          .toList();
    } else if (bookType == BibleType.newTestament) {
      return filteredBookList
          .where(
            (v) =>
                (v['book'] as int) >= newTestamentBooks['start']! &&
                (v['book'] as int) <= newTestamentBooks['end']!,
          )
          .toList();
    }
    return filteredBookList;
  }

  List<BibleType> getBibleTypeList() {
    return verses
        .map((v) {
          if (v.book >= 1 && v.book <= 39) {
            return BibleType.oldTestament;
          } else {
            return BibleType.newTestament;
          }
        })
        .toSet()
        .toList();
  }

  Verse getVerse({
    required int book,
    required int chapter,
    required int verse,
  }) {
    return verses.firstWhere(
      (v) => v.book == book && v.chapter == chapter && v.verse == verse,
    );
  }

  @override
  String toString() {
    return 'Bible('
        'id: $id, '
        'name: $name, '
        'shortName: $shortName, '
        'langShort: $language, '
        'moduleVersion: $moduleVersion'
        'adapterHint: $adapterHint';
  }
}
