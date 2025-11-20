import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/components.dart';

/// Primary CTA button styled after Toss minimal pill.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: DaytwoColors.primary,
        disabledBackgroundColor: DaytwoColors.primary.withValues(alpha: 0.3),
        shape: const RoundedRectangleBorder(borderRadius: DaytwoComponentTokens.mediumRadius),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: DaytwoTypography.textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
