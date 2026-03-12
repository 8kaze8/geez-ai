import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class GeezCard extends StatelessWidget {
  const GeezCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation = 0,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final BorderRadius? borderRadius;

  static const _defaultRadius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveRadius = borderRadius ?? _defaultRadius;
    final surfaceColor = isDark ? GeezColors.surfaceDark : GeezColors.surface;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: effectiveRadius,
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: elevation * 4,
              offset: Offset(0, elevation),
            ),
          if (elevation == 0)
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(GeezSpacing.md),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
