import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/chat/data/chat_repository.dart';
import 'package:geez_ai/features/chat/presentation/providers/chat_provider.dart';
import 'package:geez_ai/features/chat/presentation/providers/route_generation_provider.dart';
import 'package:geez_ai/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:geez_ai/features/chat/presentation/widgets/question_chips.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _onGenerateRoute(
    Map<String, dynamic> extractedParams,
  ) async {
    // Navigation is handled by the ref.listen block below on success.
    await ref
        .read(routeGenerationProvider.notifier)
        .generate(extractedParams);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final generationState = ref.watch(routeGenerationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Scroll every time message count changes or typing indicator appears.
    ref.listen(chatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length ||
          prev?.isLoading != next.isLoading) {
        _scrollToBottom();
      }
    });

    // Navigate when route is successfully generated (only on transition).
    ref.listen(routeGenerationProvider, (prev, next) {
      if (prev?.isSuccess != true && next.isSuccess && next.routeId != null) {
        context.go(RoutePaths.routeDetailPath(next.routeId!));
      }
    });

    // Derive a simple title from the first user message (city).
    final firstUserMsg = chatState.messages
        .where((m) => m.isUser)
        .map((m) => m.content)
        .firstOrNull;
    final title =
        firstUserMsg != null ? '$firstUserMsg Rotası' : 'Yeni Rota';

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: GeezTypography.h3.copyWith(
            color: isDark
                ? GeezColors.textPrimaryDark
                : GeezColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          if (chatState.messages.length > 1)
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: isDark
                    ? GeezColors.textSecondaryDark
                    : GeezColors.textSecondary,
              ),
              tooltip: 'Yeni Sohbet',
              onPressed: () {
                ref.read(chatProvider.notifier).reset();
                ref.read(routeGenerationProvider.notifier).reset();
                _scrollToBottom();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // ----------------------------------------------------------------
          // Chat messages
          // ----------------------------------------------------------------
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                top: GeezSpacing.sm,
                bottom: GeezSpacing.md,
              ),
              itemCount: _itemCount(chatState),
              itemBuilder: (context, index) =>
                  _buildItem(context, index, chatState, isDark),
            ),
          ),

          // ----------------------------------------------------------------
          // Error banner
          // ----------------------------------------------------------------
          if (chatState.hasError)
            _ErrorBanner(
              message: chatState.errorMessage!,
              isRateLimit:
                  chatState.errorType == ChatErrorType.rateLimitExceeded,
              isDark: isDark,
              onDismiss: () =>
                  ref.read(chatProvider.notifier).reset(),
              onRetry: chatState.canRetry
                  ? () => ref.read(chatProvider.notifier).retryLastMessage()
                  : null,
            ),

          if (generationState.isError &&
              generationState.errorMessage != null)
            _ErrorBanner(
              message: generationState.errorMessage!,
              isRateLimit: generationState.errorType ==
                  ChatErrorType.rateLimitExceeded,
              isDark: isDark,
              onDismiss: () =>
                  ref.read(routeGenerationProvider.notifier).reset(),
              onRetry: generationState.canRetry
                  ? () => ref.read(routeGenerationProvider.notifier).retry()
                  : null,
            ),

          // ----------------------------------------------------------------
          // Generation loading overlay
          // ----------------------------------------------------------------
          if (generationState.isLoading)
            _GenerationLoadingBar(
              message: generationState.progressMessage ??
                  'Rotanız hazırlanıyor...',
              isDark: isDark,
            ),

          // ----------------------------------------------------------------
          // Bottom input bar / Generate button
          // ----------------------------------------------------------------
          if (!generationState.isLoading)
            _BottomInputBar(
              textController: _textController,
              isDark: isDark,
              isLoading: chatState.isLoading,
              isComplete: chatState.isComplete || chatState.currentStep > 4,
              extractedParams: chatState.extractedParams,
              onSend: (text) {
                ref.read(chatProvider.notifier).sendMessage(text);
                _textController.clear();
              },
              onGenerate: chatState.extractedParams != null
                  ? () => _onGenerateRoute(chatState.extractedParams!)
                  : null,
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // List building helpers
  // ---------------------------------------------------------------------------

  int _itemCount(ChatState s) {
    var count = s.messages.length;
    if (s.isLoading) count += 1; // typing indicator
    if (!s.isLoading && !s.isComplete && s.suggestions.isNotEmpty) {
      count += 1; // suggestion chips
    }
    return count;
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    ChatState s,
    bool isDark,
  ) {
    // Real messages
    if (index < s.messages.length) {
      return _AnimatedMessage(
        key: ValueKey('msg_$index'),
        child: ChatBubble(message: s.messages[index]),
      );
    }

    final extra = index - s.messages.length;

    // Typing indicator
    if (s.isLoading && extra == 0) {
      return _AnimatedMessage(
        key: const ValueKey('typing'),
        child: const ChatBubble.typing(),
      );
    }

    // Suggestion chips (only when not loading and not complete)
    if (!s.isLoading && !s.isComplete && s.suggestions.isNotEmpty) {
      if (extra == 0) {
        return _AnimatedMessage(
          key: ValueKey('chips_${s.currentStep}'),
          child: QuestionChips(
            suggestions: s.suggestions,
            onSelected: (text) =>
                ref.read(chatProvider.notifier).selectSuggestion(text),
            allowCustomInput: false,
            customInputHint: 'Şehir veya ülke yaz...',
          ),
        );
      }
    }

    return const SizedBox.shrink();
  }
}

// ---------------------------------------------------------------------------
// Error banner
// ---------------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.isRateLimit,
    required this.isDark,
    required this.onDismiss,
    this.onRetry,
  });

  final String message;
  final bool isRateLimit;
  final bool isDark;
  final VoidCallback onDismiss;

  /// When non-null a "Tekrar Dene" button is shown alongside the dismiss icon.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isRateLimit ? GeezColors.warning : GeezColors.error;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isRateLimit ? 0.12 : 0.1),
        borderRadius: BorderRadius.circular(GeezRadius.card),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isRateLimit
                    ? Icons.workspace_premium_rounded
                    : Icons.error_outline_rounded,
                color: accentColor,
                size: 20,
              ),
              const SizedBox(width: GeezSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: GeezTypography.bodySmall.copyWith(
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: isDark
                      ? GeezColors.textSecondaryDark
                      : GeezColors.textSecondary,
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: GeezSpacing.sm),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GeezSpacing.md,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(GeezRadius.button),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 14,
                      color: accentColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tekrar Dene',
                      style: GeezTypography.bodySmall.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Generation loading bar
// ---------------------------------------------------------------------------

class _GenerationLoadingBar extends StatelessWidget {
  const _GenerationLoadingBar({
    required this.message,
    required this.isDark,
  });

  final String message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? GeezColors.surfaceDark : GeezColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(GeezColors.primary),
            backgroundColor: Color(0xFFE3F2FD),
          ),
          const SizedBox(height: GeezSpacing.sm),
          Text(
            message,
            style: GeezTypography.bodySmall.copyWith(
              color: isDark
                  ? GeezColors.textSecondaryDark
                  : GeezColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom input bar
// ---------------------------------------------------------------------------

class _BottomInputBar extends StatelessWidget {
  const _BottomInputBar({
    required this.textController,
    required this.isDark,
    required this.isLoading,
    required this.isComplete,
    required this.extractedParams,
    required this.onSend,
    required this.onGenerate,
  });

  final TextEditingController textController;
  final bool isDark;
  final bool isLoading;
  final bool isComplete;
  final Map<String, dynamic>? extractedParams;
  final ValueChanged<String> onSend;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: GeezSpacing.md,
        right: GeezSpacing.sm,
        top: GeezSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + GeezSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? GeezColors.surfaceDark : GeezColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: isComplete
          ? _buildCompleteSection()
          : _buildTextInput(),
    );
  }

  Widget _buildTextInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: textController,
              enabled: !isLoading,
              style: GeezTypography.body.copyWith(
                color: isDark
                    ? GeezColors.textPrimaryDark
                    : GeezColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın...',
                hintStyle: GeezTypography.body.copyWith(
                  color: isDark
                      ? GeezColors.textSecondaryDark
                      : GeezColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onSend(value);
                }
              },
            ),
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: textController,
          builder: (context, value, _) {
            final hasText = value.text.trim().isNotEmpty;
            if (!hasText) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: GeezSpacing.xs),
                GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          final text = textController.text.trim();
                          if (text.isNotEmpty) {
                            onSend(text);
                          }
                        },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isLoading
                          ? GeezColors.primary.withValues(alpha: 0.4)
                          : GeezColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCompleteSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Extra notes input
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: textController,
                  style: GeezTypography.body.copyWith(
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Eklemek istediğin bir şey var mı?',
                    hintStyle: GeezTypography.bodySmall.copyWith(
                      color: isDark
                          ? GeezColors.textSecondaryDark
                          : GeezColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      onSend(value);
                    }
                  },
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: textController,
              builder: (context, value, _) {
                final hasText = value.text.trim().isNotEmpty;
                if (!hasText) return const SizedBox.shrink();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: GeezSpacing.xs),
                    GestureDetector(
                      onTap: () {
                        final text = textController.text.trim();
                        if (text.isNotEmpty) {
                          onSend(text);
                        }
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: GeezColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: GeezSpacing.sm),
        // Generate button
        GestureDetector(
          onTap: onGenerate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [GeezColors.primary, Color(0xFF1565C0)],
              ),
              borderRadius: BorderRadius.circular(GeezRadius.button),
              boxShadow: [
                BoxShadow(
                  color: GeezColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: GeezSpacing.sm),
                Text(
                  'Rotamı Oluştur',
                  style: GeezTypography.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Animated message wrapper (fade + slide in)
// ---------------------------------------------------------------------------

class _AnimatedMessage extends StatefulWidget {
  const _AnimatedMessage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<_AnimatedMessage> createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<_AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
