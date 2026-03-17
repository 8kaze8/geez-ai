import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';
import 'package:geez_ai/shared/widgets/geez_card.dart';
import 'package:geez_ai/features/passport/presentation/providers/passport_provider.dart';
import 'package:geez_ai/features/passport/presentation/widgets/collection_card.dart';
import 'package:geez_ai/features/passport/presentation/widgets/stamp_card.dart';
import 'package:geez_ai/features/passport/presentation/widgets/stats_row.dart';
import 'package:geez_ai/shared/widgets/shimmer_box.dart';

// ---------------------------------------------------------------------------
// Static collection definitions (data-backed in a future sprint)
// ---------------------------------------------------------------------------

final _staticCollections = [
  const CollectionEntry(
    icon: '\u{1F3DB}',
    title: 'Antik Dunya',
    current: 0,
    total: 7,
    color: GeezColors.history,
    comingSoon: true,
  ),
  const CollectionEntry(
    icon: '\u{1F355}',
    title: 'Food Capital',
    current: 0,
    total: 5,
    color: GeezColors.foodie,
    comingSoon: true,
  ),
  const CollectionEntry(
    icon: '\u{1F3D6}',
    title: 'Akdeniz',
    current: 0,
    total: 8,
    color: GeezColors.primary,
    comingSoon: true,
  ),
];

// ---------------------------------------------------------------------------
// PassportScreen
// ---------------------------------------------------------------------------

class PassportScreen extends ConsumerWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(passportProvider);

    return Scaffold(
      body: SafeArea(
        child: asyncState.when(
          loading: () => const _PassportShimmer(),
          error: (error, _) => _PassportError(
            message: error.toString(),
            onRetry: () => ref.invalidate(passportProvider),
          ),
          data: (state) => state.isEmpty
              ? _PassportEmpty(
                  onCreateRoute: () => context.go(RoutePaths.newRoute),
                )
              : _PassportContent(state: state),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content (stamps exist)
// ---------------------------------------------------------------------------

class _PassportContent extends ConsumerWidget {
  const _PassportContent({required this.state});

  final PassportState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return RefreshIndicator(
      color: GeezColors.primary,
      onRefresh: () => ref.read(passportProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            _buildSectionTitle('Damgalarım', isDark),
            const SizedBox(height: GeezSpacing.md),
            _buildStampGrid(),
            const SizedBox(height: GeezSpacing.lg),

            // Statistics Section
            _buildSectionTitle('İstatistikler', isDark),
            const SizedBox(height: GeezSpacing.md),
            _buildStatsCard(isDark),
            const SizedBox(height: GeezSpacing.lg),

            // Persona Bars Section
            if (state.personaLevels.isNotEmpty) ...[
              _buildSectionTitle('Seyahat Tarzım', isDark),
              const SizedBox(height: GeezSpacing.md),
              _buildPersonaBars(isDark),
              const SizedBox(height: GeezSpacing.lg),
            ],

            // Collections Section
            _buildSectionTitle('Koleksiyonlar', isDark),
            const SizedBox(height: GeezSpacing.md),
            _buildCollections(),
            const SizedBox(height: GeezSpacing.lg),

            // Share Button
            GeezButton(
              label: 'Pasaportumu Paylaş',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yakinda!')),
              ),
              icon: Icons.share,
              width: double.infinity,
            ),
            const SizedBox(height: GeezSpacing.lg),
          ],
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
            Container(
              width: 120,
              height: 1,
              color: GeezColors.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: GeezSpacing.md),
            Text(
              state.displayName,
              style: GeezTypography.h3.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GeezSpacing.xs),
            Text(
              state.personaTitle,
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
            color: isDark
                ? GeezColors.textPrimaryDark
                : GeezColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStampGrid() {
    // Show real stamps + locked slots to always fill a multiple of 3.
    const minSlots = 6;
    final stampCount = state.stamps.length;
    final lockedCount =
        (stampCount < minSlots ? minSlots - stampCount : 0);
    final totalItems = stampCount + lockedCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: GeezSpacing.sm,
        mainAxisSpacing: GeezSpacing.sm,
        childAspectRatio: 0.85,
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < stampCount) {
          return StampCard(stamp: state.stamps[index]);
        }
        return const StampCard.locked();
      },
    );
  }

  Widget _buildStatsCard(bool isDark) {
    return GeezCard(
      elevation: 1,
      child: Column(
        children: [
          StatsRow(stats: state.stats),
          const SizedBox(height: GeezSpacing.lg),
          // Goal progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.goalLabel,
                style: GeezTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? GeezColors.textPrimaryDark
                      : GeezColors.textPrimary,
                ),
              ),
              Text(
                '${(state.goalProgress * 100).toInt()}%',
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
              value: state.goalProgress,
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

  Widget _buildPersonaBars(bool isDark) {
    return GeezCard(
      elevation: 1,
      child: Column(
        children: state.personaLevels
            .map((level) => _PersonaBar(level: level, isDark: isDark))
            .toList(),
      ),
    );
  }

  Widget _buildCollections() {
    return Column(
      children: _staticCollections
          .map((c) => CollectionCard(collection: c))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Persona bar row
// ---------------------------------------------------------------------------

class _PersonaBar extends StatelessWidget {
  const _PersonaBar({required this.level, required this.isDark});

  final PersonaLevel level;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GeezSpacing.md),
      child: Row(
        children: [
          Text(level.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: GeezSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      level.name,
                      style: GeezTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? GeezColors.textPrimaryDark
                            : GeezColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Lv ${level.level}',
                      style: GeezTypography.caption.copyWith(
                        color: level.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: level.progress,
                    backgroundColor: level.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(level.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading shimmer
// ---------------------------------------------------------------------------

class _PassportShimmer extends StatelessWidget {
  const _PassportShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Center(child: ShimmerBox(width: 200, height: 32, color: baseColor)),
          const SizedBox(height: GeezSpacing.lg),
          // Cover shimmer
          ShimmerBox(width: double.infinity, height: 220, color: baseColor),
          const SizedBox(height: GeezSpacing.lg),
          ShimmerBox(width: 120, height: 20, color: baseColor),
          const SizedBox(height: GeezSpacing.md),
          // Stamp grid shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: GeezSpacing.sm,
              mainAxisSpacing: GeezSpacing.sm,
              childAspectRatio: 0.85,
            ),
            itemCount: 6,
            itemBuilder: (_, _) =>
                ShimmerBox(width: double.infinity, height: double.infinity, color: baseColor),
          ),
          const SizedBox(height: GeezSpacing.lg),
          ShimmerBox(width: double.infinity, height: 100, color: baseColor),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _PassportError extends StatelessWidget {
  const _PassportError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GeezSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: GeezColors.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: GeezSpacing.md),
            Text(
              'Bir hata oluştu',
              style: GeezTypography.h3.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.sm),
            Text(
              'Pasaport verisi yüklenemedi. Lütfen tekrar deneyin.',
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
// Empty state (no trips yet)
// ---------------------------------------------------------------------------

class _PassportEmpty extends StatelessWidget {
  const _PassportEmpty({required this.onCreateRoute});

  final VoidCallback onCreateRoute;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GeezSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '\u{1F6C2}',
              style: TextStyle(fontSize: 72),
            ),
            const SizedBox(height: GeezSpacing.lg),
            Text(
              'Pasaportunuz Boş',
              style: GeezTypography.h2.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.sm),
            Text(
              'Henüz bir gezi yapmadınız!\nİlk rotanızı oluşturun ve damganızı kazanın.',
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.xl),
            GeezButton(
              label: 'İlk Rotamı Oluştur',
              onTap: onCreateRoute,
              icon: Icons.explore,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
