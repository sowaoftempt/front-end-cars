// features/report/report_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'report_model.dart';
import '../../services/location_service.dart';

class ReportService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Submit a report with location-based notifications
  static Future<String> submit(ReportModel report) async {
    try {
      print('📤 Submitting report with location: ${report.lat}, ${report.lng}');
      print('📍 Notification radius: ${report.notificationRadius}km');

      final docRef = await _db.collection('incidents').add(report.toJson());

      print('✅ Report submitted successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error submitting report: $e');
      throw Exception('Failed to submit report: $e');
    }
  }

  /// Get nearby incidents based on user's location
  static Future<List<ReportModel>> getNearbyIncidents(double radiusKm) async {
    try {
      final userLocation = LocationService.getCurrentLocationMap();
      final snapshot = await _db
          .collection('incidents')
          .where('status', isEqualTo: 'active')
          .get();

      final nearbyIncidents = <ReportModel>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final lat = (data['lat'] as num?)?.toDouble();
        final lng = (data['lng'] as num?)?.toDouble();

        if (lat != null && lng != null) {
          final isNearby = LocationService.isWithinRadius(
            lat,
            lng,
            userLocation['lat']!,
            userLocation['lng']!,
            radiusKm,
          );

          if (isNearby) {
            nearbyIncidents.add(ReportModel.fromJson({...data, 'id': doc.id}));
          }
        }
      }

      return nearbyIncidents;
    } catch (e) {
      print('❌ Error fetching nearby incidents: $e');
      return [];
    }
  }
}