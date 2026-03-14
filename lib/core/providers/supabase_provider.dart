import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides the global [SupabaseClient] instance.
///
/// Initialized in `main()` via `Supabase.initialize()`.
/// Use this provider everywhere instead of accessing `Supabase.instance` directly
/// so that dependencies are explicit and testable.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provides the [GoTrueClient] for auth operations.
///
/// Shortcut to avoid `ref.read(supabaseClientProvider).auth` everywhere.
final supabaseAuthProvider = Provider<GoTrueClient>((ref) {
  return ref.read(supabaseClientProvider).auth;
});
