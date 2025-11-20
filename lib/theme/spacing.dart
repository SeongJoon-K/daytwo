import 'package:flutter/widgets.dart';

/// Spacing tokens built around 4pt grid for simple proportional layouts.
class DaytwoSpacing {
  DaytwoSpacing._();

  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;

  /// Convenience padding helper that keeps rounded corners consistent.
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: s24,
    vertical: s20,
  );

  static EdgeInsets horizontal(double value) => EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets vertical(double value) => EdgeInsets.symmetric(vertical: value);
}
