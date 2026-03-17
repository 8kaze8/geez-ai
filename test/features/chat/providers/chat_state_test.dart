import 'package:flutter_test/flutter_test.dart';
import 'package:geez_ai/features/chat/data/chat_repository.dart';
import 'package:geez_ai/features/chat/domain/chat_message_model.dart';
import 'package:geez_ai/features/chat/presentation/providers/chat_provider.dart';

void main() {
  group('ChatState — default values', () {
    test('initial state has expected defaults', () {
      const state = ChatState();

      expect(state.messages, isEmpty);
      expect(state.currentStep, 0);
      expect(state.suggestions, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.isComplete, isFalse);
      expect(state.extractedParams, isNull);
      expect(state.errorMessage, isNull);
      expect(state.errorType, isNull);
      expect(state.lastFailedMessage, isNull);
    });
  });

  group('ChatState.hasError', () {
    test('returns false when errorMessage is null', () {
      const state = ChatState();
      expect(state.hasError, isFalse);
    });

    test('returns true when errorMessage is set', () {
      const state = ChatState(errorMessage: 'Something went wrong');
      expect(state.hasError, isTrue);
    });
  });

  group('ChatState.canRetry', () {
    test('returns false when there is no error', () {
      const state = ChatState();
      expect(state.canRetry, isFalse);
    });

    test('returns false when errorMessage is set but lastFailedMessage is null', () {
      const state = ChatState(errorMessage: 'error');
      expect(state.canRetry, isFalse);
    });

    test('returns false when error type is rateLimitExceeded', () {
      const state = ChatState(
        errorMessage: 'Rate limit',
        errorType: ChatErrorType.rateLimitExceeded,
        lastFailedMessage: 'İstanbul',
      );
      expect(state.canRetry, isFalse);
    });

    test('returns true for retryable error types', () {
      for (final type in ChatErrorType.values) {
        if (type == ChatErrorType.rateLimitExceeded) continue;

        final state = ChatState(
          errorMessage: 'error',
          errorType: type,
          lastFailedMessage: 'İstanbul',
        );
        expect(
          state.canRetry,
          isTrue,
          reason: 'Expected canRetry=true for errorType=$type',
        );
      }
    });
  });

  group('ChatState.copyWith', () {
    test('preserves unchanged fields', () {
      final msg = ChatMessageModel.user('hello');
      final original = ChatState(
        messages: [msg],
        currentStep: 2,
        suggestions: const ['a', 'b'],
        isLoading: true,
        isComplete: false,
        extractedParams: const {'city': 'Istanbul'},
        errorMessage: 'err',
        errorType: ChatErrorType.networkError,
        lastFailedMessage: 'retry me',
      );

      final copy = original.copyWith(currentStep: 3);

      expect(copy.messages, same(original.messages));
      expect(copy.currentStep, 3);
      expect(copy.suggestions, same(original.suggestions));
      expect(copy.isLoading, original.isLoading);
      expect(copy.isComplete, original.isComplete);
      expect(copy.extractedParams, original.extractedParams);
      expect(copy.errorMessage, original.errorMessage);
      expect(copy.errorType, original.errorType);
      expect(copy.lastFailedMessage, original.lastFailedMessage);
    });

    test('clearError resets errorMessage, errorType and lastFailedMessage', () {
      const state = ChatState(
        errorMessage: 'some error',
        errorType: ChatErrorType.serverError,
        lastFailedMessage: 'failed text',
      );

      final cleared = state.copyWith(clearError: true);

      expect(cleared.errorMessage, isNull);
      expect(cleared.errorType, isNull);
      expect(cleared.lastFailedMessage, isNull);
    });

    test('can update isLoading independently', () {
      const state = ChatState(isLoading: false);
      final loading = state.copyWith(isLoading: true);
      expect(loading.isLoading, isTrue);
    });

    test('can set isComplete and extractedParams together', () {
      const state = ChatState();
      final done = state.copyWith(
        isComplete: true,
        extractedParams: {'city': 'Paris', 'style': 'culture'},
      );
      expect(done.isComplete, isTrue);
      expect(done.extractedParams, {'city': 'Paris', 'style': 'culture'});
    });

    test('updating messages replaces the list', () {
      final msg1 = ChatMessageModel.assistant('Hi');
      final msg2 = ChatMessageModel.user('Hello');

      final state = ChatState(messages: [msg1]);
      final updated = state.copyWith(messages: [msg1, msg2]);

      expect(updated.messages.length, 2);
      expect(updated.messages.last.content, 'Hello');
    });
  });

  group('ChatErrorType', () {
    test('all expected error types are defined', () {
      expect(ChatErrorType.values, containsAll([
        ChatErrorType.rateLimitExceeded,
        ChatErrorType.validationError,
        ChatErrorType.serverError,
        ChatErrorType.networkError,
        ChatErrorType.unauthorized,
      ]));
    });
  });

  group('ChatException', () {
    test('toString includes type name and message', () {
      const ex = ChatException(
        type: ChatErrorType.networkError,
        message: 'connection refused',
      );
      expect(ex.toString(), contains('networkError'));
      expect(ex.toString(), contains('connection refused'));
    });
  });
}
