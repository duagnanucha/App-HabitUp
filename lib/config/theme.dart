import 'package:flutter/material.dart';

class AppColors {
  // Primary palette (from app screenshots)
  static const Color primaryPink = Color(0xFFF5B7B1);
  static const Color primaryPinkLight = Color(0xFFFADAD5);
  static const Color primaryPinkDark = Color(0xFFE8908A);
  static const Color primaryGreen = Color(0xFFD5F5E3);
  static const Color primaryGreenLight = Color(0xFFEAFAF1);
  static const Color primaryGreenDark = Color(0xFFA9DFBF);

  // Accent colors for habit progress bars
  static const Color accentRed = Color(0xFFE74C3C);
  static const Color accentBlue = Color(0xFF5DADE2);
  static const Color accentOrange = Color(0xFFF5B041);
  static const Color accentPurple = Color(0xFFAF7AC5);
  static const Color accentTeal = Color(0xFF48C9B0);
  static const Color accentYellow = Color(0xFFF7DC6F);

  // Neutral
  static const Color backgroundWhite = Color(0xFFFDFDFD);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFBDC3C7);
  static const Color divider = Color(0xFFECF0F1);

  // Habit colors palette (user selectable)
  static const List<Color> habitColors = [
    primaryPink,
    accentBlue,
    accentOrange,
    accentPurple,
    accentTeal,
    accentYellow,
    accentRed,
    primaryGreenDark,
    Color(0xFF85C1E9),
    Color(0xFFF1948A),
    Color(0xFF82E0AA),
    Color(0xFFD7BDE2),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HabitUp',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.light,
        primary: AppColors.primaryPinkDark,
        secondary: AppColors.primaryGreenDark,
        surface: AppColors.backgroundWhite,
      ),
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'HabitUp',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardWhite,
        selectedItemColor: AppColors.primaryPinkDark,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: AppColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryPinkDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HabitUp',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.dark,
        primary: AppColors.primaryPink,
        secondary: AppColors.primaryGreenDark,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      cardTheme: CardTheme(
        color: const Color(0xFF16213E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
