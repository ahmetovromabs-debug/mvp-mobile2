import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../widgets/marquee.dart';

class MarqueeStrip extends StatelessWidget {
  const MarqueeStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    final items = [
      l10n.homeMarqueeReceipt,
      l10n.homeMarqueeWarranty,
      l10n.homeMarqueeRegion,
      l10n.homeMarqueeCleanup,
      l10n.homeMarqueeBoth,
      l10n.homeMarqueeOnTime,
      l10n.homeMarqueePros,
      l10n.homeMarqueeClean,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: palette.stroke),
      ),
      child: Marquee(items: items),
    );
  }
}
