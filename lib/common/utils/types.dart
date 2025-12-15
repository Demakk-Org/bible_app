import 'package:hive_flutter/hive_flutter.dart';
part 'types.g.dart';

@HiveType(typeId: 22)
enum BibleStatus {
  @HiveField(0)
  initial,
  @HiveField(1)
  success,
  @HiveField(2)
  error,
  @HiveField(3)
  saving,
  @HiveField(4)
  searching,
}

enum BibleType {
  all('All'),
  oldTestament('Old Testament'),
  newTestament('New Testament');

  const BibleType(this.label);

  factory BibleType.fromString(String name) {
    switch (name.toLowerCase()) {
      case 'all':
        return BibleType.all;
      case 'old testament':
        return BibleType.oldTestament;
      case 'new testament':
        return BibleType.newTestament;
      default:
        throw Exception('Unknown Bible type: $name');
    }
  }

  final String label;
}

enum QueryAccuracy {
  exact,
  partial,
  contains,
  wordOnly;

  static QueryAccuracy fromString(String name) {
    switch (name.toLowerCase()) {
      case 'exact':
        return QueryAccuracy.exact;
      case 'partial':
        return QueryAccuracy.partial;
      case 'contains':
        return QueryAccuracy.contains;
      case 'word only':
        return QueryAccuracy.wordOnly;
      default:
        throw Exception('Unknown query accuracy: $name');
    }
  }
}

class SearchFilter {
  SearchFilter({
    this.type = BibleType.all,
    this.query = '',
    this.book = 'All',
    this.queryAccuracy = QueryAccuracy.partial,
  });
  final BibleType type;
  final String query;
  final String book;
  final QueryAccuracy queryAccuracy;

  SearchFilter copyWith({
    BibleType? type,
    String? query,
    String? book,
    QueryAccuracy? queryAccuracy,
  }) {
    return SearchFilter(
      type: type ?? this.type,
      query: query ?? this.query,
      book: book ?? this.book,
      queryAccuracy: queryAccuracy ?? this.queryAccuracy,
    );
  }

  @override
  String toString() {
    return 'SearchFilter('
        'type: $type, '
        'query: $query, '
        'book: $book, '
        'queryAccuracy: $queryAccuracy)';
  }
}

@HiveType(typeId: 39)
enum QueryStatus {
  @HiveField(0)
  initial,

  @HiveField(1)
  loading,

  @HiveField(2)
  success,

  @HiveField(3)
  error,
}

@HiveType(typeId: 40)
enum MutationStatus {
  @HiveField(0)
  initial,

  @HiveField(1)
  saving,

  @HiveField(2)
  success,

  @HiveField(3)
  error,
}

@HiveType(typeId: 60)
enum AppLanguage {
  @HiveField(0)
  english, // 'en'
  @HiveField(1)
  amharic, // 'am'
  @HiveField(2)
  afanOromo; // 'om'

  static AppLanguage fromString(String lang) {
    switch (lang) {
      case 'en':
        return AppLanguage.english;
      case 'am':
        return AppLanguage.amharic;
      case 'om':
        return AppLanguage.afanOromo;
      default:
        throw Exception('Unknown language: $lang');
    }
  }

  @override
  String toString() {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.amharic:
        return 'am';
      case AppLanguage.afanOromo:
        return 'om';
    }
  }
}

@HiveType(typeId: 61)
enum AppTheme {
  @HiveField(0)
  light,

  @HiveField(1)
  dark,

  @HiveField(2)
  system;

  static AppTheme fromString(String theme) {
    switch (theme) {
      case 'light':
        return AppTheme.light;
      case 'dark':
        return AppTheme.dark;
      case 'system':
        return AppTheme.system;
      default:
        throw Exception('Unknown theme: $theme');
    }
  }

  @override
  String toString() {
    switch (this) {
      case AppTheme.light:
        return 'light';
      case AppTheme.dark:
        return 'dark';
      case AppTheme.system:
        return 'system';
    }
  }
}
