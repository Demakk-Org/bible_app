import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/common/utils/share.dart';
import 'package:bible_app/common/widgets/contained_icon_button.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_bloc.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_state.dart';

class BibleNavigationScreen extends StatelessWidget {
  const BibleNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'JosefinSans',
            height: 22 / 16,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: const Color(0xFF595D72), height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DailyVerseComponent(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: const Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_SearchBar(), BookList()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyVerseComponent extends StatelessWidget {
  _DailyVerseComponent();

  final GlobalKey verseKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyVerseBloc, DailyVerseState>(
      builder: (context, state) {
        return RepaintBoundary(
          key: verseKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 25),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              border: Border.all(color: AppColors.primary),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              spacing: 15,
              children: [
                Text(
                  state.verse?.text ?? "Couldn't find a verse for today",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.baseBlack,
                    fontSize: 20,
                    height: 25 / 20,
                    fontFamily: 'JosefinSans',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.verse?.reference ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.baseBlack,
                        fontSize: 20,
                        height: 22 / 20,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    26.ww,
                    ContainedIconButton(
                      action: () async {
                        await shareCapturedWidget(verseKey);
                      },
                      icon: Icons.share_outlined,
                    ),
                    5.ww,
                    ContainedIconButton(
                      action: () async {
                        final verse = state.verse;
                        if (verse == null) return;
                        final text = '"${verse.text}", ${verse.reference}.';

                        await Clipboard.setData(ClipboardData(text: text));
                      },
                      icon: Icons.copy,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 36,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.gray500),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                onChanged: (value) {
                  context.read<BibleBloc>().changeSearchQuery(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  int currentBookIndex = 1;
  late final BibleBloc bibleBloc;

  @override
  void initState() {
    super.initState();
    bibleBloc = context.read<BibleBloc>();
    setState(() {
      currentBookIndex = bibleBloc.state.currentPage.book;
    });
    bibleBloc.changeSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final books =
            state.currentBible?.verses
                .where((v) => v.chapter == 1 && v.verse == 1)
                .toList() ??
            [];

        final filteredBooks = state.searchQuery.isEmpty
            ? books
            : books
                  .where(
                    (book) => book.bookName.toLowerCase().startsWith(
                      state.searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

        final chapters =
            state.currentBible?.verses
                .where((v) => v.book == currentBookIndex && v.verse == 1)
                .map((v) => v.chapter)
                .toList() ??
            [];

        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: (filteredBooks.isNotEmpty)
                ? Column(
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (filteredBooks.isNotEmpty)
                                    Expanded(
                                      child: ListView.separated(
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  currentBookIndex =
                                                      filteredBooks[index].book;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      filteredBooks[index]
                                                              .book ==
                                                          currentBookIndex
                                                      ? AppColors
                                                            .backgroundLight
                                                      : Colors.transparent,
                                                ),
                                                child: Text(
                                                  filteredBooks[index].bookName,
                                                  style: const TextStyle(
                                                    color: AppColors.baseBlack,
                                                    fontSize: 20,
                                                    fontFamily: 'JosefinSans',
                                                    height: 22 / 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        separatorBuilder: (context, index) =>
                                            Container(
                                              height: 1,
                                              color: AppColors.gray200,
                                            ),
                                        itemCount: filteredBooks.length,
                                      ),
                                    ),
                                  if (filteredBooks.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 50,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'No books found',
                                          style: TextStyle(
                                            color: AppColors.baseBlack,
                                            fontSize: 20,
                                            fontFamily: 'JosefinSans',
                                            height: 22 / 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                            onTap: () {
                                              final newPage = BiblePage(
                                                book: currentBookIndex,
                                                chapter: chapters[index],
                                                scrollToVerse: false,
                                              );
                                              bibleBloc.changeChapter(newPage);
                                              context.pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    (currentBookIndex ==
                                                            state
                                                                .currentPage
                                                                .book &&
                                                        state
                                                                .currentPage
                                                                .chapter ==
                                                            index + 1)
                                                    ? AppColors.backgroundLight
                                                    : Colors.transparent,
                                              ),
                                              child: Text(
                                                chapters[index].toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: AppColors.baseBlack,
                                                  fontSize: 20,
                                                  fontFamily: 'JosefinSans',
                                                  height: 22 / 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                      separatorBuilder: (context, index) =>
                                          Container(
                                            height: 1,
                                            color: AppColors.gray200,
                                          ),
                                      itemCount: chapters.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      'No books found',
                      style: TextStyle(
                        color: AppColors.baseBlack,
                        fontSize: 20,
                        fontFamily: 'JosefinSans',
                        height: 22 / 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
