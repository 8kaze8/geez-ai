import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';
import 'package:geez_ai/shared/widgets/geez_chip.dart';
import 'package:geez_ai/features/onboarding/domain/onboarding_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.state,
    required this.onStateChanged,
    required this.onContinue,
  });

  final OnboardingState state;
  final ValueChanged<OnboardingState> onStateChanged;
  final VoidCallback onContinue;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _q1Fade;
  late final Animation<Offset> _q1Slide;
  late final Animation<double> _q2Fade;
  late final Animation<Offset> _q2Slide;
  late final Animation<double> _q3Fade;
  late final Animation<Offset> _q3Slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _q1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _q1Slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _q2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _q2Slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _q3Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
    _q3Slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleStyle(String style) {
    final current = List<String>.from(widget.state.selectedStyles);
    if (current.contains(style)) {
      current.remove(style);
    } else {
      current.add(style);
    }
    widget.onStateChanged(widget.state.copyWith(selectedStyles: current));
  }

  void _setBudget(String budget) {
    widget.onStateChanged(widget.state.copyWith(budget: budget));
  }

  void _setCompanion(String companion) {
    widget.onStateChanged(widget.state.copyWith(companion: companion));
  }

  bool get _canContinue {
    return widget.state.selectedStyles.isNotEmpty &&
        widget.state.budget.isNotEmpty &&
        widget.state.companion.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GeezSpacing.xl),

          // Question 1: Travel style
          SlideTransition(
            position: _q1Slide,
            child: FadeTransition(
              opacity: _q1Fade,
              child: _QuestionSection(
                title: 'Genelde nasıl gezmeyi seversin?',
                subtitle: 'Birden fazla seçebilirsin',
                child: Wrap(
                  spacing: GeezSpacing.sm,
                  runSpacing: GeezSpacing.sm,
                  children: _travelStyles.map((style) {
                    return GeezChip(
                      label: style,
                      isSelected:
                          widget.state.selectedStyles.contains(style),
                      onTap: () => _toggleStyle(style),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: GeezSpacing.xl),

          // Question 2: Budget
          SlideTransition(
            position: _q2Slide,
            child: FadeTransition(
              opacity: _q2Fade,
              child: _QuestionSection(
                title: 'Bütçen nasıl?',
                child: Wrap(
                  spacing: GeezSpacing.sm,
                  runSpacing: GeezSpacing.sm,
                  children: _budgetOptions.map((budget) {
                    return GeezChip(
                      label: budget,
                      isSelected: widget.state.budget == budget,
                      onTap: () => _setBudget(budget),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: GeezSpacing.xl),

          // Question 3: Companion
          SlideTransition(
            position: _q3Slide,
            child: FadeTransition(
              opacity: _q3Fade,
              child: _QuestionSection(
                title: 'Kiminle?',
                child: Wrap(
                  spacing: GeezSpacing.sm,
                  runSpacing: GeezSpacing.sm,
                  children: _companionOptions.map((companion) {
                    return GeezChip(
                      label: companion,
                      isSelected: widget.state.companion == companion,
                      onTap: () => _setCompanion(companion),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: GeezSpacing.xxl),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: GeezButton(
              label: 'Devam Et',
              onTap: _canContinue ? widget.onContinue : null,
              isDisabled: !_canContinue,
              icon: Icons.arrow_forward_rounded,
            ),
          ),

          SizedBox(
              height: MediaQuery.of(context).padding.bottom + GeezSpacing.xl),
        ],
      ),
    );
  }
}

const _travelStyles = [
  '🏛️ Tarihi Keşif',
  '🍕 Yemek Turu',
  '🌿 Doğa',
  '🎒 Macera',
  '🎲 Karma — Surprise me!',
];

const _budgetOptions = [
  '💰 Ekonomik',
  '💳 Orta',
  '💎 Premium',
];

const _companionOptions = [
  '🧑 Solo',
  '💑 Çift',
  '👫 Arkadaşlar',
  '👨‍👩‍👧‍👦 Aile',
];

class _QuestionSection extends StatelessWidget {
  const _QuestionSection({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GeezTypography.h3.copyWith(
            color:
                isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: GeezSpacing.xs),
          Text(
            subtitle!,
            style: GeezTypography.caption.copyWith(
              color: GeezColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: GeezSpacing.md),
        child,
      ],
    );
  }
}
