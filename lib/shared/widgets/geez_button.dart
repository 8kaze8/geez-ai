import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

enum GeezButtonVariant { primary, secondary, text }

class GeezButton extends StatelessWidget {
  const GeezButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = GeezButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
  });

  final String label;
  final VoidCallback? onTap;
  final GeezButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;

  bool get _isInteractive => !isLoading && !isDisabled && onTap != null;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return SizedBox(
      width: width,
      child: switch (variant) {
        GeezButtonVariant.primary => _buildPrimary(isDark),
        GeezButtonVariant.secondary => _buildSecondary(isDark),
        GeezButtonVariant.text => _buildText(isDark),
      },
    );
  }

  Widget _buildPrimary(bool isDark) {
    return ElevatedButton(
      onPressed: _isInteractive ? onTap : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: GeezColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: GeezColors.primary.withValues(alpha: 0.4),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(
          horizontal: GeezSpacing.lg,
          vertical: GeezSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GeezRadius.button),
        ),
        textStyle: GeezTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
      child: _buildContent(Colors.white),
    );
  }

  Widget _buildSecondary(bool isDark) {
    final borderColor =
        isDisabled ? GeezColors.primary.withValues(alpha: 0.3) : GeezColors.primary;
    final textColor =
        isDisabled ? GeezColors.primary.withValues(alpha: 0.5) : GeezColors.primary;

    return OutlinedButton(
      onPressed: _isInteractive ? onTap : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: GeezColors.primary,
        disabledForegroundColor: GeezColors.primary.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(
          horizontal: GeezSpacing.lg,
          vertical: GeezSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GeezRadius.button),
        ),
        side: BorderSide(color: borderColor, width: 1.5),
        textStyle: GeezTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
      child: _buildContent(textColor),
    );
  }

  Widget _buildText(bool isDark) {
    return TextButton(
      onPressed: _isInteractive ? onTap : null,
      style: TextButton.styleFrom(
        foregroundColor: GeezColors.primary,
        disabledForegroundColor: GeezColors.primary.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(
          horizontal: GeezSpacing.md,
          vertical: GeezSpacing.sm,
        ),
        textStyle: GeezTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
      child: _buildContent(
        isDisabled ? GeezColors.primary.withValues(alpha: 0.5) : GeezColors.primary,
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: GeezSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
