import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/mock_data.dart';

class ActiveRouteCard extends StatelessWidget {
  const ActiveRouteCard({
    super.key,
    required this.route,
    this.onContinue,
  });

  final MockRoute route;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? GeezColors.surfaceDark : GeezColors.surface;
    final textColor = isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor = isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

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
                  child: const Text(
                    '\u{1F4CD}',
                    style: TextStyle(fontSize: 18),
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
                        '${route.date}  |  ${route.stopCount} durak',
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

            // Progress section
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 6,
                      child: Stack(
                        children: [
                          Container(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.grey.shade200,
                          ),
                          FractionallySizedBox(
                            widthFactor: route.completionPercent,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    GeezColors.primary,
                                    GeezColors.primary.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: GeezSpacing.sm + 4),
                Text(
                  '%${(route.completionPercent * 100).toInt()}',
                  style: GeezTypography.bodySmall.copyWith(
                    color: GeezColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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

            // Next stop + continue button
            Row(
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: GeezColors.secondary,
                ),
                const SizedBox(width: GeezSpacing.xs + 2),
                Expanded(
                  child: Text(
                    'Sonraki: ${route.nextStop}',
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
}

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
