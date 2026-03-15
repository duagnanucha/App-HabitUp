import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../models/habit_record.dart';
import '../services/database_service.dart';
import '../utils/streak_calculator.dart';
import '../utils/date_utils.dart';
import 'habit_provider.dart';

// ── Stats for a Single Habit ─────────────────────────────────

final habitStatsProvider =
    Provider.family<HabitStats, String>((ref, habitId) {
  final db = ref.watch(databaseServiceProvider);
  final habit = db.getHabit(habitId);
  if (habit == null) return const HabitStats();

  final records = db.getRecordsForHabit(habitId);
  return StreakCalculator.calculate(habit, records);
});

// ── Records for Habit in Range ───────────────────────────────

final habitRecordsProvider =
    Provider.family<List<HabitRecord>, String>((ref, habitId) {
  final db = ref.watch(databaseServiceProvider);
  return db.getRecordsForHabit(habitId);
});

// ── Report Period ────────────────────────────────────────────

enum ReportPeriod { weekly, monthly, yearly }

final reportPeriodProvider = StateProvider<ReportPeriod>((ref) {
  return ReportPeriod.weekly;
});

// ── Overall Stats for Report ─────────────────────────────────

class OverallStats {
  final double overallCompletionRate;
  final int totalCompletedToday;
  final int totalHabitsToday;
  final Map<String, HabitStats> perHabitStats;

  const OverallStats({
    this.overallCompletionRate = 0,
    this.totalCompletedToday = 0,
    this.totalHabitsToday = 0,
    this.perHabitStats = const {},
  });
}

final overallStatsProvider = Provider<OverallStats>((ref) {
  final db = ref.watch(databaseServiceProvider);
  final habits = ref.watch(habitsProvider);
  final today = AppDateUtils.today;
  final todayRecords = db.getRecordsForDate(today);

  final todayHabits = habits.where((h) => h.isScheduledFor(today.weekday));
  final completedToday = todayRecords.where((r) => r.isCompleted).length;

  final perHabitStats = <String, HabitStats>{};
  double totalRate = 0;

  for (final habit in habits) {
    final records = db.getRecordsForHabit(habit.id);
    final stats = StreakCalculator.calculate(habit, records);
    perHabitStats[habit.id] = stats;
    totalRate += stats.completionRate;
  }

  final avgRate = habits.isNotEmpty ? totalRate / habits.length : 0.0;

  return OverallStats(
    overallCompletionRate: avgRate,
    totalCompletedToday: completedToday,
    totalHabitsToday: todayHabits.length,
    perHabitStats: perHabitStats,
  );
});
