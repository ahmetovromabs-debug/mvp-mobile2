import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final cats = <_Category>[
      _Category(
        title: l10n.homeCategoryElectricalTitle,
        icon: Icons.electrical_services_rounded,
        items: const [
          'повесить светильник',
          'установить розетку',
          'заменить выключатель',
        ],
      ),
      _Category(
        title: l10n.homeCategoryPlumbingTitle,
        icon: Icons.water_drop_rounded,
        items: const [
          'замена смесителя',
          'фильтр для воды',
          'герметизация ванны',
        ],
      ),
      _Category(
        title: l10n.homeCategoryHouseholdTitle,
        icon: Icons.chair_rounded,
        items: const [
          'отрегулировать окна',
          'починить мебель',
          'заменить замок',
        ],
      ),
      _Category(
        title: l10n.homeCategoryConstructionTitle,
        icon: Icons.construction_rounded,
        items: const [
          'мелкий ремонт',
          'монтаж / демонтаж',
          'уборка после работ',
        ],
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, i) {
        return _CategoryCard(data: cats[i])
            .animate(delay: (i * 80).ms)
            .fadeIn(duration: 360.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _Category {
  _Category({required this.title, required this.icon, required this.items});
  final String title;
  final IconData icon;
  final List<String> items;
}

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({required this.data});
  final _Category data;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          Transform.scale(scale: 1 - 0.03 * _controller.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: _controller.reverse,
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: palette.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: palette.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.brandGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.data.icon,
                  color: palette.brandGreen,
                  size: 22,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.data.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final item in widget.data.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 7),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: palette.brandGreen.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    l10n.homeCategoryCta,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: palette.brandGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: palette.brandGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
