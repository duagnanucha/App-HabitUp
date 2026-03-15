import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../models/habit.dart';
import '../../../models/habit_record.dart';
import '../../../utils/date_utils.dart';

class DotMatrix extends StatelessWidget {
  final Habit habit;
  final List<HabitRecord> records;
  final DateTime startDate;
  final DateTime endDate;

  const DotMatrix({
    super.key,
    required this.habit,
    required this.records,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final dates = AppDateUtils.datesInRange(startDate, endDate);
    final recordMap = <String, HabitRecord>{};
    for (final r in records) {
      recordMap[r.dateKey] = r;
    }
    final habitColor = Color(habit.colorValue);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Habit icon + name
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(
                  IconData(
                    int.tryParse(habit.icon) ?? 0xe156,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: habitColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Dots
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: dates.map((date) {
                final dateKey =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final record = recordMap[dateKey];
                final isScheduled = habit.isScheduledFor(date.weekday);

                Color dotColor;
                if (!isScheduled) {
                  dotColor = Colors.transparent;
                } else if (record != null && record.isCompleted) {
                  dotColor = habitColor;
                } else if (date.isAfter(AppDateUtils.today)) {
                  dotColor = AppColors.divider;
                } else {
                  dotColor = habitColor.withOpacity(0.2);
                }

                return Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
