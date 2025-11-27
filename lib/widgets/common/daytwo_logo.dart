import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// Lightweight logo widget using typography so it works without asset files.
class DaytwoLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;

  const DaytwoLogo({super.key, this.size = 56, this.showWordmark = false});

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DaytwoColors.primary, DaytwoColors.accent],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4C7FFB),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'dt',
          style: DaytwoTypography.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ),
    );

    if (!showWordmark) return circle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        circle,
        const SizedBox(width: 12),
        Text(
          'daytwo',
          style: DaytwoTypography.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}
