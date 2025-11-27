import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class DaytwoTag extends StatelessWidget {
  final String label;
  final IconData? icon;

  const DaytwoTag({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DaytwoColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: DaytwoColors.primary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: DaytwoTypography.textTheme.labelMedium?.copyWith(
              color: DaytwoColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
