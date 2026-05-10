import 'package:flutter/material.dart';

/// Animated number counter that ramps from 0 (or a configurable start) to
/// [target] when first scrolled into view.
///
/// Used for hero metrics («1 500 ₽», «23/7», «97 %»).
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.target,
    this.suffix = '',
    this.prefix = '',
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOutCubic,
    this.style,
  });

  final num target;
  final String prefix;
  final String suffix;
  final Duration duration;
  final Curve curve;
  final TextStyle? style;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _controller, curve: widget.curve);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controller.forward(from: 0));
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.target != widget.target) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(num value) {
    final isInt = widget.target is int;
    final v = isInt ? value.toInt() : value.toDouble();
    if (isInt) {
      // Insert non-breaking space as thousands separator (RU style).
      final s = v.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i != 0 && (s.length - i) % 3 == 0) buf.write('\u00A0');
        buf.write(s[i]);
      }
      return buf.toString();
    }
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final value = widget.target * _anim.value;
        return Text(
          '${widget.prefix}${_format(value)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
