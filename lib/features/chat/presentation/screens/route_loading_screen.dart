import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/shared/widgets/loading_indicator.dart';

class RouteLoadingScreen extends StatefulWidget {
  const RouteLoadingScreen({super.key});

  @override
  State<RouteLoadingScreen> createState() => _RouteLoadingScreenState();
}

class _RouteLoadingScreenState extends State<RouteLoadingScreen> {
  int _currentStep = 0;
  String _snippet = '';

  final _steps = const [
    _LoadingStep(
      label: 'Google Maps verileri alınıyor',
      completedLabel: 'Google Maps verileri',
    ),
    _LoadingStep(
      label: '847 review okunuyor',
      completedLabel: '847 review okundu',
    ),
    _LoadingStep(
      label: 'Insider tips aranıyor...',
      completedLabel: 'Insider tips bulundu',
    ),
    _LoadingStep(
      label: 'Fun facts hazırlanıyor',
      completedLabel: 'Fun facts hazır',
    ),
    _LoadingStep(
      label: 'Rota optimize ediliyor',
      completedLabel: 'Rota optimize edildi',
    ),
  ];

  final _snippets = const [
    '',
    '',
    'Süleymaniye\'nin gizli bahçesi hakkında ilginç bir şey buldum...',
    'Kapalıçarşı\'da 5. kuşak bir bakırcı keşfettim!',
    'Sana özel 6 duraklık mükemmel bir rota çıktı!',
  ];

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  Future<void> _simulateProgress() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 600 : 700));
      if (!mounted) return;
      setState(() {
        _currentStep = i + 1;
        if (i < _snippets.length) {
          _snippet = _snippets[i];
        }
      });
    }

    // Brief pause before navigating
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.go('/route-detail');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? GeezColors.backgroundDark : GeezColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
          onPressed: () => context.go('/new-route'),
        ),
        title: Text(
          'İstanbul Rotası',
          style: GeezTypography.h3.copyWith(
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Loading indicator
              const GeezLoadingIndicator(
                size: 80,
                message: 'Rotanı hazırlıyorum...',
              ),

              const SizedBox(height: GeezSpacing.xl),

              // Progress steps
              Container(
                padding: const EdgeInsets.all(GeezSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? GeezColors.surfaceDark : GeezColors.surface,
                  borderRadius: BorderRadius.circular(GeezRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_steps.length, (index) {
                    return _StepRow(
                      step: _steps[index],
                      status: index < _currentStep
                          ? _StepStatus.completed
                          : index == _currentStep
                              ? _StepStatus.inProgress
                              : _StepStatus.pending,
                      isDark: isDark,
                    );
                  }),
                ),
              ),

              const SizedBox(height: GeezSpacing.lg),

              // AI snippet
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _snippet.isNotEmpty
                    ? Container(
                        key: ValueKey(_snippet),
                        padding: const EdgeInsets.symmetric(
                          horizontal: GeezSpacing.md,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: GeezColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: GeezSpacing.sm),
                            Expanded(
                              child: Text(
                                _snippet,
                                style: GeezTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? GeezColors.textPrimaryDark
                                      : GeezColors.textPrimary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

enum _StepStatus { pending, inProgress, completed }

class _LoadingStep {
  final String label;
  final String completedLabel;

  const _LoadingStep({required this.label, required this.completedLabel});
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.status,
    required this.isDark,
  });

  final _LoadingStep step;
  final _StepStatus status;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (status) {
              _StepStatus.completed => const Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey('completed'),
                  color: GeezColors.success,
                  size: 22,
                ),
              _StepStatus.inProgress => const SizedBox(
                  key: ValueKey('progress'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(GeezColors.primary),
                  ),
                ),
              _StepStatus.pending => Icon(
                  Icons.radio_button_unchecked_rounded,
                  key: const ValueKey('pending'),
                  color: isDark
                      ? const Color(0xFF555555)
                      : const Color(0xFFBDBDBD),
                  size: 22,
                ),
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GeezTypography.bodySmall.copyWith(
                color: switch (status) {
                  _StepStatus.completed =>
                    isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
                  _StepStatus.inProgress => GeezColors.primary,
                  _StepStatus.pending => isDark
                      ? GeezColors.textSecondaryDark
                      : GeezColors.textSecondary,
                },
                fontWeight: status == _StepStatus.inProgress
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              child: Text(
                status == _StepStatus.completed
                    ? step.completedLabel
                    : step.label,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
