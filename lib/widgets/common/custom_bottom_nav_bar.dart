// 설명: 글래시 블러 효과가 적용된 커스텀 BottomNavigationBar 위젯.
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/daytwo_tab.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class CustomBottomNavBar extends StatelessWidget {
  final DaytwoTab current;
  final ValueChanged<DaytwoTab> onChanged;

  const CustomBottomNavBar({super.key, required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: DaytwoTab.values.map((tab) {
                  final bool selected = tab == current;
                  final Color color = selected ? DaytwoColors.primary : const Color(0xFF9AA0A6);
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(tab),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: selected ? DaytwoColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(tab.iconData, color: color),
                            const SizedBox(height: 4),
                            Text(
                              tab.label,
                              style: DaytwoTypography.textTheme.labelMedium?.copyWith(
                                color: color,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
