import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/passport/domain/passport_stamp_model.dart';

/// Displays a single passport stamp.
///
/// Pass [stamp] from the real [PassportStampModel]. For locked (empty) slots
/// use [StampCard.locked].
class StampCard extends StatelessWidget {
  const StampCard({super.key, required this.stamp});

  const StampCard.locked({super.key}) : stamp = null;

  final PassportStampModel? stamp;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (stamp == null) return _buildLockedStamp(isDark);
    return _buildCompletedStamp(isDark, stamp!);
  }

  Widget _buildCompletedStamp(bool isDark, PassportStampModel s) {
    final bgColor = isDark ? GeezColors.surfaceDark : GeezColors.surface;
    final countryLabel = (s.countryCode ?? '').toUpperCase();
    // Format date as M/YY from the stamp_date yyyy-MM-dd string.
    final dateLabel = _formatDate(s.stampDate);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(GeezRadius.stamp + 4),
        border: Border.all(
          color: GeezColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GeezColors.primary.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: GeezColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.location_on_rounded,
                size: 20,
                color: GeezColors.primary,
              ),
            ),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            _cityCode(s.city),
            style: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          if (countryLabel.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              countryLabel,
              style: GeezTypography.caption.copyWith(
                color: GeezColors.textSecondary,
                fontSize: 9,
                letterSpacing: 1.0,
              ),
            ),
          ],
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 14,
                color: GeezColors.success,
              ),
              const SizedBox(width: 3),
              Text(
                dateLabel,
                style: GeezTypography.caption.copyWith(
                  color: GeezColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLockedStamp(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(GeezRadius.stamp + 4),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline_rounded,
            size: 28,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            '???',
            style: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Icon(
            Icons.lock,
            size: 14,
            color: Colors.grey.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the first three characters of [city] uppercased — acts as the
  /// IATA-style city code shown on the stamp (e.g. "Istanbul" → "IST").
  static String _cityCode(String city) =>
      city.length >= 3 ? city.substring(0, 3).toUpperCase() : city.toUpperCase();

  /// Formats a yyyy-MM-dd date string to "M/YY" (e.g. "2026-03-15" → "3/26").
  static String _formatDate(String stampDate) {
    try {
      final parts = stampDate.split('-');
      if (parts.length < 3) return stampDate;
      final month = int.parse(parts[1]);
      // parts[0] is the 4-digit year, e.g. "2026" → "26"
      final yearStr = parts[0];
      final year = yearStr.length >= 4 ? yearStr.substring(2) : yearStr;
      return '$month/$year';
    } catch (_) {
      return stampDate;
    }
  }
}
