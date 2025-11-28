// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =============================
  // PUBLIC REPORTS (For Community Feed)
  // =============================

  /// Get all public reports for community feed
  static Future<List<Map<String, dynamic>>> getPublicReports() async {
    try {
      final snapshot = await _db
          .collection('public_reports')
          .orderBy('publishedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
          // Add default values if missing
          'reportType': data['reportType'] ?? 'announcement',
          'severity_score': data['severity_score'] ?? 50,
          'location': data['location'] ?? 'Lusaka',
          'author': data['author'] ?? 'Police Department',
          'isVerified': data['isVerified'] ?? true,
          'viewCount': data['viewCount'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting public reports: $e');
      return [];
    }
  }

  /// Stream public reports for real-time updates
  static Stream<QuerySnapshot> getPublicReportsStream() {
    return _db
        .collection('public_reports')
        .orderBy('publishedAt', descending: true)
        .limit(50)
        .snapshots();
  }

  /// Publish a public report
  static Future<bool> publishPublicReport({
    required String title,
    required String description,
    String? imageUrl,
    String? videoUrl,
    required String author,
    String reportType = 'announcement',
    int severityScore = 50,
    String location = 'Lusaka',
    double? lat,
    double? lng,
  }) async {
    try {
      await _db.collection('public_reports').add({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'author': author,
        'reportType': reportType,
        'severity_score': severityScore,
        'location': location,
        'lat': lat,
        'lng': lng,
        'publishedAt': FieldValue.serverTimestamp(),
        'isVerified': true,
        'viewCount': 0,
      });

      print('✅ Public report published successfully');
      return true;
    } catch (e) {
      print('❌ Error publishing report: $e');
      return false;
    }
  }

  /// Increment view count
  static Future<void> incrementViewCount(String reportId) async {
    try {
      await _db.collection('public_reports').doc(reportId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('❌ Error incrementing view count: $e');
    }
  }

  // =============================
  // INCIDENT COUNTS
  // =============================

  static Future<int> getIncidentCount(String status) async {
    try {
      final snapshot = await _db
          .collection('incidents')
          .where('status', isEqualTo: status)
          .get();
      return snapshot.size;
    } catch (e) {
      print('❌ Error getting incident count: $e');
      return 0;
    }
  }

  static Future<int> getTotalIncidents() async {
    try {
      final snapshot = await _db.collection('incidents').get();
      return snapshot.size;
    } catch (e) {
      print('❌ Error getting total incidents: $e');
      return 0;
    }
  }

  // =============================
  // POLICE UNITS
  // =============================

  static Future<int> getFreeUnitsCount() async {
    try {
      final snapshot = await _db
          .collection('police_units')
          .where('status', isEqualTo: 'free')
          .get();
      return snapshot.size;
    } catch (e) {
      print('❌ Error getting free units count: $e');
      return 0;
    }
  }

  static Future<List<QueryDocumentSnapshot>> getAvailableUnits() async {
    try {
      final snapshot = await _db
          .collection('police_units')
          .where('status', isEqualTo: 'free')
          .get();
      return snapshot.docs;
    } catch (e) {
      print('❌ Error getting available units: $e');
      return [];
    }
  }

  // =============================
  // INCIDENTS STREAM & QUERIES
  // =============================

  static Stream<QuerySnapshot> getNewReports() {
    try {
      return _db
          .collection('incidents')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots();
    } catch (e) {
      print('❌ Error streaming new reports: $e');
      return const Stream.empty();
    }
  }

  static Future<List<Map<String, dynamic>>> getAllIncidents() async {
    try {
      final snapshot = await _db
          .collection('incidents')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      print('❌ Error getting all incidents: $e');
      return [];
    }
  }

  // =============================
  // TEST CONNECTION
  // =============================

  static Future<bool> testConnection() async {
    try {
      await _db.collection('_test').doc('connection').set({
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'connected',
      });
      print('✅ Firebase connection successful');
      return true;
    } catch (e) {
      print('❌ Firebase connection failed: $e');
      return false;
    }
  }
}
