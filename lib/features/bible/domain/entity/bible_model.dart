import 'package:bible_app/features/bible/domain/entity/verse_model.dart';

abstract class BibleModel {
  BibleModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.language,
    required this.moduleVersion,
    required this.verses,
    required this.adapterHint,
  });

  final String id;
  final String name;
  final String shortName;
  final String language;
  final String moduleVersion;
  final List<VerseModel> verses;
  final String? adapterHint;
}
