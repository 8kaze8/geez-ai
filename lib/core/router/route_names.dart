/// Centralised route path constants.
///
/// Use these instead of hardcoded strings so that typos are caught at
/// compile time and rename-refactors propagate automatically.
class RoutePaths {
  RoutePaths._();

  // Auth
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';

  // Onboarding
  static const onboarding = '/onboarding';

  // Main tabs (inside ShellRoute)
  static const home = '/';
  static const explore = '/explore';
  static const newRoute = '/new-route';
  static const passport = '/passport';
  static const profile = '/profile';

  // Detail screens (inside ShellRoute but nav hidden)
  static const routeLoading = '/route-loading';

  /// Base path — use [routeDetailPath] to build a navigable URI.
  static const routeDetail = '/route/:routeId';

  /// Builds the navigable path for a specific route.
  ///
  /// Usage: `context.go(RoutePaths.routeDetailPath(routeId));`
  static String routeDetailPath(String routeId) => '/route/$routeId';

  // Post-trip feedback
  /// Base path — use [feedbackPath] to build a navigable URI.
  static const feedback = '/feedback/:routeId';

  /// Builds the navigable path for the feedback screen.
  ///
  /// Usage: `context.go(RoutePaths.feedbackPath(routeId));`
  static String feedbackPath(String routeId) => '/feedback/$routeId';
}
