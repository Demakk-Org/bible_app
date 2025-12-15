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
        state.copyWith(
          showHomeTutorial: false,
          showBibleTutorial: false,
          showAudiosTutorial: false,
          showGroupsTutorial: false,
          showNewsTutorial: false,
        ),
      ),
      (tutorial) => emit(
        state.copyWith(
          showHomeTutorial: !tutorial.isHomePageTutorialCompleted,
          showBibleTutorial: !tutorial.isBibleTutorialCompleted,
          showAudiosTutorial: !tutorial.isAudiosTutorialCompleted,
          showGroupsTutorial: !tutorial.isGroupsTutorialCompleted,
          showNewsTutorial: !tutorial.isNewsTutorialCompleted,
        ),
      ),
    );
  }

  void dismissHomeTutorial() {
    emit(state.copyWith(showHomeTutorial: false));
  }

  void completeHomeTutorial() {
    _tutorialRepo.completeHomePageTutorial().fold(
      (_) => emit(state.copyWith(showHomeTutorial: false)),
      (_) => emit(state.copyWith(showHomeTutorial: false)),
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

  void dismissAudiosTutorial() {
    emit(state.copyWith(showAudiosTutorial: false));
  }

  void completeAudiosTutorial() {
    _tutorialRepo.completeAudiosTutorial().fold(
      (_) => emit(state.copyWith(showAudiosTutorial: false)),
      (_) => emit(state.copyWith(showAudiosTutorial: false)),
    );
  }

  void dismissGroupsTutorial() {
    emit(state.copyWith(showGroupsTutorial: false));
  }

  void completeGroupsTutorial() {
    _tutorialRepo.completeGroupsTutorial().fold(
      (_) => emit(state.copyWith(showGroupsTutorial: false)),
      (_) => emit(state.copyWith(showGroupsTutorial: false)),
    );
  }

  void dismissNewsTutorial() {
    emit(state.copyWith(showNewsTutorial: false));
  }

  void completeNewsTutorial() {
    _tutorialRepo.completeNewsTutorial().fold(
      (_) => emit(state.copyWith(showNewsTutorial: false)),
      (_) => emit(state.copyWith(showNewsTutorial: false)),
    );
  }
}
