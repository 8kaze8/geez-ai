class ApiConstants {
  ApiConstants._();

  // ─── Supabase ─────────────────────────────────────────────────
  // These should be loaded from environment variables in production.
  // Use --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=...
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // ─── API Endpoints ────────────────────────────────────────────

  // Routes
  static const String routesPath = '/rest/v1/routes';
  static const String routeStopsPath = '/rest/v1/route_stops';
  static const String routeGeneratePath = '/functions/v1/generate-route';

  // Feedback
  static const String feedbackPath = '/rest/v1/feedback';
  static const String feedbackSubmitPath = '/functions/v1/submit-feedback';

  // User & Profile
  static const String profilePath = '/rest/v1/profiles';
  static const String personaPath = '/rest/v1/travel_personas';
  static const String discoveryScorePath = '/rest/v1/discovery_scores';

  // Passport & Stamps
  static const String passportPath = '/rest/v1/passports';
  static const String stampsPath = '/rest/v1/stamps';

  // AI Chat
  static const String chatPath = '/functions/v1/chat';
  static const String memoryInsightPath = '/functions/v1/memory-insight';

  // Explore
  static const String trendingRoutesPath = '/rest/v1/trending_routes';
  static const String collectionsPath = '/rest/v1/collections';

  // ─── Timeouts ─────────────────────────────────────────────────
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration routeGenerationTimeout = Duration(seconds: 60);
  static const Duration chatTimeout = Duration(seconds: 45);

  // ─── Pagination ───────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int explorePageSize = 10;
}
