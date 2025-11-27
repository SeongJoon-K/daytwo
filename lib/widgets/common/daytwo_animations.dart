import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Lightweight animation helpers tuned for subtle, Toss-like motions.
class DaytwoAnimations {
  DaytwoAnimations._();

  static Widget fadeInUp({
    Duration duration = const Duration(milliseconds: 320),
    Duration delay = Duration.zero,
    double beginOffsetY = 12,
    Curve curve = Curves.easeOutCubic,
    required Widget child,
  }) {
    return _FadeInUp(
      duration: duration,
      delay: delay,
      beginOffsetY: beginOffsetY,
      curve: curve,
      child: child,
    );
  }

  static Widget scalePopOnTap({
    required VoidCallback onTap,
    Duration duration = const Duration(milliseconds: 240),
    required Widget child,
  }) {
    return _ScalePopOnTap(
      onTap: onTap,
      duration: duration,
      child: child,
    );
  }

  static Widget springDialog({
    required Animation<double> animation,
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
        child: child,
      ),
    );
  }

  static AnimatedSwitcherTransitionBuilder tabTransition({
    double offsetY = 10,
  }) {
    return (Widget child, Animation<double> animation) {
      final slide = Tween<Offset>(
        begin: Offset(0, offsetY / 100),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slide, child: child),
      );
    };
  }
}

class _FadeInUp extends StatefulWidget {
  const _FadeInUp({
    required this.child,
    required this.duration,
    required this.delay,
    required this.beginOffsetY,
    required this.curve,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginOffsetY;
  final Curve curve;

  @override
  State<_FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<_FadeInUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _start();
  }

  Future<void> _start() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final dy = lerpDouble(widget.beginOffsetY, 0, _animation.value) ?? 0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Opacity(opacity: _animation.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class _ScalePopOnTap extends StatefulWidget {
  const _ScalePopOnTap({
    required this.child,
    required this.onTap,
    required this.duration,
  });

  final Widget child;
  final VoidCallback onTap;
  final Duration duration;

  @override
  State<_ScalePopOnTap> createState() => _ScalePopOnTapState();
}

class _ScalePopOnTapState extends State<_ScalePopOnTap> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.elasticOut, reverseCurve: Curves.easeIn);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(curve);
    _opacity = Tween<double>(begin: 0.85, end: 1.0).animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller
      ..reset()
      ..forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = _controller.isAnimating ? _scale.value : 1.0;
          final opacity = _controller.isAnimating ? _opacity.value : 1.0;
          return Opacity(
            opacity: opacity,
            child: Transform.scale(scale: max(scale, 0.85), child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}
