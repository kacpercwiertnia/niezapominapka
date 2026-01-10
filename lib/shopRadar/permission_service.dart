import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermissions() async {
    // 1) When In Use (to powinno wywołać prompt)
    final whenInUse = await Permission.locationWhenInUse.request();
    debugPrint('locationWhenInUse: $whenInUse');

    if (!whenInUse.isGranted) {
      if (whenInUse.isPermanentlyDenied || whenInUse.isRestricted) {
        await openAppSettings();
      }
      return false;
    }

    // 2) Always (na iOS może nie pokazać prompta -> często trzeba Settings)
    final always = await Permission.locationAlways.request();
    debugPrint('locationAlways: $always');

    // Jeśli potrzebujesz geofence w tle na 100%, to tu możesz wymagać always:
    // if (!always.isGranted) { await openAppSettings(); return false; }

    // 3) Notyfikacje (opcjonalnie)
    //final notif = await Permission.notification.request();
    //debugPrint('notification: $notif');

    return true; // masz co najmniej WhenInUse
  }
}
