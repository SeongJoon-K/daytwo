import 'package:flutter/material.dart';

/// Central color palette with airy Toss-like blues and confident Uber neutrals.
class DaytwoColors {
  DaytwoColors._();

  static const Color primary = Color(0xFF4C7FFB); // bright Toss-esque blue
  static const Color accent = Color(0xFF6A94FF); // softer highlight blue
  static const Color secondary = Color(0xFF172033); // deep navy for contrast
  static const Color background = Color(0xFFF5F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE3E8F1);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF5B6475);

  /// Generates a ColorScheme for Material components without deprecated fields.
  static ColorScheme colorScheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? const ColorScheme.dark()
        : const ColorScheme.light();
    return base.copyWith(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      outline: border,
    );
  }
}
