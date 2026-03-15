import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';
import '../../../providers/stats_provider.dart';

class HabitProgressSummary extends ConsumerWidget {
  const HabitProgressSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(overallStatsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryPink, AppColors.primaryPinkLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            '${stats.totalCompletedToday}/${stats.totalHabitsToday}',
            'Done Today',
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.textPrimary.withOpacity(0.2),
          ),
          _buildStat(
            '${(stats.overallCompletionRate * 100).toInt()}%',
            'Overall',
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
