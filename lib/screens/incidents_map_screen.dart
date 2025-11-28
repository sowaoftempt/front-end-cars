// lib/screens/incidents_map_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../features/community/community_service.dart';
import '../features/community/community_model.dart';
import '../services/location_service.dart';

class IncidentsMapScreen extends StatefulWidget {
  const IncidentsMapScreen({super.key});

  @override
  State<IncidentsMapScreen> createState() => _IncidentsMapScreenState();
}

class _IncidentsMapScreenState extends State<IncidentsMapScreen> {
  final MapController _mapController = MapController();
  Position? _userPosition;
  List<CommunityReportModel> _nearbyIncidents = [];
  List<Marker> _markers = [];
  bool _isLoading = true;
  double _radiusKm = 10.0;
  LatLng _center = const LatLng(-15.4167, 28.2833); // Lusaka default

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Get user location
      _userPosition = await LocationService.updateCurrentLocation();
      
      if (_userPosition != null) {
        _center = LatLng(_userPosition!.latitude, _userPosition!.longitude);
      }
      
      // Get nearby incidents
      final incidents = await CommunityService.getCommunityReports(
        radiusKm: _radiusKm,
      );

      // Create markers
      _markers = [
        // User location marker
        if (_userPosition != null)
          Marker(
            point: _center,
            width: 50,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 3),
              ),
              child: const Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        
        // Incident markers
        ...incidents.where((i) => i.latitude != null && i.longitude != null).map((incident) {
          return Marker(
            point: LatLng(incident.latitude!, incident.longitude!),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showIncidentDetails(incident),
              child: Icon(
                Icons.location_on,
                color: _getSeverityColor(incident.severity),
                size: 40,
              ),
            ),
          );
        }).toList(),
      ];

      setState(() {
        _nearbyIncidents = incidents;
        _isLoading = false;
      });

      // Move map to user location
      if (_userPosition != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _mapController.move(_center, 13.0);
        });
      }
    } catch (e) {
      print('Error loading map data: $e');
      setState(() => _isLoading = false);
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return const Color(0xFFDC2626);
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  void _showIncidentDetails(CommunityReportModel incident) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(incident.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getSeverityColor(incident.severity),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    incident.severity.toUpperCase(),
                    style: TextStyle(
                      color: _getSeverityColor(incident.severity),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              incident.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              incident.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text(
                  incident.getFormattedDistance(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text(
                  incident.getTimeAgo(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.magain',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          // Top overlay with title and controls
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Incidents Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.my_location, color: Colors.white),
                        onPressed: () {
                          if (_userPosition != null) {
                            _mapController.move(_center, 13.0);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loadData,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Stats overlay
          Positioned(
            top: 100,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Color(0xFFFF0000),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_nearbyIncidents.length} Incidents',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Within ${_radiusKm.toInt()} km',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Radius control at bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.radar, color: Color(0xFFFF0000), size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Search Radius',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_radiusKm.toInt()} km',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF0000),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _radiusKm,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    activeColor: const Color(0xFFFF0000),
                    onChanged: (value) {
                      setState(() => _radiusKm = value);
                      _loadData();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),

          // Legend
          Positioned(
            bottom: 140,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Severity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLegendItem('Critical', const Color(0xFFDC2626)),
                  _buildLegendItem('High', const Color(0xFFEF4444)),
                  _buildLegendItem('Medium', const Color(0xFFF59E0B)),
                  _buildLegendItem('Low', const Color(0xFF10B981)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
