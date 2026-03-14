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
    final flag = _countryCodeToFlag(s.countryCode);
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
          Text(
            flag,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            _cityCode(s.city),
            style: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
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
          Text(
            '\u{2753}',
            style: TextStyle(
              fontSize: 28,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
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

  /// Converts an ISO 3166-1 alpha-2 country code (e.g. "TR") to a flag emoji.
  /// Falls back to a globe emoji when the code is null or invalid.
  static String _countryCodeToFlag(String? code) {
    if (code == null || code.length != 2) return '\u{1F310}';
    final upper = code.toUpperCase();
    final first = upper.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final second = upper.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(first) + String.fromCharCode(second);
  }

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
