import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Notification service - only functional on mobile platforms.
// On web, all methods are no-ops.
class NotificationService {
  static Future<void> initialize() async {
    if (kIsWeb) return;
    // flutter_local_notifications init is handled on mobile only
    // TODO: Initialize with platform-specific code when running on mobile
  }

  static Future<void> requestPermissions() async {
    if (kIsWeb) return;
  }

  static Future<void> scheduleHabitReminder({
    required int notificationId,
    required String habitName,
    required TimeOfDay time,
    required List<int> days,
  }) async {
    if (kIsWeb) return;
  }

  static Future<void> cancelHabitReminder(int notificationId) async {
    if (kIsWeb) return;
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
  }
}
