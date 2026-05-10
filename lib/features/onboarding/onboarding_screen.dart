import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/pill_button.dart';
import 'onboarding_seen_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _next() {
    if (_index >= 2) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = <_PageData>[
      _PageData(
        icon: Icons.handyman_rounded,
        title: l10n.onboardingPage1Title,
        body: l10n.onboardingPage1Body,
        accent: AppColors.brandGreen,
        sigil: '01',
      ),
      _PageData(
        icon: Icons.payments_rounded,
        title: l10n.onboardingPage2Title,
        body: l10n.onboardingPage2Body,
        accent: AppColors.info,
        sigil: '02',
      ),
      _PageData(
        icon: Icons.bolt_rounded,
        title: l10n.onboardingPage3Title,
        body: l10n.onboardingPage3Body,
        accent: AppColors.warning,
        sigil: '03',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                return _OnboardingPage(
                  data: pages[i],
                  controller: _controller,
                  pageIndex: i,
                );
              },
            ),
            Positioned(
              top: AppSpacing.base,
              right: AppSpacing.lg,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  l10n.onboardingSkip,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.xl,
              child: Column(
                children: [
                  _PageIndicator(count: pages.length, activeIndex: _index),
                  const SizedBox(height: AppSpacing.xl),
                  PillButton(
                    label: _index == pages.length - 1
                        ? l10n.onboardingStart
                        : l10n.onboardingNext,
                    onPressed: _next,
                    expand: true,
                    icon: _index == pages.length - 1
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  _PageData({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
    required this.sigil,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final String sigil;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.controller,
    required this.pageIndex,
  });

  final _PageData data;
  final PageController controller;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // [PageController.page] throws before content dimensions are
        // established (e.g. on the first frame in tests). Guard with a
        // try/catch so widget tests stay deterministic.
        double safePage() {
          if (!controller.hasClients) return pageIndex.toDouble();
          try {
            return controller.page ?? controller.initialPage.toDouble();
          } catch (_) {
            return pageIndex.toDouble();
          }
        }

        final page = safePage();
        final delta = page - pageIndex;
        // parallax: background moves slower than content.
        final bgShift = delta * 60;
        final fgShift = delta * 110;

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: 32),
          child: Stack(
            children: [
              // Decorative background blob — parallax with smaller delta.
              Transform.translate(
                offset: Offset(bgShift, 0),
                child: Center(
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          data.accent.withOpacity(0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Big sigil number in outline (like «01 / 02 / 03» on the site).
              Positioned(
                top: 56,
                left: 0,
                child: Transform.translate(
                  offset: Offset(bgShift * 0.5, 0),
                  child: Text(
                    data.sigil,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      fontSize: 132,
                      height: 1,
                      letterSpacing: -6,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.4
                        ..color = palette.stroke,
                    ),
                  ),
                ),
              ),
              // Foreground content with stronger parallax.
              Transform.translate(
                offset: Offset(fgShift, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: palette.surfaceElevated,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: palette.stroke),
                        boxShadow: [
                          BoxShadow(
                            color: data.accent.withOpacity(0.25),
                            blurRadius: 36,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Icon(data.icon, size: 38, color: data.accent),
                    )
                        .animate()
                        .scale(
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                          begin: const Offset(0.6, 0.6),
                        )
                        .fadeIn(),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      data.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 32,
                        height: 1.05,
                      ),
                    )
                        .animate(delay: 120.ms)
                        .fadeIn(duration: 480.ms)
                        .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      data.body,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: palette.textSecondary,
                      ),
                    )
                        .animate(delay: 220.ms)
                        .fadeIn(duration: 480.ms)
                        .slideY(begin: 0.12, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? palette.brandGreen : palette.stroke,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: palette.brandGreen.withOpacity(0.55),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
