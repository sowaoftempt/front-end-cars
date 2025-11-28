// lib/features/community/community_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityReportModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String reportType; // 'crime', 'emergency', 'announcement', 'event'
  final String severity; // 'low', 'medium', 'high', 'critical'
  final String location;
  final DateTime timestamp;
  final String author;
  final bool isVerified;
  final int viewCount;
  final double? latitude;
  final double? longitude;
  final double distanceFromUser; // in km

  CommunityReportModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.reportType,
    required this.severity,
    required this.location,
    required this.timestamp,
    required this.author,
    this.isVerified = false,
    this.viewCount = 0,
    this.latitude,
    this.longitude,
    this.distanceFromUser = 0.0,
  });

  factory CommunityReportModel.fromFirestore(String id, Map<String, dynamic> data, double userDistance) {
    return CommunityReportModel(
      id: id,
      title: data['title'] ?? 'Untitled Report',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
      reportType: data['reportType'] ?? 'announcement',
      severity: _calculateSeverity(data['severity_score']),
      location: data['location'] ?? 'Unknown Location',
      timestamp: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      author: data['author'] ?? 'Police Department',
      isVerified: data['isVerified'] ?? true,
      viewCount: data['viewCount'] ?? 0,
      latitude: data['lat']?.toDouble(),
      longitude: data['lng']?.toDouble(),
      distanceFromUser: userDistance,
    );
  }

  static String _calculateSeverity(dynamic severityScore) {
    if (severityScore == null) return 'low';
    
    int score = severityScore is int 
        ? severityScore 
        : int.tryParse(severityScore.toString()) ?? 0;
    
    if (score >= 80) return 'critical';
    if (score >= 60) return 'high';
    if (score >= 30) return 'medium';
    return 'low';
  }

  String getTimeAgo() {
    final difference = DateTime.now().difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  String getFormattedDistance() {
    if (distanceFromUser < 1) {
      return '${(distanceFromUser * 1000).toStringAsFixed(0)}m away';
    }
    return '${distanceFromUser.toStringAsFixed(1)}km away';
  }
}
