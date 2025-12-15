import 'package:equatable/equatable.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';

class BibleState extends Equatable {
  const BibleState({
    required this.bibles,
    required this.currentPage,
    this.status = BibleStatus.initial,
    this.error = "",
    this.currentBible,
    this.searchQuery = '',
    this.bookmarkedVerses,
    this.searchFilter,
    this.filteredVerses = const [],
    this.isSelectingBible = false,
    this.isRedirected = false,
  });

  final BibleStatus status;
  final String error;
  final List<Bible> bibles;
  final Bible? currentBible;
  final BiblePage currentPage;
  final String searchQuery;
  final List<Verse>? bookmarkedVerses;
  final SearchFilter? searchFilter;
  final List<Verse> filteredVerses;
  final bool isSelectingBible;
  final bool isRedirected;

  BibleState copyWith({
    BibleStatus? status,
    String? error,
    List<Bible>? bibles,
    Bible? currentBible,
    BiblePage? currentPage,
    String? searchQuery,
    List<Verse>? bookmarkedVerses,
    SearchFilter? searchFilter,
    List<Verse>? filteredVerses,
    bool? isSelectingBible,
    bool? isRedirected,
  }) {
    return BibleState(
      status: status ?? this.status,
      error: error ?? this.error,
      bibles: bibles ?? this.bibles,
      currentBible: currentBible ?? this.currentBible,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      bookmarkedVerses: bookmarkedVerses ?? this.bookmarkedVerses,
      searchFilter: searchFilter ?? this.searchFilter,
      filteredVerses: filteredVerses ?? this.filteredVerses,
      isSelectingBible: isSelectingBible ?? this.isSelectingBible,
      isRedirected: isRedirected ?? this.isRedirected,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    bibles,
    currentBible,
    currentPage,
    searchQuery,
    bookmarkedVerses,
    searchFilter,
    filteredVerses,
    isSelectingBible,
    isRedirected,
  ];
}
