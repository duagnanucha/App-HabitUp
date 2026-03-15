import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class StatsSummaryRow extends StatelessWidget {
  final double metPercentage;
  final int bestDay;
  final int totalDone;
  final int bestStreak;

  const StatsSummaryRow({
    super.key,
    required this.metPercentage,
    required this.bestDay,
    required this.totalDone,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            '${metPercentage.toInt()}',
            '%',
            'Met',
            AppColors.accentRed,
          ),
          _buildStatItem(
            '$bestDay',
            'd',
            'BestDay',
            AppColors.accentBlue,
          ),
          _buildStatItem(
            '$totalDone',
            '',
            'TotalDone',
            AppColors.accentTeal,
          ),
          _buildStatItem(
            '$bestStreak',
            'd',
            'BestStreak',
            AppColors.accentOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String suffix,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (suffix.isNotEmpty)
                TextSpan(
                  text: suffix,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color.withOpacity(0.7),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
