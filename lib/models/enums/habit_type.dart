import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit_type.g.dart';

@HiveType(typeId: 10)
enum HabitType {
  @HiveField(0)
  boolean,   // Simple yes/no (e.g., Swim ✓)

  @HiveField(1)
  quantity,  // Measurable amount (e.g., Drink water 3000ml)

  @HiveField(2)
  count,     // Number of times (e.g., Stand 3 times)

  @HiveField(3)
  duration,  // Time-based (e.g., Yoga 30 min)
}

extension HabitTypeExtension on HabitType {
  String get label {
    switch (this) {
      case HabitType.boolean:
        return 'Yes / No';
      case HabitType.quantity:
        return 'Quantity';
      case HabitType.count:
        return 'Count';
      case HabitType.duration:
        return 'Duration';
    }
  }

  String get description {
    switch (this) {
      case HabitType.boolean:
        return 'Mark as done or not done';
      case HabitType.quantity:
        return 'Track a measurable amount (ml, steps, etc.)';
      case HabitType.count:
        return 'Count number of times';
      case HabitType.duration:
        return 'Track time spent (minutes)';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitType.boolean:
        return Icons.check_circle_outline;
      case HabitType.quantity:
        return Icons.water_drop_outlined;
      case HabitType.count:
        return Icons.numbers;
      case HabitType.duration:
        return Icons.timer_outlined;
    }
  }

  String defaultUnit() {
    switch (this) {
      case HabitType.boolean:
        return '';
      case HabitType.quantity:
        return 'ml';
      case HabitType.count:
        return 'times';
      case HabitType.duration:
        return 'min';
    }
  }

  double defaultTarget() {
    switch (this) {
      case HabitType.boolean:
        return 1;
      case HabitType.quantity:
        return 2000;
      case HabitType.count:
        return 3;
      case HabitType.duration:
        return 30;
    }
  }
}

