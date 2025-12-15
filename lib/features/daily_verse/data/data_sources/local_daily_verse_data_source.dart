import 'package:bible_app/common/utils/date_time_extension.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/core/error/cache_exception.dart';
import 'package:bible_app/features/daily_verse/domain/entity/daily_verse_model.dart';

class LocalDailyVerseDataSource {
  LocalDailyVerseDataSource({required this.dailyVerseBox});
  final Box<DailyVerseModel> dailyVerseBox;

  Future<DailyVerseModel> getDailyVerse(DateTime date) async {
    try {
      final verseListFromCache = dailyVerseBox.values.toList();
      AppLogger.info(
        'Found ${verseListFromCache.length} verses',
        name: 'LocalDailyVerseDataSource: verseCount',
      );

      if (verseListFromCache.isEmpty) {
        throw CacheException('No verses found in cache');
      }

      final dailyVerseFromCache = verseListFromCache.firstWhereOrNull((v) {
        final dateFromCachedVerse = DateTime.now().copyWith(
          year: v.displayDate.year,
          month: v.displayDate.month,
          day: v.displayDate.day,
        );
        return date.isEqualTo(dateFromCachedVerse);
      });

      AppLogger.info(
        dailyVerseFromCache.toString(),
        name: 'LocalDailyVerseDataSource: fromCacheAfterFilter',
      );

      if (dailyVerseFromCache == null) {
        throw CacheException('No verses found in cache');
      }

      return dailyVerseFromCache;
    } on Exception catch (e, st) {
      AppLogger.error(
        e.toString(),
        name: 'LocalDailyVerseDataSource: getDailyVerse',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> cacheDailyVerse(DailyVerseModel dailyVerse) async {
    try {
      await dailyVerseBox.add(dailyVerse);
    } on Exception catch (e, st) {
      AppLogger.error(
        'Error: failed to cache daily verse',
        name: 'LocalDailyVerseDataSource: cacheDailyVerse',
        error: e,
        stackTrace: st,
      );
      throw Exception('Failed to cache daily verse');
    }
  }
}
