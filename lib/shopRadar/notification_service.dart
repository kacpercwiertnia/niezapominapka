import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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