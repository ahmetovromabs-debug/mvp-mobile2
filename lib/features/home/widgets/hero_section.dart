import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../widgets/floating_chip.dart';
import '../../../widgets/pill_button.dart';

/// Hero block:
///   «Мастер на час | в Тюмени | для дома и офиса» (city in brand-green,
///   third line in Caveat-script). CTA pill below. Stack of floating service
///   chips on the right.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Stack(
        children: [
          // Background ambient glow
          Positioned(
            top: -60,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      palette.brandGreen.withOpacity(0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tagline pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: palette.stroke),
                  color: palette.pill.withOpacity(0.6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: palette.brandGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: palette.brandGreen.withOpacity(0.7),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    )
                        .animate(
                          onPlay: (c) => c.repeat(reverse: true),
                        )
                        .fadeIn(duration: 1.seconds),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Принимаем заявки 24/7',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Hero stack: title (left) and floating chip cluster (right).
              SizedBox(
                height: 360,
                child: Stack(
                  children: [
                    // Title
                    Positioned.fill(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeHeroLine1,
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontSize: 44,
                              height: 1.0,
                            ),
                          )
                              .animate(delay: 60.ms)
                              .fadeIn(duration: 480.ms)
                              .slideY(begin: 0.2),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: 44,
                                height: 1.0,
                              ),
                              children: [
                                TextSpan(text: '${l10n.homeHeroLine2In} '),
                                TextSpan(
                                  text: l10n.homeHeroLine2City,
                                  style: TextStyle(
                                    color: palette.brandGreen,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(
                                        color: palette.brandGreen
                                            .withOpacity(0.45),
                                        blurRadius: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate(delay: 200.ms)
                              .fadeIn(duration: 480.ms)
                              .slideY(begin: 0.2),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeHeroLine3,
                            style: TextStyle(
                              fontFamily: 'Caveat',
                              fontWeight: FontWeight.w700,
                              fontSize: 42,
                              height: 1,
                              color: palette.textSecondary,
                            ),
                          )
                              .animate(delay: 360.ms)
                              .fadeIn(duration: 480.ms)
                              .slideX(begin: -0.1),
                          const Spacer(),
                          PillButton(
                            label: l10n.homeHeroCta,
                            onPressed: () {},
                            icon: Icons.bolt_rounded,
                          ).animate(delay: 600.ms).fadeIn(duration: 380.ms),
                        ],
                      ),
                    ),

                    // Floating chips cluster (right)
                    Positioned(
                      right: -8,
                      top: 70,
                      child: _FloatingChipCluster(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FloatingChipCluster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = <(String, Offset)>[
      (l10n.homeChipSocket, Offset.zero),
      (l10n.homeChipFaucet, const Offset(-30, 56)),
      (l10n.homeChipFurniture, const Offset(20, 116)),
      (l10n.homeChipLock, const Offset(-10, 178)),
      (l10n.homeChipPicture, const Offset(28, 236)),
    ];
    return SizedBox(
      width: 200,
      height: 280,
      child: Stack(
        children: [
          for (var i = 0; i < chips.length; i++)
            Positioned(
              left: chips[i].$2.dx + 20,
              top: chips[i].$2.dy,
              child: FloatingChip(
                label: chips[i].$1,
                phase: i * (math.pi / 3),
                period: Duration(milliseconds: 6500 + i * 400),
                amplitude: const Offset(10, 8),
                icon: _iconFor(i),
              ),
            ).animate(delay: (200 + i * 90).ms).fadeIn(duration: 420.ms).slideX(
                  begin: 0.2,
                  curve: Curves.easeOutCubic,
                ),
        ],
      ),
    );
  }

  IconData _iconFor(int i) => switch (i) {
        0 => Icons.electrical_services_rounded,
        1 => Icons.water_drop_rounded,
        2 => Icons.chair_rounded,
        3 => Icons.lock_rounded,
        _ => Icons.image_rounded,
      };
}
