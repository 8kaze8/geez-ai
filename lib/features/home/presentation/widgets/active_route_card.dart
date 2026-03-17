import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';

class ActiveRouteCard extends StatelessWidget {
  const ActiveRouteCard({
    super.key,
    required this.route,
    this.onContinue,
  });

  final RouteModel route;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? GeezColors.surfaceDark : GeezColors.surface;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    final dateLabel = _formatDate(route.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(GeezRadius.card),
        border: const Border(
          left: BorderSide(
            color: GeezColors.primary,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(GeezSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(GeezSpacing.sm),
                  decoration: BoxDecoration(
                    color: GeezColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 18,
                    color: GeezColors.primary,
                  ),
                ),
                const SizedBox(width: GeezSpacing.sm + 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.title,
                        style: GeezTypography.h3.copyWith(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dateLabel  |  ${route.durationDays} gün',
                        style: GeezTypography.caption.copyWith(
                          color: mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: GeezSpacing.md),

            // City + country badge row
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: mutedColor,
                ),
                const SizedBox(width: GeezSpacing.xs),
                Text(
                  '${route.city}, ${route.country}',
                  style: GeezTypography.caption.copyWith(
                    color: mutedColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _StyleChip(travelStyle: route.travelStyle, isDark: isDark),
              ],
            ),
            const SizedBox(height: GeezSpacing.md),

            // Divider
            Divider(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              height: 1,
            ),
            const SizedBox(height: GeezSpacing.md),

            // Continue button row
            Row(
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  size: 16,
                  color: GeezColors.secondary,
                ),
                const SizedBox(width: GeezSpacing.xs + 2),
                Expanded(
                  child: Text(
                    'Devam etmeye hazir',
                    style: GeezTypography.bodySmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _ContinueButton(onTap: onContinue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day} ${_monthTr(dt.month)} ${dt.year}';
  }

  String _monthTr(int month) {
    const months = [
      'Oca', 'Sub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Agu', 'Eyl', 'Eki', 'Kas', 'Ara',
    ];
    return months[month - 1];
  }
}

// ---------------------------------------------------------------------------
// Travel style chip
// ---------------------------------------------------------------------------

class _StyleChip extends StatelessWidget {
  const _StyleChip({required this.travelStyle, required this.isDark});

  final String travelStyle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.sm + 2,
        vertical: GeezSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: GeezColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(GeezRadius.chip),
      ),
      child: Text(
        _labelTr(travelStyle),
        style: GeezTypography.caption.copyWith(
          color: GeezColors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _labelTr(String style) {
    switch (style) {
      case 'historical':
        return 'Tarih';
      case 'food':
        return 'Yemek';
      case 'adventure':
        return 'Macera';
      case 'nature':
        return 'Doga';
      case 'mixed':
        return 'Karma';
      default:
        return style;
    }
  }
}

// ---------------------------------------------------------------------------
// Continue button
// ---------------------------------------------------------------------------

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GeezColors.primary,
      borderRadius: BorderRadius.circular(GeezRadius.button),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GeezRadius.button),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.md,
            vertical: GeezSpacing.sm + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Devam Et',
                style: GeezTypography.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: GeezSpacing.xs),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
