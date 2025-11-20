// 설명: 브랜드 색상과 컴포넌트 스타일을 담은 전역 ThemeData 빌더.
import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

ThemeData buildDaytwoTheme() {
  final scheme = DaytwoColors.colorScheme(Brightness.light);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: DaytwoColors.background,
    textTheme: DaytwoTypography.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: DaytwoColors.background,
      foregroundColor: DaytwoColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: DaytwoTypography.textTheme.titleMedium,
    ),
    cardTheme: CardThemeData(
      color: DaytwoColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: DaytwoColors.border),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DaytwoColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: DaytwoTypography.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DaytwoColors.primary,
        textStyle: DaytwoTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DaytwoColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: DaytwoColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: DaytwoColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DaytwoSpacing.s16,
        vertical: DaytwoSpacing.s12,
      ),
    ),
  );
}
