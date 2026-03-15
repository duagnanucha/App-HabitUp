import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'screens/home/home_screen.dart';
import 'screens/report/report_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class HabitUpApp extends StatelessWidget {
  const HabitUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 1; // Start on "Today" tab

  final _screens = const [
    _PlaceholderScreen(label: 'Quick Add'), // Tab 0: Add shortcut
    HomeScreen(),                           // Tab 1: Today
    _HabitsListScreen(),                    // Tab 2: All Habits
    ReportScreen(),                         // Tab 3: Report
    SettingsScreen(),                        // Tab 4: Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // Quick add -> navigate to create screen
            Navigator.pushNamed(context, AppRoutes.createHabit);
            return;
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

// Placeholder for the "All Habits" tab
class _HabitsListScreen extends StatelessWidget {
  const _HabitsListScreen();

  @override
  Widget build(BuildContext context) {
    return const HomeScreen(); // Reuse home screen for now
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(label)),
    );
  }
}
