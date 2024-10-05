import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification response callback
  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  // Initialize the notification service
  static Future<void> init() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: true, // Ask for alert permission
            requestBadgePermission: true, // Ask for badge permission
            requestSoundPermission: true, // Ask for sound permission
            onDidReceiveLocalNotification:
                onDidReceiveLocalNotification // Handle foreground notification
            );

    // Combine Android and iOS initialization settings
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: androidInitializationSettings,
            iOS: initializationSettingDarwin);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
    );

    // Request notification permissions for iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // For Android, you can request exact alarms permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  // Show an instant notification (now supports iOS)
  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName",
          importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  // Schedule a notification (now supports iOS)
  static Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDate) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName",
          importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // iOS-specific callback for foreground notifications
  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle iOS foreground notification behavior here
  }
}
