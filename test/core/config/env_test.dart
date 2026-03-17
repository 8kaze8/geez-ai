import 'package:flutter_test/flutter_test.dart';
import 'package:geez_ai/core/config/env.dart';

void main() {
  group('Env', () {
    test('isConfigured returns false when no dart-defines are provided', () {
      // When compiled without --dart-define flags, String.fromEnvironment
      // returns an empty string. Both supabaseUrl and supabaseAnonKey will be
      // empty, so isConfigured must be false.
      expect(Env.supabaseUrl, isEmpty);
      expect(Env.supabaseAnonKey, isEmpty);
      expect(Env.isConfigured, isFalse);
    });

    test('supabaseUrl is a compile-time constant (const field)', () {
      // Verifying that reading the value twice returns the identical object —
      // const Strings are canonicalised by the Dart VM.
      const a = Env.supabaseUrl;
      const b = Env.supabaseUrl;
      expect(identical(a, b), isTrue);
    });

    test('supabaseAnonKey is a compile-time constant (const field)', () {
      const a = Env.supabaseAnonKey;
      const b = Env.supabaseAnonKey;
      expect(identical(a, b), isTrue);
    });

    test('isConfigured requires both url and key to be non-empty', () {
      // The logic is: supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty
      // Without dart-defines both are empty — so the result is false.
      final result = Env.supabaseUrl.isNotEmpty && Env.supabaseAnonKey.isNotEmpty;
      expect(result, equals(Env.isConfigured));
    });
  });
}
