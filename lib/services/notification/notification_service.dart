import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:root_app/services/meal/lunch_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    // Set local timezone for Bangladesh
    final String timeZoneName = 'Asia/Dhaka';
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request notification permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Request exact alarm permission for Android 13+
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isDenied) {
        debugPrint('⚠️ Exact alarm permission denied');
      }
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // You can add navigation logic here
  }

  /// Schedule daily lunch reminder at 9:00 AM (checks if user submitted lunch request)
  Future<void> scheduleDailyLunchReminder() async {
    try {
      // Check if we have exact alarm permission
      final hasPermission = await Permission.scheduleExactAlarm.isGranted;

      if (!hasPermission) {
        debugPrint('⚠️ Exact alarm permission not granted. Requesting...');
        final status = await Permission.scheduleExactAlarm.request();

        if (!status.isGranted) {
          debugPrint('⚠️ Cannot schedule exact alarms. Using inexact scheduling.');
          await _scheduleInexactNotification();
          return;
        }
      }

      await _notifications.zonedSchedule(
        0, // Notification ID
        'Lunch Request Reminder',
        'Don\'t forget to submit your lunch request for today!',
        _nextInstanceOf9AM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'lunch_reminder_channel',
            'Lunch Reminders',
            channelDescription: 'Daily reminders for lunch requests',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      final scheduledTime = _nextInstanceOf9AM();
      debugPrint('✅ Daily lunch reminder scheduled for: $scheduledTime');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
      await _scheduleInexactNotification();
    }
  }

  Future<void> _scheduleInexactNotification() async {
    try {
      await _notifications.zonedSchedule(
        0,
        'Lunch Request Reminder',
        'Don\'t forget to submit your lunch request for today!',
        _nextInstanceOf9AM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'lunch_reminder_channel',
            'Lunch Reminders',
            channelDescription: 'Daily reminders for lunch requests',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('✅ Inexact notification scheduled');
    } catch (e) {
      debugPrint('❌ Error scheduling inexact notification: $e');
    }
  }

  tz.TZDateTime _nextInstanceOf9AM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9, // 9 AM
      0, // 0 minutes
    );

    // If 9 AM has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Skip Friday and Saturday (weekends in Bangladesh)
    // Only notify Sunday (7) to Thursday (4)
    while (scheduledDate.weekday == DateTime.friday || 
           scheduledDate.weekday == DateTime.saturday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint('📅 Next notification scheduled for: $scheduledDate');
    debugPrint('📅 Day of week: ${_getDayName(scheduledDate.weekday)}');
    return scheduledDate;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday: return 'Sunday';
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      default: return 'Unknown';
    }
  }

  /// Check with backend if user has submitted lunch request and notify if not
  Future<void> checkAndNotifyIfNoLunchRequest() async {
    try {
      final lunchService = GetIt.instance<LunchRequestService>();
      final hasRequest = await lunchService.hasLunchRequestForToday();

      debugPrint('🔔 Lunch request check result: $hasRequest');

      if (!hasRequest) {
        await showImmediateNotification(
          'Lunch Request Missing',
          'You haven\'t submitted your lunch request for today. Please submit now!',
        );
        debugPrint('✅ Notification sent: No lunch request found');
      } else {
        debugPrint('✅ Lunch request already submitted. No notification needed.');
      }
    } catch (e) {
      debugPrint('❌ Error checking lunch request: $e');
    }
  }

  /// Show immediate notification
  Future<void> showImmediateNotification(String title, String body) async {
    await _notifications.show(
      1,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'lunch_reminder_channel',
          'Lunch Reminders',
          channelDescription: 'Daily reminders for lunch requests',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🗑️ All notifications cancelled');
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    debugPrint('🗑️ Notification $id cancelled');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// TEST METHOD - Schedule notification 1 minute from now for testing
  Future<void> scheduleTestNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));

    debugPrint('🧪 Test notification scheduled for: $scheduledDate');

    await _notifications.zonedSchedule(
      99, // Different ID for testing
      'Test Lunch Reminder',
      'This is a test notification! Checking if you submitted lunch request...',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'lunch_reminder_channel',
          'Lunch Reminders',
          channelDescription: 'Daily reminders for lunch requests',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}