import 'package:flutter/material.dart';

class AppColors {
  // Cores principais baseadas no design Skilled
  static const Color primary = Color(0xFF7C4DFF);
  static const Color primaryDark = Color(0xFF651FFF);

  // Accent colors
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentDark = Color(0xFF651FFF);

  // Background colors
  static const Color background = Color(0xFFF8F9FD);
  static const Color backgroundDark = Color(0xFF1A1B2E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213A);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1B2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Crypto specific
  static const Color priceUp = Color(0xFF10B981);
  static const Color priceDown = Color(0xFFEF4444);

  // Neutral colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color inputBackground = Color(0xFFF3F4F6);
  static const Color shadow = Color(0x1A000000);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF4081),
      Color(0xFFFF6EC7),
    ],
  );
}