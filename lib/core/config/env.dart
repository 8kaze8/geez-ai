/// Compile-time environment configuration for Geez AI.
///
/// Values are injected at build time via `--dart-define` flags.
/// No secrets are bundled inside the app binary or asset bundle.
///
/// Build examples:
///   flutter run \
///     --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=eyJ...
///
///   flutter build apk \
///     --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=eyJ...
///
/// In CI, pass the values through environment secrets injected as
/// `--dart-define` arguments — never commit real values to version control.
class Env {
  Env._();

  // ---------------------------------------------------------------------------
  // Supabase
  // ---------------------------------------------------------------------------

  /// Supabase project URL (e.g. https://abcdefgh.supabase.co).
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Supabase anon/public key — safe to ship in the client, but must not be
  /// bundled as a plaintext asset (APK/IPA extraction risk).
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  /// Returns true when all required compile-time values are present.
  ///
  /// Call this in main() to catch misconfigured builds early.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
