import 'package:intl/intl.dart';

class AppDateUtils {
  /// Normalize a DateTime to date-only (midnight)
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get today's date (normalized)
  static DateTime get today => dateOnly(DateTime.now());

  /// Get start of week (Monday) for a given date
  static DateTime startOfWeek(DateTime date) {
    final d = dateOnly(date);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  /// Get end of week (Sunday) for a given date
  static DateTime endOfWeek(DateTime date) {
    final d = dateOnly(date);
    return d.add(Duration(days: 7 - d.weekday));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Get list of dates in a range (inclusive)
  static List<DateTime> datesInRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = dateOnly(start);
    final endDate = dateOnly(end);
    while (!current.isAfter(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }

  /// Get number of days in a month
  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Format date: "Today", "Yesterday", or "Mar 15"
  static String formatRelative(DateTime date) {
    final now = today;
    final d = dateOnly(date);
    if (d == now) return 'Today';
    if (d == now.subtract(const Duration(days: 1))) return 'Yesterday';
    if (d == now.add(const Duration(days: 1))) return 'Tomorrow';
    return DateFormat('MMM d').format(d);
  }

  /// Format: "March 2026"
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Format: "Mon", "Tue", etc.
  static String formatDayOfWeek(int dayOfWeek) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dayOfWeek - 1];
  }

  /// Short day: "M", "T", "W", "T", "F", "S", "S"
  static String formatDayOfWeekShort(int dayOfWeek) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[dayOfWeek - 1];
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get week number of the year
  static int weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final diff = date.difference(firstDayOfYear).inDays;
    return ((diff + firstDayOfYear.weekday) / 7).ceil();
  }
}
