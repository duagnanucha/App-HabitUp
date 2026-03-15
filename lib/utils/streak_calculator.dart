import '../models/habit.dart';
import '../models/habit_record.dart';
import 'date_utils.dart';

class HabitStats {
  final int totalDone;
  final int currentStreak;
  final int bestStreak;
  final int bestDay; // Day of week with most completions (1=Mon)
  final double completionRate; // 0.0 - 1.0
  final Map<DateTime, bool> completionMap; // date -> completed

  const HabitStats({
    this.totalDone = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.bestDay = 1,
    this.completionRate = 0,
    this.completionMap = const {},
  });
}

class StreakCalculator {
  /// Calculate all stats for a habit
  static HabitStats calculate(Habit habit, List<HabitRecord> records) {
    if (records.isEmpty) {
      return const HabitStats();
    }

    final completedRecords = records.where((r) => r.isCompleted).toList();
    final totalDone = completedRecords.length;

    // Completion map
    final completionMap = <DateTime, bool>{};
    for (final record in records) {
      completionMap[AppDateUtils.dateOnly(record.date)] = record.isCompleted;
    }

    // Current streak (counting back from today)
    final currentStreak = _calculateCurrentStreak(habit, completionMap);

    // Best streak
    final bestStreak = _calculateBestStreak(habit, completionMap);

    // Best day of week
    final bestDay = _calculateBestDay(completedRecords);

    // Completion rate
    final totalScheduled = _countScheduledDays(
      habit,
      records.first.date,
      AppDateUtils.today,
    );
    final completionRate =
        totalScheduled > 0 ? totalDone / totalScheduled : 0.0;

    return HabitStats(
      totalDone: totalDone,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      bestDay: bestDay,
      completionRate: completionRate,
      completionMap: completionMap,
    );
  }

  static int _calculateCurrentStreak(
    Habit habit,
    Map<DateTime, bool> completionMap,
  ) {
    int streak = 0;
    var date = AppDateUtils.today;

    // If today isn't completed yet, start from yesterday
    if (completionMap[date] != true) {
      date = date.subtract(const Duration(days: 1));
    }

    while (true) {
      if (!habit.isScheduledFor(date.weekday)) {
        // Skip non-scheduled days
        date = date.subtract(const Duration(days: 1));
        continue;
      }
      if (completionMap[date] == true) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  static int _calculateBestStreak(
    Habit habit,
    Map<DateTime, bool> completionMap,
  ) {
    if (completionMap.isEmpty) return 0;

    final sortedDates = completionMap.keys.toList()..sort();
    int bestStreak = 0;
    int currentStreak = 0;

    var date = sortedDates.first;
    final endDate = sortedDates.last;

    while (!date.isAfter(endDate)) {
      if (!habit.isScheduledFor(date.weekday)) {
        date = date.add(const Duration(days: 1));
        continue;
      }

      if (completionMap[date] == true) {
        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }

      date = date.add(const Duration(days: 1));
    }

    return bestStreak;
  }

  static int _calculateBestDay(List<HabitRecord> completedRecords) {
    if (completedRecords.isEmpty) return 1;

    final dayCounts = <int, int>{};
    for (final record in completedRecords) {
      final day = record.date.weekday;
      dayCounts[day] = (dayCounts[day] ?? 0) + 1;
    }

    int bestDay = 1;
    int maxCount = 0;
    dayCounts.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        bestDay = day;
      }
    });

    return bestDay;
  }

  static int _countScheduledDays(
    Habit habit,
    DateTime start,
    DateTime end,
  ) {
    int count = 0;
    var date = AppDateUtils.dateOnly(start);
    final endDate = AppDateUtils.dateOnly(end);
    while (!date.isAfter(endDate)) {
      if (habit.isScheduledFor(date.weekday)) {
        count++;
      }
      date = date.add(const Duration(days: 1));
    }
    return count;
  }
}
