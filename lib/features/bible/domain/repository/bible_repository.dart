import 'package:either_dart/either.dart';
import 'package:bible_app/core/failure.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';

abstract class BibleRepository {
  Future<Either<Failure, List<Bible>>> initializeBibleFromLocalSource();

  Future<Either<Failure, List<BibleSource>>> getBibleSources();

  Future<Either<Failure, List<Bible>>> downloadBible(String id);

  Future<Either<Failure, Bible>> getBible(String id);

  Future<Either<Failure, List<Verse>>> setBookmarks(List<Verse> verses);

  Future<Either<Failure, List<Verse>>> getBookmarks();

  Future<Either<Failure, List<Verse>>> removeBookmark(Verse verse);

  Future<Either<Failure, void>> removeBible(String id);
}
