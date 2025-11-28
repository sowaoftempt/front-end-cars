// lib/features/community/community_stats_widget.dart
import 'package:flutter/material.dart';
import 'community_service.dart';

class CommunityStatsWidget extends StatelessWidget {
  final double radiusKm;

  const CommunityStatsWidget({
    super.key,
    required this.radiusKm,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: CommunityService.getCommunityReports(radiusKm: radiusKm),
      builder: (context, snapshot) {
        final reportCount = snapshot.data?.length ?? 0;
        final criticalCount = snapshot.data
            ?.where((r) => r.severity == 'critical')
            .length ?? 0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E3A8A).withOpacity(0.1),
                const Color(0xFF3B82F6).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.report,
                reportCount.toString(),
                'Total Reports',
                const Color(0xFF3B82F6),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE5E7EB),
              ),
              _buildStatItem(
                Icons.warning_amber,
                criticalCount.toString(),
                'Critical',
                const Color(0xFFDC2626),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE5E7EB),
              ),
              _buildStatItem(
                Icons.location_on,
                '${radiusKm.toInt()}km',
                'Radius',
                const Color(0xFF10B981),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
