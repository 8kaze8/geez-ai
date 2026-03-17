import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/chat/domain/chat_message_model.dart';

// ---------------------------------------------------------------------------
// Public widget
// ---------------------------------------------------------------------------

/// Renders a single chat bubble.
///
/// Pass [message] for a real message or set [isTyping] to `true` to render
/// the animated three-dot typing indicator (always AI-side).
class ChatBubble extends StatelessWidget {
  /// Bubble from a real message.
  const ChatBubble({
    super.key,
    required this.message,
  }) : isTyping = false;

  /// Typing indicator bubble — shown while waiting for the AI response.
  const ChatBubble.typing({super.key})
      : message = null,
        isTyping = true;

  final ChatMessageModel? message;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAI = isTyping || (message?.isAssistant ?? true);

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
                        ? GeezColors.chatAiBubbleDark
                        : GeezColors.chatAiBubbleLight)
                    : GeezColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isAI ? 4 : 18),
                  bottomRight: Radius.circular(isAI ? 18 : 4),
                ),
              ),
              child: isTyping
                  ? _TypingIndicator(isDark: isDark)
                  : Text(
                      message!.content,
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

// ---------------------------------------------------------------------------
// AI avatar
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Typing indicator  (three animated dots)
// ---------------------------------------------------------------------------

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({required this.isDark});

  final bool isDark;

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (i) {
          // Each dot starts its animation offset by 0.2 of the total duration.
          final delay = i * 0.2;
          final animation = TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween(begin: 0, end: -6),
              weight: 30,
            ),
            TweenSequenceItem(
              tween: Tween(begin: -6, end: 0),
              weight: 30,
            ),
            TweenSequenceItem(
              tween: ConstantTween(0),
              weight: 40,
            ),
          ]).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, (delay + 0.6).clamp(0, 1)),
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (_, _) => Transform.translate(
              offset: Offset(0, animation.value),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? GeezColors.textSecondaryDark
                      : GeezColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
