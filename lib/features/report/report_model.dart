// features/report/report_model.dart
class ReportModel {
  final String type;
  final String description;
  final String? photoUrl;
  final double lat;
  final double lng;
  final double notificationRadius; // in kilometers
  final DateTime timestamp;
  final String status;

  ReportModel({
    required this.type,
    required this.description,
    this.photoUrl,
    required this.lat,
    required this.lng,
    this.notificationRadius = 5.0, // Default 5km
    DateTime? timestamp,
    this.status = 'active',
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': type,
    'description': description,
    'photoUrl': photoUrl,
    'lat': lat,
    'lng': lng,
    'location_ID': 'Latitude: $lat Longitude: $lng',
    'notification_radius': notificationRadius,
    'timestamp': timestamp,
    'status': status,
    'severity_score': _calculateSeverity(),
  };

  int _calculateSeverity() {
    // Higher severity for certain types
    if (type.toLowerCase().contains('fire') ||
        type.toLowerCase().contains('accident')) {
      return 90;
    } else if (type.toLowerCase().contains('missing')) {
      return 70;
    }
    return 50;
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    type: json['type'] ?? json['title'] ?? '',
    description: json['description'] ?? '',
    photoUrl: json['photoUrl'],
    lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
    lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    notificationRadius: (json['notification_radius'] as num?)?.toDouble() ?? 5.0,
    timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    status: json['status'] ?? 'active',
  );
}
