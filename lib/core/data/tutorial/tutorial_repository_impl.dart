import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/core/data/tutorial/tutorial.dart';
import 'package:bible_app/core/domain/tutorial/tutorial_model.dart';
import 'package:bible_app/core/domain/tutorial/tutorial_repository_model.dart';
import 'package:bible_app/core/failure.dart';

class TutorialRepositoryImpl implements TutorialRepository {
  TutorialRepositoryImpl({required this.tutorialBox});

  final Box<Tutorial> tutorialBox;

  @override
  Either<Failure, TutorialModel> getTutorial() {
    return Right(tutorialBox.get('tutorial') ?? Tutorial.defaultTutorial());
  }

  @override
  Either<Failure, TutorialModel> completeBibleTutorial() {
    return _completeTutorials(bible: true);
  }

  @override
  Either<Failure, TutorialModel> completeBookmarksTutorial() {
    return _completeTutorials(bookmarks: true);
  }

  Either<Failure, TutorialModel> resetBibleTutorial() {
    return _completeTutorials(bible: false);
  }

  Either<Failure, TutorialModel> _completeTutorials({
    bool? bible,
    bool? bookmarks,
  }) {
    try {
      final current = tutorialBox.get('tutorial') ?? Tutorial.defaultTutorial();
      final updated = Tutorial(
        isBibleTutorialCompleted: bible ?? current.isBibleTutorialCompleted,
        isBookmarksTutorialCompleted:
            bookmarks ?? current.isBookmarksTutorialCompleted,
      );
      unawaited(tutorialBox.put('tutorial', updated));
      return Right(updated);
    } on Object catch (_) {
      return const Left(CacheFailure());
    }
  }
}
