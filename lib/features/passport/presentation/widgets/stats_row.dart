import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/passport/presentation/providers/passport_provider.dart';

/// Displays five passport stat items (cities, countries, stops, etc.)
/// from a [PassportStats] value object.
class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.stats});

  final PassportStats stats;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _StatData(icon: Icons.location_city, value: '${stats.cityCount}', label: 'Sehir'),
      _StatData(icon: Icons.flag, value: '${stats.countryCount}', label: 'Ulke'),
      _StatData(icon: Icons.place, value: '${stats.totalStops}', label: 'Durak'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map((item) => _StatItem(data: item, isDark: isDark))
          .toList(),
    );
  }
}

class _StatData {
  const _StatData({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.data, required this.isDark});

  final _StatData data;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          data.icon,
          size: 20,
          color: GeezColors.primary,
        ),
        const SizedBox(height: GeezSpacing.xs),
        Text(
          data.value,
          style: GeezTypography.h3.copyWith(
            fontSize: 18,
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
        Text(
          data.label,
          style: GeezTypography.caption.copyWith(
            color: GeezColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
