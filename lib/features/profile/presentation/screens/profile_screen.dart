import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../shared/widgets/geez_button.dart';
import '../../../../shared/widgets/geez_card.dart';
import '../../../passport/domain/mock_passport_data.dart';
import '../providers/profile_provider.dart';
import '../widgets/persona_bar.dart';

// ---------------------------------------------------------------------------
// ProfileScreen
// ---------------------------------------------------------------------------

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const _ProfileLoadingState(),
          error: (error, _) => _ProfileErrorState(
            message: error.toString(),
            onRetry: () => ref.invalidate(profileProvider),
          ),
          data: (data) => _ProfileContent(data: data),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading state — skeleton shimmer-style placeholders
// ---------------------------------------------------------------------------

class _ProfileLoadingState extends StatelessWidget {
  const _ProfileLoadingState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.07);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar placeholder
          Center(
            child: Column(
              children: [
                _Skeleton(width: 88, height: 88, radius: 44, color: shimmerColor),
                const SizedBox(height: GeezSpacing.md),
                _Skeleton(width: 120, height: 22, color: shimmerColor),
                const SizedBox(height: GeezSpacing.sm),
                _Skeleton(width: 140, height: 28, radius: 24, color: shimmerColor),
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.lg),
          // Discovery score card
          _Skeleton(
            width: double.infinity,
            height: 96,
            radius: GeezRadius.card,
            color: shimmerColor,
          ),
          const SizedBox(height: GeezSpacing.lg),
          // Section header
          _Skeleton(width: 120, height: 20, color: shimmerColor),
          const SizedBox(height: GeezSpacing.md),
          // Persona bars
          _Skeleton(
            width: double.infinity,
            height: 200,
            radius: GeezRadius.card,
            color: shimmerColor,
          ),
          const SizedBox(height: GeezSpacing.lg),
          _Skeleton(width: 140, height: 20, color: shimmerColor),
          const SizedBox(height: GeezSpacing.md),
          for (int i = 0; i < 3; i++) ...[
            _Skeleton(
              width: double.infinity,
              height: 64,
              radius: GeezRadius.card,
              color: shimmerColor,
            ),
            const SizedBox(height: GeezSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({
    required this.width,
    required this.height,
    this.radius = 8,
    required this.color,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: GeezColors.textSecondary,
            ),
            const SizedBox(height: GeezSpacing.md),
            Text(
              'Profil yuklenemedi',
              style: GeezTypography.h3.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.sm),
            Text(
              message,
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.lg),
            GeezButton(
              label: 'Tekrar Dene',
              onTap: onRetry,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data state — full profile content
// ---------------------------------------------------------------------------

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.data});

  final ProfileData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(data, isDark, textColor),
          const SizedBox(height: GeezSpacing.lg),

          // Discovery Score
          _buildDiscoveryScore(data, isDark, textColor),
          const SizedBox(height: GeezSpacing.lg),

          // Travel Persona Section
          _buildSectionTitle('Travel Persona', isDark),
          const SizedBox(height: GeezSpacing.md),
          _buildPersonaCard(data, isDark),
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
          _buildSettings(context, ref, isDark, textColor),
          const SizedBox(height: GeezSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    ProfileData data,
    bool isDark,
    Color textColor,
  ) {
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
            data.displayName,
            style: GeezTypography.h2.copyWith(color: textColor),
          ),
          const SizedBox(height: GeezSpacing.xs),
          // Persona title chip
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
              data.personaTitle,
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

  Widget _buildDiscoveryScore(
    ProfileData data,
    bool isDark,
    Color textColor,
  ) {
    final filledStars = data.starCount;

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
                data.discoveryScore.toString(),
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
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < filledStars ? Icons.star : Icons.star_border,
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
                  data.tierLabel,
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

  Widget _buildPersonaCard(ProfileData data, bool isDark) {
    final categories = data.persona != null
        ? personaCategoriesFromLevels(
            foodieLevel: data.persona!.foodieLevel,
            historyBuffLevel: data.persona!.historyBuffLevel,
            adventureSeekerLevel: data.persona!.adventureSeekerLevel,
            cultureExplorerLevel: data.persona!.cultureExplorerLevel,
            natureLoverLevel: data.persona!.natureLoverLevel,
          )
        : MockPassportData.personaCategories;

    if (categories.isEmpty) {
      return GeezCard(
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: GeezSpacing.lg),
            child: Text(
              'Persona henuz olusturulmadi.\nBir rota olusturarak baslayabilirsin.',
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return GeezCard(
      elevation: 1,
      child: Column(
        children: categories.map((cat) => PersonaBar(category: cat)).toList(),
      ),
    );
  }

  Widget _buildTripHistory(bool isDark, Color textColor) {
    // Trip history is still mock data — will be replaced in Sprint 3
    // when the trips table / repository is implemented.
    if (MockPassportData.tripHistory.isEmpty) {
      return GeezCard(
        elevation: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: GeezSpacing.lg),
            child: Text(
              'Henuz tamamlanmis bir gezin yok.',
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: MockPassportData.tripHistory.map((trip) {
        return _TripHistoryTile(
          trip: trip,
          isDark: isDark,
          textColor: textColor,
        );
      }).toList(),
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref, bool isDark, Color textColor) {
    final settingsItems = [
      _SettingItem(icon: Icons.language, title: 'Dil', trailing: 'Turkce'),
      _SettingItem(icon: Icons.palette, title: 'Tema', trailing: 'Light'),
      _SettingItem(icon: Icons.notifications_outlined, title: 'Bildirimler'),
      _SettingItem(icon: Icons.star, title: 'Premium', isPremium: true),
      _SettingItem(icon: Icons.person_outline, title: 'Hesap'),
      _SettingItem(
        icon: Icons.logout,
        title: 'Cikis Yap',
        isDestructive: true,
      ),
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
                onTap: item.isDestructive
                    ? () => _confirmSignOut(context, ref)
                    : () {},
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
                        color: item.isDestructive
                            ? GeezColors.error
                            : item.isPremium
                                ? GeezColors.discovery
                                : GeezColors.textSecondary,
                      ),
                      const SizedBox(width: GeezSpacing.md),
                      Expanded(
                        child: Text(
                          item.title,
                          style: GeezTypography.body.copyWith(
                            color: item.isDestructive ? GeezColors.error : textColor,
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
                      if (!item.isDestructive) ...[
                        const SizedBox(width: GeezSpacing.sm),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: GeezColors.textSecondary
                              .withValues(alpha: 0.5),
                        ),
                      ],
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

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(profileProvider.notifier).signOut();
      }
    });
  }
}

// ---------------------------------------------------------------------------
// Private helper widgets
// ---------------------------------------------------------------------------

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
                    '${trip.date} \u2022 ${trip.days} gun \u2022 ${trip.stops} durak',
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
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final bool isPremium;
  final bool isDestructive;
}
