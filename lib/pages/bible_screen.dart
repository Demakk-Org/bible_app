import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_state.dart';
import 'package:bible_app/features/bible/presentation/ui/bible_view.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        if (state.status == BibleStatus.error) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                if (state.bibles.isEmpty) {
                  await bibleBloc.initializeBibleFromLocalSource();
                } else {
                  await bibleBloc.setCurrentBible(state.bibles.first.id);
                }
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(
                    child: Text('Something went wrong, refresh the page.'),
                  ),
                ],
              ),
            ),
          );
        }

        if ((state.status == BibleStatus.saving && !state.isSelectingBible) ||
            state.status == BibleStatus.initial ||
            state.bibles.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const BibleView();
      },
    );
  }
}
