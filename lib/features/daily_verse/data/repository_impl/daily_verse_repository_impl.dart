import 'package:either_dart/either.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/core/error/cache_exception.dart';
import 'package:bible_app/core/failure.dart';
import 'package:bible_app/features/daily_verse/data/data_sources/local_daily_verse_data_source.dart';
import 'package:bible_app/features/daily_verse/data/model/daily_verse.dart';
import 'package:bible_app/features/daily_verse/domain/entity/daily_verse_model.dart';
import 'package:bible_app/features/daily_verse/domain/repository/daily_verse_repository.dart';

class DailyVerseRepositoryImpl extends DailyVerseRepository {
  DailyVerseRepositoryImpl({
    required this.localDailyVerseDataSource,
  });
  final LocalDailyVerseDataSource localDailyVerseDataSource;

  @override
  Future<Either<Failure, DailyVerseModel>> fetchDailyVerseFormCache(
    DateTime date,
  ) async {
    try {
      final dailyVerse = await localDailyVerseDataSource.getDailyVerse(date);
      return Right(dailyVerse);
    } on CacheException {
      // Expected cache miss; do not log error. Map to CacheFailure.
      return const Left(CacheFailure());
    } on Exception catch (e) {
      AppLogger.error(
        e.toString(),
        name: 'DailyVerseRepositoryImpl: fetchDailyVerse',
        error: e,
      );
      // Return a generic cache failure message
      return const Left(CacheFailure());
    }
  }

  @override
  Future<void> cacheDailyVerse(DailyVerseModel dailyVerse) async {
    try {
      await localDailyVerseDataSource.cacheDailyVerse(dailyVerse as DailyVerse);
    } on Exception catch (e, st) {
      AppLogger.error(
        'Error: failed to cache daily verse',
        name: 'Daily Verse Repo Impl: cacheDailyVerse',
        error: e,
        stackTrace: st,
      );
    } catch (e) {
      rethrow;
    }
  }
}
