import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';

/// A self-contained data class for a collection card entry.
///
/// Collections are not yet backed by real Supabase data — they use static
/// definitions with a "Yakinda" badge until the backend supports them.
class CollectionEntry {
  const CollectionEntry({
    required this.icon,
    required this.title,
    required this.current,
    required this.total,
    required this.color,
    this.comingSoon = false,
  });

  final String icon;
  final String title;
  final int current;
  final int total;
  final Color color;
  final bool comingSoon;

  double get progress => total > 0 ? current / total : 0.0;
}

/// Card that displays a single collection with a progress bar.
///
/// When [collection.comingSoon] is true a "Yakinda" badge is shown and the
/// progress bar is replaced with a placeholder.
class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key, required this.collection});

  final CollectionEntry collection;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? GeezColors.surfaceDark : GeezColors.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: GeezSpacing.sm),
      padding: const EdgeInsets.all(GeezSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(GeezRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: collection.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              collection.icon,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: GeezSpacing.md),
          // Title + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      collection.title,
                      style: GeezTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? GeezColors.textPrimaryDark
                            : GeezColors.textPrimary,
                      ),
                    ),
                    if (collection.comingSoon)
                      const _YakindaBadge()
                    else
                      Text(
                        '${collection.current}/${collection.total}',
                        style: GeezTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: collection.color,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: GeezSpacing.sm),
                if (collection.comingSoon)
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: collection.progress,
                      backgroundColor:
                          collection.color.withValues(alpha: 0.12),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(collection.color),
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

class _YakindaBadge extends StatelessWidget {
  const _YakindaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: GeezColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(GeezRadius.chip),
      ),
      child: Text(
        'Yakinda',
        style: GeezTypography.caption.copyWith(
          color: GeezColors.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
