import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/features/route/presentation/providers/routes_list_provider.dart';
import 'package:geez_ai/features/explore/presentation/widgets/route_history_card.dart';

/// Route History screen — repurposed from the placeholder Explore screen.
///
/// Shows the current user's past generated routes ordered newest-first.
/// Pull-to-refresh supported. Empty state guides the user to start a new
/// route via the Chat tab.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asyncRoutes = ref.watch(routesListProvider);

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      body: asyncRoutes.when(
        loading: () => _LoadingBody(isDark: isDark),
        error: (error, _) => _ErrorBody(
          isDark: isDark,
          onRetry: () => ref.invalidate(routesListProvider),
        ),
        data: (routes) => routes.isEmpty
            ? _EmptyBody(isDark: isDark)
            : _HistoryBody(
                isDark: isDark,
                routes: routes,
                onRefresh: () =>
                    ref.read(routesListProvider.notifier).refresh(),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading body
// ---------------------------------------------------------------------------

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final shimmerBase = isDark
        ? GeezColors.surfaceElevatedDark
        : GeezColors.borderLight;
    final titleColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScreenHeader(isDark: isDark, titleColor: titleColor),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                GeezSpacing.md,
                GeezSpacing.sm,
                GeezSpacing.md,
                GeezSpacing.xl,
              ),
              itemCount: 4,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: GeezSpacing.md),
              itemBuilder: (_, __) => _ShimmerCard(color: shimmerBase),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.isDark,
    required this.onRetry,
  });

  final bool isDark;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScreenHeader(isDark: isDark, titleColor: textColor),
          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: GeezSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 52,
                      color: GeezColors.error,
                    ),
                    const SizedBox(height: GeezSpacing.md),
                    Text(
                      'Yüklenemedi',
                      style: GeezTypography.h3.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: GeezSpacing.sm),
                    Text(
                      'Rotalarınız yüklenirken bir hata oluştu. Lütfen tekrar deneyin.',
                      style: GeezTypography.bodySmall.copyWith(
                        color: mutedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: GeezSpacing.xl),
                    FilledButton.icon(
                      onPressed: onRetry,
                      style: FilledButton.styleFrom(
                        backgroundColor: GeezColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: GeezSpacing.lg,
                          vertical: GeezSpacing.sm,
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Tekrar Dene'),
                    ),
                  ],
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
// Empty body
// ---------------------------------------------------------------------------

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScreenHeader(isDark: isDark, titleColor: textColor),
          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: GeezSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: GeezColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        size: 38,
                        color: GeezColors.primary,
                      ),
                    ),
                    const SizedBox(height: GeezSpacing.lg),
                    Text(
                      'Henüz rota oluşturmadınız',
                      style: GeezTypography.h3.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: GeezSpacing.sm),
                    Text(
                      'AI ile kişiselleştirilmiş gezi rotanızı\noluşturmaya başlayın.',
                      style: GeezTypography.bodySmall.copyWith(
                        color: mutedColor,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: GeezSpacing.xl),
                    FilledButton(
                      onPressed: () => context.go(RoutePaths.newRoute),
                      style: FilledButton.styleFrom(
                        backgroundColor: GeezColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            GeezRadius.button,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Rota Oluştur',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
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
// History body — non-empty list with pull-to-refresh
// ---------------------------------------------------------------------------

class _HistoryBody extends StatelessWidget {
  const _HistoryBody({
    required this.isDark,
    required this.routes,
    required this.onRefresh,
  });

  final bool isDark;
  final List<RouteModel> routes;

  /// Called when the user triggers a pull-to-refresh gesture.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScreenHeader(isDark: isDark, titleColor: textColor),
          Expanded(
            child: RefreshIndicator(
              color: GeezColors.primary,
              backgroundColor:
                  isDark ? GeezColors.surfaceDark : GeezColors.surface,
              onRefresh: onRefresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  GeezSpacing.md,
                  GeezSpacing.xs,
                  GeezSpacing.md,
                  GeezSpacing.xxl,
                ),
                itemCount: routes.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: GeezSpacing.md),
                itemBuilder: (context, index) {
                  final route = routes[index];
                  return RouteHistoryCard(
                    route: route,
                    onTap: () =>
                        context.go(RoutePaths.routeDetailPath(route.id)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared screen header
// ---------------------------------------------------------------------------

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({
    required this.isDark,
    required this.titleColor,
  });

  final bool isDark;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GeezSpacing.md,
        GeezSpacing.lg,
        GeezSpacing.md,
        GeezSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rotalarım',
            style: GeezTypography.h2.copyWith(color: titleColor),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            'Geçmiş seyahat planlarınız',
            style: GeezTypography.bodySmall.copyWith(color: mutedColor),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer placeholder card (loading state)
// ---------------------------------------------------------------------------

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? GeezColors.surfaceVariantDark
        : GeezColors.borderLight;

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(GeezRadius.card),
        border: isDark ? Border.all(color: borderColor) : null,
      ),
    );
  }
}
