import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/habit.dart';
import '../../models/enums/habit_type.dart';
import '../../models/enums/frequency.dart';
import '../../providers/habit_provider.dart';
import '../../providers/ad_provider.dart';
import 'widgets/icon_picker.dart';
import 'widgets/color_picker.dart';
import 'widgets/goal_setting.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  final String? habitId; // null = create, non-null = edit

  const CreateHabitScreen({super.key, this.habitId});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool get _isEditing => widget.habitId != null;

  late String _icon;
  late int _colorValue;
  late HabitType _type;
  late double _targetValue;
  late String _unit;
  late Frequency _frequency;
  late List<int> _customDays;
  String? _reminderTime;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      final db = ref.read(databaseServiceProvider);
      final habit = db.getHabit(widget.habitId!);
      if (habit != null) {
        _nameController.text = habit.name;
        _icon = habit.icon;
        _colorValue = habit.colorValue;
        _type = habit.type;
        _targetValue = habit.targetValue;
        _unit = habit.unit;
        _frequency = habit.frequency;
        _customDays = List.from(habit.customDays);
        _reminderTime = habit.reminderTime;
        return;
      }
    }

    // Defaults for new habit
    _icon = Icons.directions_run.codePoint.toString();
    _colorValue = AppColors.primaryPink.value;
    _type = HabitType.boolean;
    _targetValue = 1;
    _unit = '';
    _frequency = Frequency.daily;
    _customDays = [];
    _reminderTime = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Habit' : 'New Habit'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
              onPressed: _deleteHabit,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Habit name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g. Drink Water, Yoga, Read',
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),

            // Icon picker
            IconPickerWidget(
              selectedIcon: _icon,
              onIconSelected: (icon) => setState(() => _icon = icon),
            ),
            const SizedBox(height: 24),

            // Color picker
            ColorPickerWidget(
              selectedColor: _colorValue,
              onColorSelected: (color) => setState(() => _colorValue = color),
            ),
            const SizedBox(height: 24),

            // Goal settings
            GoalSettingWidget(
              habitType: _type,
              targetValue: _targetValue,
              unit: _unit,
              frequency: _frequency,
              customDays: _customDays,
              reminderTime: _reminderTime,
              onTypeChanged: (type) {
                setState(() {
                  _type = type;
                  _targetValue = type.defaultTarget();
                  _unit = type.defaultUnit();
                });
              },
              onTargetChanged: (val) => setState(() => _targetValue = val),
              onUnitChanged: (val) => setState(() => _unit = val),
              onFrequencyChanged: (freq) {
                setState(() {
                  _frequency = freq;
                  if (freq != Frequency.custom) {
                    _customDays = [];
                  }
                });
              },
              onCustomDaysChanged: (days) =>
                  setState(() => _customDays = days),
              onReminderChanged: (time) =>
                  setState(() => _reminderTime = time),
            ),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Update Habit' : 'Create Habit',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHabit() {
    if (!_formKey.currentState!.validate()) return;

    final habit = Habit(
      id: widget.habitId ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      icon: _icon,
      colorValue: _colorValue,
      type: _type,
      targetValue: _type == HabitType.boolean ? 1 : _targetValue,
      unit: _unit,
      frequency: _frequency,
      customDays: _customDays,
      reminderTime: _reminderTime,
      createdAt: DateTime.now(),
      sortOrder: _isEditing ? 0 : ref.read(habitsProvider).length,
    );

    if (_isEditing) {
      ref.read(habitsProvider.notifier).updateHabit(habit);
    } else {
      ref.read(habitsProvider.notifier).addHabit(habit);
      // Track action for interstitial ad
      ref.read(adServiceProvider).trackAction();
    }

    Navigator.pop(context);
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text(
          'This will permanently delete this habit and all its records. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(habitsProvider.notifier).deleteHabit(widget.habitId!);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
