import 'package:hive/hive.dart';

part 'habit_record.g.dart';

@HiveType(typeId: 1)
class HabitRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String habitId;

  @HiveField(2)
  final DateTime date; // Date only (no time component)

  @HiveField(3)
  double value; // Current progress value

  @HiveField(4)
  bool isCompleted; // Met the target?

  HabitRecord({
    required this.id,
    required this.habitId,
    required this.date,
    this.value = 0,
    this.isCompleted = false,
  });

  /// Normalized date key for lookups (yyyy-MM-dd)
  String get dateKey => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Composite key for unique lookup: habitId_dateKey
  String get compositeKey => '${habitId}_$dateKey';

  HabitRecord copyWith({
    double? value,
    bool? isCompleted,
  }) {
    return HabitRecord(
      id: id,
      habitId: habitId,
      date: date,
      value: value ?? this.value,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
