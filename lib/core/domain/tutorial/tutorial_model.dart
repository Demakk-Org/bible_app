abstract class TutorialModel {
  TutorialModel({
    required this.isHomePageTutorialCompleted,
    required this.isBibleTutorialCompleted,
    required this.isAudiosTutorialCompleted,
    required this.isGroupsTutorialCompleted,
    required this.isNewsTutorialCompleted,
  });

  final bool isHomePageTutorialCompleted;
  final bool isBibleTutorialCompleted;
  final bool isAudiosTutorialCompleted;
  final bool isGroupsTutorialCompleted;
  final bool isNewsTutorialCompleted;
}
