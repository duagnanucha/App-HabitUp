import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../models/habit_record.dart';
import '../models/enums/habit_type.dart';
import '../services/database_service.dart';
import '../utils/date_utils.dart';

const _uuid = Uuid();

// ── Database Service Provider ────────────────────────────────

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// ── Habits List Provider ─────────────────────────────────────

final habitsProvider =
    StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return HabitsNotifier(db);
});

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final DatabaseService _db;

  HabitsNotifier(this._db) : super([]) {
    _loadHabits();
  }

  void _loadHabits() {
    state = _db.getAllHabits();
  }

  Future<void> addHabit(Habit habit) async {
    await _db.saveHabit(habit);
    _loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _db.saveHabit(habit);
    _loadHabits();
  }

  Future<void> deleteHabit(String id) async {
    await _db.deleteHabit(id);
    _loadHabits();
  }

  Future<void> archiveHabit(String id) async {
    await _db.archiveHabit(id);
    _loadHabits();
  }

  Future<void> reorderHabits(List<String> orderedIds) async {
    await _db.reorderHabits(orderedIds);
    _loadHabits();
  }
}

// ── Selected Date Provider ───────────────────────────────────

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return AppDateUtils.today;
});

// ── Habits for Selected Date ─────────────────────────────────

final habitsForDateProvider = Provider<List<Habit>>((ref) {
  final habits = ref.watch(habitsProvider);
  final date = ref.watch(selectedDateProvider);
  return habits.where((h) => h.isScheduledFor(date.weekday)).toList();
});

// ── Records for Date Provider ────────────────────────────────

final recordsForDateProvider =
    StateNotifierProvider<RecordsNotifier, Map<String, HabitRecord>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  final date = ref.watch(selectedDateProvider);
  return RecordsNotifier(db, date);
});

class RecordsNotifier extends StateNotifier<Map<String, HabitRecord>> {
  final DatabaseService _db;
  final DateTime _date;

  RecordsNotifier(this._db, this._date) : super({}) {
    _loadRecords();
  }

  void _loadRecords() {
    final records = _db.getRecordsForDate(_date);
    state = {for (final r in records) r.habitId: r};
  }

  /// Toggle boolean habit completion
  Future<void> toggleHabit(Habit habit) async {
    final existing = state[habit.id];
    if (existing != null) {
      // Toggle off
      if (existing.isCompleted) {
        final updated = existing.copyWith(value: 0, isCompleted: false);
        await _db.saveRecord(updated);
      } else {
        final updated = existing.copyWith(
          value: habit.targetValue,
          isCompleted: true,
        );
        await _db.saveRecord(updated);
      }
    } else {
      // Create new completed record
      final record = HabitRecord(
        id: _uuid.v4(),
        habitId: habit.id,
        date: _date,
        value: habit.targetValue,
        isCompleted: true,
      );
      await _db.saveRecord(record);
    }
    _loadRecords();
  }

  /// Update value for quantity/count/duration habits
  Future<void> updateValue(Habit habit, double newValue) async {
    final isCompleted = newValue >= habit.targetValue;
    final existing = state[habit.id];

    if (existing != null) {
      final updated = existing.copyWith(
        value: newValue,
        isCompleted: isCompleted,
      );
      await _db.saveRecord(updated);
    } else {
      final record = HabitRecord(
        id: _uuid.v4(),
        habitId: habit.id,
        date: _date,
        value: newValue,
        isCompleted: isCompleted,
      );
      await _db.saveRecord(record);
    }
    _loadRecords();
  }

  /// Increment value by a step
  Future<void> incrementValue(Habit habit, double step) async {
    final existing = state[habit.id];
    final currentValue = existing?.value ?? 0;
    await updateValue(habit, currentValue + step);
  }
}
