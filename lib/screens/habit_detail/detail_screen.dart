import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/habit_provider.dart';
import '../../providers/stats_provider.dart';
import '../../widgets/banner_ad_widget.dart';
import 'widgets/calendar_heatmap.dart';
import 'widgets/yearly_heatmap.dart';
import 'widgets/record_stats.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseServiceProvider);
    final habit = db.getHabit(widget.habitId);

    if (habit == null) {
      return const Scaffold(
        body: Center(child: Text('Habit not found')),
      );
    }

    final stats = ref.watch(habitStatsProvider(widget.habitId));
    final habitColor = Color(habit.colorValue);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(
                int.tryParse(habit.icon) ?? 0xe156,
                fontFamily: 'MaterialIcons',
              ),
              color: habitColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(habit.name),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushNamed(
                  context,
                  AppRoutes.editHabit,
                  arguments: habit.id,
                );
              } else if (value == 'archive') {
                ref.read(habitsProvider.notifier).archiveHabit(habit.id);
                Navigator.pop(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Calendar heatmap
          Container(
            padding: const EdgeInsets.all(12),
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
            child: CalendarHeatmap(
              month: _selectedMonth,
              completionMap: stats.completionMap,
              habitColor: habitColor,
              onMonthChanged: (month) {
                setState(() => _selectedMonth = month);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Yearly heatmap
          Container(
            padding: const EdgeInsets.all(12),
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
            child: YearlyHeatmap(
              year: DateTime.now().year,
              completionMap: stats.completionMap,
              habitColor: habitColor,
            ),
          ),
          const SizedBox(height: 20),

          // Stats grid
          RecordStatsGrid(stats: stats, habitColor: habitColor),
          const SizedBox(height: 16),

          // Banner ad
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
