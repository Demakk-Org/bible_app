import 'package:equatable/equatable.dart';

class TutorialState extends Equatable {
  const TutorialState({
    required this.showHomeTutorial,
    required this.showBibleTutorial,
    required this.showAudiosTutorial,
    required this.showGroupsTutorial,
    required this.showNewsTutorial,
    this.loading = false,
  });

  final bool showHomeTutorial;
  final bool showBibleTutorial;
  final bool showAudiosTutorial;
  final bool showGroupsTutorial;
  final bool showNewsTutorial;
  final bool loading;

  TutorialState copyWith({
    bool? showHomeTutorial,
    bool? showBibleTutorial,
    bool? showAudiosTutorial,
    bool? showGroupsTutorial,
    bool? showNewsTutorial,
    bool? loading,
  }) {
    return TutorialState(
      showHomeTutorial: showHomeTutorial ?? this.showHomeTutorial,
      showBibleTutorial: showBibleTutorial ?? this.showBibleTutorial,
      showAudiosTutorial: showAudiosTutorial ?? this.showAudiosTutorial,
      showGroupsTutorial: showGroupsTutorial ?? this.showGroupsTutorial,
      showNewsTutorial: showNewsTutorial ?? this.showNewsTutorial,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        showHomeTutorial,
        showBibleTutorial,
        showAudiosTutorial,
        showGroupsTutorial,
        showNewsTutorial,
        loading,
      ];

  static const TutorialState initial = TutorialState(
    showHomeTutorial: false,
    showBibleTutorial: false,
    showAudiosTutorial: false,
    showGroupsTutorial: false,
    showNewsTutorial: false,
  );
}
