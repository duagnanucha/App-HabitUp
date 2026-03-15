import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';
import '../../../models/habit.dart';
import '../../../models/habit_record.dart';
import '../../../models/enums/habit_type.dart';
import '../../../providers/habit_provider.dart';
import '../../../config/routes.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recordsForDateProvider);
    final record = records[habit.id];
    final color = Color(habit.colorValue);

    return GestureDetector(
      onTap: () => _onTap(context, ref, record),
      onLongPress: () {
        Navigator.pushNamed(
          context,
          AppRoutes.habitDetail,
          arguments: habit.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                IconData(
                  int.tryParse(habit.icon) ?? 0xe156,
                  fontFamily: 'MaterialIcons',
                ),
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Name + progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (habit.type != HabitType.boolean) ...[
                    const SizedBox(height: 6),
                    _buildProgressBar(record, color),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Value or checkmark
            _buildTrailingWidget(record, color),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(HabitRecord? record, Color color) {
    final value = record?.value ?? 0;
    final progress = (value / habit.targetValue).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Background bar
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        // Progress fill
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingWidget(HabitRecord? record, Color color) {
    if (habit.type == HabitType.boolean) {
      final isCompleted = record?.isCompleted ?? false;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isCompleted ? color : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted ? color : AppColors.textLight,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      );
    }

    // Quantity / Count / Duration
    final value = record?.value ?? 0;
    final displayValue = _formatValue(value);
    final unitStr = habit.unit.isNotEmpty ? ' ${habit.unit}' : '';

    return Text(
      '$displayValue$unitStr',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: (record?.isCompleted ?? false) ? color : AppColors.textSecondary,
      ),
    );
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  void _onTap(BuildContext context, WidgetRef ref, HabitRecord? record) {
    final notifier = ref.read(recordsForDateProvider.notifier);

    switch (habit.type) {
      case HabitType.boolean:
        notifier.toggleHabit(habit);
        break;
      case HabitType.count:
        notifier.incrementValue(habit, 1);
        break;
      case HabitType.quantity:
        _showValueDialog(context, ref, record);
        break;
      case HabitType.duration:
        notifier.incrementValue(habit, 5); // +5 minutes
        break;
    }
  }

  void _showValueDialog(
    BuildContext context,
    WidgetRef ref,
    HabitRecord? record,
  ) {
    final controller = TextEditingController(
      text: record != null ? _formatValue(record.value) : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(habit.name),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Enter value (${habit.unit})',
            hintText: 'Target: ${_formatValue(habit.targetValue)}',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                ref
                    .read(recordsForDateProvider.notifier)
                    .updateValue(habit, value);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
