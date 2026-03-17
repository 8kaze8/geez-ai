import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/spacing.dart';

/// A simple rectangular placeholder used inside shimmer loading skeletons.
///
/// Set [radius] explicitly when you need a non-standard corner size;
/// defaults to [GeezRadius.card] (16).
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.radius = GeezRadius.card,
  });

  final double width;
  final double height;
  final Color color;

  /// Corner radius. Defaults to [GeezRadius.card].
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
