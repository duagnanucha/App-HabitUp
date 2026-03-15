import 'package:hive/hive.dart';
import 'enums/habit_type.dart';
import 'enums/frequency.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon; // Icon code point as string

  @HiveField(3)
  int colorValue; // Color as int (0xFFxxxxxx)

  @HiveField(4)
  HabitType type;

  @HiveField(5)
  double targetValue; // Goal value

  @HiveField(6)
  String unit; // "ml", "min", "times", ""

  @HiveField(7)
  Frequency frequency;

  @HiveField(8)
  List<int> customDays; // Days of week [1-7]

  @HiveField(9)
  String? reminderTime; // HH:mm format

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  int sortOrder;

  @HiveField(12)
  bool isArchived;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.type,
    required this.targetValue,
    required this.unit,
    required this.frequency,
    this.customDays = const [],
    this.reminderTime,
    required this.createdAt,
    this.sortOrder = 0,
    this.isArchived = false,
  });

  /// Check if habit is scheduled for a given day of week (1=Mon, 7=Sun)
  bool isScheduledFor(int dayOfWeek) {
    switch (frequency) {
      case Frequency.daily:
        return true;
      case Frequency.weekdays:
        return dayOfWeek >= 1 && dayOfWeek <= 5;
      case Frequency.weekends:
        return dayOfWeek >= 6;
      case Frequency.custom:
        return customDays.contains(dayOfWeek);
    }
  }

  /// Get the active days list based on frequency
  List<int> get activeDays {
    if (frequency == Frequency.custom) return customDays;
    return frequency.defaultDays;
  }

  Habit copyWith({
    String? name,
    String? icon,
    int? colorValue,
    HabitType? type,
    double? targetValue,
    String? unit,
    Frequency? frequency,
    List<int>? customDays,
    String? reminderTime,
    int? sortOrder,
    bool? isArchived,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
