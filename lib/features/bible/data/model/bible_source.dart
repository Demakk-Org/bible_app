import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/features/bible/domain/entity/bible_source_model.dart';

part 'bible_source.g.dart';

@HiveType(typeId: 20)
class BibleSource extends HiveObject implements BibleSourceModel {
  BibleSource({
    required this.id,
    required this.name,
    required this.shortName,
    required this.language,
    required this.sourceUrl,
    required this.isDownloaded,
  });

  factory BibleSource.fromJson(Map<String, dynamic> json) {
    return BibleSource(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      language: json['lang'] as String,
      sourceUrl: json['source_url'] as String,
      isDownloaded: json['is_downloaded'] as bool,
    );
  }
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
  final String sourceUrl;

  @HiveField(5)
  @override
  final bool isDownloaded;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'short_name': shortName,
      'language': language,
      'source_url': sourceUrl,
      'is_downloaded': isDownloaded,
    };
  }

  BibleSource copyWith({
    String? name,
    String? shortName,
    String? language,
    String? sourceUrl,
    bool? isDownloaded,
  }) {
    return BibleSource(
      id: id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      language: language ?? this.language,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  @override
  String toString() {
    return 'BibleSource('
        'name: $name, '
        'shortName: $shortName, '
        'language: $language, '
        'sourceUrl: $sourceUrl, '
        'isDownloaded: $isDownloaded)';
  }
}
