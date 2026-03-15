import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/create_habit/create_screen.dart';
import '../screens/habit_detail/detail_screen.dart';
import '../screens/report/report_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String createHabit = '/create-habit';
  static const String editHabit = '/edit-habit';
  static const String habitDetail = '/habit-detail';
  static const String report = '/report';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case createHabit:
        return MaterialPageRoute(
          builder: (_) => const CreateHabitScreen(),
          fullscreenDialog: true,
        );

      case editHabit:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CreateHabitScreen(habitId: habitId),
          fullscreenDialog: true,
        );

      case habitDetail:
        final habitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HabitDetailScreen(habitId: habitId),
        );

      case report:
        return MaterialPageRoute(builder: (_) => const ReportScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
