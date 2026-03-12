import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../shared/widgets/geez_card.dart';
import '../../domain/mock_data.dart';
import '../widgets/active_route_card.dart';
import '../widgets/discovery_bar.dart';
import '../widgets/suggestion_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? GeezColors.backgroundDark : GeezColors.background;
    final textColor = isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor = isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- Header ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  GeezSpacing.lg,
                  GeezSpacing.lg,
                  GeezSpacing.lg,
                  GeezSpacing.md,
                ),
                child: _Header(
                  textColor: textColor,
                  mutedColor: mutedColor,
                  isDark: isDark,
                ),
              ),
            ),

            // --- Discovery Score Bar ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.lg,
                ),
                child: const DiscoveryBar(data: sampleDiscoveryScore),
              ),
            ),

            // --- Section: Aktif Rota ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  GeezSpacing.lg,
                  GeezSpacing.lg + 4,
                  GeezSpacing.lg,
                  GeezSpacing.sm,
                ),
                child: _SectionHeader(
                  title: 'Aktif Rota',
                  textColor: textColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.lg,
                ),
                child: ActiveRouteCard(
                  route: sampleActiveRoute,
                  onContinue: () {},
                ),
              ),
            ),

            // --- Section: Sana Ozel ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  GeezSpacing.lg,
                  GeezSpacing.lg + 4,
                  GeezSpacing.lg,
                  GeezSpacing.sm,
                ),
                child: _SectionHeader(
                  title: 'Sana Ozel',
                  textColor: textColor,
                  trailing: Text(
                    'Tumu',
                    style: GeezTypography.bodySmall.copyWith(
                      color: GeezColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: GeezSpacing.lg,
                  ),
                  itemCount: sampleSuggestions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: GeezSpacing.md),
                  itemBuilder: (context, index) {
                    return SuggestionCard(
                      suggestion: sampleSuggestions[index],
                      onPlan: () {},
                    );
                  },
                ),
              ),
            ),

            // --- Section: Son Kesifler ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  GeezSpacing.lg,
                  GeezSpacing.lg + 4,
                  GeezSpacing.lg,
                  GeezSpacing.sm,
                ),
                child: _SectionHeader(
                  title: 'Son Kesifler',
                  textColor: textColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.lg,
                ),
                child: GeezCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (int i = 0; i < sampleDiscoveries.length; i++) ...[
                        _DiscoveryTile(
                          discovery: sampleDiscoveries[i],
                          isDark: isDark,
                        ),
                        if (i < sampleDiscoveries.length - 1)
                          Divider(
                            height: 1,
                            indent: GeezSpacing.md,
                            endIndent: GeezSpacing.md,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.grey.shade100,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Bottom spacing for nav bar
            const SliverToBoxAdapter(
              child: SizedBox(height: GeezSpacing.xxl + GeezSpacing.xl),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Header ---
class _Header extends StatelessWidget {
  const _Header({
    required this.textColor,
    required this.mutedColor,
    required this.isDark,
  });

  final Color textColor;
  final Color mutedColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [GeezColors.primary, GeezColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(GeezRadius.avatar),
          ),
          child: const Center(
            child: Text(
              'K',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: GeezSpacing.sm + 4),

        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merhaba, Kaze!',
                style: GeezTypography.h3.copyWith(
                  color: textColor,
                ),
              ),
              Text(
                'Bugun nereyi kesfedeceksin?',
                style: GeezTypography.caption.copyWith(
                  color: mutedColor,
                ),
              ),
            ],
          ),
        ),

        // Notification bell
        _IconButton(
          icon: Icons.notifications_outlined,
          isDark: isDark,
          badgeCount: 2,
          onTap: () {},
        ),
        const SizedBox(width: GeezSpacing.sm),

        // Settings
        _IconButton(
          icon: Icons.settings_outlined,
          isDark: isDark,
          onTap: () {},
        ),
      ],
    );
  }
}

// --- Icon Button with optional badge ---
class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.isDark,
    this.onTap,
    this.badgeCount,
  });

  final IconData icon;
  final bool isDark;
  final VoidCallback? onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.grey.shade100;
    final iconColor = isDark
        ? GeezColors.textPrimaryDark
        : GeezColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: GeezColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// --- Section Header ---
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.textColor,
    this.trailing,
  });

  final String title;
  final Color textColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: GeezColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: GeezSpacing.sm),
            Text(
              title,
              style: GeezTypography.h3.copyWith(
                color: textColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing!,  // ignore: use_null_aware_elements
      ],
    );
  }
}

// --- Discovery Tile ---
class _DiscoveryTile extends StatelessWidget {
  const _DiscoveryTile({
    required this.discovery,
    required this.isDark,
  });

  final MockDiscovery discovery;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.sm + 4,
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : GeezColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                discovery.icon,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: GeezSpacing.sm + 4),

          // Place name
          Expanded(
            child: Text(
              discovery.placeName,
              style: GeezTypography.bodySmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Score or rating
          if (discovery.rating != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: GeezColors.warning,
                  size: 16,
                ),
                const SizedBox(width: 2),
                Text(
                  '${discovery.rating}',
                  style: GeezTypography.bodySmall.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            )
          else
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
                '+${discovery.score}',
                style: GeezTypography.caption.copyWith(
                  color: GeezColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
