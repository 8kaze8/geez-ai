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
    // C-9: Check both session existence AND expiry before granting access.
    // An expired session means the refresh token also failed (or was never
    // attempted), so we treat it the same as having no session at all.
    final session = _repo.currentSession;
    if (session != null && !session.isExpired) {
      state = AuthState.authenticated(session.user);
    } else {
      state = const AuthState.unauthenticated();
    }

    _sub = _repo.authStateChanges.listen((event) {
      final incoming = event.session;

      // When a token refresh fails, Supabase fires signedOut with a null
      // session — the null branch below already handles that correctly.
      // We also guard against receiving an already-expired session object
      // (e.g. from an initialSession event before refresh completes).
      if (incoming != null && !incoming.isExpired) {
        state = AuthState.authenticated(incoming.user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  // H-18: Maps Supabase AuthException error codes to user-facing Turkish
  // messages so the UI never displays raw English API errors.
  String _authErrorMessage(supa.AuthException e) {
    switch (e.code) {
      case 'email_exists':
      case 'user_already_exists':
        return 'Bu e-posta adresi zaten kullanımda.';
      case 'invalid_credentials':
      case 'user_not_found':
        return 'E-posta veya şifre hatalı.';
      case 'email_not_confirmed':
        return 'E-posta adresiniz henüz doğrulanmadı. Lütfen gelen kutunuzu kontrol edin.';
      case 'weak_password':
        return 'Şifre çok zayıf. Lütfen daha güçlü bir şifre seçin.';
      case 'over_request_rate_limit':
      case 'over_email_send_rate_limit':
        return 'Çok fazla deneme yaptınız. Lütfen bir süre bekleyin.';
      case 'signup_disabled':
        return 'Yeni kayıt şu anda kapalı. Lütfen daha sonra tekrar deneyin.';
      case 'user_banned':
        return 'Hesabınız askıya alınmıştır.';
      case 'session_not_found':
      case 'bad_jwt':
        return 'Oturumunuz sona erdi. Lütfen tekrar giriş yapın.';
      default:
        return 'Bir sorun oluştu. Lütfen tekrar deneyin.';
    }
  }

  /// Sign up and update state.
  ///
  /// Only transitions to authenticated when [response.session] is non-null,
  /// meaning the user has a valid JWT. When email confirmation is required,
  /// Supabase returns a user but no session — we stay unauthenticated until
  /// the confirmation link is clicked and the session is issued.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final response = await _repo.signUp(email: email, password: password);
      final session = response.session;
      if (session != null) {
        state = AuthState.authenticated(session.user);
      } else {
        // Email confirmation required — no session yet.
        state = const AuthState.unauthenticated();
      }
    } on supa.AuthException catch (e) {
      state = AuthState.unauthenticated(errorMessage: _authErrorMessage(e));
    } catch (_) {
      state = const AuthState.unauthenticated(
        errorMessage: 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.',
      );
    }
  }

  /// Sign in and update state.
  ///
  /// Only transitions to authenticated when [response.session] is non-null.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final response = await _repo.signIn(email: email, password: password);
      final session = response.session;
      if (session != null) {
        state = AuthState.authenticated(session.user);
      } else {
        state = const AuthState.unauthenticated(
          errorMessage: 'Giriş başarısız. Lütfen tekrar deneyin.',
        );
      }
    } on supa.AuthException catch (e) {
      state = AuthState.unauthenticated(errorMessage: _authErrorMessage(e));
    } catch (_) {
      state = const AuthState.unauthenticated(
        errorMessage: 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.',
      );
    }
  }

  /// Sign out and update state.
  Future<void> signOut() async {
    try {
      await _repo.signOut();
    } catch (_) {
      // Ignore signOut errors — always transition to unauthenticated.
    } finally {
      state = const AuthState.unauthenticated();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
