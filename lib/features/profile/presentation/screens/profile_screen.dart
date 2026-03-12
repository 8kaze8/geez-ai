import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../shared/widgets/geez_button.dart';
import '../../../../shared/widgets/geez_card.dart';
import '../../../passport/domain/mock_passport_data.dart';
import '../widgets/persona_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              // Profile Header
              _buildProfileHeader(isDark, textColor),
              const SizedBox(height: GeezSpacing.lg),

              // Discovery Score
              _buildDiscoveryScore(isDark, textColor),
              const SizedBox(height: GeezSpacing.lg),

              // Travel Persona Section
              _buildSectionTitle('Travel Persona', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildPersonaCard(isDark),
              const SizedBox(height: GeezSpacing.md),

              // Share Persona Button
              Center(
                child: GeezButton(
                  label: 'Personami Paylas',
                  onTap: () {},
                  icon: Icons.share,
                  variant: GeezButtonVariant.secondary,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: GeezSpacing.lg),

              // Trip History
              _buildSectionTitle('Gecmis Geziler', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildTripHistory(isDark, textColor),
              const SizedBox(height: GeezSpacing.lg),

              // Settings
              _buildSectionTitle('Ayarlar', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildSettings(isDark, textColor),
              const SizedBox(height: GeezSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark, Color textColor) {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  GeezColors.primary,
                  GeezColors.primary.withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: GeezColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: GeezSpacing.md),
          // Name
          Text(
            'Kaze',
            style: GeezTypography.h2.copyWith(color: textColor),
          ),
          const SizedBox(height: GeezSpacing.xs),
          // Persona title
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.md,
              vertical: GeezSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: GeezColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(GeezRadius.chip),
            ),
            child: Text(
              'Adventurous Foodie',
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryScore(bool isDark, Color textColor) {
    return GeezCard(
      elevation: 1,
      child: Column(
        children: [
          // Score row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.explore,
                    color: GeezColors.discovery,
                    size: 24,
                  ),
                  const SizedBox(width: GeezSpacing.sm),
                  Text(
                    'Discovery Score',
                    style: GeezTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Text(
                '847',
                style: GeezTypography.h2.copyWith(
                  color: GeezColors.discovery,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: GeezSpacing.md),
          // Stars + tier
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: GeezColors.discovery,
                    size: 22,
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: GeezColors.discovery.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(GeezRadius.chip),
                ),
                child: Text(
                  'Explorer',
                  style: GeezTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: GeezColors.discovery,
                  ),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildPersonaCard(bool isDark) {
    return GeezCard(
      elevation: 1,
      child: Column(
        children: MockPassportData.personaCategories
            .map((cat) => PersonaBar(category: cat))
            .toList(),
      ),
    );
  }

  Widget _buildTripHistory(bool isDark, Color textColor) {
    return Column(
      children: MockPassportData.tripHistory.map((trip) {
        return _TripHistoryTile(trip: trip, isDark: isDark, textColor: textColor);
      }).toList(),
    );
  }

  Widget _buildSettings(bool isDark, Color textColor) {
    final settingsItems = [
      _SettingItem(icon: Icons.language, title: 'Dil', trailing: 'Turkce'),
      _SettingItem(icon: Icons.palette, title: 'Tema', trailing: 'Light'),
      _SettingItem(icon: Icons.notifications_outlined, title: 'Bildirimler'),
      _SettingItem(icon: Icons.star, title: 'Premium', isPremium: true),
      _SettingItem(icon: Icons.person_outline, title: 'Hesap'),
    ];

    return GeezCard(
      elevation: 0,
      padding: EdgeInsets.zero,
      child: Column(
        children: settingsItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == settingsItems.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.vertical(
                  top: index == 0
                      ? const Radius.circular(GeezRadius.card)
                      : Radius.zero,
                  bottom: isLast
                      ? const Radius.circular(GeezRadius.card)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GeezSpacing.md,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: item.isPremium
                            ? GeezColors.discovery
                            : GeezColors.textSecondary,
                      ),
                      const SizedBox(width: GeezSpacing.md),
                      Expanded(
                        child: Text(
                          item.title,
                          style: GeezTypography.body.copyWith(
                            color: textColor,
                            fontWeight: item.isPremium
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (item.trailing != null)
                        Text(
                          item.trailing!,
                          style: GeezTypography.bodySmall.copyWith(
                            color: GeezColors.textSecondary,
                          ),
                        ),
                      if (item.isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: GeezSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: GeezColors.discovery.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(GeezRadius.chip),
                          ),
                          child: Text(
                            'PRO',
                            style: GeezTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: GeezColors.discovery,
                            ),
                          ),
                        ),
                      const SizedBox(width: GeezSpacing.sm),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: GeezColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: GeezSpacing.md + 22 + GeezSpacing.md,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// --- Private helper widgets ---

class _TripHistoryTile extends StatelessWidget {
  const _TripHistoryTile({
    required this.trip,
    required this.isDark,
    required this.textColor,
  });

  final TripHistory trip;
  final bool isDark;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GeezSpacing.sm),
      child: GeezCard(
        elevation: 0,
        onTap: () {},
        child: Row(
          children: [
            // Flag
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: GeezColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                trip.flag,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: GeezSpacing.md),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.cityName,
                    style: GeezTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${trip.date} \u{2022} ${trip.days} gun \u{2022} ${trip.stops} durak',
                    style: GeezTypography.caption.copyWith(
                      color: GeezColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Score badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GeezSpacing.sm,
                vertical: GeezSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: GeezColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(GeezRadius.chip),
              ),
              child: Text(
                '+${trip.score}',
                style: GeezTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GeezColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem {
  const _SettingItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.isPremium = false,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final bool isPremium;
}
