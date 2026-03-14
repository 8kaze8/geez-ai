import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    super.key,
    required this.isPlaying,
    this.duration = const Duration(seconds: 3),
    this.particleCount = 50,
    this.child,
  });

  final bool isPlaying;
  final Duration duration;
  final int particleCount;
  final Widget? child;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_ConfettiParticle> _particles;
  final _random = math.Random();

  static const _confettiColors = [
    GeezColors.primary,
    GeezColors.secondary,
    GeezColors.accent,
    GeezColors.foodie,
    GeezColors.adventure,
    GeezColors.culture,
    GeezColors.discovery,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _particles = _generateParticles();

    if (widget.isPlaying) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _particles = _generateParticles();
      _controller.forward(from: 0);
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_ConfettiParticle> _generateParticles() {
    return List.generate(widget.particleCount, (_) {
      return _ConfettiParticle(
        x: _random.nextDouble(),
        speed: 0.3 + _random.nextDouble() * 0.7,
        size: 4 + _random.nextDouble() * 6,
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        drift: (_random.nextDouble() - 0.5) * 0.3,
        rotationSpeed: (_random.nextDouble() - 0.5) * 4,
        delay: _random.nextDouble() * 0.3,
        shape: _ConfettiShape.values[_random.nextInt(_ConfettiShape.values.length)],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (widget.isPlaying)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

enum _ConfettiShape { circle, square, rectangle }

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.color,
    required this.drift,
    required this.rotationSpeed,
    required this.delay,
    required this.shape,
  });

  final double x;
  final double speed;
  final double size;
  final Color color;
  final double drift;
  final double rotationSpeed;
  final double delay;
  final _ConfettiShape shape;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final adjustedProgress = (progress - particle.delay).clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      // Fade out in the last 30%
      final opacity =
          adjustedProgress > 0.7 ? (1 - adjustedProgress) / 0.3 : 1.0;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width +
          math.sin(adjustedProgress * math.pi * 2) *
              particle.drift *
              size.width;
      final y = -particle.size + adjustedProgress * (size.height + particle.size * 2) * particle.speed;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(adjustedProgress * particle.rotationSpeed * math.pi);

      switch (particle.shape) {
        case _ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
        case _ConfettiShape.square:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size,
            ),
            paint,
          );
        case _ConfettiShape.rectangle:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.5,
            ),
            paint,
          );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
