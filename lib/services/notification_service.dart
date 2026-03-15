import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Schedule daily reminder for a habit
  static Future<void> scheduleHabitReminder({
    required int notificationId,
    required String habitName,
    required TimeOfDay time,
    required List<int> days, // 1=Mon, 7=Sun
  }) async {
    for (final day in days) {
      await _plugin.zonedSchedule(
        notificationId + day, // Unique ID per day
        'HabitUp Reminder',
        "Time to $habitName!",
        _nextInstanceOfTime(time, day),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_reminders',
            'Habit Reminders',
            channelDescription: 'Daily habit reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  /// Cancel all notifications for a habit
  static Future<void> cancelHabitReminder(int notificationId) async {
    for (int day = 1; day <= 7; day++) {
      await _plugin.cancel(notificationId + day);
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static TZDateTime _nextInstanceOfTime(TimeOfDay time, int dayOfWeek) {
    final now = TZDateTime.now(local);
    var scheduled = TZDateTime(
      local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Adjust to the correct day of week
    while (scheduled.weekday != dayOfWeek) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    // If the time has passed today, schedule for next week
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    return scheduled;
  }
}

// Placeholder types for timezone support
// In production, use the `timezone` package
class TZDateTime extends DateTime {
  TZDateTime(Location loc, int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0])
      : super(year, month, day, hour, minute, second);

  static TZDateTime now(Location loc) {
    final now = DateTime.now();
    return TZDateTime(loc, now.year, now.month, now.day, now.hour, now.minute);
  }
}

final local = Location._();

class Location {
  Location._();
}
