import 'package:either_dart/either.dart';
import 'package:bible_app/core/failure.dart';
import 'package:bible_app/features/bible/data/data_sources/bible_data_sources.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/domain/repository/bible_repository.dart';

class BibleRepositoryImpl implements BibleRepository {
  BibleRepositoryImpl({required this.bibleDataSources});
  final BibleDataSources bibleDataSources;

  @override
  Future<Either<Failure, List<Bible>>> initializeBibleFromLocalSource() async {
    try {
      final bibles = await bibleDataSources.initializeBibleFromLocalSource();
      return Right(bibles);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BibleSource>>> getBibleSources() async {
    try {
      final bibles = await bibleDataSources.getBibleSources();
      return Right(bibles);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bible>>> downloadBible(String id) async {
    try {
      final bibles = await bibleDataSources.downloadBible(id);
      return Right(bibles);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Bible>> getBible(String id) async {
    try {
      final bible = await bibleDataSources.getBible(id);
      return Right(bible);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Verse>>> setBookmarks(List<Verse> verses) async {
    try {
      final bookmarks = await bibleDataSources.setBookmarks(verses);
      return Right(bookmarks);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Verse>>> getBookmarks() async {
    try {
      final bookmarks = await bibleDataSources.getBookmarks();
      return Right(bookmarks);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBible(String id) async {
    try {
      await bibleDataSources.removeBible(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
