import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;
    final bgColor =
        isDark ? GeezColors.backgroundDark : GeezColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.travel_explore_rounded,
                  size: 64,
                  color: GeezColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(height: GeezSpacing.lg),
                Text(
                  'Keşfet',
                  style: GeezTypography.h1.copyWith(color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GeezSpacing.sm),
                Text(
                  'Kişiselleştirilmiş öneriler yakında burada!',
                  style: GeezTypography.body.copyWith(color: mutedColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
