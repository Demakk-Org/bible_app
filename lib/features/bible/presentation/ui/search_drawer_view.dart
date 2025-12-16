import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/search/search_result_view.dart';

class SearchDrawerView extends StatelessWidget {
  const SearchDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.85,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(
          height: size.height * 0.95,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black26,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 12,
            children: [
              BibleVerseSearchBar(),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TestamentSelector(),
                  BookSelector(),
                  QueryAccuracySelector(),
                ],
              ),
              SearchResultView(),
            ],
          ),
        ),
      ),
    );
  }
}

class BibleVerseSearchBar extends StatefulWidget {
  const BibleVerseSearchBar({super.key});

  @override
  State<BibleVerseSearchBar> createState() => _BibleVerseSearchBarState();
}

class _BibleVerseSearchBarState extends State<BibleVerseSearchBar> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final bibleBloc = context.read<BibleBloc>();
    final searchFilter = bibleBloc.state.searchFilter;
    _searchController = TextEditingController(text: searchFilter?.query ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                onSubmitted: (value) {
                  final currentFilterState =
                      bibleBloc.state.searchFilter ?? SearchFilter();
                  bibleBloc
                    ..changeSearchFilter(
                      currentFilterState.copyWith(query: value),
                    )
                    ..searchVerses();
                },
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.gray500,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final currentFilterState =
                  bibleBloc.state.searchFilter ?? SearchFilter();
              bibleBloc
                ..changeSearchFilter(
                  currentFilterState.copyWith(query: searchQuery),
                )
                ..searchVerses();
              FocusScope.of(context).unfocus();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

class BookSelector extends StatelessWidget {
  const BookSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final bibleFilter = state.searchFilter;
        final getBooks = state.currentBible!.getBookList(
          bookType: bibleFilter?.type,
        );
        return Container(
          height: 30,
          padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButton(
            menuMaxHeight: 400,
            value: bibleFilter?.book ?? 'All',
            underline: Container(),
            items: [
              _buildMenuItem('All'),
              ...getBooks.map((e) => _buildMenuItem(e['name'].toString())),
            ],
            onChanged: (value) {
              context.read<BibleBloc>().changeSearchFilter(
                state.searchFilter?.copyWith(book: value) ??
                    SearchFilter(book: value!),
              );
            },
            isDense: true,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ),
        );
      },
    );
  }
}

class TestamentSelector extends StatelessWidget {
  const TestamentSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    final bibleTypeList = bibleBloc.state.currentBible!.getBibleTypeList();
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final bibleFilter = state.searchFilter;
        return Container(
          height: 30,
          padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButton(
            value: bibleFilter?.type.label ?? BibleType.all.label,
            underline: Container(),
            items: [
              _buildMenuItem(BibleType.all.label),
              ...bibleTypeList.map((e) => _buildMenuItem(e.label)),
            ],
            isDense: true,
            onChanged: (value) {
              if (value == null) return;
              bibleBloc.changeSearchFilter(
                bibleFilter?.copyWith(
                      book: 'All',
                      type: BibleType.fromString(value),
                    ) ??
                    SearchFilter(),
              );
            },
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ),
        );
      },
    );
  }
}

class QueryAccuracySelector extends StatelessWidget {
  const QueryAccuracySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final bibleFilter = state.searchFilter;
        return Container(
          height: 30,
          padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButton(
            value:
                bibleFilter?.queryAccuracy.name ?? QueryAccuracy.partial.name,
            underline: Container(),
            items: QueryAccuracy.values.map((q) {
              return _buildMenuItem(q.name);
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              context.read<BibleBloc>().changeSearchFilter(
                state.searchFilter?.copyWith(
                      queryAccuracy: QueryAccuracy.fromString(value),
                    ) ??
                    SearchFilter(
                      queryAccuracy: QueryAccuracy.fromString(value),
                    ),
              );
            },
            isDense: true,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ),
        );
      },
    );
  }
}

DropdownMenuItem<String> _buildMenuItem(String value) {
  return DropdownMenuItem(
    value: value,
    child: Text(
      value,
      style: const TextStyle(
        color: AppColors.baseBlack,
        fontSize: 12,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
