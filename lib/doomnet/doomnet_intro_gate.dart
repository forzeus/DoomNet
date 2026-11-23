import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Three seconds after Flutter begins rendering, including a 550ms fade out.
class DoomNetIntroGate extends StatefulWidget {
  const DoomNetIntroGate({super.key, required this.child});
  final Widget child;
  @override
  State<DoomNetIntroGate> createState() => _DoomNetIntroGateState();
}

class _DoomNetIntroGateState extends State<DoomNetIntroGate>
    with SingleTickerProviderStateMixin {
  bool _finished = false;
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _finished = true);
      }
    });

  @override
  void initState() {
    super.initState();
    _intro.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      ExcludeFocus(excluding: !_finished, child: widget.child),
      if (!_finished)
        Positioned.fill(
          child: AbsorbPointer(
            child: AnimatedBuilder(
              animation: _intro,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF13432A), Color(0xFF061B10), Color(0xFF020805)],
                    stops: [0, .55, 1],
                  ),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage('assets/images/doomnet_orbit.webp'),
                    width: 290,
                    height: 290,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              builder: (context, child) {
                const start = 2.45 / 3;
                final fade = ((_intro.value - start) / (1 - start))
                    .clamp(0.0, 1.0).toDouble();
                final opacity = _intro.value <= start
                    ? 1.0
                    : 1 - Curves.easeInOutCubic.transform(fade);
                // One gentle, slow "breath" while the intro is visible,
                // without a bright flash or an endlessly running animation.
                final pulse = 1 + .035 * math.sin(_intro.value * math.pi);
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: pulse, child: child),
                );
              },
            ),
          ),
        ),
    ],
  );
}
