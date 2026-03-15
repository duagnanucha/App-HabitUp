import 'package:hive/hive.dart';

part 'frequency.g.dart';

@HiveType(typeId: 11)
enum Frequency {
  @HiveField(0)
  daily,       // Every day

  @HiveField(1)
  weekdays,    // Mon-Fri

  @HiveField(2)
  weekends,    // Sat-Sun

  @HiveField(3)
  custom,      // Custom days
}

extension FrequencyExtension on Frequency {
  String get label {
    switch (this) {
      case Frequency.daily:
        return 'Every Day';
      case Frequency.weekdays:
        return 'Weekdays';
      case Frequency.weekends:
        return 'Weekends';
      case Frequency.custom:
        return 'Custom';
    }
  }

  List<int> get defaultDays {
    switch (this) {
      case Frequency.daily:
        return [1, 2, 3, 4, 5, 6, 7]; // Mon=1, Sun=7
      case Frequency.weekdays:
        return [1, 2, 3, 4, 5];
      case Frequency.weekends:
        return [6, 7];
      case Frequency.custom:
        return [];
    }
  }
}
