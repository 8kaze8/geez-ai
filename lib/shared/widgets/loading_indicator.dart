import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

class GeezLoadingIndicator extends StatefulWidget {
  const GeezLoadingIndicator({
    super.key,
    this.message,
    this.size = 64,
  });

  final String? message;
  final double size;

  @override
  State<GeezLoadingIndicator> createState() => _GeezLoadingIndicatorState();
}

class _GeezLoadingIndicatorState extends State<GeezLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress track
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    GeezColors.primary.withValues(alpha: 0.3),
                  ),
                  value: 1,
                ),
              ),
              // Spinning progress arc
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(GeezColors.primary),
                ),
              ),
              // Rotating plane icon
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: Icon(
                  Icons.flight,
                  size: widget.size * 0.4,
                  color: GeezColors.primary,
                ),
              ),
            ],
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: GeezSpacing.md),
          Text(
            widget.message!,
            style: GeezTypography.bodySmall.copyWith(
              color: isDark
                  ? GeezColors.textSecondaryDark
                  : GeezColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
