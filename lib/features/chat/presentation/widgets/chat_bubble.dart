import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.text,
    this.isAI = true,
  });

  final String text;
  final bool isAI;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment:
            isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAI) ...[
            _AIAvatar(isDark: isDark),
            const SizedBox(width: GeezSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GeezSpacing.md,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isAI
                    ? (isDark
                        ? const Color(0xFF2A2A2E)
                        : const Color(0xFFF0F4FA))
                    : GeezColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isAI ? 4 : 18),
                  bottomRight: Radius.circular(isAI ? 18 : 4),
                ),
              ),
              child: Text(
                text,
                style: GeezTypography.aiChat.copyWith(
                  color: isAI
                      ? (isDark
                          ? GeezColors.textPrimaryDark
                          : GeezColors.textPrimary)
                      : Colors.white,
                ),
              ),
            ),
          ),
          if (!isAI) const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _AIAvatar extends StatelessWidget {
  const _AIAvatar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: GeezColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.flight,
          size: 18,
          color: GeezColors.primary,
        ),
      ),
    );
  }
}
