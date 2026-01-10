import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'notification_service.dart';
import 'permission_service.dart';

final geofenceServiceProvider = Provider((ref) => GeofenceLogic());

// Model dla geofence
class ShopGeofence {
  final String id;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  bool isInside;

  ShopGeofence({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.radiusMeters = 100,
    this.isInside = false,
  });
}

// Lista sklepów do monitorowania - globalna dla dostępu z TaskHandler
final List<ShopGeofence> geofenceList = [
  ShopGeofence(
    id: 'biedronka',
    latitude: 50.07140908624185,
    longitude: 19.905001422306473,
    radiusMeters: 100,
  ),
  ShopGeofence(
    id: 'zabka',
    latitude: 50.06875220007963,
    longitude: 19.909920014219765,
    radiusMeters: 100,
  ),
];

// Top-level function dla TaskHandler - MUSI być poza klasą
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(GeofenceTaskHandler());
}

// TaskHandler wykonywany w tle
class GeofenceTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionSubscription;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('🚀 [GeofenceTaskHandler] onStart');
    
    // Inicjalizacja notyfikacji
    await NotificationService.init();
    
    // Rozpocznij nasłuchiwanie lokalizacji
    _startLocationMonitoring();
  }

  void _startLocationMonitoring() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Minimum 10 metrów między aktualizacjami
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _checkGeofences(position);
      },
      onError: (error) {
        debugPrint('❌ [GeofenceTaskHandler] Błąd lokalizacji: $error');
      },
    );
  }

  void _checkGeofences(Position position) {
    for (final geofence in geofenceList) {
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        geofence.latitude,
        geofence.longitude,
      );

      final wasInside = geofence.isInside;
      final isNowInside = distance <= geofence.radiusMeters;

      if (!wasInside && isNowInside) {
        // Właśnie weszliśmy do geofence
        debugPrint('✅ [GeofenceTaskHandler] WEJŚCIE do: ${geofence.id}');
        geofence.isInside = true;
        _onEnterGeofence(geofence);
      } else if (wasInside && !isNowInside) {
        // Właśnie wyszliśmy z geofence
        debugPrint('🚪 [GeofenceTaskHandler] WYJŚCIE z: ${geofence.id}');
        geofence.isInside = false;
      }
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // metry
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  Future<void> _onEnterGeofence(ShopGeofence geofence) async {
    final safeId = geofence.id.hashCode & 0x7fffffff;
    
    await NotificationService.showNotification(
      id: safeId,
      title: "Jesteś blisko sklepu!",
      body: "Sklep: ${geofence.id} jest w zasięgu ${geofence.radiusMeters.toInt()} metrów. Wejdź i kup co trzeba!",
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Opcjonalnie: można tu dodać logikę wykonywaną cyklicznie
    debugPrint('🔄 [GeofenceTaskHandler] onRepeatEvent: $timestamp');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool gowno) async {
    debugPrint('🛑 [GeofenceTaskHandler] onDestroy');
    await _positionSubscription?.cancel();
  }

  @override
  void onNotificationButtonPressed(String id) {
    debugPrint('📱 [GeofenceTaskHandler] Przycisk notyfikacji: $id');
  }

  @override
  void onNotificationPressed() {
    debugPrint('📱 [GeofenceTaskHandler] Notyfikacja kliknięta');
    FlutterForegroundTask.launchApp();
  }

  @override
  void onNotificationDismissed() {
    debugPrint('📱 [GeofenceTaskHandler] Notyfikacja zamknięta');
  }
}

class GeofenceLogic {
  bool _isRunning = false;

  GeofenceLogic() {
    debugPrint("🏗️ GeofenceLogic utworzony");
  }

  /// Inicjalizacja foreground service
  Future<void> _initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'geofence_service_channel',
        channelName: 'Geofence Service',
        channelDescription: 'Usługa monitorowania lokalizacji sklepów',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> startMonitoring() async {
    if (_isRunning) {
      debugPrint("⚠️ Monitoring już działa");
      return;
    }

    // Sprawdź uprawnienia
    final ok = await PermissionService.requestLocationPermissions();
    if (!ok) {
      debugPrint("❌ Brak uprawnień do lokalizacji");
      return;
    }

    // Inicjalizacja notyfikacji
    await NotificationService.init();
    await NotificationService.requestAndroidPermissions();
    await NotificationService.requestIosPermissions();

    // Inicjalizacja foreground task
    await _initForegroundTask();

    // Sprawdź czy można uruchomić
    if (await FlutterForegroundTask.isRunningService) {
      debugPrint("⚠️ Serwis już działa, restartuję...");
      await FlutterForegroundTask.restartService();
    } else {
      // Uruchom foreground service
      final result = await FlutterForegroundTask.startService(
        notificationTitle: 'Niezapominapka działa',
        notificationText: 'Monitorowanie sklepów w tle...',
        notificationIcon: null,
        callback: startCallback,
      );

      if (result is ServiceRequestSuccess) {
        debugPrint("✅ Foreground service uruchomiony");
        _isRunning = true;
      } else {
        debugPrint("❌ Błąd uruchamiania foreground service: $result");
      }
    }
  }

  Future<void> stopMonitoring() async {
    try {
      final result = await FlutterForegroundTask.stopService();
      if (result is ServiceRequestSuccess) {
        debugPrint("✅ Foreground service zatrzymany");
        _isRunning = false;
      } else {
        debugPrint("❌ Błąd zatrzymywania foreground service: $result");
      }
    } catch (e) {
      debugPrint("❌ Błąd stopu geofencingu: $e");
    }
  }

  bool get isRunning => _isRunning;
}