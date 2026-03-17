import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/home/presentation/providers/home_provider.dart';
import 'package:geez_ai/features/home/presentation/widgets/active_route_card.dart';
import 'package:geez_ai/features/home/presentation/widgets/discovery_bar.dart';
import 'package:geez_ai/features/home/presentation/widgets/suggestion_card.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/shared/widgets/email_confirm_banner.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';
import 'package:geez_ai/shared/widgets/geez_card.dart';
import 'package:geez_ai/shared/widgets/shimmer_box.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? GeezColors.backgroundDark : GeezColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EmailConfirmBanner(),
            Expanded(
              child: ref.watch(homeProvider).when(
                    loading: () => const _HomeLoadingState(),
                    error: (error, _) => _HomeErrorState(
                      onRetry: () => ref.read(homeProvider.notifier).refresh(),
                    ),
                    data: (data) => _HomeContent(data: data, isDark: isDark),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading state
// ---------------------------------------------------------------------------

class _HomeLoadingState extends StatelessWidget {
  const _HomeLoadingState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerBase = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.grey.shade200;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              GeezSpacing.lg,
              GeezSpacing.lg,
              GeezSpacing.lg,
              GeezSpacing.md,
            ),
            child: Row(
              children: [
                ShimmerBox(width: 44, height: 44, radius: 22, color: shimmerBase),
                const SizedBox(width: GeezSpacing.sm + 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(
                          width: 140, height: 16, radius: 8, color: shimmerBase),
                      const SizedBox(height: 6),
                      ShimmerBox(
                          width: 200, height: 12, radius: 6, color: shimmerBase),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
            child: ShimmerBox(
                width: double.infinity, height: 88, radius: 12, color: shimmerBase),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              GeezSpacing.lg,
              GeezSpacing.lg + 4,
              GeezSpacing.lg,
              GeezSpacing.sm,
            ),
            child: ShimmerBox(
                width: 120, height: 20, radius: 8, color: shimmerBase),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
            child: ShimmerBox(
                width: double.infinity, height: 130, radius: 16, color: shimmerBase),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: GeezSpacing.xxl + GeezSpacing.xl),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _HomeErrorState extends StatelessWidget {
  const _HomeErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GeezSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('\u{1F4F5}', style: TextStyle(fontSize: 48)),
            const SizedBox(height: GeezSpacing.md),
            Text(
              'Bir sorun oluştu',
              style: GeezTypography.h3.copyWith(color: textColor),
            ),
            const SizedBox(height: GeezSpacing.sm),
            Text(
              'Veriler yüklenemedi. Lütfen tekrar dene.',
              style: GeezTypography.bodySmall.copyWith(color: mutedColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.lg),
            GeezButton(
              label: 'Tekrar Dene',
              onTap: onRetry,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded content
// ---------------------------------------------------------------------------

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.data, required this.isDark});

  final HomeData data;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return CustomScrollView(
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
              displayName: data.displayName,
              textColor: textColor,
              mutedColor: mutedColor,
              isDark: isDark,
            ),
          ),
        ),

        // --- Discovery Score Bar ---
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
            child: DiscoveryBar(
              score: data.discoveryScore,
              tier: data.tierLabel,
              nextTier: data.nextTierLabel,
              pointsToNext: data.pointsToNextTier,
              progress: data.tierProgress,
            ),
          ),
        ),

        // --- New user welcome OR active route ---
        if (data.isNewUser) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GeezSpacing.lg,
                GeezSpacing.lg + 4,
                GeezSpacing.lg,
                GeezSpacing.sm,
              ),
              child: _WelcomeBanner(isDark: isDark),
            ),
          ),
        ] else ...[
          // Section: Aktif Rota
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
              padding:
                  const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
              child: data.activeRoute != null
                  ? ActiveRouteCard(
                      route: data.activeRoute!,
                      onContinue: () => context.go(
                        RoutePaths.routeDetailPath(data.activeRoute!.id),
                      ),
                    )
                  : _NoActiveRouteCard(isDark: isDark),
            ),
          ),
        ],

        // --- Section: Sana Özel ---
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              GeezSpacing.lg,
              GeezSpacing.lg + 4,
              GeezSpacing.lg,
              GeezSpacing.sm,
            ),
            child: _SectionHeader(
              title: 'Sana Özel',
              textColor: textColor,
              trailing: Text(
                'Tümü',
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
              itemCount: kSampleSuggestions.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: GeezSpacing.md),
              itemBuilder: (context, index) {
                return SuggestionCard(
                  suggestion: kSampleSuggestions[index],
                  onPlan: () => context.go(RoutePaths.newRoute),
                );
              },
            ),
          ),
        ),

        // --- Section: Son Rotalar ---
        // Always shown for returning users (non-new), with an empty state
        // when no completed routes exist yet.
        if (!data.isNewUser) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GeezSpacing.lg,
                GeezSpacing.lg + 4,
                GeezSpacing.lg,
                GeezSpacing.sm,
              ),
              child: _SectionHeader(
                title: 'Son Rotalar',
                textColor: textColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeezSpacing.lg,
              ),
              child: data.recentRoutes.isEmpty
                  ? _NoRecentRoutesCard(isDark: isDark)
                  : GeezCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (int i = 0;
                              i < data.recentRoutes.length;
                              i++) ...[
                            _RecentRouteTile(
                              route: data.recentRoutes[i],
                              isDark: isDark,
                            ),
                            if (i < data.recentRoutes.length - 1)
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
        ],

        // Bottom spacing for nav bar
        const SliverToBoxAdapter(
          child: SizedBox(height: GeezSpacing.xxl + GeezSpacing.xl),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.displayName,
    required this.textColor,
    required this.mutedColor,
    required this.isDark,
  });

  final String displayName;
  final Color textColor;
  final Color mutedColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

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
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
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
                'Merhaba, $displayName!',
                style: GeezTypography.h3.copyWith(color: textColor),
              ),
              Text(
                'Bugün nereyi keşfedeceksin?',
                style: GeezTypography.caption.copyWith(color: mutedColor),
              ),
            ],
          ),
        ),

        // Notification bell
        _IconButton(
          icon: Icons.notifications_outlined,
          isDark: isDark,
          badgeCount: 0,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bildirimler yakında!')),
            );
          },
        ),
        const SizedBox(width: GeezSpacing.sm),

        // Settings
        _IconButton(
          icon: Icons.settings_outlined,
          isDark: isDark,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ayarlar yakında!')),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Icon button with optional badge
// ---------------------------------------------------------------------------

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
    final bgColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100;
    final iconColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

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

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

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
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Welcome banner (new users)
// ---------------------------------------------------------------------------

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return GeezCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('\u{1F30D}', style: TextStyle(fontSize: 36)),
          const SizedBox(height: GeezSpacing.sm),
          Text(
            'İlk rotanı oluştur!',
            style: GeezTypography.h3.copyWith(color: textColor),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            'Birkaç soruya cevap ver, yapay zeka sana özel bir rota hazırlasın.',
            style: GeezTypography.bodySmall.copyWith(color: mutedColor),
          ),
          const SizedBox(height: GeezSpacing.md),
          GeezButton(
            label: 'Rota Oluştur',
            onTap: () => context.go(RoutePaths.newRoute),
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// No active route card
// ---------------------------------------------------------------------------

class _NoActiveRouteCard extends StatelessWidget {
  const _NoActiveRouteCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return GeezCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GeezSpacing.sm),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.route_outlined,
              size: 24,
              color: GeezColors.primary,
            ),
          ),
          const SizedBox(width: GeezSpacing.sm + 4),
          Expanded(
            child: Text(
              'Aktif bir rotanız yok.',
              style: GeezTypography.bodySmall.copyWith(color: mutedColor),
            ),
          ),
          const SizedBox(width: GeezSpacing.sm),
          // Quick action: start a new route
          Material(
            color: GeezColors.primary,
            borderRadius: BorderRadius.circular(GeezRadius.button),
            child: InkWell(
              onTap: () => context.go(RoutePaths.newRoute),
              borderRadius: BorderRadius.circular(GeezRadius.button),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.md,
                  vertical: GeezSpacing.sm,
                ),
                child: Text(
                  'Yeni Rota',
                  style: GeezTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

// ---------------------------------------------------------------------------
// No recent routes empty state
// ---------------------------------------------------------------------------

class _NoRecentRoutesCard extends StatelessWidget {
  const _NoRecentRoutesCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return GeezCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GeezSpacing.sm),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 24,
              color: GeezColors.primary,
            ),
          ),
          const SizedBox(width: GeezSpacing.sm + 4),
          Expanded(
            child: Text(
              'Henüz tamamlanmış rotanız yok.',
              style: GeezTypography.bodySmall.copyWith(color: mutedColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent route tile
// ---------------------------------------------------------------------------

class _RecentRouteTile extends StatelessWidget {
  const _RecentRouteTile({
    required this.route,
    required this.isDark,
  });

  final RouteModel route;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return InkWell(
      onTap: () => context.go(RoutePaths.routeDetailPath(route.id)),
      borderRadius: BorderRadius.circular(GeezRadius.card),
      child: Padding(
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
            child: const Center(
              child: Icon(
                Icons.place_outlined,
                size: 20,
                color: GeezColors.primary,
              ),
            ),
          ),
          const SizedBox(width: GeezSpacing.sm + 4),

          // Route name + city
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.title,
                  style: GeezTypography.bodySmall.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${route.city}, ${route.country}',
                  style: GeezTypography.caption.copyWith(
                    color: isDark
                        ? GeezColors.textSecondaryDark
                        : GeezColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Completed badge + chevron
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  'Tamamlandı',
                  style: GeezTypography.caption.copyWith(
                    color: GeezColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: GeezSpacing.xs),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark
                    ? GeezColors.textSecondaryDark
                    : GeezColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
