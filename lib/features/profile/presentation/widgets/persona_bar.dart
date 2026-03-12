import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../passport/domain/mock_passport_data.dart';

class PersonaBar extends StatefulWidget {
  const PersonaBar({super.key, required this.category});

  final PersonaCategory category;

  @override
  State<PersonaBar> createState() => _PersonaBarState();
}

class _PersonaBarState extends State<PersonaBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.category.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start the animation after a short delay for staggered effect
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = widget.category;

    return Padding(
      padding: const EdgeInsets.only(bottom: GeezSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row: emoji + name + level + percentage
          Row(
            children: [
              Text(cat.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: GeezSpacing.sm),
              Expanded(
                child: Text(
                  cat.name,
                  style: GeezTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(GeezRadius.chip),
                ),
                child: Text(
                  'Lv.${cat.level}',
                  style: GeezTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cat.color,
                  ),
                ),
              ),
              const SizedBox(width: GeezSpacing.sm),
              Text(
                '${(cat.progress * 100).toInt()}%',
                style: GeezTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: GeezColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: GeezSpacing.sm),
          // Animated progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: cat.color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                  minHeight: 8,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
