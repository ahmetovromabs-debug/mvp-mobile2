import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../widgets/animated_counter.dart';

/// Horizontal strip with the four hero metrics:
///   1500 ₽ / час  •  3 направления  •  23/7  •  97 %
class MetricsStrip extends StatelessWidget {
  const MetricsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final theme = Theme.of(context);

    final metrics = <_Metric>[
      _Metric(
        animated: AnimatedCounter(
          target: 1500,
          suffix: ' ₽',
          duration: const Duration(milliseconds: 1300),
          style: theme.textTheme.headlineLarge?.copyWith(
            color: palette.brandGreen,
            fontSize: 26,
          ),
        ),
        label: l10n.homeMetricRateLabel,
      ),
      _Metric(
        animated: AnimatedCounter(
          target: 3,
          suffix: '',
          duration: const Duration(milliseconds: 900),
          style: theme.textTheme.headlineLarge?.copyWith(
            color: palette.brandGreen,
            fontSize: 26,
          ),
        ),
        label: l10n.homeMetricDirectionsLabel,
      ),
      _Metric(
        animated: Text(
          l10n.homeMetricSchedule,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: palette.brandGreen,
            fontSize: 26,
          ),
        ),
        label: l10n.homeMetricScheduleLabel,
      ),
      _Metric(
        animated: AnimatedCounter(
          target: 97,
          suffix: ' %',
          duration: const Duration(milliseconds: 1100),
          style: theme.textTheme.headlineLarge?.copyWith(
            color: palette.brandGreen,
            fontSize: 26,
          ),
        ),
        label: l10n.homeMetricReceiptLabel,
      ),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: metrics.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          final m = metrics[i];
          return Container(
            width: 168,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              AppSpacing.base,
              AppSpacing.base,
              AppSpacing.base,
            ),
            decoration: BoxDecoration(
              color: palette.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: palette.stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                m.animated,
                const SizedBox(height: AppSpacing.xs),
                Text(
                  m.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: palette.textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ).animate(delay: (i * 80).ms).fadeIn(duration: 360.ms).slideY(
                begin: 0.1,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }
}

class _Metric {
  _Metric({required this.animated, required this.label});
  final Widget animated;
  final String label;
}
