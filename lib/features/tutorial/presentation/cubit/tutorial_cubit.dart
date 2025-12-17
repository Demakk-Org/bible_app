import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/data/tutorial/tutorial_repository_impl.dart';
import 'package:bible_app/features/tutorial/presentation/cubit/tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState> {
  TutorialCubit({required TutorialRepositoryImpl tutorialRepo})
    : super(TutorialState.initial) {
    _tutorialRepo = tutorialRepo;
  }

  late final TutorialRepositoryImpl _tutorialRepo;

  Future<void> initialize() async {
    _tutorialRepo.getTutorial().fold(
      (failure) => emit(
        state.copyWith(showBibleTutorial: false, showBookmarksTutorial: false),
      ),
      (tutorial) => emit(
        state.copyWith(
          showBibleTutorial: !tutorial.isBibleTutorialCompleted,
          showBookmarksTutorial: !tutorial.isBookmarksTutorialCompleted,
        ),
      ),
    );
  }

  void completeBookmarksTutorial() {
    _tutorialRepo.completeBookmarksTutorial().fold(
      (_) => emit(state.copyWith(showBookmarksTutorial: false)),
      (_) => emit(state.copyWith(showBookmarksTutorial: false)),
    );
  }

  void dismissBibleTutorial() {
    emit(state.copyWith(showBibleTutorial: false));
  }

  void completeBibleTutorial() {
    _tutorialRepo.completeBibleTutorial().fold(
      (_) => emit(state.copyWith(showBibleTutorial: false)),
      (_) => emit(state.copyWith(showBibleTutorial: false)),
    );
  }

  void resetBibleTutorial() {
    _tutorialRepo.resetBibleTutorial().fold(
      (_) => emit(state.copyWith(showBibleTutorial: true)),
      (_) => emit(state.copyWith(showBibleTutorial: true)),
    );
  }
}
