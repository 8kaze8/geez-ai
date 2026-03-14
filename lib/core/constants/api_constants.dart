/// API endpoint paths and timeout constants.
///
/// Supabase URL and keys are loaded from `.env` via `flutter_dotenv`
/// in `main.dart`. This class only holds path suffixes and timeouts.
class ApiConstants {
  ApiConstants._();

  // --- API Endpoints (path suffixes, appended to SUPABASE_URL) -----------

  // Routes
  static const String routesPath = '/rest/v1/routes';
  static const String routeStopsPath = '/rest/v1/route_stops';
  static const String routeGeneratePath = '/functions/v1/generate-route';

  // Feedback
  static const String feedbackPath = '/rest/v1/trip_feedback';
  static const String feedbackSubmitPath = '/functions/v1/submit-feedback';

  // User & Profile
  static const String usersPath = '/rest/v1/users';
  static const String profilePath = '/rest/v1/user_profiles';
  static const String personaPath = '/rest/v1/travel_personas';

  // Passport & Stamps
  static const String passportStampsPath = '/rest/v1/passport_stamps';
  static const String visitedPlacesPath = '/rest/v1/visited_places';

  // AI Chat
  static const String chatPath = '/functions/v1/chat';
  static const String memoryInsightPath = '/functions/v1/memory-insight';

  // Cache
  static const String aiRouteCachePath = '/rest/v1/ai_route_cache';

  // Subscriptions
  static const String subscriptionsPath = '/rest/v1/subscriptions';
  static const String usageTrackingPath = '/rest/v1/usage_tracking';

  // --- Timeouts ----------------------------------------------------------

  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration routeGenerationTimeout = Duration(seconds: 60);
  static const Duration chatTimeout = Duration(seconds: 45);

  // --- Pagination --------------------------------------------------------

  static const int defaultPageSize = 20;
  static const int explorePageSize = 10;
}
