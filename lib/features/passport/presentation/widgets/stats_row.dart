import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/mock_passport_data.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.stats});

  final List<PassportStat> stats;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) => _StatItem(stat: stat, isDark: isDark)).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat, required this.isDark});

  final PassportStat stat;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          stat.icon,
          size: 20,
          color: GeezColors.primary,
        ),
        const SizedBox(height: GeezSpacing.xs),
        Text(
          stat.value,
          style: GeezTypography.h3.copyWith(
            fontSize: 18,
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
        Text(
          stat.label,
          style: GeezTypography.caption.copyWith(
            color: GeezColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
