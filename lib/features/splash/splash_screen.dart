import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/monogram_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    Future<void>.microtask(() async {
      unawaited(_controller.forward());
      // Resolve target route in parallel.
      final target = await resolvePostSplashRoute(ref);
      // Wait for animation to finish (or 1.4s, whichever first).
      await _controller.forward();
      if (!mounted) return;
      // brief breath before navigating
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (!mounted) return;
      context.go(target);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgBase, // splash is always dark — это бренд
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = _controller.value;
          final taglineOpacity = ((progress - 0.55) / 0.4).clamp(0.0, 1.0);
          return Stack(
            fit: StackFit.expand,
            children: [
              // Soft brand-green ambience that grows as the logo morphs in.
              Center(
                child: IgnorePointer(
                  child: Container(
                    width: 380 * (0.4 + progress * 0.9),
                    height: 380 * (0.4 + progress * 0.9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          palette.brandGreen.withOpacity(0.18 * progress),
                          Colors.transparent,
                        ],
                        stops: const [0, 1],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MonogramLogo(progress: progress),
                    const SizedBox(height: AppSpacing.xl),
                    Opacity(
                      opacity: taglineOpacity,
                      child: Transform.translate(
                        offset: Offset(0, 8 * (1 - taglineOpacity)),
                        child: Text(
                          l10n.splashTagline,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
