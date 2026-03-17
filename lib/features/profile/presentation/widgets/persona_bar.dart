import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';

// ---------------------------------------------------------------------------
// PersonaCategory — value class representing a single persona dimension.
// ---------------------------------------------------------------------------

class PersonaCategory {
  const PersonaCategory({
    required this.icon,
    required this.name,
    required this.level,
    required this.progress,
    required this.color,
  });

  final IconData icon;
  final String name;
  final int level;
  final double progress;
  final Color color;
}

// ---------------------------------------------------------------------------
// PersonaBar — animates a single persona-level bar.
// ---------------------------------------------------------------------------

class PersonaBar extends StatefulWidget {
  const PersonaBar({super.key, required this.category});

  final PersonaCategory category;

  @override
  State<PersonaBar> createState() => _PersonaBarState();
}

class _PersonaBarState extends State<PersonaBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.category.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Staggered start
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = widget.category;

    return Padding(
      padding: const EdgeInsets.only(bottom: GeezSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row: emoji + name + level badge + percentage
          Row(
            children: [
              Icon(cat.icon, size: 18, color: cat.color),
              const SizedBox(width: GeezSpacing.sm),
              Expanded(
                child: Text(
                  cat.name,
                  style: GeezTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(GeezRadius.chip),
                ),
                child: Text(
                  'Lv.${cat.level}',
                  style: GeezTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cat.color,
                  ),
                ),
              ),
              const SizedBox(width: GeezSpacing.sm),
              Text(
                '${(cat.progress * 100).toInt()}%',
                style: GeezTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: GeezColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: GeezSpacing.sm),
          // Animated progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: cat.color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                  minHeight: 8,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper: build a PersonaCategory list from a TravelPersonaModel level fields.
// ---------------------------------------------------------------------------

/// Maps a persona level (1-10) to a progress bar value in [0.0, 1.0].
double _levelProgress(int level) => (level / 10).clamp(0.0, 1.0);

List<PersonaCategory> personaCategoriesFromLevels({
  required int foodieLevel,
  required int historyBuffLevel,
  required int adventureSeekerLevel,
  required int cultureExplorerLevel,
  required int natureLoverLevel,
}) {
  return [
    PersonaCategory(
      icon: Icons.restaurant_rounded,
      name: 'Gurme',
      level: foodieLevel,
      progress: _levelProgress(foodieLevel),
      color: GeezColors.foodie,
    ),
    PersonaCategory(
      icon: Icons.account_balance_rounded,
      name: 'Tarih Sever',
      level: historyBuffLevel,
      progress: _levelProgress(historyBuffLevel),
      color: GeezColors.history,
    ),
    PersonaCategory(
      icon: Icons.hiking_rounded,
      name: 'Maceraperest',
      level: adventureSeekerLevel,
      progress: _levelProgress(adventureSeekerLevel),
      color: GeezColors.adventure,
    ),
    PersonaCategory(
      icon: Icons.palette_rounded,
      name: 'Kültür',
      level: cultureExplorerLevel,
      progress: _levelProgress(cultureExplorerLevel),
      color: GeezColors.culture,
    ),
    PersonaCategory(
      icon: Icons.park_rounded,
      name: 'Doğa Sever',
      level: natureLoverLevel,
      progress: _levelProgress(natureLoverLevel),
      color: GeezColors.nature,
    ),
  ];
}
