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

    // 2) Always (WYMAGANE dla geofence w tle!)
    final always = await Permission.locationAlways.request();
    debugPrint('locationAlways: $always');

    // Dla geofence w tle MUSIMY mieć "Always" permission
    if (!always.isGranted) {
      debugPrint('Brak uprawnień do lokalizacji w tle - geofence nie będzie działać w tle!');
      if (always.isPermanentlyDenied) {
        await openAppSettings();
      }
      // Nadal zwracamy true, ale geofence nie będzie działać w tle
      // Możesz tu zmienić na return false; jeśli chcesz wymagać always
    }

    // 3) Notyfikacje (WYMAGANE na Android 13+)
    final notif = await Permission.notification.request();
    debugPrint('notification: $notif');

    return true;
  }
  
  /// Sprawdza czy mamy wszystkie uprawnienia potrzebne do działania w tle
  static Future<bool> hasBackgroundPermissions() async {
    final locationAlways = await Permission.locationAlways.status;
    final notification = await Permission.notification.status;
    
    return locationAlways.isGranted && notification.isGranted;
  }
}
