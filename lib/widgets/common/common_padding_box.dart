import 'package:flutter/widgets.dart';
import '../../theme/spacing.dart';

/// Wrapper that keeps consistent screen gutters for both web/mobile.
class CommonPaddingBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const CommonPaddingBox({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? DaytwoSpacing.screen,
      child: child,
    );
  }
}
