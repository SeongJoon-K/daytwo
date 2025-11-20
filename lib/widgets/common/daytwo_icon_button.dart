import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Circular icon button resembling Uber's monochrome controls.
class DaytwoIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const DaytwoIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DaytwoColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: DaytwoColors.textPrimary),
        ),
      ),
    );
  }
}
