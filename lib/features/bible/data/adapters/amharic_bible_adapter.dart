import 'package:bible_app/features/bible/data/adapters/bible_adapters.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';

/// Adapter for hierarchical Amharic JSON with `title` and `books` arrays.
class AmharicBibleAdapter implements BibleJsonAdapter {
  @override
  bool canParse(Map<String, dynamic> json) {
    return json.containsKey('title') && json.containsKey('books');
  }

  @override
  Bible parse({required String id, required Map<String, dynamic> json}) {
    final title = (json['title'] ?? 'Amharic Bible').toString();
    final metadata = (json['metadata'] as Map<String, dynamic>?) ?? const {};
    final name = (metadata['name'] ?? title).toString();
    final shortName = (metadata['shortname'] ?? 'amh').toString();
    final langShort = (metadata['lang'] ?? 'am').toString();
    final moduleVersion = (metadata['module_version'] ?? '1.0.0').toString();
    final books = json['books'] as List<dynamic>? ?? const [];
    final adapterHint = (metadata['adapter'] ?? 'nested').toString();

    final verses = <Verse>[];

    for (var bIndex = 0; bIndex < books.length; bIndex++) {
      final book = books[bIndex] as Map<String, dynamic>?;
      if (book == null) continue;
      final bookName = (book['title'] ?? 'Book ${bIndex + 1}').toString();
      final chapters = book['chapters'] as List<dynamic>? ?? const [];

      for (var cIndex = 0; cIndex < chapters.length; cIndex++) {
        final chapterObj = chapters[cIndex] as Map<String, dynamic>?;
        if (chapterObj == null) continue;
        final rawChapter = chapterObj['chapter']?.toString();
        final chapterNumber = int.tryParse(rawChapter ?? '') ?? (cIndex + 1);
        final rawVerses = chapterObj['verses'] as List<dynamic>? ?? const [];

        for (var vIndex = 0; vIndex < rawVerses.length; vIndex++) {
          final text = rawVerses[vIndex]?.toString() ?? '';
          verses.add(
            Verse(
              bookName: bookName,
              book: bIndex + 1, // 1-based index by appearance
              chapter: chapterNumber,
              verse: vIndex + 1, // 1-based index
              text: text,
            ),
          );
        }
      }
    }

    // Compose a Bible object using simplified metadata schema.
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
