import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../generated/l10n/app_localizations.dart';
import 'widgets/category_grid.dart';
import 'widgets/hero_section.dart';
import 'widgets/marquee_strip.dart';
import 'widgets/metrics_strip.dart';
import 'widgets/sos_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.base,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    _AvatarBubble(palette: palette),
                    const SizedBox(width: AppSpacing.md),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: palette.brandGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.homeLocation,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: l10n.themeToggleHint,
                      icon: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: theme.colorScheme.onSurface,
                          ),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: palette.brandGreen,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: palette.brandGreen.withOpacity(0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: HeroSection()),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: MetricsStrip(),
              ),
            ),
            const SliverToBoxAdapter(child: MarqueeStrip()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xl + AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.base,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeServicesTitle,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 26,
                        height: 1.1,
                      ),
                    ).animate().fadeIn().slideY(
                          begin: 0.08,
                          duration: 480.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.homeServicesSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: CategoryGrid(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.huge,
                ),
                child: SosBanner(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: palette.brandGreen,
        boxShadow: [
          BoxShadow(
            color: palette.brandGreen.withOpacity(0.45),
            blurRadius: 16,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text(
        'М',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w800,
          color: Color(0xFF062012),
        ),
      ),
    );
  }
}
