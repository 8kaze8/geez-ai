import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/features/route/presentation/providers/route_detail_provider.dart';
import 'package:geez_ai/features/route/presentation/widgets/stop_card.dart';

class RouteDetailScreen extends ConsumerStatefulWidget {
  const RouteDetailScreen({super.key, required this.routeId});

  final String routeId;

  @override
  ConsumerState<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends ConsumerState<RouteDetailScreen> {
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asyncData = ref.watch(routeDetailProvider(widget.routeId));

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      body: asyncData.when(
        loading: () => _LoadingBody(isDark: isDark),
        error: (error, _) => _ErrorBody(
          isDark: isDark,
          message: 'Rota yüklenemedi. Lütfen tekrar deneyin.',
          onRetry: () =>
              ref.invalidate(routeDetailProvider(widget.routeId)),
        ),
        data: (data) => _RouteBody(
          routeId: widget.routeId,
          data: data,
          isDark: isDark,
          selectedDay: _selectedDay,
          onDaySelected: (day) => setState(() => _selectedDay = day),
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          backgroundColor:
              isDark ? GeezColors.surfaceDark : GeezColors.surface,
          leading: IconButton(
            icon: _CircleIcon(icon: Icons.arrow_back_rounded),
            onPressed: () => context.go(RoutePaths.home),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: _MapPlaceholder(isDark: isDark),
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(
              color: GeezColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.isDark,
    required this.message,
    required this.onRetry,
  });

  final bool isDark;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor:
              isDark ? GeezColors.surfaceDark : GeezColors.surface,
          leading: IconButton(
            icon: _CircleIcon(icon: Icons.arrow_back_rounded),
            onPressed: () => context.go(RoutePaths.home),
          ),
          title: Text(
            'Rota',
            style: GeezTypography.h3.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark
                  : GeezColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(GeezSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: GeezColors.error,
                ),
                const SizedBox(height: GeezSpacing.md),
                Text(
                  'Rota yüklenemedi',
                  style: GeezTypography.h3.copyWith(
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GeezSpacing.sm),
                Text(
                  message,
                  style: GeezTypography.bodySmall.copyWith(
                    color: isDark
                        ? GeezColors.textSecondaryDark
                        : GeezColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GeezSpacing.xl),
                FilledButton.icon(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: GeezColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Main route body (data loaded)
// ---------------------------------------------------------------------------

class _RouteBody extends ConsumerWidget {
  const _RouteBody({
    required this.routeId,
    required this.data,
    required this.isDark,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final String routeId;
  final RouteDetailData data;
  final bool isDark;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = data.days;
    final currentDayStops = data.stopsForDay(selectedDay);

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor:
                isDark ? GeezColors.surfaceDark : GeezColors.surface,
            leading: IconButton(
              icon: _CircleIcon(icon: Icons.arrow_back_rounded),
              onPressed: () => context.go(RoutePaths.home),
            ),
            actions: [
              IconButton(
                icon: _CircleIcon(icon: Icons.share_rounded),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _MapPlaceholder(isDark: isDark),
            ),
          ),

          // Route info header
          SliverToBoxAdapter(
            child: _RouteHeader(route: data.route, isDark: isDark),
          ),

          // Day tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _DayTabsDelegate(
              days: days,
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
              isDark: isDark,
            ),
          ),

          // Content for selected day
          if (currentDayStops.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyDayContent(
                dayNumber: selectedDay,
                isDark: isDark,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeezSpacing.md,
                vertical: GeezSpacing.sm,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final stop = currentDayStops[index];
                    final isLast = index == currentDayStops.length - 1;

                    // Travel connector data comes from the next stop.
                    final nextStop =
                        isLast ? null : currentDayStops[index + 1];

                    return StopCard(
                      stop: stop,
                      travelFromNextMin: nextStop?.travelFromPreviousMin,
                      travelModeFromNext: nextStop?.travelModeFromPrevious,
                      isLast: isLast,
                    );
                  },
                  childCount: currentDayStops.length,
                ),
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: GeezSpacing.xxl),
          ),
        ],
      ),

      // "Rotayı Tamamla" FAB
      floatingActionButton: currentDayStops.isNotEmpty &&
              data.route.status != 'completed'
          ? FloatingActionButton.extended(
              onPressed: () async {
                await ref
                    .read(routeDetailProvider(routeId).notifier)
                    .markAsCompleted();
                if (context.mounted) {
                  context.go(RoutePaths.home);
                }
              },
              backgroundColor: GeezColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.check_rounded),
              label: const Text(
                'Rotayı Tamamla',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Map placeholder (until real maps integration)
// ---------------------------------------------------------------------------

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1A2332),
                  const Color(0xFF2A3342),
                ]
              : [
                  const Color(0xFFD4E4F7),
                  const Color(0xFFE8EAF0),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative stop dots
          ..._buildMapDots(isDark),
          // Centre label
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_rounded,
                  size: 36,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 4),
                Text(
                  'Harita',
                  style: GeezTypography.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMapDots(bool isDark) {
    final dotColor = isDark
        ? GeezColors.primary.withValues(alpha: 0.5)
        : GeezColors.primary.withValues(alpha: 0.4);
    const positions = [
      Offset(0.25, 0.35),
      Offset(0.35, 0.45),
      Offset(0.45, 0.55),
      Offset(0.55, 0.42),
      Offset(0.65, 0.5),
      Offset(0.72, 0.6),
    ];

    return List.generate(positions.length, (index) {
      return Positioned(
        left: positions[index].dx * 300,
        top: positions[index].dy * 200,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Route header (title + badges)
// ---------------------------------------------------------------------------

class _RouteHeader extends StatelessWidget {
  const _RouteHeader({required this.route, required this.isDark});

  final RouteModel route;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GeezSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route.title,
            style: GeezTypography.h2.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark
                  : GeezColors.textPrimary,
            ),
          ),
          const SizedBox(height: GeezSpacing.sm),
          Wrap(
            spacing: GeezSpacing.md,
            runSpacing: GeezSpacing.xs,
            children: [
              _InfoBadge(
                icon: '📅',
                text: '${route.durationDays} gün',
                isDark: isDark,
              ),
              _InfoBadge(
                icon: '📍',
                text: '${route.city}, ${route.country}',
                isDark: isDark,
              ),
              _InfoBadge(
                icon: _transportIcon(route.transportMode),
                text: _transportLabel(route.transportMode),
                isDark: isDark,
              ),
              _InfoBadge(
                icon: '💰',
                text: _budgetLabel(route.budgetLevel),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _transportIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'walking':
      case 'yürüyüş':
        return '🚶';
      case 'transit':
      case 'toplu taşıma':
        return '🚌';
      case 'car':
      case 'araç':
        return '🚗';
      case 'cycling':
      case 'bisiklet':
        return '🚲';
      default:
        return '🚶';
    }
  }

  String _transportLabel(String mode) {
    switch (mode.toLowerCase()) {
      case 'walking':
        return 'Yürüyüş';
      case 'transit':
        return 'Toplu Taşıma';
      case 'car':
        return 'Araç';
      case 'cycling':
        return 'Bisiklet';
      default:
        return mode;
    }
  }

  String _budgetLabel(String level) {
    switch (level.toLowerCase()) {
      case 'budget':
        return 'Ekonomik';
      case 'mid':
      case 'moderate':
        return 'Orta';
      case 'luxury':
        return 'Lüks';
      default:
        return level;
    }
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  final String icon;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252528) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            text,
            style: GeezTypography.caption.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark
                  : GeezColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Day tab bar (pinned sliver)
// ---------------------------------------------------------------------------

class _DayTabsDelegate extends SliverPersistentHeaderDelegate {
  _DayTabsDelegate({
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
    required this.isDark,
  });

  final List<int> days;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final bool isDark;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDark ? GeezColors.backgroundDark : GeezColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: days.map((day) {
            final isSelected = day == selectedDay;
            return Padding(
              padding: const EdgeInsets.only(right: GeezSpacing.sm),
              child: GestureDetector(
                onTap: () => onDaySelected(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GeezColors.primary
                        : (isDark
                            ? GeezColors.surfaceDark
                            : GeezColors.surface),
                    borderRadius: BorderRadius.circular(GeezRadius.chip),
                    border: Border.all(
                      color: isSelected
                          ? GeezColors.primary
                          : (isDark
                              ? const Color(0xFF3A3A3E)
                              : const Color(0xFFE0E0E0)),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    'Gün $day',
                    style: GeezTypography.bodySmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? GeezColors.textPrimaryDark
                              : GeezColors.textPrimary),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _DayTabsDelegate oldDelegate) {
    return oldDelegate.selectedDay != selectedDay ||
        oldDelegate.days != days;
  }
}

// ---------------------------------------------------------------------------
// Empty day placeholder
// ---------------------------------------------------------------------------

class _EmptyDayContent extends StatelessWidget {
  const _EmptyDayContent({
    required this.dayNumber,
    required this.isDark,
  });

  final int dayNumber;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GeezSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: GeezSpacing.xxl),
          Icon(
            Icons.construction_rounded,
            size: 48,
            color: isDark
                ? GeezColors.textSecondaryDark
                : GeezColors.textSecondary,
          ),
          const SizedBox(height: GeezSpacing.md),
          Text(
            'Gün $dayNumber',
            style: GeezTypography.h3.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark
                  : GeezColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: GeezSpacing.sm),
          Text(
            'Bu günün detayları henüz hazır değil.\nGün 1\'i keşfetmeye devam et!',
            style: GeezTypography.bodySmall.copyWith(
              color: isDark
                  ? GeezColors.textSecondaryDark
                  : GeezColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable circle icon button decoration
// ---------------------------------------------------------------------------

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
