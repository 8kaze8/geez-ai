import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/features/chat/data/chat_repository.dart';
import 'package:geez_ai/features/chat/domain/chat_message_model.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class ChatState {
  const ChatState({
    this.messages = const [],
    this.currentStep = 0,
    this.suggestions = const [],
    this.isLoading = false,
    this.isComplete = false,
    this.extractedParams,
    this.errorMessage,
    this.errorType,
  });

  final List<ChatMessageModel> messages;

  /// Mirrors `currentStep` from the Edge Function response.
  /// 0=city, 1=style, 2=transport, 3=budget, 4=duration, 5+=complete.
  final int currentStep;

  /// Quick-reply chips from the last Edge Function response.
  final List<String> suggestions;

  /// True while waiting for a response from the Edge Function.
  final bool isLoading;

  /// True once the Edge Function reports `isComplete = true`.
  final bool isComplete;

  /// Non-null when [isComplete] is true — passed to generate-route.
  final Map<String, dynamic>? extractedParams;

  final String? errorMessage;
  final ChatErrorType? errorType;

  bool get hasError => errorMessage != null;

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    int? currentStep,
    List<String>? suggestions,
    bool? isLoading,
    bool? isComplete,
    Map<String, dynamic>? extractedParams,
    String? errorMessage,
    ChatErrorType? errorType,
    bool clearError = false,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        currentStep: currentStep ?? this.currentStep,
        suggestions: suggestions ?? this.suggestions,
        isLoading: isLoading ?? this.isLoading,
        isComplete: isComplete ?? this.isComplete,
        extractedParams: extractedParams ?? this.extractedParams,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        errorType: clearError ? null : (errorType ?? this.errorType),
      );
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._repo) : super(const ChatState()) {
    _sendWelcome();
  }

  final ChatRepository _repo;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// User typed or selected [text] — adds the user bubble then calls /chat.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMessage = ChatMessageModel.user(trimmed);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      suggestions: [],
      clearError: true,
    );

    await _callChat(userMessage);
  }

  /// Tapping a suggestion chip — delegates to [sendMessage].
  Future<void> selectSuggestion(String text) => sendMessage(text);

  /// Resets the conversation so the user can start a new route.
  void reset() {
    state = const ChatState();
    _sendWelcome();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Bootstraps the conversation with the opening assistant greeting without
  /// making a real network call — keeps the welcome instant.
  void _sendWelcome() {
    const greeting = 'Merhaba! Ben Geez, seyahat asistanın. ✈️\n\n'
        'Sana özel bir rota hazırlamam için birkaç soru soracağım. '
        'Hadi başlayalım!\n\nNereye gitmek istiyorsun?';
    state = state.copyWith(
      messages: [ChatMessageModel.assistant(greeting)],
      suggestions: ['İstanbul', 'Paris', 'Roma', 'Tokyo', 'Barcelona'],
      currentStep: 0,
    );
  }

  /// Sends [userMessage] to the /chat Edge Function and applies the response
  /// to [state].
  Future<void> _callChat(ChatMessageModel userMessage) async {
    try {
      final response = await _repo.sendMessage(
        messages: state.messages,
        currentStep: state.currentStep,
      );

      final assistantMessage = ChatMessageModel.assistant(response.message);

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        currentStep: response.currentStep,
        suggestions: response.suggestions,
        isLoading: false,
        isComplete: response.isComplete,
        extractedParams: response.extractedParams ?? state.extractedParams,
      );
    } on ChatException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _turkishError(e),
        errorType: e.type,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.',
      );
    }
  }

  String _turkishError(ChatException e) {
    return switch (e.type) {
      ChatErrorType.rateLimitExceeded =>
        'Bu ay için rota hakkınız doldu. Premium\'a geçerek sınırsız rota oluşturun.',
      ChatErrorType.validationError =>
        'Geçersiz giriş. Lütfen tekrar deneyin.',
      ChatErrorType.serverError =>
        'Sunucu hatası oluştu. Lütfen biraz bekleyip tekrar deneyin.',
      ChatErrorType.networkError =>
        'İnternet bağlantısı kurulamadı. Bağlantınızı kontrol edin.',
    };
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final chatProvider =
    StateNotifierProvider.autoDispose<ChatNotifier, ChatState>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repo);
});
