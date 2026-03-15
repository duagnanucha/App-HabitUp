import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../models/enums/habit_type.dart';
import '../../../models/enums/frequency.dart';
import '../../../utils/date_utils.dart';

class GoalSettingWidget extends StatelessWidget {
  final HabitType habitType;
  final double targetValue;
  final String unit;
  final Frequency frequency;
  final List<int> customDays;
  final String? reminderTime;
  final ValueChanged<HabitType> onTypeChanged;
  final ValueChanged<double> onTargetChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<Frequency> onFrequencyChanged;
  final ValueChanged<List<int>> onCustomDaysChanged;
  final ValueChanged<String?> onReminderChanged;

  const GoalSettingWidget({
    super.key,
    required this.habitType,
    required this.targetValue,
    required this.unit,
    required this.frequency,
    required this.customDays,
    required this.reminderTime,
    required this.onTypeChanged,
    required this.onTargetChanged,
    required this.onUnitChanged,
    required this.onFrequencyChanged,
    required this.onCustomDaysChanged,
    required this.onReminderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Habit type selector
        const Text(
          'Habit Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: HabitType.values.map((type) {
            final isSelected = type == habitType;
            return ChoiceChip(
              label: Text(type.label),
              selected: isSelected,
              selectedColor: AppColors.primaryPink,
              onSelected: (_) => onTypeChanged(type),
            );
          }).toList(),
        ),

        // Target value (for non-boolean types)
        if (habitType != HabitType.boolean) ...[
          const SizedBox(height: 20),
          const Text(
            'Goal',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: targetValue > 0
                      ? targetValue.toInt().toString()
                      : '',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target',
                    hintText: 'e.g. 2000',
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) onTargetChanged(parsed);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: unit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    hintText: 'ml',
                  ),
                  onChanged: onUnitChanged,
                ),
              ),
            ],
          ),
        ],

        // Frequency
        const SizedBox(height: 20),
        const Text(
          'Frequency',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: Frequency.values.map((freq) {
            final isSelected = freq == frequency;
            return ChoiceChip(
              label: Text(freq.label),
              selected: isSelected,
              selectedColor: AppColors.primaryGreen,
              onSelected: (_) => onFrequencyChanged(freq),
            );
          }).toList(),
        ),

        // Custom day picker
        if (frequency == Frequency.custom) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: List.generate(7, (i) {
              final day = i + 1;
              final isSelected = customDays.contains(day);
              return FilterChip(
                label: Text(AppDateUtils.formatDayOfWeek(day)),
                selected: isSelected,
                selectedColor: AppColors.primaryGreen,
                onSelected: (selected) {
                  final newDays = List<int>.from(customDays);
                  if (selected) {
                    newDays.add(day);
                  } else {
                    newDays.remove(day);
                  }
                  newDays.sort();
                  onCustomDaysChanged(newDays);
                },
              );
            }),
          ),
        ],

        // Reminder time
        const SizedBox(height: 20),
        _buildReminderPicker(context),
      ],
    );
  }

  Widget _buildReminderPicker(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.notifications_outlined,
            size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        const Text(
          'Reminder',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (reminderTime != null) ...[
          Text(
            reminderTime!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryPinkDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => onReminderChanged(null),
          ),
        ],
        TextButton(
          onPressed: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              final formatted =
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              onReminderChanged(formatted);
            }
          },
          child: Text(reminderTime == null ? 'Set' : 'Change'),
        ),
      ],
    );
  }
}
