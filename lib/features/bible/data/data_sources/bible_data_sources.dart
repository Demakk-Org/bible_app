import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/features/bible/data/adapters/bible_json_adapter_selector.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';

class BibleDataSources {
  BibleDataSources({
    required this.bibleBox,
    required this.bibleSourceBox,
    required this.bookmarkBox,
  });
  final Box<Bible> bibleBox;
  final Box<BibleSource> bibleSourceBox;
  final Box<Verse> bookmarkBox;

  Future<List<Bible>> initializeBibleFromLocalSource() async {
    try {
      if (bibleBox.values.isNotEmpty) {
        return bibleBox.values.toList();
      }

      // Discover all bible JSON files from the asset manifest.
      final manifestString = await rootBundle.loadString('AssetManifest.json');
      final manifestMap = jsonDecode(manifestString) as Map<String, dynamic>;

      final bibleAssetPaths = manifestMap.keys
          .where((k) => k.startsWith('assets/bible/') && k.endsWith('.json'))
          .toList();

      AppLogger.debug(
        'Discovered bible assets: $bibleAssetPaths',
        name: 'Bible Data source: initializeBibleFromLocalSource',
      );

      for (final assetPath in bibleAssetPaths) {
        try {
          final jsonString = await rootBundle.loadString(assetPath);
          final json = jsonDecode(jsonString) as Map<String, dynamic>;

          final id = _deriveLocalId(assetPath);

          // Parse into Bible using selector.
          final bible = BibleJsonAdapterSelector.parse(id: id, json: json);

          // Create or update BibleSource entry for this local asset.
          final bibleSource = BibleSource(
            id: id,
            name: bible.name,
            shortName: bible.shortName,
            language: bible.language,
            sourceUrl: assetPath,
            isDownloaded: true,
          );

          final hasBible = bibleBox.values.any((b) => b.id == id);
          if (!hasBible) {
            await bibleBox.add(bible);
            AppLogger.debug(
              'Added local Bible: ${bible.name} ($id)',
              name: 'Bible Data source: initializeBibleFromLocalSource',
            );
          }

          final hasSource = bibleSourceBox.values.any((s) => s.id == id);
          if (!hasSource) {
            await bibleSourceBox.add(bibleSource);
            AppLogger.debug(
              'Added local BibleSource for: ${bibleSource.name} ($id)',
              name: 'Bible Data source: initializeBibleFromLocalSource',
            );
          }
        } on Exception catch (e, st) {
          AppLogger.error(
            'Failed to load bible asset $assetPath',
            name: 'Bible Data source: initializeBibleFromLocalSource',
            error: e,
            stackTrace: st,
          );
          continue;
        }
      }

      return bibleBox.values.toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'initializeBibleFromLocalSource failed',
        name: 'Bible Data source: initializeBibleFromLocalSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  String _deriveLocalId(String assetPath) {
    try {
      final file = assetPath.split('/').last;
      final dot = file.lastIndexOf('.');
      final base = dot > 0 ? file.substring(0, dot) : file;
      return 'local:$base';
    } on Exception catch (_) {
      return 'local:${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<List<BibleSource>> getBibleSources() async {
    try {
      final listOfBiblesFromCache = bibleSourceBox.values.toList();
      AppLogger.debug(
        'listOfBiblesFromCache: $listOfBiblesFromCache',
        name: 'Bible Data source: listOfBiblesFromCache',
      );

      final idsOfAlreadyFetchedBibles = listOfBiblesFromCache
          .map((bibleSource) => bibleSource.id)
          .toList();

      AppLogger.debug(
        'idsOfAlreadyFetchedBibleSources: $idsOfAlreadyFetchedBibles',
        name: 'Bible Data source: idsOfAlreadyFetchedBibles',
      );

      return bibleSourceBox.values.toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'getBibleSources failed',
        name: 'Bible Data source: getBibleSources',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<Bible>> downloadBible(String id) async {
    try {
      int? bibleSourceIndex;
      for (var i = 0; i < bibleSourceBox.length; i++) {
        if (bibleSourceBox.getAt(i)?.id == id) {
          bibleSourceIndex = i;
          AppLogger.debug(
            'Found bible item at index: $i',
            name: 'Bible Data source: download bible',
          );
          break;
        }
      }

      if (bibleSourceIndex == null) {
        AppLogger.debug(
          'News item with id: $id not found in box',
          name: 'NewsDataSource: markNewsAsRead',
        );
        throw Exception('Bible item with id: $id not found in box');
      }

      final bibleSource = bibleSourceBox.getAt(bibleSourceIndex)!;
      AppLogger.debug(
        'Original bible downloaded status: ${bibleSource.isDownloaded}',
        name: 'Bible Data source: downloadBible',
      );

      if (bibleSource.isDownloaded) {
        AppLogger.debug(
          'Bible item with id: $id is already downloaded',
          name: 'Bible Data source: downloadBible',
        );

        return bibleBox.values.toList();
      }

      final updatedBibleSource = bibleSource.copyWith(isDownloaded: true);

      AppLogger.debug(
        'Updating bibleSource item to downloaded: true',
        name: 'Bible Data source: downloadBible',
      );

      try {
        await bibleSourceBox.putAt(bibleSourceIndex, updatedBibleSource);
        AppLogger.debug(
          'Successfully updated bibleSource item in box',
          name: 'Bible Data source: downloadBible',
        );
      } catch (e, st) {
        AppLogger.error(
          'Error updating bibleSource item',
          name: 'Bible Data source: downloadBible',
          error: e,
          stackTrace: st,
        );
        rethrow;
      }

      return bibleBox.values.toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'downloadBible failed',
        name: 'Bible Data source: downloadBible',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<Bible> getBible(String id) async {
    try {
      final bible = bibleBox.values.firstWhere((bible) => bible.id == id);
      return bible;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Verse>> setBookmarks(List<Verse> verses) async {
    try {
      final bookmarks = bookmarkBox.values.toList();
      for (final verse in verses) {
        if (!bookmarks.contains(verse)) {
          await bookmarkBox.add(verse);
        }
      }
      return bookmarkBox.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Verse>> getBookmarks() async {
    try {
      final bookmarks = bookmarkBox.values.toList();
      AppLogger.debug(
        'Bookmarks: $bookmarks',
        name: 'Bible Data source: get bookmarks',
      );
      return bookmarks;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Verse>> removeBookmark(Verse verse) async {
    try {
      int? bookmarkIndex;
      for (var i = 0; i < bookmarkBox.length; i++) {
        final v = bookmarkBox.getAt(i);
        if (v == null) continue;
        if (v.bookName == verse.bookName &&
            v.book == verse.book &&
            v.chapter == verse.chapter &&
            v.verse == verse.verse) {
          bookmarkIndex = i;
          break;
        }
      }

      if (bookmarkIndex != null) {
        await bookmarkBox.deleteAt(bookmarkIndex);
      }

      return bookmarkBox.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeBible(String id) async {
    try {
      int? bibleSourceIndex;
      for (var i = 0; i < bibleSourceBox.length; i++) {
        if (bibleSourceBox.getAt(i)?.id == id) {
          bibleSourceIndex = i;
          AppLogger.debug(
            'Found bible item at index: $i',
            name: 'Bible Data source: removeBible',
          );
          break;
        }
      }
      if (bibleSourceIndex == null) {
        AppLogger.debug(
          'Bible item with id: $id not found in box',
          name: 'Bible Data source: remove bible',
        );
        throw Exception('Bible item with id: $id not found in box');
      }
      final bibleSource = bibleSourceBox.getAt(bibleSourceIndex)!;
      final updatedBibleSource = bibleSource.copyWith(isDownloaded: false);
      await bibleSourceBox.putAt(bibleSourceIndex, updatedBibleSource);
      await bibleBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}
