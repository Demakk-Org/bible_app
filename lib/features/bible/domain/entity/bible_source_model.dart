abstract class BibleSourceModel {
  BibleSourceModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.language,
    required this.sourceUrl,
    required this.isDownloaded,
  });
  final String id;
  final String name;
  final String shortName;
  final String language;
  final String sourceUrl;
  final bool isDownloaded;
}
