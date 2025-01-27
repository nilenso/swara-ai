import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import '../models/checkin.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  int _getNotificationId(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  Future<void> cancelNotification(Checkin checkin) async {
    await flutterLocalNotificationsPlugin
        .cancel(_getNotificationId(checkin.time));
  }

  Future<void> scheduleCheckinNotification(Checkin checkin) async {
    debugPrint(
        'Scheduling checkin notification for ${checkin.time.hour}:${checkin.time.minute}');
    await scheduleDailyNotification(
        checkin.time, 'Hello!', 'How are you feeling?');
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification received: ${details.payload}');
      },
    );
    debugPrint('Notifications initialized');
  }

  // Test method to show immediate notification
  Future<void> showTestNotification() async {
    debugPrint('Showing test notification');
    await flutterLocalNotificationsPlugin.show(
      999,
      'Test Notification',
      'This is a test notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notifications',
          'Test Notifications',
          channelDescription: 'Channel for test notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleDailyNotification(
      TimeOfDay time, String title, String body) async {
    // Initialize timezone (necessary for accurate scheduling)
    tz.initializeTimeZones();
    debugPrint('Scheduling notification for ${time.hour}:${time.minute}');

    final scheduledTime = _nextInstanceOfTime(time);
    debugPrint('Next scheduled time: $scheduledTime');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _getNotificationId(time),
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_notifications', 'Daily Notifications',
            channelDescription: 'This channel is used for daily notifications',
            importance: Importance.high,
            priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Ensures daily repetition
    );
  }

  // Helper function to calculate the next occurrence of a specific time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      // Schedule for the next day if the time has already passed
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
