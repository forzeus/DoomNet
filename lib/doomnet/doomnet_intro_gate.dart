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
        // Make the TV's first focus target reachable after splash fade.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final focused = FocusManager.instance.primaryFocus;
          if (focused == null || focused is FocusScopeNode) {
            FocusScope.of(context).nextFocus();
          }
        });
      }
    });

  // Drive only the final 550 ms fade from the existing controller.
  // CurveTween avoids allocating a new animation on every build.
  late final Animation<double> _fade = Tween<double>(begin: 1, end: 0)
      .chain(CurveTween(curve: const Interval(2.45 / 3, 1, curve: Curves.easeInOutCubic)))
      .animate(_intro);

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
            child: FadeTransition(
              key: const ValueKey('doomnet-splash'),
              opacity: _fade,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // The background is full-screen but static. Keep it in a
                  // separate layer instead of scaling it with the logo.
                  const RepaintBoundary(
                    key: ValueKey('doomnet-splash-background'),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF13432A), Color(0xFF061B10), Color(0xFF020805)],
                          stops: [0, .55, 1],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedBuilder(
                      animation: _intro,
                      child: const RepaintBoundary(
                        child: Image(
                          image: AssetImage('assets/images/doomnet_orbit_hd.png'),
                          width: 290,
                          height: 290,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      builder: (context, child) => Transform.scale(
                        key: const ValueKey('doomnet-splash-pulse'),
                        scale: 1 + .035 * math.sin(_intro.value * math.pi),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}
