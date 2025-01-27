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
    tz.initializeTimeZones(); // Initialize timezone data at app start

    // Request Android runtime permissions
    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final bool? granted = await platform?.requestNotificationsPermission();
    debugPrint('Android notification permission granted: $granted');
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification received: ${details.payload}');
      },
    );
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    print('iOS notification permission granted: $result');
    debugPrint('Notifications initialized');
  }

  // Test method to show immediate notification
  Future<void> showTestNotification() async {
    debugPrint('Attempting to show test notification');
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
          enableLights: true,
          enableVibration: true,
          playSound: true,
          visibility: NotificationVisibility.public,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
          sound: 'default',
        ),
      ),
    );
  }

  Future<bool> _checkNotificationPermission() async {
    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final result = await platform?.areNotificationsEnabled() ?? false;
    debugPrint('Notification permission status: $result');
    return result;
  }

  Future<void> scheduleDailyNotification(
      TimeOfDay time, String title, String body) async {
    if (!await _checkNotificationPermission()) {
      print('ERROR: Notification permission not granted');
      return;
    }

    debugPrint('=== Scheduling notification ===');
    debugPrint('Time: ${time.hour}:${time.minute}');
    debugPrint('Current time: ${DateTime.now()}');

    final scheduledTime = _nextInstanceOfTime(time);
    debugPrint('Next scheduled time: $scheduledTime');
    debugPrint('Time zone: ${tz.local}');
    debugPrint('================================');

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        _getNotificationId(time),
        title,
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_notifications',
            'Daily Notifications',
            channelDescription: 'This channel is used for daily notifications',
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            enableVibration: true,
            playSound: true,
            visibility: NotificationVisibility.public,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
            sound: 'default',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode
            .alarmClock, // Use alarm clock mode for more reliable scheduling
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.time, // Ensures daily repetition
      );
      debugPrint('Notification scheduled successfully');

      // Verify schedule
      final pendingNotifs =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      debugPrint('Pending notifications: ${pendingNotifs.length}');
      for (var notif in pendingNotifs) {
        debugPrint(
            'Pending notification: id=${notif.id}, title=${notif.title}');
      }
    } catch (e) {
      debugPrint('ERROR scheduling notification: $e');
    }
  }

  static void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('iOS foreground notification: $title');
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
