import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/onboarding/domain/onboarding_state.dart';
import 'package:geez_ai/features/onboarding/domain/onboarding_submit_state.dart';
import 'package:geez_ai/features/onboarding/presentation/providers/onboarding_provider.dart';

class PersonaRevealScreen extends ConsumerStatefulWidget {
  const PersonaRevealScreen({super.key});

  @override
  ConsumerState<PersonaRevealScreen> createState() =>
      _PersonaRevealScreenState();
}

class _PersonaRevealScreenState extends ConsumerState<PersonaRevealScreen>
    with TickerProviderStateMixin {
  late final AnimationController _cardController;
  late final AnimationController _barsController;
  late final AnimationController _buttonController;

  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;
  late final Animation<double> _sparkleOpacity;
  late final Animation<double> _barsFade;
  late final Animation<double> _barsProgress;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    // Card entrance
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _cardScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _sparkleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Progress bars
    _barsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _barsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _barsController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _barsProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _barsController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Button entrance
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutCubic),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _cardController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _barsController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _buttonController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _barsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final notifier = ref.read(onboardingProvider.notifier);
    await notifier.submitOnboarding();

    if (!mounted) return;

    final submitState = ref.read(onboardingProvider).$2;

    if (submitState.isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            submitState.errorMessage ?? 'Bir hata olustu. Lutfen tekrar dene.',
          ),
          backgroundColor: GeezColors.error,
        ),
      );
      return;
    }

    // submitOnboarding wrote to prefs (unauthenticated) → go to signup.
    // submitOnboarding wrote to DB (authenticated) → go to home.
    final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
    if (!mounted) return;

    if (isAuthenticated) {
      context.go(RoutePaths.home);
    } else {
      context.go(RoutePaths.signup);
    }
  }

  static const _personaColors = {
    'Foodie': GeezColors.foodie,
    'History': GeezColors.history,
    'Adventure': GeezColors.adventure,
    'Culture': GeezColors.culture,
    'Nature': GeezColors.nature,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (quizState, submitState) = ref.watch(onboardingProvider);
    final traits = quizState.personaTraits;
    final personaName = quizState.personaName;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.lg,
            vertical: GeezSpacing.xl,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: GeezSpacing.lg),

                // Sparkle + title
                AnimatedBuilder(
                  animation: _cardController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _sparkleOpacity,
                      child: Text(
                        '✨ SENİN TRAVEL PERSONAN: ✨',
                        style: GeezTypography.caption.copyWith(
                          color: GeezColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),

                const SizedBox(height: GeezSpacing.md),

                // Persona card
                FadeTransition(
                  opacity: _cardFade,
                  child: ScaleTransition(
                    scale: _cardScale,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(GeezSpacing.lg),
                      decoration: BoxDecoration(
                        color: isDark
                            ? GeezColors.surfaceDark
                            : GeezColors.surface,
                        borderRadius: BorderRadius.circular(GeezRadius.card),
                        border: Border.all(
                          color: GeezColors.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: GeezColors.primary.withValues(alpha: 0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Persona name
                          Text(
                            personaName,
                            style: GeezTypography.h2.copyWith(
                              color: GeezColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: GeezSpacing.lg),

                          // Persona bars
                          FadeTransition(
                            opacity: _barsFade,
                            child: AnimatedBuilder(
                              animation: _barsProgress,
                              builder: (context, child) {
                                return Column(
                                  children: traits.map((trait) {
                                    final color = _personaColors[trait.name] ??
                                        GeezColors.primary;
                                    final targetProgress =
                                        trait.isActive ? 0.2 : 0.05;
                                    final currentProgress =
                                        targetProgress * _barsProgress.value;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: GeezSpacing.sm,
                                      ),
                                      child: _PersonaBar(
                                        emoji: trait.emoji,
                                        name: trait.name,
                                        level: trait.level,
                                        progress: currentProgress,
                                        color: color,
                                        isActive: trait.isActive,
                                        isDark: isDark,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: GeezSpacing.md),

                          // Discovery Score
                          FadeTransition(
                            opacity: _barsFade,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Discovery Score',
                                      style: GeezTypography.bodySmall.copyWith(
                                        color: isDark
                                            ? GeezColors.textPrimaryDark
                                            : GeezColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '0',
                                      style: GeezTypography.bodySmall.copyWith(
                                        color: GeezColors.discovery,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: GeezSpacing.sm),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 0,
                                    minHeight: 8,
                                    backgroundColor: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.black.withValues(alpha: 0.06),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      GeezColors.discovery,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: GeezSpacing.lg),

                // Motivational text
                SlideTransition(
                  position: _buttonSlide,
                  child: FadeTransition(
                    opacity: _buttonFade,
                    child: Text(
                      'Gezine başladıkça\nseviyelerin yükselecek!',
                      style: GeezTypography.body.copyWith(
                        color: GeezColors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: GeezSpacing.lg),

                // CTA button
                SlideTransition(
                  position: _buttonSlide,
                  child: FadeTransition(
                    opacity: _buttonFade,
                    child: SizedBox(
                      width: double.infinity,
                      child: GeezButton(
                        label: _ctaLabel(quizState, submitState),
                        onTap:
                            submitState.isLoading ? null : _handleContinue,
                        isLoading: submitState.isLoading,
                        isDisabled: submitState.isLoading,
                        icon: Icons.flight_takeoff_rounded,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: GeezSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  String _ctaLabel(OnboardingState quiz, OnboardingSubmitState submit) {
    if (submit.isLoading) return 'Kaydediliyor...';
    final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
    if (!isAuthenticated && quiz.selectedStyles.isNotEmpty) {
      return 'Hesap Olustur ve Baslayalim!';
    }
    return 'İlk Rotamı Planla!';
  }
}

class _PersonaBar extends StatelessWidget {
  const _PersonaBar({
    required this.emoji,
    required this.name,
    required this.level,
    required this.progress,
    required this.color,
    required this.isActive,
    required this.isDark,
  });

  final String emoji;
  final String name;
  final int level;
  final double progress;
  final Color color;
  final bool isActive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: GeezSpacing.sm),
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: GeezTypography.bodySmall.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark
                  : GeezColors.textPrimary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(
                isActive ? color : color.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
        const SizedBox(width: GeezSpacing.sm),
        Text(
          'Lv.$level',
          style: GeezTypography.caption.copyWith(
            color: isActive ? color : GeezColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
