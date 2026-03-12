import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../shared/widgets/geez_card.dart';
import '../../domain/mock_data.dart';

class DiscoveryBar extends StatelessWidget {
  const DiscoveryBar({
    super.key,
    required this.data,
  });

  final MockDiscoveryScore data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return GeezCard(
      padding: const EdgeInsets.all(GeezSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score header row
          Row(
            children: [
              const Text(
                '\u{1F9ED}',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: GeezSpacing.sm),
              Text(
                'Discovery Score',
                style: GeezTypography.bodySmall.copyWith(
                  color: mutedColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${data.score}',
                style: GeezTypography.h2.copyWith(
                  color: GeezColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: GeezSpacing.sm + 4),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                  // Filled portion with gradient
                  FractionallySizedBox(
                    widthFactor: data.progress,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [GeezColors.primary, GeezColors.accent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GeezSpacing.sm),

          // Tier info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.sm + 2,
                  vertical: GeezSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: GeezColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(GeezRadius.chip),
                ),
                child: Text(
                  data.tier,
                  style: GeezTypography.caption.copyWith(
                    color: GeezColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${data.pointsToNext} puan \u{2192} ${data.nextTier} seviye',
                style: GeezTypography.caption.copyWith(
                  color: mutedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
