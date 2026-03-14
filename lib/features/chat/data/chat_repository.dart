import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/chat/domain/chat_message_model.dart';

// ---------------------------------------------------------------------------
// Typed response models
// ---------------------------------------------------------------------------

/// Parsed response from the `/chat` Edge Function.
class ChatResponse {
  const ChatResponse({
    required this.message,
    required this.currentStep,
    required this.suggestions,
    required this.isComplete,
    this.extractedParams,
  });

  final String message;
  final int currentStep;
  final List<String> suggestions;
  final bool isComplete;
  final Map<String, dynamic>? extractedParams;

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final rawSuggestions = json['suggestions'];
    final suggestions = rawSuggestions is List
        ? rawSuggestions.map((e) => e.toString()).toList()
        : <String>[];

    return ChatResponse(
      message: json['message'] as String? ?? '',
      currentStep: json['currentStep'] as int? ?? 0,
      suggestions: suggestions,
      isComplete: json['isComplete'] as bool? ?? false,
      extractedParams: json['extractedParams'] as Map<String, dynamic>?,
    );
  }
}

/// Parsed response from the `/generate-route` Edge Function.
class GenerateRouteResponse {
  const GenerateRouteResponse({
    required this.routeId,
    required this.city,
    required this.country,
    required this.days,
  });

  final String routeId;
  final String city;
  final String country;
  final List<dynamic> days;

  factory GenerateRouteResponse.fromJson(Map<String, dynamic> json) {
    return GenerateRouteResponse(
      routeId: json['routeId'] as String,
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      days: json['days'] as List<dynamic>? ?? [],
    );
  }
}

// ---------------------------------------------------------------------------
// Error types
// ---------------------------------------------------------------------------

/// Categorised errors surfaced by [ChatRepository].
enum ChatErrorType {
  /// HTTP 429 — free tier rate limit exceeded.
  rateLimitExceeded,

  /// HTTP 400 — invalid request parameters.
  validationError,

  /// HTTP 500 or Edge Function failure.
  serverError,

  /// No network / connection refused.
  networkError,
}

class ChatException implements Exception {
  const ChatException({required this.type, required this.message});

  final ChatErrorType type;
  final String message;

  @override
  String toString() => 'ChatException[${type.name}]: $message';
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class ChatRepository {
  const ChatRepository(this._client);

  final SupabaseClient _client;

  /// Sends the current [messages] and [currentStep] to the `/chat` Edge
  /// Function and returns a typed [ChatResponse].
  Future<ChatResponse> sendMessage({
    required List<ChatMessageModel> messages,
    required int currentStep,
    String language = 'tr',
  }) async {
    try {
      final response = await _client.functions.invoke(
        'chat',
        body: {
          'messages': messages.map((m) => m.toJson()).toList(),
          'currentStep': currentStep,
          'language': language,
        },
      );

      _assertSuccess(response);

      final data = response.data as Map<String, dynamic>;
      return ChatResponse.fromJson(data);
    } on ChatException {
      rethrow;
    } catch (e) {
      throw ChatException(
        type: ChatErrorType.networkError,
        message: e.toString(),
      );
    }
  }

  /// Calls the `/generate-route` Edge Function with [params] extracted from
  /// the completed Q&A flow and returns a typed [GenerateRouteResponse].
  Future<GenerateRouteResponse> generateRoute({
    required Map<String, dynamic> params,
    String language = 'tr',
  }) async {
    try {
      final body = Map<String, dynamic>.from(params)..['language'] = language;

      final response = await _client.functions.invoke(
        'generate-route',
        body: body,
      );

      _assertSuccess(response);

      final data = response.data as Map<String, dynamic>;
      return GenerateRouteResponse.fromJson(data);
    } on ChatException {
      rethrow;
    } catch (e) {
      throw ChatException(
        type: ChatErrorType.networkError,
        message: e.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _assertSuccess(FunctionResponse response) {
    final status = response.status;
    if (status == 200 || status == 201) return;

    if (status == 429) {
      throw const ChatException(
        type: ChatErrorType.rateLimitExceeded,
        message: 'Rate limit exceeded',
      );
    }
    if (status == 400) {
      throw const ChatException(
        type: ChatErrorType.validationError,
        message: 'Validation error',
      );
    }
    throw ChatException(
      type: ChatErrorType.serverError,
      message: 'Server error: $status',
    );
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(supabaseClientProvider));
});
