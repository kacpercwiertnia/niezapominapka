import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('ic_notification_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
      },
    );

    _initialized = true;
  }

  static Future<bool> requestIosPermissions() async {
    final ios = _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    final granted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return granted ?? false;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body
}) async {
    const androidDetails = AndroidNotificationDetails(
      'shop_radar_channel',
      'Radar Sklepów',
      channelDescription: 'Powiadomienia o sklepach w okolicy',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('app_logo'),
      color: Color(0xFF64B5F6),
    );

    const iosDetails = DarwinNotificationDetails(
      presentBanner: true,
      presentList: true,
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(id, title, body, details);
  }
}