import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';

/// Splash screen shown at app launch.
///
/// Plays the brand animation while [authStateProvider] resolves the stored
/// session. Once auth state is known the router guard (in `app_router.dart`)
/// automatically redirects to login or home -- this screen does NOT navigate
/// itself.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _planeController;
  late final AnimationController _fadeController;
  late final AnimationController _taglineController;
  late final AnimationController _dotsController;

  late final Animation<double> _planeRotation;
  late final Animation<double> _planeFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();

    // Plane rotation + fade in
    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _planeRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _planeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _planeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _planeController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Title fade + slide
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    // Tagline fade + slide
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOutCubic),
    );

    // Loading dots
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _dotsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dotsController, curve: Curves.easeOut),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Start plane animation immediately
    _planeController.forward();

    // Title appears after 400ms
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _fadeController.forward();

    // Tagline appears after 800ms
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineController.forward();

    // Loading dots appear after 400ms more
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _dotsController.forward();

    // The router guard handles navigation once auth state resolves.
    // No explicit context.go() needed here.
  }

  @override
  void dispose() {
    _planeController.dispose();
    _fadeController.dispose();
    _taglineController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch auth state -- this triggers the router guard redirect.
    ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Plane icon with rotation
            AnimatedBuilder(
              animation: _planeController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _planeFade,
                  child: Transform.rotate(
                    angle: _planeRotation.value * math.pi,
                    child: Icon(
                      Icons.flight,
                      size: 64,
                      color: GeezColors.primary,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: GeezSpacing.lg),

            // GEEZ AI title
            SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleFade,
                child: Text(
                  'G E E Z   A I',
                  style: GeezTypography.h1.copyWith(
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: GeezSpacing.sm),

            // Tagline
            SlideTransition(
              position: _taglineSlide,
              child: FadeTransition(
                opacity: _taglineFade,
                child: Text(
                  'Her gezi bir kesif',
                  style: GeezTypography.body.copyWith(
                    color: GeezColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            const SizedBox(height: GeezSpacing.xxl),

            // Loading dots
            FadeTransition(
              opacity: _dotsFade,
              child: _LoadingDots(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            final delay = index * 0.2;
            final value = _controller.value;
            final opacity =
                ((value - delay) % 1.0).clamp(0.0, 0.5) * 2.0;

            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GeezColors.primary.withValues(alpha: 0.3 + opacity * 0.7),
              ),
            );
          }),
        );
      },
    );
  }
}
