import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Noti {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mitmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    // Initialize timezone data
    tz.initializeTimeZones();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'todo_app_notification_channel',
      'todo_app_notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Get the current timezone
    var currentTimeZone = tz.local;

    // Convert the scheduled time to TZDateTime
    var scheduledDateTime = tz.TZDateTime.from(scheduledTime, currentTimeZone);

    // Calculate the intervals based on the scheduled time
    final interval70 = scheduledDateTime.subtract(Duration(minutes: 70));
    final interval80 = scheduledDateTime.subtract(Duration(minutes: 80));
    final interval90 = scheduledDateTime.subtract(Duration(minutes: 90));

    // Add notifications at the intervals
    await fln.zonedSchedule(
      id,
      title,
      body,
      interval70,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'notification_payload',
    );

    await fln.zonedSchedule(
      id + 1,
      title,
      body,
      interval80,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'notification_payload',
    );

    await fln.zonedSchedule(
      id + 2,
      title,
      body,
      interval90,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'notification_payload',
    );

    // Schedule the final notification at the original scheduled time
    await fln.zonedSchedule(
      id + 3,
      title,
      body,
      scheduledDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'notification_payload',
    );
  }
}
