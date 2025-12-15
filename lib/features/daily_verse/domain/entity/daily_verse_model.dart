abstract class DailyVerseModel {
  String get id;
  String get text;
  String get reference;
  int get book;
  int get chapter;
  int get verse;
  DateTime get displayDate;
  DateTime get createdAt;
  String get tag;

  Map<String, dynamic> toJson();
}
