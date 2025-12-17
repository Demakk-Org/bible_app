import 'package:either_dart/either.dart';
import 'package:bible_app/core/domain/tutorial/tutorial_model.dart';
import 'package:bible_app/core/failure.dart';

abstract class TutorialRepository {
  Either<Failure, TutorialModel> getTutorial();
  Either<Failure, TutorialModel> completeBibleTutorial();
  Either<Failure, TutorialModel> completeBookmarksTutorial();
}
