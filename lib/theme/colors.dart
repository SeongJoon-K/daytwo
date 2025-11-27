import 'package:flutter/material.dart';

/// Central color palette with airy Toss-like blues and confident Uber neutrals.
class DaytwoColors {
  DaytwoColors._();

  static const Color primary = Color(0xFF4C7FFB); // bright Toss-esque blue
  static const Color primaryStrong = Color(0xFF2F66F5); // pressed/active
  static const Color primarySoft = Color(0xFFE8F0FF); // subtle fills
  static const Color accent = Color(0xFF6A94FF); // softer highlight blue
  static const Color secondary = Color(0xFF172033); // deep navy for contrast
  static const Color background = Color(0xFFF7F9FC);
  static const Color backgroundAlt = Color(0xFFF0F4FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFBFCFF);
  static const Color border = Color(0xFFE3E8F1);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF5B6475);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  /// Generates a ColorScheme for Material components without deprecated fields.
  static ColorScheme colorScheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? const ColorScheme.dark()
        : const ColorScheme.light();
    return base.copyWith(
      primary: primary,
      secondary: secondary,
      surface: surface,
      surfaceTint: Colors.transparent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      outline: border,
    );
  }
}
