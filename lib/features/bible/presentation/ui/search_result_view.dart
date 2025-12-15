import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/search_display_grouped_by_book.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final filterResult = state.filteredVerses;
        final groupedVerses = groupVersesByBook(filterResult);

        if (state.status == BibleStatus.searching) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Found: ${filterResult.length} verses',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 22 / 12,
                ),
              ),
              10.hh,
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  separatorBuilder: (context, index) => 20.hh,
                  itemCount: groupedVerses.length,
                  itemBuilder: (context, index) =>
                      SearchDisplayGroupedByBook(verses: groupedVerses[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<List<Verse>> groupVersesByBook(List<Verse> verses) {
    final grouped = <String, List<Verse>>{};

    for (final verse in verses) {
      grouped.putIfAbsent(verse.bookName, () => []).add(verse);
    }

    return grouped.values.toList();
  }
}
