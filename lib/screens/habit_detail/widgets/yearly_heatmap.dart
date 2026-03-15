import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../utils/date_utils.dart';

class YearlyHeatmap extends StatelessWidget {
  final int year;
  final Map<DateTime, bool> completionMap;
  final Color habitColor;

  const YearlyHeatmap({
    super.key,
    required this.year,
    required this.completionMap,
    required this.habitColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Yearly Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryPinkLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$year',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildHeatmapGrid(),
      ],
    );
  }

  Widget _buildHeatmapGrid() {
    // Build a 7-row (days of week) x ~53-column (weeks) grid
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    final totalDays = endDate.difference(startDate).inDays + 1;

    // Map days to grid positions
    final cells = <int, List<Widget>>{};
    for (int i = 0; i < 7; i++) {
      cells[i] = [];
    }

    var current = startDate;
    // Pad first week
    for (int d = 1; d < startDate.weekday; d++) {
      cells[d - 1]!.add(_buildCell(null));
    }

    for (int i = 0; i < totalDays; i++) {
      final dayOfWeek = current.weekday - 1; // 0=Mon
      final isCompleted =
          completionMap[AppDateUtils.dateOnly(current)] == true;
      cells[dayOfWeek]!.add(_buildCell(isCompleted));
      current = current.add(const Duration(days: 1));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(7, (row) {
          return Row(children: cells[row]!);
        }),
      ),
    );
  }

  Widget _buildCell(bool? isCompleted) {
    Color color;
    if (isCompleted == null) {
      color = Colors.transparent;
    } else if (isCompleted) {
      color = habitColor;
    } else {
      color = AppColors.divider;
    }

    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
