// lib/config/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFFFF0000);
  static const Color secondaryColor = Color(0xFFFF4500);
  static const Color accentColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);

  // Status Colors
  static const Color activeColor = Color(0xFF10B981);
  static const Color pendingColor = Color(0xFFF59E0B);
  static const Color resolvedColor = Color(0xFF6B7280);
  static const Color criticalColor = Color(0xFFDC2626);

  // Severity Colors
  static const Color lowSeverity = Color(0xFF10B981);
  static const Color mediumSeverity = Color(0xFFF59E0B);
  static const Color highSeverity = Color(0xFFEF4444);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Utility Methods
  static Color getSeverityColor(int score) {
    if (score <= 33) return lowSeverity;
    if (score <= 66) return mediumSeverity;
    return highSeverity;
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'pending':
        return pendingColor;
      case 'in_progress':
        return activeColor;
      case 'resolved':
      case 'completed':
        return resolvedColor;
      default:
        return textSecondary;
    }
  }

  static String getSeverityLabel(int score) {
    if (score <= 33) return 'Low';
    if (score <= 66) return 'Medium';
    return 'High';
  }
}
