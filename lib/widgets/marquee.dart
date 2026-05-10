import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';

/// Infinite horizontally-scrolling marquee with smooth, frame-paced motion.
/// Used for the «Электронный чек • Гарантия на работы • …» strip.
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.items,
    this.pixelsPerSecond = 28,
    this.separatorBuilder,
    this.itemBuilder,
  });

  final List<String> items;
  final double pixelsPerSecond;
  final WidgetBuilder? separatorBuilder;
  final Widget Function(BuildContext, String)? itemBuilder;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ScrollController _scrollController;
  double? _stripWidth;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.repeat();
    });
  }

  void _tick() {
    if (!_scrollController.hasClients) return;
    final width = _stripWidth;
    if (width == null || width <= 0) return;
    final dt = 1 / 60; // ~16ms per frame target
    var next = _scrollController.offset + widget.pixelsPerSecond * dt;
    if (next >= width) next -= width;
    _scrollController.jumpTo(next);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_tick)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    Widget defaultItem(BuildContext c, String s) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: palette.brandGreen,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.brandGreen.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Build one strip + repeat to fill 2x the viewport for seamless loop.
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: const [0, 0.05, 0.95, 1],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: SizedBox(
            height: 36,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: _StripMeasured(
                onMeasured: (w) {
                  if (_stripWidth != w) {
                    setState(() => _stripWidth = w);
                  }
                },
                child: Row(
                  children: [
                    for (var copy = 0; copy < 4; copy++)
                      ...widget.items.map(
                        (it) =>
                            widget.itemBuilder?.call(context, it) ??
                            defaultItem(context, it),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Measures the *single-strip* width (1/4 of total since we duplicate 4x).
class _StripMeasured extends StatefulWidget {
  const _StripMeasured({required this.child, required this.onMeasured});

  final Widget child;
  final ValueChanged<double> onMeasured;

  @override
  State<_StripMeasured> createState() => _StripMeasuredState();
}

class _StripMeasuredState extends State<_StripMeasured> {
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _key.currentContext;
      if (ctx != null) {
        final w = (ctx.findRenderObject()! as RenderBox).size.width;
        // single strip = total / 4 (we render 4 copies)
        widget.onMeasured(w / 4);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      SizedBox(key: _key, child: widget.child);
}
