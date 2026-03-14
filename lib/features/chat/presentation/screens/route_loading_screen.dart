import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/chat/presentation/providers/route_generation_provider.dart';
import 'package:geez_ai/shared/widgets/loading_indicator.dart';

class RouteLoadingScreen extends ConsumerStatefulWidget {
  const RouteLoadingScreen({super.key});

  @override
  ConsumerState<RouteLoadingScreen> createState() => _RouteLoadingScreenState();
}

class _RouteLoadingScreenState extends ConsumerState<RouteLoadingScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generationState = ref.watch(routeGenerationProvider);

    // Navigate to route detail as soon as routeId is available.
    if (generationState.isSuccess &&
        generationState.routeId != null &&
        !_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(RoutePaths.routeDetailPath(generationState.routeId!));
        }
      });
    }

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color:
                isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
          onPressed: () => context.go(RoutePaths.newRoute),
        ),
        title: Text(
          'Rota Hazırlanıyor',
          style: GeezTypography.h3.copyWith(
            color:
                isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
          child: generationState.isError
              ? _ErrorView(
                  message: generationState.errorMessage ??
                      'Beklenmedik bir hata oluştu.',
                  isDark: isDark,
                  onRetry: () {
                    // Reset and send user back to chat to retry.
                    ref.read(routeGenerationProvider.notifier).reset();
                    context.go(RoutePaths.newRoute);
                  },
                )
              : _LoadingView(
                  progressMessage: generationState.progressMessage,
                  isDark: isDark,
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading view
// ---------------------------------------------------------------------------

class _LoadingView extends StatelessWidget {
  const _LoadingView({
    required this.progressMessage,
    required this.isDark,
  });

  final String? progressMessage;
  final bool isDark;

  static const _steps = [
    _LoadingStep(
      label: 'Mekanlar araştırılıyor',
      completedLabel: 'Mekanlar araştırıldı',
    ),
    _LoadingStep(
      label: 'Yorumlar analiz ediliyor',
      completedLabel: 'Yorumlar analiz edildi',
    ),
    _LoadingStep(
      label: 'Insider ipuçları ekleniyor',
      completedLabel: 'Insider ipuçları hazır',
    ),
    _LoadingStep(
      label: 'Rota optimize ediliyor',
      completedLabel: 'Rota optimize edildi',
    ),
    _LoadingStep(
      label: 'Neredeyse hazır!',
      completedLabel: 'Rota hazır!',
    ),
  ];

  static const _progressMessages = [
    'Rotanız hazırlanıyor...',
    'Mekanlar araştırılıyor...',
    'Yorumlar analiz ediliyor...',
    'Insider ipuçları ekleniyor...',
    'Rota optimize ediliyor...',
  ];

  int get _currentStep {
    if (progressMessage == null) return 0;
    final idx = _progressMessages.indexOf(progressMessage!);
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentStep;

    return Column(
      children: [
        const Spacer(flex: 2),

        // Loading indicator
        GeezLoadingIndicator(
          size: 80,
          message: progressMessage ?? 'Rotanız hazırlanıyor...',
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
                status: index < step
                    ? _StepStatus.completed
                    : index == step
                        ? _StepStatus.inProgress
                        : _StepStatus.pending,
                isDark: isDark,
              );
            }),
          ),
        ),

        const SizedBox(height: GeezSpacing.lg),

        // Live progress message bubble
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: progressMessage != null
              ? Container(
                  key: ValueKey(progressMessage),
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
                          progressMessage!,
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
    );
  }
}

// ---------------------------------------------------------------------------
// Error view
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.isDark,
    required this.onRetry,
  });

  final String message;
  final bool isDark;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 64,
          color: GeezColors.error,
        ),
        const SizedBox(height: GeezSpacing.md),
        Text(
          'Bir hata oluştu',
          style: GeezTypography.h3.copyWith(
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GeezSpacing.sm),
        Text(
          message,
          style: GeezTypography.bodySmall.copyWith(
            color: isDark
                ? GeezColors.textSecondaryDark
                : GeezColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GeezSpacing.xl),
        FilledButton.icon(
          onPressed: onRetry,
          style: FilledButton.styleFrom(
            backgroundColor: GeezColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.xl,
              vertical: GeezSpacing.md,
            ),
          ),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Tekrar Dene'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step models & widgets
// ---------------------------------------------------------------------------

enum _StepStatus { pending, inProgress, completed }

class _LoadingStep {
  const _LoadingStep({required this.label, required this.completedLabel});

  final String label;
  final String completedLabel;
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
