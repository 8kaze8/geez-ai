import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/features/chat/data/chat_repository.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum RouteGenerationStatus { idle, loading, success, error }

class RouteGenerationState {
  const RouteGenerationState({
    this.status = RouteGenerationStatus.idle,
    this.progressMessage,
    this.routeId,
    this.errorMessage,
    this.errorType,
  });

  final RouteGenerationStatus status;

  /// Human-readable Turkish progress message shown during generation.
  final String? progressMessage;

  /// Non-null when [status] is [RouteGenerationStatus.success].
  final String? routeId;

  final String? errorMessage;
  final ChatErrorType? errorType;

  bool get isIdle => status == RouteGenerationStatus.idle;
  bool get isLoading => status == RouteGenerationStatus.loading;
  bool get isSuccess => status == RouteGenerationStatus.success;
  bool get isError => status == RouteGenerationStatus.error;

  RouteGenerationState copyWith({
    RouteGenerationStatus? status,
    String? progressMessage,
    String? routeId,
    String? errorMessage,
    ChatErrorType? errorType,
  }) =>
      RouteGenerationState(
        status: status ?? this.status,
        progressMessage: progressMessage ?? this.progressMessage,
        routeId: routeId ?? this.routeId,
        errorMessage: errorMessage ?? this.errorMessage,
        errorType: errorType ?? this.errorType,
      );
}

// ---------------------------------------------------------------------------
// Progress messages shown in sequence while the Edge Function runs
// ---------------------------------------------------------------------------

const _progressMessages = [
  'Rotanız hazırlanıyor...',
  'Mekanlar araştırılıyor...',
  'Yorumlar analiz ediliyor...',
  'Insider ipuçları ekleniyor...',
  'Rota optimize ediliyor...',
];

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class RouteGenerationNotifier extends StateNotifier<RouteGenerationState> {
  RouteGenerationNotifier(this._repo) : super(const RouteGenerationState());

  final ChatRepository _repo;

  Timer? _progressTimer;
  int _progressIndex = 0;

  /// Generates a route from [extractedParams] (received from the chat Edge
  /// Function when [isComplete] is `true`).
  ///
  /// Cycles through [_progressMessages] while the request is in-flight so the
  /// UI can display meaningful feedback.
  Future<String?> generate(Map<String, dynamic> extractedParams) async {
    if (state.isLoading) return null;

    _startProgressCycle();

    try {
      final response = await _repo.generateRoute(params: extractedParams);

      _stopProgressCycle();
      state = RouteGenerationState(
        status: RouteGenerationStatus.success,
        routeId: response.routeId,
      );
      return response.routeId;
    } on ChatException catch (e) {
      _stopProgressCycle();
      state = RouteGenerationState(
        status: RouteGenerationStatus.error,
        errorMessage: _turkishError(e),
        errorType: e.type,
      );
      return null;
    } catch (e) {
      _stopProgressCycle();
      state = RouteGenerationState(
        status: RouteGenerationStatus.error,
        errorMessage: 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.',
      );
      return null;
    }
  }

  void reset() {
    _stopProgressCycle();
    state = const RouteGenerationState();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _startProgressCycle() {
    _progressIndex = 0;
    state = RouteGenerationState(
      status: RouteGenerationStatus.loading,
      progressMessage: _progressMessages.first,
    );

    _progressTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _progressIndex =
          (_progressIndex + 1) % _progressMessages.length;
      if (state.isLoading) {
        state = RouteGenerationState(
          status: RouteGenerationStatus.loading,
          progressMessage: _progressMessages[_progressIndex],
        );
      }
    });
  }

  void _stopProgressCycle() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  String _turkishError(ChatException e) {
    return switch (e.type) {
      ChatErrorType.rateLimitExceeded =>
        'Bu ay için rota hakkınız doldu. Premium\'a geçerek sınırsız rota oluşturun.',
      ChatErrorType.validationError =>
        'Geçersiz rota parametreleri. Lütfen soruları tekrar yanıtlayın.',
      ChatErrorType.serverError =>
        'Sunucu hatası oluştu. Lütfen biraz bekleyip tekrar deneyin.',
      ChatErrorType.networkError =>
        'İnternet bağlantısı kurulamadı. Bağlantınızı kontrol edin.',
    };
  }

  @override
  void dispose() {
    _stopProgressCycle();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final routeGenerationProvider = StateNotifierProvider.autoDispose<
    RouteGenerationNotifier, RouteGenerationState>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return RouteGenerationNotifier(repo);
});
