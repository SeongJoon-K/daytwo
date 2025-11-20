import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/components.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

/// Hero card used for swipe recommendation preview.
class RoundedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? overlayColor;

  const RoundedCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: DaytwoComponentTokens.mediumRadius,
        gradient: LinearGradient(
          colors: [
            DaytwoColors.secondary,
            (overlayColor ?? DaytwoColors.primary).withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(DaytwoSpacing.s20),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: DaytwoTypography.textTheme.displaySmall?.copyWith(color: Colors.white)),
            const SizedBox(height: DaytwoSpacing.s8),
            Text(subtitle, style: DaytwoTypography.textTheme.bodyLarge?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
