import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermissions() async {
    // 1. Sprawdź/poproś o podstawową lokalizację
    var status = await Permission.location.request();

    if (status.isGranted) {
      // 2. Jeśli mamy podstawową, prosimy o tę w tle (Background)
      // To otworzy systemowe okno lub przeniesie do ustawień
      var backgroundStatus = await Permission.locationAlways.request();

      if (backgroundStatus.isGranted) {
        // 3. Dodatkowo dla Androida 13+ prosimy o powiadomienia
        var notificationPerm = await Permission.notification.request();

        if (notificationPerm.isGranted){
          // var activityStatus = await Permission.activityRecognition.request();
          //
          // if (activityStatus.isGranted){
            return true;
          // }
        }
      }
    }

    print("Użytkownik odmówił uprawnień!");
    return false;
  }
}