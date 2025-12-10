import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/birthday_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
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

    await _notifications.initialize(settings);

    // Request permissions for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future scheduleBirthdayReminder(
      Birthday birthday, TimeOfDay reminderTime) async {
    await _cancelNotifications(birthday.id);

    final now = DateTime.now();
    final birthdayThisYear =
        DateTime(now.year, birthday.date.month, birthday.date.day);
    final birthdayNextYear =
        DateTime(now.year + 1, birthday.date.month, birthday.date.day);

    // Schedule for this year and next year
    for (final targetBirthday in [birthdayThisYear, birthdayNextYear]) {
      if (targetBirthday.isBefore(now)) continue;

      // On the day
      if (birthday.remindOnDay) {
        await _scheduleNotification(
          id: '${birthday.id}_onday_${targetBirthday.year}'.hashCode,
          title: '🎂 Birthday Today!',
          body: '${birthday.name}\'s birthday is today!',
          scheduledDate: targetBirthday,
          reminderTime: reminderTime,
          phoneNumber: birthday.phoneNumber,
        );
      }

      // 1 day before
      if (birthday.remindOneDayBefore) {
        await _scheduleNotification(
          id: '${birthday.id}_1day_${targetBirthday.year}'.hashCode,
          title: '🎈 Birthday Tomorrow!',
          body: '${birthday.name}\'s birthday is tomorrow!',
          scheduledDate: targetBirthday.subtract(const Duration(days: 1)),
          reminderTime: reminderTime,
          phoneNumber: birthday.phoneNumber,
        );
      }

      // 1 week before
      if (birthday.remindOneWeekBefore) {
        await _scheduleNotification(
          id: '${birthday.id}_1week_${targetBirthday.year}'.hashCode,
          title: '📅 Birthday in 1 Week!',
          body: '${birthday.name}\'s birthday is in one week!',
          scheduledDate: targetBirthday.subtract(const Duration(days: 7)),
          reminderTime: reminderTime,
          phoneNumber: birthday.phoneNumber,
        );
      }
    }
  }

  Future _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required TimeOfDay reminderTime,
    String? phoneNumber,
  }) async {
    final scheduledDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'birthday_reminders',
          'Birthday Reminders',
          channelDescription: 'Notifications for upcoming birthdays',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future _cancelNotifications(String birthdayId) async {
    // Cancel all notifications for this birthday
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();
    for (final notification in pendingNotifications) {
      if (notification.id.toString().contains(birthdayId)) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  Future cancelAllNotifications(String birthdayId) async {
    await _cancelNotifications(birthdayId);
  }
}
