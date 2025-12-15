import 'package:equatable/equatable.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/daily_verse/domain/entity/daily_verse_model.dart';

class DailyVerseState extends Equatable {
  const DailyVerseState({
    required this.date,
    this.status = QueryStatus.initial,
    this.error = '',
    this.verse,
    this.isUpdatingDate = false,
  });

  final QueryStatus status;
  final String error;
  final DailyVerseModel? verse;
  final bool isUpdatingDate;
  final DateTime date;

  DailyVerseState copyWith({
    QueryStatus? status,
    String? error,
    DailyVerseModel? verse,
    bool? isUpdatingDate,
    DateTime? date,
  }) {
    return DailyVerseState(
      status: status ?? this.status,
      error: error ?? this.error,
      verse: verse ?? this.verse,
      isUpdatingDate: isUpdatingDate ?? this.isUpdatingDate,
      date: date ?? this.date,
    );
  }

  @override
  List<Object> get props => [isUpdatingDate, status, error, date];

  @override
  String toString() {
    return 'Status: $status, '
        'Error: $error, '
        'IsUpdatingDate: ${isUpdatingDate ? "true" : "false"}, '
        'DailyVerse: $verse, '
        'Date: $date';
  }
}
