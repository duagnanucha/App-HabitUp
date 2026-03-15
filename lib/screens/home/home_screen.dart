import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/banner_ad_widget.dart';
import 'widgets/date_ribbon.dart';
import 'widgets/habit_card.dart';
import 'widgets/habit_progress.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsForDateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Date ribbon at top
            const DateRibbon(),

            // Daily progress summary
            const HabitProgressSummary(),

            // Habit list
            Expanded(
              child: habits.isEmpty
                  ? _buildEmptyState(context)
                  : ReorderableListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: habits.length,
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex--;
                        final ids = habits.map((h) => h.id).toList();
                        final id = ids.removeAt(oldIndex);
                        ids.insert(newIndex, id);
                        ref.read(habitsProvider.notifier).reorderHabits(ids);
                      },
                      itemBuilder: (context, index) {
                        return HabitCard(
                          key: ValueKey(habits[index].id),
                          habit: habits[index],
                        );
                      },
                    ),
            ),

            // Banner ad at bottom
            const BannerAdWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createHabit),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_nature_outlined,
            size: 64,
            color: AppColors.primaryPink.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No habits for today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to create your first habit',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
