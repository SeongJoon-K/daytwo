import 'package:flutter/material.dart';
import 'colors.dart';

/// Toss-inspired typography scale with Uber-like confident weights.
class DaytwoTypography {
  DaytwoTypography._();

  static TextTheme textTheme = const TextTheme(
    displaySmall: TextStyle(
      fontSize: 28,
      height: 1.2,
      letterSpacing: -0.5,
      fontWeight: FontWeight.w600,
      color: DaytwoColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      height: 1.4,
      letterSpacing: -0.2,
      fontWeight: FontWeight.w500,
      color: DaytwoColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.5,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w400,
      color: DaytwoColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.5,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w400,
      color: DaytwoColors.textSecondary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 1.4,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w500,
      color: DaytwoColors.textSecondary,
    ),
  );
}
