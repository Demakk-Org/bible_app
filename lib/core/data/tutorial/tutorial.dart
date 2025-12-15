// part 'audio.g.dart';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/core/domain/tutorial/tutorial_model.dart';

part 'tutorial.g.dart';

@HiveType(typeId: 45)
class Tutorial extends HiveObject implements TutorialModel {
  Tutorial({
    required this.isHomePageTutorialCompleted,
    required this.isBibleTutorialCompleted,
    required this.isAudiosTutorialCompleted,
    required this.isGroupsTutorialCompleted,
    required this.isNewsTutorialCompleted,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      isHomePageTutorialCompleted: json['isHomePageTutorialCompleted'] as bool,
      isBibleTutorialCompleted: json['isBibleTutorialCompleted'] as bool,
      isAudiosTutorialCompleted: json['isAudiosTutorialCompleted'] as bool,
      isGroupsTutorialCompleted: json['isGroupsTutorialCompleted'] as bool,
      isNewsTutorialCompleted: json['isNewsTutorialCompleted'] as bool,
    );
  }

  factory Tutorial.defaultTutorial() {
    return Tutorial(
      isHomePageTutorialCompleted: false,
      isBibleTutorialCompleted: false,
      isAudiosTutorialCompleted: false,
      isGroupsTutorialCompleted: false,
      isNewsTutorialCompleted: false,
    );
  }

  @override
  @HiveField(0)
  final bool isHomePageTutorialCompleted;

  @override
  @HiveField(1)
  final bool isBibleTutorialCompleted;

  @override
  @HiveField(2)
  final bool isAudiosTutorialCompleted;

  @override
  @HiveField(3)
  final bool isGroupsTutorialCompleted;

  @override
  @HiveField(4)
  final bool isNewsTutorialCompleted;

  String toJson() {
    final data = <String, dynamic>{
      'isHomePageTutorialCompleted': isHomePageTutorialCompleted,
      'isBibleTutorialCompleted': isBibleTutorialCompleted,
      'isAudiosTutorialCompleted': isAudiosTutorialCompleted,
      'isGroupsTutorialCompleted': isGroupsTutorialCompleted,
      'isNewsTutorialCompleted': isNewsTutorialCompleted,
    };
    return jsonEncode(data);
  }

  @override
  String toString() {
    return '''
        Tutorial(
          isHomePageTutorialCompleted: $isHomePageTutorialCompleted, 
          isBibleTutorialCompleted: $isBibleTutorialCompleted, 
          isAudiosTutorialCompleted: $isAudiosTutorialCompleted, 
          isGroupsTutorialCompleted: $isGroupsTutorialCompleted, 
          isNewsTutorialCompleted: $isNewsTutorialCompleted
        )
        ''';
  }
}
