import 'package:bible_app/common/utils/date_formatter.dart';

extension DateChecker on DateTime {
  bool isEqualTo(DateTime date) {
    final today = this;
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }

  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}hr${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  DateTime? from(dynamic date) {
    if (date == null) return null;
    if (date is String) {
      return DateTime.parse(date);
    }  else {
      throw const FormatException('Unknown createdAt format');
    }
  }

  String getWeekdayInitial() {
    return getWeekdayName(weekday)[0].toUpperCase();
  }
}
