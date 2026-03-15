import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../utils/streak_calculator.dart';
import '../../../utils/date_utils.dart';

class RecordStatsGrid extends StatelessWidget {
  final HabitStats stats;
  final Color habitColor;

  const RecordStatsGrid({
    super.key,
    required this.stats,
    required this.habitColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Records',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_today,
                value: '${_daysThisMonth()}',
                unit: 'Days',
                label: 'Days in ${_currentMonthName()}',
                color: habitColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle,
                value: '${stats.totalDone}',
                unit: 'Days',
                label: 'Total Days Done',
                color: AppColors.accentTeal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.local_fire_department,
                value: '${stats.currentStreak}',
                unit: stats.currentStreak == 1 ? 'Day' : 'Days',
                label: 'Current Streak',
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events,
                value: '${stats.bestStreak}',
                unit: 'Days',
                label: 'Best Streak',
                color: AppColors.accentYellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  int _daysThisMonth() {
    final now = DateTime.now();
    final startOfMonth = AppDateUtils.startOfMonth(now);
    int count = 0;
    stats.completionMap.forEach((date, completed) {
      if (completed && !date.isBefore(startOfMonth) && !date.isAfter(now)) {
        count++;
      }
    });
    return count;
  }

  String _currentMonthName() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[DateTime.now().month - 1];
  }
}
