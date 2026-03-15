import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../utils/date_utils.dart';

class CalendarHeatmap extends StatelessWidget {
  final DateTime month;
  final Map<DateTime, bool> completionMap;
  final Color habitColor;
  final ValueChanged<DateTime>? onMonthChanged;

  const CalendarHeatmap({
    super.key,
    required this.month,
    required this.completionMap,
    required this.habitColor,
    this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = AppDateUtils.startOfMonth(month);
    final daysInMonth = AppDateUtils.daysInMonth(month.year, month.month);
    final startWeekday = firstDay.weekday; // 1=Mon

    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                onMonthChanged?.call(
                  DateTime(month.year, month.month - 1, 1),
                );
              },
            ),
            Text(
              AppDateUtils.formatMonthYear(month),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                onMonthChanged?.call(
                  DateTime(month.year, month.month + 1, 1),
                );
              },
            ),
          ],
        ),

        // Day of week headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              return SizedBox(
                width: 36,
                child: Text(
                  AppDateUtils.formatDayOfWeekShort(i + 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),

        // Calendar grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildCalendarGrid(daysInMonth, startWeekday),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int startWeekday) {
    final rows = <Widget>[];
    var dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      if (dayCounter > daysInMonth) break;

      final cells = <Widget>[];
      for (int weekday = 1; weekday <= 7; weekday++) {
        if ((week == 0 && weekday < startWeekday) ||
            dayCounter > daysInMonth) {
          cells.add(const SizedBox(width: 36, height: 36));
        } else {
          final date = DateTime(month.year, month.month, dayCounter);
          final isCompleted = completionMap[AppDateUtils.dateOnly(date)] == true;
          final isToday = AppDateUtils.isSameDay(date, AppDateUtils.today);

          cells.add(
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted ? habitColor : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: habitColor, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$dayCounter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isToday ? FontWeight.w700 : FontWeight.w400,
                    color: isCompleted
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: cells,
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}
