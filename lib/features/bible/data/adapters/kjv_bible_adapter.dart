import 'package:bible_app/features/bible/data/adapters/bible_adapters.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';

/// Adapter for KJV-like flat verse list JSON with a `metadata` object.
class KjvBibleAdapter implements BibleJsonAdapter {
  @override
  bool canParse(Map<String, dynamic> json) {
    return json.containsKey('metadata') && json.containsKey('verses');
  }

  @override
  Bible parse({required String id, required Map<String, dynamic> json}) {
    final metadata = (json['metadata'] as Map<String, dynamic>?) ?? const {};

    final name = (metadata['name'] ?? 'Bible').toString();
    final shortName = (metadata['shortname'] ?? 'KJV').toString();
    final langShort = (metadata['lang'] ?? 'en').toString();
    final moduleVersion = (metadata['module_version'] ?? '1.0.0').toString();
    final adapterHint = (metadata['adapter'] ?? 'flat').toString();

    final versesJson = json['verses'] as List<dynamic>? ?? const [];
    final verses = <Verse>[];
    for (final v in versesJson) {
      final m = (v as Map).cast<String, dynamic>();
      verses.add(
        Verse(
          bookName: m['book_name']?.toString() ?? '',
          book: (m['book'] as num?)?.toInt() ?? 0,
          chapter: (m['chapter'] as num?)?.toInt() ?? 0,
          verse: (m['verse'] as num?)?.toInt() ?? 0,
          text: m['text']?.toString() ?? '',
        ),
      );
    }

    return Bible(
      id: id,
      name: name,
      shortName: shortName,
      language: langShort,
      moduleVersion: moduleVersion,
      verses: verses,
      adapterHint: adapterHint,
    );
  }
}
