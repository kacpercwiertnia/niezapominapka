import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('ic_notification_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body
}) async {
    const androidDetails = AndroidNotificationDetails(
      'shop_radar_channel', // ID kanału (może być dowolne)
      'Radar Sklepów',      // Nazwa kanału widoczna w ustawieniach
      channelDescription: 'Powiadomienia o sklepach w okolicy',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('app_logo'),

      // Opcjonalnie: kolor paska/przycisku powiadomienia (np. niebieski z Twojego logo)
      color: Color(0xFF64B5F6),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(id, title, body, details);
  }
}