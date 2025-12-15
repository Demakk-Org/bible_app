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
  Either<Failure, TutorialModel> completeHomePageTutorial() {
    return _completeTutorials(home: true);
  }

  @override
  Either<Failure, TutorialModel> completeBibleTutorial() {
    return _completeTutorials(bible: true);
  }

  @override
  Either<Failure, TutorialModel> completeAudiosTutorial() {
    return _completeTutorials(audios: true);
  }

  @override
  Either<Failure, TutorialModel> completeGroupsTutorial() {
    return _completeTutorials(groups: true);
  }

  @override
  Either<Failure, TutorialModel> completeNewsTutorial() {
    return _completeTutorials(news: true);
  }

  Either<Failure, TutorialModel> _completeTutorials({
    bool? home,
    bool? bible,
    bool? audios,
    bool? groups,
    bool? news,
  }) {
    try {
      final current = tutorialBox.get('tutorial') ?? Tutorial.defaultTutorial();
      final updated = Tutorial(
        isHomePageTutorialCompleted:
            home ?? current.isHomePageTutorialCompleted,
        isBibleTutorialCompleted: bible ?? current.isBibleTutorialCompleted,
        isAudiosTutorialCompleted: audios ?? current.isAudiosTutorialCompleted,
        isGroupsTutorialCompleted: groups ?? current.isGroupsTutorialCompleted,
        isNewsTutorialCompleted: news ?? current.isNewsTutorialCompleted,
      );
      unawaited(tutorialBox.put('tutorial', updated));
      return Right(updated);
    } on Object catch (_) {
      return const Left(CacheFailure());
    }
  }
}
