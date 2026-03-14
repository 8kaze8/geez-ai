import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/shared/widgets/confetti_overlay.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';
import 'package:geez_ai/shared/widgets/geez_card.dart';
import 'package:geez_ai/shared/widgets/geez_chip.dart';
import 'package:geez_ai/features/feedback/presentation/providers/feedback_provider.dart';

// ---------------------------------------------------------------------------
// FeedbackScreen
// ---------------------------------------------------------------------------

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key, required this.routeId});

  final String routeId;

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _freeTextController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _freeTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // Sync text field value into provider before submitting.
    ref
        .read(feedbackFormProvider.notifier)
        .setFreeText(_freeTextController.text.trim());
    ref.read(feedbackFormProvider.notifier).submit(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(feedbackFormProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? GeezColors.backgroundDark : GeezColors.background;
    final textPrimary =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    // Navigate home after successful submission (only on transition).
    ref.listen<FeedbackFormState>(feedbackFormProvider, (prev, next) {
      if (prev?.isSubmitted == true || !next.isSubmitted) return;
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) {
          context.go(RoutePaths.home);
        }
      });
    });

    return ConfettiOverlay(
      isPlaying: formState.isSubmitted,
      duration: const Duration(seconds: 3),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: formState.isSubmitted
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: textPrimary,
                  ),
                  onPressed: () => context.pop(),
                ),
          title: Text(
            'Geri Bildirim',
            style: GeezTypography.h3.copyWith(color: textPrimary),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: formState.isSubmitted
              ? _SuccessState(isDark: isDark, textPrimary: textPrimary)
              : _FormBody(
                  formState: formState,
                  freeTextController: _freeTextController,
                  scrollController: _scrollController,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  onSubmit: _onSubmit,
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Success state
// ---------------------------------------------------------------------------

class _SuccessState extends StatelessWidget {
  const _SuccessState({
    required this.isDark,
    required this.textPrimary,
  });

  final bool isDark;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: GeezColors.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 52,
                color: GeezColors.accent,
              ),
            ),
            const SizedBox(height: GeezSpacing.lg),
            Text(
              'Tesekkurler!',
              style: GeezTypography.h2.copyWith(color: textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GeezSpacing.sm),
            Text(
              'Geri bildirimin basariyla gonderildi.\nAI asistanin seni daha iyi anlayacak.',
              style: GeezTypography.body.copyWith(
                color: GeezColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form body
// ---------------------------------------------------------------------------

class _FormBody extends ConsumerWidget {
  const _FormBody({
    required this.formState,
    required this.freeTextController,
    required this.scrollController,
    required this.isDark,
    required this.textPrimary,
    required this.onSubmit,
  });

  final FeedbackFormState formState;
  final TextEditingController freeTextController;
  final ScrollController scrollController;
  final bool isDark;
  final Color textPrimary;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(feedbackFormProvider.notifier);

    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        GeezSpacing.md,
        GeezSpacing.sm,
        GeezSpacing.md,
        GeezSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1: Overall Rating
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  number: '1',
                  title: 'Genel Degerlendirme',
                  subtitle: 'Bu rota deneyiminizi nasil buldunuz?',
                  textPrimary: textPrimary,
                ),
                const SizedBox(height: GeezSpacing.md),
                _StarRatingRow(
                  rating: formState.overallRating,
                  onRatingSelected: notifier.setOverallRating,
                ),
                if (formState.overallRating > 0) ...[
                  const SizedBox(height: GeezSpacing.sm),
                  Center(
                    child: Text(
                      _emojiForRating(formState.overallRating),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.md),

          // Step 2: Accuracy Rating
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  number: '2',
                  title: 'AI Rotasi Dogrulugu',
                  subtitle: 'AI rotasi ne kadar dogruydu?',
                  textPrimary: textPrimary,
                ),
                const SizedBox(height: GeezSpacing.md),
                _StarRatingRow(
                  rating: formState.accuracyRating,
                  onRatingSelected: notifier.setAccuracyRating,
                  color: GeezColors.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.md),

          // Step 3: Highlights
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  number: '3',
                  title: 'Onslar',
                  subtitle: 'En cok ne begendingiz? (birden fazla secebilirsiniz)',
                  textPrimary: textPrimary,
                ),
                const SizedBox(height: GeezSpacing.md),
                _ChipGroup(
                  options: _kHighlightOptions,
                  selected: formState.highlights,
                  onTap: notifier.toggleHighlight,
                ),
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.md),

          // Step 4: Lowlights
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  number: '4',
                  title: 'Gelistirilebilecekler',
                  subtitle: 'Hangi konular iyilestirilebilir?',
                  textPrimary: textPrimary,
                ),
                const SizedBox(height: GeezSpacing.md),
                _ChipGroup(
                  options: _kLowlightOptions,
                  selected: formState.lowlights,
                  onTap: notifier.toggleLowlight,
                  selectedColor: GeezColors.warning,
                ),
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.md),

          // Step 5: Would Recommend
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  number: '5',
                  title: 'Tavsiye',
                  subtitle: 'Bu rotayi arkadaslariniza onerir misiniz?',
                  textPrimary: textPrimary,
                ),
                const SizedBox(height: GeezSpacing.md),
                _RecommendToggle(
                  value: formState.wouldRecommend,
                  onChanged: notifier.setWouldRecommend,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.md),

          // Step 6: Free text
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  number: '6',
                  title: 'Ekstra Yorumlar',
                  subtitle: 'Eklemek istediginiz bir sey var mi?',
                  textPrimary: textPrimary,
                  isOptional: true,
                ),
                const SizedBox(height: GeezSpacing.md),
                _FreeTextField(
                  controller: freeTextController,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: GeezSpacing.lg),

          // Error message
          if (formState.error != null) ...[
            _ErrorBanner(message: formState.error!),
            const SizedBox(height: GeezSpacing.md),
          ],

          // Submit button
          GeezButton(
            label: 'Gonder',
            onTap: formState.canSubmit ? onSubmit : null,
            isLoading: formState.isSubmitting,
            isDisabled: formState.overallRating < 1,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section card wrapper
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GeezCard(
      elevation: 1,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.textPrimary,
    this.isOptional = false,
  });

  final String number;
  final String title;
  final String subtitle;
  final Color textPrimary;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: GeezColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GeezTypography.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: GeezSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: GeezTypography.body.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isOptional) ...[
                    const SizedBox(width: GeezSpacing.xs),
                    Text(
                      '(opsiyonel)',
                      style: GeezTypography.caption.copyWith(
                        color: GeezColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GeezTypography.bodySmall.copyWith(
                  color: GeezColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Star rating row
// ---------------------------------------------------------------------------

class _StarRatingRow extends StatelessWidget {
  const _StarRatingRow({
    required this.rating,
    required this.onRatingSelected,
    this.color = GeezColors.discovery,
  });

  final int rating;
  final ValueChanged<int> onRatingSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return GestureDetector(
          onTap: () => onRatingSelected(starIndex),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.xs),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                key: ValueKey('star_${starIndex}_$isFilled'),
                size: 40,
                color: isFilled ? color : GeezColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Chip group
// ---------------------------------------------------------------------------

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.options,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  });

  final List<String> options;
  final List<String> selected;
  final ValueChanged<String> onTap;

  /// When null, GeezChip uses its default primary color.
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: GeezSpacing.sm,
      runSpacing: GeezSpacing.sm,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        // GeezChip handles its own selected styling using GeezColors.primary.
        // For lowlight chips we pass a custom chip-style widget instead.
        if (selectedColor != null && selectedColor != GeezColors.primary) {
          return _TintedChip(
            label: option,
            isSelected: isSelected,
            selectedColor: selectedColor!,
            onTap: () => onTap(option),
          );
        }
        return GeezChip(
          label: option,
          isSelected: isSelected,
          onTap: () => onTap(option),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Tinted chip for non-primary selection colours (e.g. lowlights)
// ---------------------------------------------------------------------------

class _TintedChip extends StatelessWidget {
  const _TintedChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedBorderColor =
        isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0);
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: GeezSpacing.md,
          vertical: GeezSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(GeezRadius.chip),
          border: Border.all(
            color: isSelected ? selectedColor : mutedBorderColor,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GeezTypography.bodySmall.copyWith(
            color: isSelected ? selectedColor : textColor,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Would recommend toggle
// ---------------------------------------------------------------------------

class _RecommendToggle extends StatelessWidget {
  const _RecommendToggle({
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  final bool? value;
  final ValueChanged<bool> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ToggleOption(
            label: 'Evet',
            icon: Icons.thumb_up_outlined,
            isSelected: value == true,
            selectedColor: GeezColors.accent,
            isDark: isDark,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: GeezSpacing.md),
        Expanded(
          child: _ToggleOption(
            label: 'Hayir',
            icon: Icons.thumb_down_outlined,
            isSelected: value == false,
            selectedColor: GeezColors.error,
            isDark: isDark,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mutedBorder =
        isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0);
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: GeezSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(GeezRadius.button),
          border: Border.all(
            color: isSelected ? selectedColor : mutedBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? selectedColor : GeezColors.textSecondary,
            ),
            const SizedBox(height: GeezSpacing.xs),
            Text(
              label,
              style: GeezTypography.body.copyWith(
                color: isSelected ? selectedColor : textColor,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Free text field
// ---------------------------------------------------------------------------

class _FreeTextField extends StatelessWidget {
  const _FreeTextField({
    required this.controller,
    required this.isDark,
    required this.textPrimary,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isDark;
  final Color textPrimary;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.04);
    final borderColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFE0E0E0);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 4,
      maxLength: 500,
      style: GeezTypography.body.copyWith(color: textPrimary),
      decoration: InputDecoration(
        hintText: 'Yorumunuzu buraya yazin...',
        hintStyle: GeezTypography.body.copyWith(
          color: GeezColors.textSecondary,
        ),
        filled: true,
        fillColor: fillColor,
        counterStyle: GeezTypography.caption.copyWith(
          color: GeezColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GeezRadius.button),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GeezRadius.button),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GeezRadius.button),
          borderSide: const BorderSide(color: GeezColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(GeezSpacing.md),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error banner
// ---------------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GeezSpacing.md),
      decoration: BoxDecoration(
        color: GeezColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(GeezRadius.button),
        border: Border.all(
          color: GeezColors.error.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: GeezColors.error,
            size: 20,
          ),
          const SizedBox(width: GeezSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: GeezTypography.bodySmall.copyWith(
                color: GeezColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chip data constants
// ---------------------------------------------------------------------------

const _kHighlightOptions = [
  'Yemekler harika',
  'Manzara muhteşem',
  'Yerel öneriler süper',
  'Zamanlama mükemmel',
  'Ulaşım kolay',
];

const _kLowlightOptions = [
  'Bazı mekanlar kapalıydı',
  'Mesafeler uzundu',
  'Fiyatlar yüksekti',
  'Bilgiler eksikti',
  'Zamanlama sıkışıktı',
];

// ---------------------------------------------------------------------------
// Emoji helper
// ---------------------------------------------------------------------------

String _emojiForRating(int rating) {
  return switch (rating) {
    1 => '😞',
    2 => '😐',
    3 => '🙂',
    4 => '😊',
    5 => '🤩',
    _ => '',
  };
}
