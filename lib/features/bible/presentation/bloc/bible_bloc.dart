import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/domain/repository/bible_repository.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';

class BibleBloc extends Cubit<BibleState> {
  BibleBloc(this._bibleRepository)
    : super(
        BibleState(
          bibles: const [],
          currentPage: BiblePage(book: 1, chapter: 1, scrollToVerse: false),
        ),
      );
  final BibleRepository _bibleRepository;

  Future<void> initializeBibleFromLocalSource() async {
    emit(state.copyWith(status: BibleStatus.saving));
    final result = await _bibleRepository.initializeBibleFromLocalSource();

    result.fold(
      (failure) {
        emit(state.copyWith(status: BibleStatus.error, error: failure.message));
      },
      (bibles) {
        emit(
          state.copyWith(
            status: BibleStatus.success,
            bibles: bibles,
            currentBible: bibles.first,
          ),
        );
      },
    );
  }

  Future<void> downloadBible(String id) async {
    emit(state.copyWith(status: BibleStatus.saving));
    final result = await _bibleRepository.downloadBible(id);

    result.fold(
      (failure) {
        emit(state.copyWith(status: BibleStatus.error, error: failure.message));
      },
      (bibles) {
        emit(state.copyWith(status: BibleStatus.success, bibles: bibles));
      },
    );
  }

  Future<void> setCurrentBible(String id) async {
    emit(state.copyWith(status: BibleStatus.saving));
    final result = await _bibleRepository.getBible(id);

    result.fold(
      (failure) {
        emit(state.copyWith(status: BibleStatus.error, error: failure.message));
      },
      (bible) {
        emit(state.copyWith(status: BibleStatus.success, currentBible: bible));
      },
    );
  }

  void changeChapter(BiblePage newPage) {
    AppLogger.debug('newPage $newPage', name: 'BibleBloc: changeChapter');
    emit(state.copyWith(currentPage: newPage));
  }

  void changeSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  Future<void> setVersesAsBookMark(List<Verse> verses) async {
    final result = await _bibleRepository.setBookmarks(verses);
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
      },
      (bookmarks) {
        emit(state.copyWith(bookmarkedVerses: bookmarks));
      },
    );
  }

  Future<void> getBookmarks() async {
    final result = await _bibleRepository.getBookmarks();

    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
      },
      (bookmarks) {
        emit(state.copyWith(bookmarkedVerses: bookmarks));
      },
    );
  }

  Future<void> removeBookmark(Verse verse) async {
    final result = await _bibleRepository.removeBookmark(verse);
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
      },
      (bookmarks) {
        emit(state.copyWith(bookmarkedVerses: bookmarks));
      },
    );
  }

  void changeSearchFilter(SearchFilter filter) {
    emit(state.copyWith(searchFilter: filter));
  }

  Future<void> searchVerses() async {
    emit(state.copyWith(status: BibleStatus.searching));
    await Future.delayed(const Duration(seconds: 2), () {});

    final searchFilter = state.searchFilter;
    if (searchFilter == null || searchFilter.query.isEmpty) return;

    AppLogger.debug(
      'searchFilter : $searchFilter',
      name: 'BibleBloc: searchVerses',
    );

    final bible = state.currentBible;
    if (bible == null) return;

    final books = bible.getBookList(bookType: searchFilter.type);
    var verses = bible.verses;

    verses = await Future.microtask(() {
      var filteredVerses = verses
          .where((v) => books.map((b) => b['book']).contains(v.book))
          .toList();

      //filter by book name
      if (searchFilter.book != 'All') {
        filteredVerses = filteredVerses
            .where((v) => v.bookName.contains(searchFilter.book))
            .toList();
      }

      //filter by accuracy
      final accurayType = searchFilter.queryAccuracy;

      //filter by query
      return filteredVerses.where((v) {
        final verseTexts = v.text.split(' ');

        for (final verseText in verseTexts) {
          return _isWordInVerse(accurayType, searchFilter.query, verseText);
        }
        return false;
      }).toList();
    });

    AppLogger.info(
      'Found ${verses.length} verses',
      name: "BibleBloc: searchVerses",
    );

    emit(state.copyWith(filteredVerses: verses, status: BibleStatus.success));
  }

  bool _isWordInVerse(
    QueryAccuracy queryAccuracy,
    String query,
    String verseText,
  ) {
    final refinedVerseText = verseText.replaceAll(RegExp('[,?.]'), "");
    switch (queryAccuracy) {
      case QueryAccuracy.exact:
        return query == refinedVerseText;
      case QueryAccuracy.wordOnly:
        return query.toLowerCase() == refinedVerseText.toLowerCase();
      case QueryAccuracy.partial:
        return refinedVerseText.toLowerCase().startsWith(query.toLowerCase());
      case QueryAccuracy.contains:
        return refinedVerseText.toLowerCase().contains(query.toLowerCase());
    }
  }

  void openBibleSelectView() {
    emit(state.copyWith(isSelectingBible: true));
  }

  void closeBibleSelectView() {
    emit(state.copyWith(isSelectingBible: false));
  }

  Future<void> removeBible(String id) async {
    await _bibleRepository.removeBible(id);
    emit(
      state.copyWith(bibles: state.bibles.where((b) => b.id != id).toList()),
    );
  }

  void changeIsRedirectedStatus(bool value) {
    emit(state.copyWith(isRedirected: value));
  }
}
