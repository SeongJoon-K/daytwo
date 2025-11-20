import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// Minimal app bar that mirrors Toss' airy look.
class DaytwoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const DaytwoAppBar({super.key, required this.title, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: DaytwoTypography.textTheme.titleMedium),
      actions: actions,
      leading: leading,
      centerTitle: true,
      backgroundColor: DaytwoColors.background,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
