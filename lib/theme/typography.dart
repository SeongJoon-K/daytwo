import 'package:flutter/material.dart';
import 'colors.dart';

/// Toss-inspired typography scale with Uber-like confident weights.
class DaytwoTypography {
  DaytwoTypography._();

  static TextTheme textTheme = const TextTheme(
    displaySmall: TextStyle(
      fontSize: 28,
      height: 1.2,
      letterSpacing: -0.4,
      fontWeight: FontWeight.w700,
      color: DaytwoColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 1.25,
      letterSpacing: -0.2,
      fontWeight: FontWeight.w600,
      color: DaytwoColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      height: 1.35,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w600,
      color: DaytwoColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      height: 1.4,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w500,
      color: DaytwoColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.55,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w400,
      color: DaytwoColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.5,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w400,
      color: DaytwoColors.textSecondary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 1.4,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w600,
      color: DaytwoColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 1.3,
      letterSpacing: 0.3,
      fontWeight: FontWeight.w600,
      color: DaytwoColors.textSecondary,
    ),
  );
}
