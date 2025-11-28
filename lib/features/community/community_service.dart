// lib/features/community/community_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'community_model.dart';
import '../../services/location_service.dart';
import 'test_data_service.dart';
import 'dart:math' show cos, sqrt, asin;

class CommunityService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Calculate distance between two points in kilometers
  static double _calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const p = 0.017453292519943295; // Pi/180
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Get community reports within radius
  static Future<List<CommunityReportModel>> getCommunityReports({
    double radiusKm = 10.0,
    String? filterType,
    String? filterSeverity,
  }) async {
    print('📦 Getting community reports... radius: ${radiusKm}km');
    
    // ALWAYS use test data for now
    try {
      final testReports = TestDataService.getTestReports();
      print('✅ Got ${testReports.length} test reports');
      
      // Apply filters
      var filtered = testReports.where((r) {
        if (filterType != null && r.reportType != filterType) return false;
        if (filterSeverity != null && r.severity != filterSeverity) return false;
        return r.distanceFromUser <= radiusKm;
      }).toList();
      
      print('✅ Filtered to ${filtered.length} reports within ${radiusKm}km');
      return filtered;
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }

  /// Stream reports for real-time updates (uses test data for now)
  static Stream<List<CommunityReportModel>> getCommunityReportsStream({
    double radiusKm = 10.0,
  }) async* {
    print('📡 Starting reports stream... radius: ${radiusKm}km');
    
    // Yield test data immediately
    final testReports = TestDataService.getTestReports()
        .where((r) => r.distanceFromUser <= radiusKm)
        .toList();
    
    print('✅ Streaming ${testReports.length} test reports');
    yield testReports;
    
    // Keep stream alive
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Increment view count
  static Future<void> incrementViewCount(String reportId) async {
    print('👁️ View count incremented for: $reportId');
    // No-op for test data
  }
}
