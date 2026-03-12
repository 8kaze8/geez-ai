import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../shared/widgets/geez_button.dart';
import '../../../../shared/widgets/geez_card.dart';
import '../../domain/mock_passport_data.dart';
import '../widgets/stamp_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/collection_card.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.md,
            vertical: GeezSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(textColor),
              const SizedBox(height: GeezSpacing.lg),

              // Passport Cover
              _buildPassportCover(context, isDark, textColor),
              const SizedBox(height: GeezSpacing.lg),

              // Stamps Section
              _buildSectionTitle('Damgalarim', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildStampGrid(),
              const SizedBox(height: GeezSpacing.lg),

              // Statistics Section
              _buildSectionTitle('Istatistikler', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildStatsCard(isDark),
              const SizedBox(height: GeezSpacing.lg),

              // Collections Section
              _buildSectionTitle('Koleksiyonlar', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildCollections(),
              const SizedBox(height: GeezSpacing.lg),

              // Share Button
              Center(
                child: GeezButton(
                  label: 'Pasaportumu Paylas',
                  onTap: () {},
                  icon: Icons.share,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: GeezSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('\u{1F6C2}', style: TextStyle(fontSize: 28)),
          const SizedBox(width: GeezSpacing.sm),
          Text(
            'GEZ PASAPORTU',
            style: GeezTypography.h2.copyWith(
              color: textColor,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportCover(
      BuildContext context, bool isDark, Color textColor) {
    return GeezCard(
      elevation: 2,
      padding: const EdgeInsets.all(GeezSpacing.lg),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(GeezRadius.card),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              GeezColors.primary.withValues(alpha: 0.08),
              GeezColors.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            // Passport emblem
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: GeezColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  '\u{2708}\u{FE0F}',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: GeezSpacing.md),
            Text(
              'GEEZ AI',
              style: GeezTypography.h3.copyWith(
                color: GeezColors.primary,
                letterSpacing: 4.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: GeezSpacing.xs),
            Text(
              'TRAVEL PASSPORT',
              style: GeezTypography.caption.copyWith(
                color: GeezColors.textSecondary,
                letterSpacing: 3.0,
              ),
            ),
            const SizedBox(height: GeezSpacing.md),
            // Divider line
            Container(
              width: 120,
              height: 1,
              color: GeezColors.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: GeezSpacing.md),
            Text(
              'Kaze',
              style: GeezTypography.h3.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GeezSpacing.xs),
            Text(
              'Adventurous Foodie',
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: GeezColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: GeezSpacing.sm),
        Text(
          title,
          style: GeezTypography.h3.copyWith(
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStampGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: GeezSpacing.sm,
        mainAxisSpacing: GeezSpacing.sm,
        childAspectRatio: 0.85,
      ),
      itemCount: MockPassportData.stamps.length,
      itemBuilder: (context, index) {
        return StampCard(stamp: MockPassportData.stamps[index]);
      },
    );
  }

  Widget _buildStatsCard(bool isDark) {
    return GeezCard(
      elevation: 1,
      child: Column(
        children: [
          StatsRow(stats: MockPassportData.stats),
          const SizedBox(height: GeezSpacing.lg),
          // Goal progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MockPassportData.goalLabel,
                style: GeezTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? GeezColors.textPrimaryDark
                      : GeezColors.textPrimary,
                ),
              ),
              Text(
                '${(MockPassportData.goalProgress * 100).toInt()}%',
                style: GeezTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GeezColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: GeezSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: MockPassportData.goalProgress,
              backgroundColor: GeezColors.primary.withValues(alpha: 0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(GeezColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollections() {
    return Column(
      children: MockPassportData.collections
          .map((c) => CollectionCard(collection: c))
          .toList(),
    );
  }
}
