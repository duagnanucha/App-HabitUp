import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';
import 'services/ad_service.dart';
import 'services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style (mobile only)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Initialize services
  await DatabaseService.initialize();

  // Mobile-only services
  if (!kIsWeb) {
    await Future.wait([
      AdService.initialize(),
      NotificationService.initialize(),
    ]);
  }

  runApp(
    const ProviderScope(
      child: HabitUpApp(),
    ),
  );
}
