import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _illustrationFade;
  late final Animation<double> _illustrationScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _illustrationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _illustrationScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final maxSize = size.height * 0.35;
    final illustrationSize = (size.width * 0.65).clamp(120.0, maxSize < 120.0 ? 120.0 : maxSize);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Illustration placeholder — gradient container with icon
          FadeTransition(
            opacity: _illustrationFade,
            child: ScaleTransition(
              scale: _illustrationScale,
              child: Container(
                width: illustrationSize,
                height: illustrationSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(GeezRadius.card * 2),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A73E8),
                      Color(0xFF4DA3FF),
                      Color(0xFF00C853),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GeezColors.primary.withValues(alpha: 0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background pattern
                    Positioned(
                      top: 30,
                      right: 40,
                      child: Icon(
                        Icons.map_rounded,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 30,
                      child: Icon(
                        Icons.explore_rounded,
                        size: 60,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    // Main icon
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.travel_explore_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: GeezSpacing.md),
                        Text(
                          'GEEZ AI',
                          style: GeezTypography.h2.copyWith(
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // Title
          SlideTransition(
            position: _titleSlide,
            child: FadeTransition(
              opacity: _titleFade,
              child: Text(
                'Merhaba, ben Geez!',
                style: GeezTypography.h1.copyWith(
                  color: isDark
                      ? GeezColors.textPrimaryDark
                      : GeezColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: GeezSpacing.md),

          // Subtitle
          SlideTransition(
            position: _subtitleSlide,
            child: FadeTransition(
              opacity: _subtitleFade,
              child: Text(
                'Seni tanımak ve mükemmel geziler\nplanlamak istiyorum.',
                style: GeezTypography.body.copyWith(
                  color: GeezColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const Spacer(flex: 2),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: GeezButton(
              label: 'Devam Et',
              onTap: widget.onContinue,
              icon: Icons.arrow_forward_rounded,
            ),
          ),

          const SizedBox(height: GeezSpacing.xxl),
        ],
      ),
    );
  }
}
