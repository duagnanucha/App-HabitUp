import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../models/habit_record.dart';
import '../models/enums/habit_type.dart';
import '../models/enums/frequency.dart';

class DatabaseService {
  static const String _habitsBox = 'habits';
  static const String _recordsBox = 'records';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(HabitRecordAdapter());
    Hive.registerAdapter(HabitTypeAdapter());
    Hive.registerAdapter(FrequencyAdapter());

    // Open boxes
    await Hive.openBox<Habit>(_habitsBox);
    await Hive.openBox<HabitRecord>(_recordsBox);
  }

  // ── Habits CRUD ──────────────────────────────────────────

  Box<Habit> get _habits => Hive.box<Habit>(_habitsBox);

  List<Habit> getAllHabits({bool includeArchived = false}) {
    final habits = _habits.values.toList();
    if (!includeArchived) {
      habits.removeWhere((h) => h.isArchived);
    }
    habits.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return habits;
  }

  Habit? getHabit(String id) {
    return _habits.get(id);
  }

  Future<void> saveHabit(Habit habit) async {
    await _habits.put(habit.id, habit);
  }

  Future<void> deleteHabit(String id) async {
    await _habits.delete(id);
    // Also delete all records for this habit
    final records = _records.values.where((r) => r.habitId == id).toList();
    for (final record in records) {
      await _records.delete(record.compositeKey);
    }
  }

  Future<void> archiveHabit(String id) async {
    final habit = _habits.get(id);
    if (habit != null) {
      habit.isArchived = true;
      await habit.save();
    }
  }

  Future<void> reorderHabits(List<String> orderedIds) async {
    for (int i = 0; i < orderedIds.length; i++) {
      final habit = _habits.get(orderedIds[i]);
      if (habit != null) {
        habit.sortOrder = i;
        await habit.save();
      }
    }
  }

  // ── Records CRUD ─────────────────────────────────────────

  Box<HabitRecord> get _records => Hive.box<HabitRecord>(_recordsBox);

  HabitRecord? getRecord(String habitId, DateTime date) {
    final key = _compositeKey(habitId, date);
    return _records.get(key);
  }

  Future<void> saveRecord(HabitRecord record) async {
    await _records.put(record.compositeKey, record);
  }

  List<HabitRecord> getRecordsForHabit(String habitId) {
    return _records.values
        .where((r) => r.habitId == habitId)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<HabitRecord> getRecordsForDate(DateTime date) {
    final dateKey = _dateKey(date);
    return _records.values
        .where((r) => r.dateKey == dateKey)
        .toList();
  }

  List<HabitRecord> getRecordsInRange(
    String habitId,
    DateTime start,
    DateTime end,
  ) {
    return _records.values
        .where((r) =>
            r.habitId == habitId &&
            !r.date.isBefore(start) &&
            !r.date.isAfter(end))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<HabitRecord> getAllRecordsInRange(DateTime start, DateTime end) {
    return _records.values
        .where((r) => !r.date.isBefore(start) && !r.date.isAfter(end))
        .toList();
  }

  Future<void> deleteRecord(String habitId, DateTime date) async {
    final key = _compositeKey(habitId, date);
    await _records.delete(key);
  }

  // ── Helpers ──────────────────────────────────────────────

  String _compositeKey(String habitId, DateTime date) {
    return '${habitId}_${_dateKey(date)}';
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
