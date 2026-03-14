import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/auth/data/auth_repository.dart';
import 'package:geez_ai/features/auth/domain/auth_state.dart';

/// Provides the [AuthRepository] singleton.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.read(supabaseAuthProvider);
  return AuthRepository(auth);
});

/// Provides the current [AuthState], automatically updated on auth changes.
///
/// This is the single source of truth for "is the user logged in?"
/// Used by the router guard to decide where to redirect.
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthStateNotifier(repo);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._repo) : super(const AuthState.loading()) {
    _init();
  }

  final AuthRepository _repo;
  StreamSubscription<supa.AuthState>? _sub;

  void _init() {
    // Check if there is already a session from storage.
    final user = _repo.currentUser;
    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = const AuthState.unauthenticated();
    }

    // Listen for future auth state changes.
    _sub = _repo.authStateChanges.listen((event) {
      final session = event.session;
      if (session != null) {
        state = AuthState.authenticated(session.user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// Sign up and update state.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final response = await _repo.signUp(email: email, password: password);
      final user = response.user;
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        // Email confirmation required -- stay unauthenticated until confirmed.
        state = const AuthState.unauthenticated();
      }
    } on supa.AuthException catch (e) {
      state = AuthState.unauthenticated(errorMessage: e.message);
    } catch (e) {
      state = AuthState.unauthenticated(errorMessage: e.toString());
    }
  }

  /// Sign in and update state.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final response = await _repo.signIn(email: email, password: password);
      final user = response.user;
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated(
          errorMessage: 'Giriş başarısız. Lütfen tekrar deneyin.',
        );
      }
    } on supa.AuthException catch (e) {
      state = AuthState.unauthenticated(errorMessage: e.message);
    } catch (e) {
      state = AuthState.unauthenticated(errorMessage: e.toString());
    }
  }

  /// Sign out and update state.
  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState.unauthenticated();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
