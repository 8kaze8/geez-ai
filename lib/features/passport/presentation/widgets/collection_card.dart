import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/mock_passport_data.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key, required this.collection});

  final PassportCollection collection;

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
          // Icon
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
          // Title + Progress
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
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: collection.progress,
                    backgroundColor: collection.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(collection.color),
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
