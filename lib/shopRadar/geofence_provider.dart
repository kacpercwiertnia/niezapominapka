import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence_service/geofence_service.dart';

import 'notification_service.dart';
import 'permission_service.dart';

final geofenceServiceProvider = Provider((ref) => GeofenceLogic());

class GeofenceLogic {
  final _geofenceService = GeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100,
    loiteringDelayMs: 60000,
    statusChangeDelayMs: 10000,
    useActivityRecognition: false,
    allowMockLocations: false,
    printDevLog: true,
  );

  bool _listenerAdded = false;

  Future<void> startMonitoring() async {
    final ok = await PermissionService.requestLocationPermissions();
    if (!ok) return;

    await NotificationService.init();

    _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    await _geofenceService.start(_geofenceList);
  }


  Future<void> stopMonitoring() async {
    try {
      await _geofenceService.stop();
      print("Geofencing zatrzymany");
    } catch (e) {
      print("Błąd stopu geofencingu: $e");
    }
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location,
      ) async {
    print('Status Geofence: ${geofenceStatus.toString()} dla ${geofence.id}');

    if (geofenceStatus == GeofenceStatus.ENTER) {
      print("WŁAŚNIE WSZEDŁEŚ DO: ${geofence.id}");

      await NotificationService.showNotification(
        id: geofence.id.hashCode,
        title: "Jesteś blisko sklepu!",
        body: "Sklep: ${geofence.id} jest w zasięgu 100 metrów. Wejdź i kup co trzeba!",
      );
    }
  }

  final List<Geofence> _geofenceList = [
    Geofence(
      id: 'sklep_1',
      latitude: 52.2297,
      longitude: 21.0122,
      radius: [GeofenceRadius(id: 'radius_100m', length: 100)],
    ),
  ];
}