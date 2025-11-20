import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/components.dart';

/// Outline style button used for secondary actions.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SecondaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: DaytwoColors.textPrimary,
        side: const BorderSide(color: DaytwoColors.border),
        shape: const RoundedRectangleBorder(borderRadius: DaytwoComponentTokens.compactRadius),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: DaytwoTypography.textTheme.bodyMedium,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
