import 'package:intl/intl.dart';

String getWeekdayName(int weekday) {
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return weekdays[weekday - 1];
}

class DateTimeUtils {
  // Formats a DateTime object to 'MMM d, y' format (e.g., Feb 5, 2024)
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final minutesString = minutes.toString().padLeft(2, '0');
    final remainingSeconds = seconds % 60;
    final secondsString = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  static bool isDateToday(DateTime date) {
    final today = DateTime.now();
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }
}
