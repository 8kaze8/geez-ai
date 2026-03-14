import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository that wraps Supabase GoTrue auth operations.
///
/// All auth calls go through this class so they can be tested
/// and swapped out without touching UI code.
class AuthRepository {
  const AuthRepository(this._auth);

  final GoTrueClient _auth;

  /// The currently signed-in user, or `null`.
  User? get currentUser => _auth.currentUser;

  /// The current session, or `null`.
  Session? get currentSession => _auth.currentSession;

  /// Stream of [AuthState] changes (sign in, sign out, token refresh).
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  /// Sign up with email and password.
  ///
  /// On success, Supabase also fires the `trg_on_auth_user_created` trigger
  /// which creates the `public.users`, `user_profiles`, and `travel_personas` rows.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return _auth.signUp(email: email, password: password);
  }

  /// Sign in with email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithPassword(email: email, password: password);
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send a password reset email.
  Future<void> resetPassword({required String email}) async {
    await _auth.resetPasswordForEmail(email);
  }
}
