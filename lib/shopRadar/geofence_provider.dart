import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence_service/geofence_service.dart';

final geofenceServiceProvider = Provider((ref) => GeofenceLogic());

class GeofenceLogic{
  final _geofenceService = GeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100,
    loiteringDelayMs: 60000,
    statusChangeDelayMs: 10000,
    useActivityRecognition: true,
    allowMockLocations: false,
    printDevLog: true,
  );

  void startMonitoring() {
    _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.start(_geofenceList).catchError((e) => print("Błąd: $e"));
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {

    if (geofenceStatus == GeofenceStatus.ENTER) {
      print("WŁAŚNIE WSZEDŁEŚ DO: ${geofence.id}");
      // TUTAJ DODAMY KOD POWIADOMIENIA LOKALNEGO
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