import 'package:supabase_flutter/supabase_flutter.dart';

/// Represents the current authentication state of the app.
///
/// Used by [authStateProvider] to drive router redirects and UI changes.
enum AuthStatus {
  /// Initial state -- checking stored session.
  loading,

  /// User is authenticated and has a valid session.
  authenticated,

  /// No valid session exists.
  unauthenticated,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  const AuthState.authenticated(User this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  const AuthState.unauthenticated({this.errorMessage})
      : status = AuthStatus.unauthenticated,
        user = null;

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}
