import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class IconPickerWidget extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;

  const IconPickerWidget({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  static const List<IconData> availableIcons = [
    Icons.directions_run,
    Icons.self_improvement,
    Icons.water_drop,
    Icons.menu_book,
    Icons.bedtime,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.coffee,
    Icons.local_fire_department,
    Icons.favorite,
    Icons.music_note,
    Icons.brush,
    Icons.code,
    Icons.phone,
    Icons.pets,
    Icons.eco,
    Icons.emoji_food_beverage,
    Icons.sports_soccer,
    Icons.pool,
    Icons.hiking,
    Icons.bike_scooter,
    Icons.stairs,
    Icons.smoking_rooms,
    Icons.no_drinks,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Icon',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableIcons.map((icon) {
            final iconStr = icon.codePoint.toString();
            final isSelected = iconStr == selectedIcon;
            return GestureDetector(
              onTap: () => onIconSelected(iconStr),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryPink
                      : AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryPinkDark : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  size: 24,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
