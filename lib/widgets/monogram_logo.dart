import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// «МВП»-monogram with a programmatic morph: a pulsing dot expands into the
/// three letters, with each glyph fading + scaling in a staggered sequence.
///
/// [progress] in [0..1]:
///   0.00–0.40 — dot pulse + grow.
///   0.40–1.00 — letters sweep in (М → В → П) with glow.
class MonogramLogo extends StatelessWidget {
  const MonogramLogo({
    super.key,
    required this.progress,
    this.size = 96,
  });

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: size * 3.4,
      height: size * 1.1,
      child: CustomPaint(
        painter: _MonogramPainter(
          progress: progress.clamp(0, 1),
          accent: palette.brandGreen,
          glow: palette.brandGreenGlow,
        ),
      ),
    );
  }
}

class _MonogramPainter extends CustomPainter {
  _MonogramPainter({
    required this.progress,
    required this.accent,
    required this.glow,
  });

  final double progress;
  final Color accent;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Phase 1: dot (0..0.4)
    final dotPhase = (progress / 0.4).clamp(0.0, 1.0);
    // pulse: 0..1..0.7 (so it grows, settles)
    final pulse =
        (math.sin(dotPhase * math.pi) * 0.5 + 0.5) * (1 - dotPhase * 0.3) +
            dotPhase * 0.4;

    final dotRadius = 6 + pulse * 14;
    final dotOpacity = (1 - ((progress - 0.32) / 0.18).clamp(0.0, 1.0));

    if (dotOpacity > 0) {
      final glowPaint = Paint()
        ..color = glow.withOpacity(0.55 * dotOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawCircle(Offset(cx, cy), dotRadius * 1.6, glowPaint);

      final dotPaint = Paint()..color = accent.withOpacity(dotOpacity);
      canvas.drawCircle(Offset(cx, cy), dotRadius, dotPaint);
    }

    // Phase 2: letters sweep in from 0.4..1.0, staggered.
    final letterPhase = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);
    if (letterPhase <= 0) return;

    const glyphs = ['М', 'В', 'П'];
    final fontSize = size.height * 0.78;
    final spacing = size.width / 3.5;
    final startX = cx - spacing;

    for (var i = 0; i < glyphs.length; i++) {
      final localStart = i * 0.18;
      final localProg =
          ((letterPhase - localStart) / (1 - localStart)).clamp(0.0, 1.0);
      if (localProg <= 0) continue;

      final eased = Curves.easeOutCubic.transform(localProg);
      final color = accent.withOpacity(eased);
      final tp = TextPainter(
        text: TextSpan(
          text: glyphs[i],
          style: TextStyle(
            color: color,
            fontFamily: 'Manrope',
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -2,
            shadows: [
              Shadow(
                color: glow.withOpacity(0.45 * eased),
                blurRadius: 24,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final dx = startX + i * spacing - tp.width / 2;
      final scale = 0.6 + eased * 0.4;
      canvas.save();
      canvas.translate(dx + tp.width / 2, cy);
      canvas.scale(scale);
      canvas.translate(-tp.width / 2, -tp.height / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _MonogramPainter old) =>
      old.progress != progress || old.accent != accent || old.glow != glow;
}
