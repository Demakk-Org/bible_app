import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/date_formatter.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_bloc.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_state.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  static const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    final dailyVerseBloc = context.read<DailyVerseBloc>();
    return BlocBuilder<DailyVerseBloc, DailyVerseState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.isUpdatingDate)
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (state.date.month == 0) return;

                  dailyVerseBloc.updateDate(
                    state.date.copyWith(month: state.date.month - 1, day: 1),
                  );
                },
                icon: const Icon(
                  Icons.arrow_left,
                  size: 24,
                  color: AppColors.baseWhite,
                ),
                splashColor: AppColors.impaktRed200,
              ),
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              onPressed: dailyVerseBloc.changeIsDateChangingStatus,
              child: Text(
                state.isUpdatingDate
                    ? months[state.date.month - 1]
                    : DateTimeUtils.isDateToday(state.date)
                    ? 'Today'
                    : '${months[state.date.month - 1]} ${state.date.day}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            if (state.isUpdatingDate)
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (state.date.month == 11) return;

                  dailyVerseBloc.updateDate(
                    state.date.copyWith(month: state.date.month + 1, day: 1),
                  );
                },
                icon: const Icon(
                  Icons.arrow_right,
                  size: 24,
                  color: AppColors.baseWhite,
                ),
                splashColor: AppColors.impaktRed200,
              ),
          ],
        );
      },
    );
  }
}
