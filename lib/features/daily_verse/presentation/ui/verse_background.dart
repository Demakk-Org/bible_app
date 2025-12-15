import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_bloc.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_state.dart';

class VerseBackground extends StatelessWidget {
  const VerseBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyVerseBloc, DailyVerseState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()
            ..scale(1.0, state.isUpdatingDate ? 1.0 : 0.75),
          child: Container(
            height: state.isUpdatingDate == true ? 200 : 150,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 34, 117, 158),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        );
      },
    );
  }
}
