import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/route/domain/mock_route_data.dart';
import 'package:geez_ai/features/route/presentation/widgets/stop_card.dart';

class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({super.key});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final route = mockIstanbulRoute;
    final currentDay = route.days[_selectedDay];

    return Scaffold(
      backgroundColor: isDark ? GeezColors.backgroundDark : GeezColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor:
                isDark ? GeezColors.surfaceDark : GeezColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () => context.go('/'),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _MapPlaceholder(isDark: isDark),
            ),
          ),

          // Route info header
          SliverToBoxAdapter(
            child: _RouteHeader(route: route, isDark: isDark),
          ),

          // Day tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _DayTabsDelegate(
              days: route.days,
              selectedDay: _selectedDay,
              onDaySelected: (index) => setState(() => _selectedDay = index),
              isDark: isDark,
            ),
          ),

          // Day content
          if (currentDay.stops.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyDayContent(day: currentDay, isDark: isDark),
            )
          else ...[
            // Day subtitle
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  GeezSpacing.md,
                  GeezSpacing.md,
                  GeezSpacing.md,
                  GeezSpacing.sm,
                ),
                child: Text(
                  '"${currentDay.subtitle}"',
                  style: GeezTypography.bodySmall.copyWith(
                    color: isDark
                        ? GeezColors.textSecondaryDark
                        : GeezColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            // Stop cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeezSpacing.md,
                vertical: GeezSpacing.sm,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final stop = currentDay.stops[index];
                    final isLast = index == currentDay.stops.length - 1;
                    final travelSegment = !isLast &&
                            index < currentDay.travelSegments.length
                        ? currentDay.travelSegments[index]
                        : null;

                    return StopCard(
                      stop: stop,
                      travelSegment: travelSegment,
                      isLast: isLast,
                    );
                  },
                  childCount: currentDay.stops.length,
                ),
              ),
            ),
          ],

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: GeezSpacing.xxl),
          ),
        ],
      ),

      // Start route FAB
      floatingActionButton: currentDay.stops.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: GeezColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Rotayı Başlat',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFE8EAF0),
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
          // Fake map dots
          ..._buildMapDots(isDark),
          // Center label
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
    final positions = [
      const Offset(0.25, 0.35),
      const Offset(0.35, 0.45),
      const Offset(0.45, 0.55),
      const Offset(0.55, 0.42),
      const Offset(0.65, 0.5),
      const Offset(0.72, 0.6),
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

class _RouteHeader extends StatelessWidget {
  const _RouteHeader({required this.route, required this.isDark});

  final MockRoute route;
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
                  text: '${route.totalDays} gün',
                  isDark: isDark),
              _InfoBadge(
                  icon: '📍',
                  text: '${route.totalStops} durak',
                  isDark: isDark),
              _InfoBadge(
                  icon: '🚶', text: route.transportMode, isDark: isDark),
              _InfoBadge(
                  icon: '💰',
                  text: route.estimatedBudget,
                  isDark: isDark),
            ],
          ),
        ],
      ),
    );
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

class _DayTabsDelegate extends SliverPersistentHeaderDelegate {
  _DayTabsDelegate({
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
    required this.isDark,
  });

  final List<RouteDay> days;
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
      child: Row(
        children: List.generate(days.length, (index) {
          final isSelected = index == selectedDay;
          final day = days[index];

          return Padding(
            padding: const EdgeInsets.only(right: GeezSpacing.sm),
            child: GestureDetector(
              onTap: () => onDaySelected(index),
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
                  'Gün ${day.dayNumber}',
                  style: GeezTypography.bodySmall.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? GeezColors.textPrimaryDark
                            : GeezColors.textPrimary),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _DayTabsDelegate oldDelegate) {
    return oldDelegate.selectedDay != selectedDay;
  }
}

class _EmptyDayContent extends StatelessWidget {
  const _EmptyDayContent({required this.day, required this.isDark});

  final RouteDay day;
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
            day.title,
            style: GeezTypography.h3.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark
                  : GeezColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: GeezSpacing.sm),
          Text(
            'Bu günün detayları yakında eklenecek.\nŞimdilik Gün 1\'i keşfet!',
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
