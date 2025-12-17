import 'package:equatable/equatable.dart';

class TutorialState extends Equatable {
  const TutorialState({
    required this.showBibleTutorial,
    required this.showBookmarksTutorial,
    this.loading = false,
  });

  final bool showBibleTutorial;
  final bool showBookmarksTutorial;
  final bool loading;

  TutorialState copyWith({
    bool? showBibleTutorial,
    bool? showBookmarksTutorial,
    bool? loading,
  }) {
    return TutorialState(
      showBibleTutorial: showBibleTutorial ?? this.showBibleTutorial,
      showBookmarksTutorial:
          showBookmarksTutorial ?? this.showBookmarksTutorial,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    showBibleTutorial,
    showBookmarksTutorial,
    loading,
  ];

  static const TutorialState initial = TutorialState(
    showBibleTutorial: false,
    showBookmarksTutorial: false,
  );
}
