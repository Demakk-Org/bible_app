import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/common/utils/share.dart';
import 'package:bible_app/common/widgets/contained_icon_button.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_bloc.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyVerseComponent extends StatelessWidget {
  DailyVerseComponent({super.key});

  final GlobalKey verseKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyVerseBloc, DailyVerseState>(
      builder: (context, state) {
        final dailyVerse = state.verse;
        final bibleBloc = context.read<BibleBloc>();
        final currentBible = bibleBloc.state.currentBible;

        String displayText =
            dailyVerse?.text ?? "Couldn't find a verse for today";
        String displayReference = dailyVerse?.reference ?? '';

        if (currentBible != null && dailyVerse != null) {
          try {
            final Verse bibleVerse = currentBible.getVerse(
              book: dailyVerse.book,
              chapter: dailyVerse.chapter,
              verse: dailyVerse.verse,
            );
            displayText = bibleVerse.text;
            displayReference = bibleVerse.getReference();
          } on StateError {
            displayText = dailyVerse.text;
            displayReference = dailyVerse.reference;
          }
        }

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
                  displayText,
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
                      displayReference,
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
                        if (displayReference.isEmpty) return;
                        final text = '"$displayText", $displayReference.';

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
