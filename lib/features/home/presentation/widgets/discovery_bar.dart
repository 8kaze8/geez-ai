import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/shared/widgets/geez_card.dart';

class DiscoveryBar extends StatelessWidget {
  const DiscoveryBar({
    super.key,
    required this.score,
    required this.tier,
    required this.nextTier,
    required this.pointsToNext,
    required this.progress,
  });

  final int score;
  final String tier;
  final String nextTier;
  final int pointsToNext;

  /// Progress within current tier band, clamped 0.0 – 1.0.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return GeezCard(
      padding: const EdgeInsets.all(GeezSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score header row
          Row(
            children: [
              const Icon(
                Icons.explore_rounded,
                size: 20,
                color: GeezColors.primary,
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
                '$score',
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
                    widthFactor: progress.clamp(0.0, 1.0),
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
                  tier,
                  style: GeezTypography.caption.copyWith(
                    color: GeezColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$pointsToNext puan → $nextTier seviye',
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
