import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/core/domain/tutorial/tutorial_model.dart';

part 'tutorial.g.dart';

@HiveType(typeId: 45)
class Tutorial extends HiveObject implements TutorialModel {
  Tutorial({
    required this.isBibleTutorialCompleted,
    required this.isBookmarksTutorialCompleted,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      isBibleTutorialCompleted: json['isBibleTutorialCompleted'] as bool,
      isBookmarksTutorialCompleted:
          (json['isBookmarksTutorialCompleted'] as bool?) ?? false,
    );
  }

  factory Tutorial.defaultTutorial() {
    return Tutorial(
      isBibleTutorialCompleted: false,
      isBookmarksTutorialCompleted: false,
    );
  }

  @override
  @HiveField(1)
  final bool isBibleTutorialCompleted;

  @override
  @HiveField(2)
  final bool isBookmarksTutorialCompleted;

  String toJson() {
    final data = <String, dynamic>{
      'isBibleTutorialCompleted': isBibleTutorialCompleted,
      'isBookmarksTutorialCompleted': isBookmarksTutorialCompleted,
    };
    return jsonEncode(data);
  }

  @override
  String toString() {
    return '''
        Tutorial(
          isBibleTutorialCompleted: $isBibleTutorialCompleted, 
          isBookmarksTutorialCompleted: $isBookmarksTutorialCompleted, 
        )
        ''';
  }
}
