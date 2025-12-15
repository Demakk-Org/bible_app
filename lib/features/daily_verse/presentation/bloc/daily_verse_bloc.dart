//
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/data/verse_library.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/daily_verse/data/model/daily_verse.dart';
import 'package:bible_app/features/daily_verse/domain/repository/daily_verse_repository.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_state.dart';

class DailyVerseBloc extends Cubit<DailyVerseState> {
  DailyVerseBloc(this._dailyVerseRepository)
    : super(DailyVerseState(date: DateTime.now()));

  final DailyVerseRepository _dailyVerseRepository;

  Future<void> getDailyVerse(DateTime date) async {
    emit(state.copyWith(status: QueryStatus.loading));

    final resultfromCache = await _dailyVerseRepository
        .fetchDailyVerseFormCache(date);

    if (resultfromCache.isRight) {
      emit(
        state.copyWith(
          status: QueryStatus.success,
          verse: resultfromCache.right,
        ),
      );
      return;
    }

    final randomVerse = VerseLibrary.getRandomVerse();

    emit(
      state.copyWith(
        status: QueryStatus.error,
        verse: DailyVerse(
          id: '',
          displayDate: DateTime.fromMillisecondsSinceEpoch(0),
          text: randomVerse.text,
          book: randomVerse.book,
          chapter: randomVerse.chapter,
          verse: randomVerse.verse,
          reference:
              '${randomVerse.bookName} ${randomVerse.chapter}:${randomVerse.verse}',
          tag: '',
          createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      ),
    );
  }

  void changeIsDateChangingStatus([bool? status]) {
    emit(state.copyWith(isUpdatingDate: status ?? !state.isUpdatingDate));
  }

  void updateDate(DateTime? date) {
    emit(state.copyWith(date: date ?? DateTime.now()));
  }
}
