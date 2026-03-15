import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/habit.dart';
import '../models/habit_record.dart';
import '../services/database_service.dart';

class ExportUtils {
  static final DatabaseService _db = DatabaseService();

  /// Export all habits and records to JSON string
  static String exportToJsonString() {
    final habits = _db.getAllHabits(includeArchived: true);
    final allRecords = <HabitRecord>[];

    for (final habit in habits) {
      allRecords.addAll(_db.getRecordsForHabit(habit.id));
    }

    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'habits': habits.map((h) => _habitToJson(h)).toList(),
      'records': allRecords.map((r) => _recordToJson(r)).toList(),
    };

    return jsonEncode(data);
  }

  static Map<String, dynamic> _habitToJson(Habit h) {
    return {
      'id': h.id,
      'name': h.name,
      'icon': h.icon,
      'colorValue': h.colorValue,
      'type': h.type.index,
      'targetValue': h.targetValue,
      'unit': h.unit,
      'frequency': h.frequency.index,
      'customDays': h.customDays,
      'reminderTime': h.reminderTime,
      'createdAt': h.createdAt.toIso8601String(),
      'sortOrder': h.sortOrder,
      'isArchived': h.isArchived,
    };
  }

  static Map<String, dynamic> _recordToJson(HabitRecord r) {
    return {
      'id': r.id,
      'habitId': r.habitId,
      'date': r.date.toIso8601String(),
      'value': r.value,
      'isCompleted': r.isCompleted,
    };
  }
}
