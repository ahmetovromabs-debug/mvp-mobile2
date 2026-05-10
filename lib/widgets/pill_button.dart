import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';

/// Premium pill-shaped CTA with neon-green glow.
///
/// Adheres to the brand: pill (height 56, radius 999), brandGreen fill,
/// black text, soft glow shadow. On press: scale 0.96 + ripple-glow.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.height = 56,
    this.expand = false,
    this.glow = true,
    this.variant = PillButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final bool expand;
  final bool glow;
  final PillButtonVariant variant;

  @override
  State<PillButton> createState() => _PillButtonState();
}

enum PillButtonVariant { primary, secondary, ghost }

class _PillButtonState extends State<PillButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
    lowerBound: 0,
    upperBound: 1,
  );

  bool get _enabled => widget.onPressed != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDown(_) => _controller.forward();
  void _handleUp(_) => _controller.reverse();
  void _handleCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    final fill = switch (widget.variant) {
      PillButtonVariant.primary => palette.brandGreen,
      PillButtonVariant.secondary => palette.surfaceElevated,
      PillButtonVariant.ghost => Colors.transparent,
    };
    final fg = switch (widget.variant) {
      PillButtonVariant.primary => const Color(0xFF062012),
      PillButtonVariant.secondary => theme.colorScheme.onSurface,
      PillButtonVariant.ghost => palette.brandGreen,
    };
    final border = widget.variant == PillButtonVariant.ghost
        ? Border.all(color: palette.brandGreen.withOpacity(0.55), width: 1.2)
        : (widget.variant == PillButtonVariant.secondary
            ? Border.all(color: palette.stroke)
            : null);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final scale = 1 - 0.04 * t;
        return Transform.scale(scale: scale, child: child);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? _handleDown : null,
        onTapUp: _enabled ? _handleUp : null,
        onTapCancel: _enabled ? _handleCancel : null,
        onTap: _enabled
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed!();
              }
            : null,
        child: Opacity(
          opacity: _enabled ? 1 : 0.45,
          child: Container(
            width: widget.expand ? double.infinity : null,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: border,
              boxShadow:
                  widget.glow && widget.variant == PillButtonVariant.primary
                      ? [
                          BoxShadow(
                            color: palette.brandGreenGlow,
                            blurRadius: 40,
                            spreadRadius: 0,
                            offset: const Offset(0, 12),
                          ),
                        ]
                      : null,
            ),
            child: Center(
              widthFactor: widget.expand ? null : 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: fg, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    widget.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
