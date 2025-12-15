import 'package:either_dart/either.dart';
import 'package:bible_app/core/failure.dart';
import 'package:bible_app/features/daily_verse/domain/entity/daily_verse_model.dart';

abstract class DailyVerseRepository {
  Future<Either<Failure, DailyVerseModel>> fetchDailyVerseFormCache(
    DateTime date,
  );

  Future<void> cacheDailyVerse(DailyVerseModel dailyVerse);
}
