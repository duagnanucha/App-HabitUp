import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import '../../config/theme.dart';
import '../../providers/habit_provider.dart';
import '../../providers/stats_provider.dart';
import '../../utils/date_utils.dart';
import '../../widgets/banner_ad_widget.dart';
import 'widgets/dot_matrix.dart';
import 'widgets/stats_summary.dart';
import 'widgets/share_card.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(reportPeriodProvider);
    final habits = ref.watch(habitsProvider);
    final db = ref.watch(databaseServiceProvider);
    final overallStats = ref.watch(overallStatsProvider);

    // Date range based on period
    final now = AppDateUtils.today;
    late DateTime startDate;
    late DateTime endDate;

    switch (period) {
      case ReportPeriod.weekly:
        startDate = AppDateUtils.startOfWeek(now);
        endDate = AppDateUtils.endOfWeek(now);
        break;
      case ReportPeriod.monthly:
        startDate = AppDateUtils.startOfMonth(now);
        endDate = AppDateUtils.endOfMonth(now);
        break;
      case ReportPeriod.yearly:
        startDate = AppDateUtils.startOfYear(now);
        endDate = AppDateUtils.endOfYear(now);
        break;
    }

    // Calculate overall stats for the period
    int totalCompleted = 0;
    int totalScheduled = 0;
    int overallBestStreak = 0;
    int overallTotalDone = 0;
    int overallBestDay = 1;

    for (final habit in habits) {
      final stats = overallStats.perHabitStats[habit.id];
      if (stats != null) {
        overallTotalDone += stats.totalDone;
        if (stats.bestStreak > overallBestStreak) {
          overallBestStreak = stats.bestStreak;
        }
      }
    }

    final avgRate = overallStats.overallCompletionRate * 100;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Period tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ReportPeriod.values.map((p) {
                final isSelected = p == period;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(reportPeriodProvider.notifier).state = p;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPink
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.name[0].toUpperCase() + p.name.substring(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Report content
          Expanded(
            child: ShareReportCard(
              screenshotController: _screenshotController,
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  // Title with date range
                  Center(
                    child: Text(
                      '${AppDateUtils.formatRelative(startDate)} - ${AppDateUtils.formatRelative(endDate)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Day of week headers (for weekly view)
                  if (period == ReportPeriod.weekly) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (i) {
                          return Text(
                            AppDateUtils.formatDayOfWeekShort(i + 1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Dot matrix per habit
                  ...habits.map((habit) {
                    final records = db.getRecordsInRange(
                      habit.id,
                      startDate,
                      endDate,
                    );
                    return DotMatrix(
                      habit: habit,
                      records: records,
                      startDate: startDate,
                      endDate: endDate,
                    );
                  }),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Summary stats
                  StatsSummaryRow(
                    metPercentage: avgRate,
                    bestDay: overallBestDay,
                    totalDone: overallTotalDone,
                    bestStreak: overallBestStreak,
                  ),
                ],
              ),
            ),
          ),

          // Banner ad
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
