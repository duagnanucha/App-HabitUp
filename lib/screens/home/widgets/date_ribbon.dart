import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';
import '../../../providers/habit_provider.dart';
import '../../../utils/date_utils.dart';

class DateRibbon extends ConsumerWidget {
  const DateRibbon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = AppDateUtils.today;

    // Show 2 weeks: 7 days before today + today + 6 days after
    final dates = List.generate(
      14,
      (i) => today.subtract(Duration(days: 7 - i)),
    );

    return Column(
      children: [
        // Header: "Today" or selected date
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "ALL" filter chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'ALL ✓',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                AppDateUtils.formatRelative(selectedDate),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              // Calendar icon
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined, size: 20),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: today.add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    ref.read(selectedDateProvider.notifier).state = picked;
                  }
                },
              ),
            ],
          ),
        ),

        // Scrollable date strip
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = AppDateUtils.isSameDay(date, selectedDate);
              final isToday = AppDateUtils.isSameDay(date, today);

              return GestureDetector(
                onTap: () {
                  ref.read(selectedDateProvider.notifier).state = date;
                },
                child: Container(
                  width: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPink
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primaryPink, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppDateUtils.formatDayOfWeekShort(date.weekday),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
