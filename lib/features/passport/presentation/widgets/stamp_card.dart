import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/mock_passport_data.dart';

class StampCard extends StatelessWidget {
  const StampCard({super.key, required this.stamp});

  final PassportStamp stamp;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!stamp.isCompleted) {
      return _buildLockedStamp(isDark);
    }
    return _buildCompletedStamp(isDark);
  }

  Widget _buildCompletedStamp(bool isDark) {
    final bgColor = isDark
        ? GeezColors.surfaceDark
        : GeezColors.surface;

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
            stamp.flag,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            stamp.cityCode,
            style: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 14,
                color: GeezColors.success,
              ),
              const SizedBox(width: 3),
              Text(
                stamp.date,
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
        color: isDark
            ? Colors.grey[800]
            : Colors.grey[100],
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
            stamp.flag,
            style: TextStyle(
              fontSize: 28,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: GeezSpacing.xs),
          Text(
            stamp.cityCode,
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
}
