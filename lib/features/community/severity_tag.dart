// lib/features/community/severity_tag.dart
import 'package:flutter/material.dart';

class SeverityTag extends StatelessWidget {
  final String severity;
  final bool showIcon;
  final double fontSize;

  const SeverityTag({
    super.key,
    required this.severity,
    this.showIcon = true,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getSeverityConfig(severity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config['gradient'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (config['color'] as Color).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              config['icon'] as IconData,
              color: Colors.white,
              size: fontSize + 2,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            config['label'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSeverityConfig(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return {
          'label': 'CRITICAL',
          'color': const Color(0xFFDC2626),
          'gradient': [const Color(0xFFDC2626), const Color(0xFFB91C1C)],
          'icon': Icons.warning_amber_rounded,
        };
      case 'high':
        return {
          'label': 'HIGH',
          'color': const Color(0xFFEF4444),
          'gradient': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          'icon': Icons.error_outline,
        };
      case 'medium':
        return {
          'label': 'MEDIUM',
          'color': const Color(0xFFF59E0B),
          'gradient': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
          'icon': Icons.info_outline,
        };
      case 'low':
      default:
        return {
          'label': 'LOW',
          'color': const Color(0xFF10B981),
          'gradient': [const Color(0xFF10B981), const Color(0xFF059669)],
          'icon': Icons.check_circle_outline,
        };
    }
  }
}
