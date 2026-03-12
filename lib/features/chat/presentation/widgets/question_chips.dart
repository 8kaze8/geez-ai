import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';

class ChipOption {
  final String label;
  final String? emoji;

  const ChipOption({required this.label, this.emoji});
}

class QuestionChips extends StatefulWidget {
  const QuestionChips({
    super.key,
    required this.options,
    required this.onSelected,
    this.allowCustomInput = false,
    this.customInputHint,
  });

  final List<ChipOption> options;
  final ValueChanged<String> onSelected;
  final bool allowCustomInput;
  final String? customInputHint;

  @override
  State<QuestionChips> createState() => _QuestionChipsState();
}

class _QuestionChipsState extends State<QuestionChips>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  String? _selected;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.md,
            vertical: GeezSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: GeezSpacing.sm,
                runSpacing: GeezSpacing.sm,
                children: widget.options.map((option) {
                  final isSelected = _selected == option.label;
                  final displayLabel = option.emoji != null
                      ? '${option.emoji} ${option.label}'
                      : option.label;

                  return GestureDetector(
                    onTap: _selected == null
                        ? () {
                            setState(() => _selected = option.label);
                            widget.onSelected(option.label);
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? GeezColors.primary
                            : _selected != null
                                ? (isDark
                                    ? const Color(0xFF2A2A2E)
                                    : const Color(0xFFF5F5F5))
                                : (isDark
                                    ? const Color(0xFF2A2A2E)
                                    : Colors.white),
                        borderRadius: BorderRadius.circular(GeezRadius.chip),
                        border: Border.all(
                          color: isSelected
                              ? GeezColors.primary
                              : _selected != null
                                  ? (isDark
                                      ? const Color(0xFF3A3A3E)
                                      : const Color(0xFFE0E0E0))
                                  : GeezColors.primary.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        displayLabel,
                        style: GeezTypography.bodySmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : _selected != null
                                  ? (isDark
                                      ? GeezColors.textSecondaryDark
                                      : GeezColors.textSecondary)
                                  : (isDark
                                      ? GeezColors.textPrimaryDark
                                      : GeezColors.textPrimary),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (widget.allowCustomInput && _selected == null) ...[
                const SizedBox(height: 12),
                _buildCustomInput(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2E) : Colors.white,
        borderRadius: BorderRadius.circular(GeezRadius.chip),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3A3E) : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(
            Icons.place_outlined,
            size: 20,
            color: isDark
                ? GeezColors.textSecondaryDark
                : GeezColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _textController,
              style: GeezTypography.bodySmall.copyWith(
                color: isDark
                    ? GeezColors.textPrimaryDark
                    : GeezColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                    widget.customInputHint ?? 'Veya şehir/ülke yaz...',
                hintStyle: GeezTypography.bodySmall.copyWith(
                  color: isDark
                      ? GeezColors.textSecondaryDark
                      : GeezColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() => _selected = value.trim());
                  widget.onSelected(value.trim());
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              final value = _textController.text.trim();
              if (value.isNotEmpty) {
                setState(() => _selected = value);
                widget.onSelected(value);
              }
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: GeezColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
