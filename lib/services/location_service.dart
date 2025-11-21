// services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationService {
  static Position? _currentPosition;

  static Future<void> initialize() async {
    await _requestPermission();
    await updateCurrentLocation();
  }

  static Future<bool> _requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> updateCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return _currentPosition;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Position? get currentPosition => _currentPosition;

  static Map<String, double> getCurrentLocationMap() {
    if (_currentPosition == null) {
      return {'lat': -15.4167, 'lng': 28.2833}; // Default: Lusaka
    }
    return {
      'lat': _currentPosition!.latitude,
      'lng': _currentPosition!.longitude,
    };
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(
      double lat1, double lon1,
      double lat2, double lon2
      ) {
    const p = 0.017453292519943295; // Pi/180
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Check if a location is within radius (km)
  static bool isWithinRadius(
      double incidentLat, double incidentLng,
      double userLat, double userLng,
      double radiusKm,
      ) {
    final distance = calculateDistance(incidentLat, incidentLng, userLat, userLng);
    return distance <= radiusKm;
  }
}