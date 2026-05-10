import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';

/// Pill-shaped service chip that floats around its anchor on an elliptical
/// orbit. Each chip gets its own AnimationController with random phase and
/// speed, producing the «парящие чипы услуг» effect on the hero block.
class FloatingChip extends StatefulWidget {
  const FloatingChip({
    super.key,
    required this.label,
    this.amplitude = const Offset(8, 6),
    this.period = const Duration(seconds: 7),
    this.phase = 0,
    this.icon,
  });

  final String label;
  final Offset amplitude;
  final Duration period;

  /// Phase offset in radians (0..2π) — каждый чип со своим смещением.
  final double phase;
  final IconData? icon;

  @override
  State<FloatingChip> createState() => _FloatingChipState();
}

class _FloatingChipState extends State<FloatingChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.period)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * math.pi + widget.phase;
        final dx = math.cos(t) * widget.amplitude.dx;
        final dy = math.sin(t) * widget.amplitude.dy;
        return Transform.translate(offset: Offset(dx, dy), child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: palette.pill,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: palette.stroke),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 14, color: palette.brandGreen),
              const SizedBox(width: AppSpacing.xs + 2),
            ],
            Text(
              widget.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
