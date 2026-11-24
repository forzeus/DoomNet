import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animates only the DoomNet wordmark, not the surrounding TV layout.
class DoomNetBrand extends StatefulWidget {
  const DoomNetBrand({super.key, this.fontSize = 26, this.animate = true, this.fontWeight = FontWeight.w800});
  final double fontSize;
  final bool animate;
  final FontWeight fontWeight;
  @override
  State<DoomNetBrand> createState() => _DoomNetBrandState();
}

class _DoomNetBrandState extends State<DoomNetBrand> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  void _sync() {
    final active = widget.animate && !MediaQuery.disableAnimationsOf(context);
    if (active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant DoomNetBrand oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: AnimatedBuilder(
      animation: _controller,
      child: Text(
        'DoomNet',
        maxLines: 1,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          letterSpacing: .7,
          height: 1.08,
          color: Colors.white,
        ),
      ),
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: const [
            Color(0xFF087A43),
            Color(0xFF28E98F),
            Color(0xFFB7FFD5),
            Color(0xFF21C777),
            Color(0xFF087A43),
          ],
          stops: const [0, .27, .5, .73, 1],
          transform: GradientRotation(_controller.value * math.pi * 2),
        ).createShader(bounds),
        child: child!,
      ),
    ),
  );
}
