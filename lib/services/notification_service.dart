// services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'location_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);

    // Start listening for nearby incidents
    _listenForNearbyIncidents();
  }

  static void _listenForNearbyIncidents() {
    FirebaseFirestore.instance
        .collection('incidents')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _checkAndNotify(change.doc.data()!);
        }
      }
    });
  }

  static Future<void> _checkAndNotify(Map<String, dynamic> incident) async {
    final userLocation = LocationService.getCurrentLocationMap();
    final incidentLat = incident['lat'] as double?;
    final incidentLng = incident['lng'] as double?;
    final notificationRadius = incident['notification_radius'] ?? 5.0; // Default 5km

    if (incidentLat == null || incidentLng == null) return;

    final isNearby = LocationService.isWithinRadius(
      incidentLat,
      incidentLng,
      userLocation['lat']!,
      userLocation['lng']!,
      notificationRadius,
    );

    if (isNearby) {
      final distance = LocationService.calculateDistance(
        incidentLat,
        incidentLng,
        userLocation['lat']!,
        userLocation['lng']!,
      );

      await showNotification(
        title: '\ud83d\udea8 ${incident['title'] ?? 'Emergency Alert'}',
        body: '${distance.toStringAsFixed(1)}km away - ${incident['description'] ?? 'Check the app for details'}',
        payload: incident['id'],
      );
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Use non-const so Color() is recognized properly with the flutter/material import
    final androidDetails = AndroidNotificationDetails(
      'emergency_alerts',
      'Emergency Alerts',
      channelDescription: 'Notifications for nearby emergencies',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Emergency',
      color: const Color(0xFFFF0000),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }
}