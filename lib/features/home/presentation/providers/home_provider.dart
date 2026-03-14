import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/constants/gamification_constants.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/auth/data/user_repository.dart';
import 'package:geez_ai/features/home/data/home_repository.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/features/passport/domain/travel_persona_model.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// All data the Home screen needs, fetched in a single provider build.
class HomeData {
  const HomeData({
    required this.displayName,
    this.activeRoute,
    required this.recentRoutes,
    this.persona,
    this.usageStats,
  });

  /// First name to show in the greeting header.
  final String displayName;

  /// The user's current active route (status = 'active'), or null.
  final RouteModel? activeRoute;

  /// Up to 3 most recently completed routes.
  final List<RouteModel> recentRoutes;

  /// Travel persona for discovery score + tier display. Null for new users.
  final TravelPersonaModel? persona;

  /// Monthly usage stats. Null when no routes have been generated yet.
  final UsageStats? usageStats;

  // ---------------------------------------------------------------------------
  // Derived display values
  // ---------------------------------------------------------------------------

  /// Discovery score from the persona, 0 when no persona exists yet.
  int get discoveryScore => persona?.discoveryScore ?? 0;

  /// Turkish-localised tier label.
  String get tierLabel =>
      GamificationConstants.tierLabels[persona?.explorerTier.toLowerCase()] ??
      'Turist';

  /// Tier to display as the "next" goal above the current tier.
  String get nextTierLabel {
    const tiers = ['tourist', 'traveler', 'explorer', 'local', 'legend'];
    final current = persona?.explorerTier.toLowerCase() ?? 'tourist';
    final index = tiers.indexOf(current);
    if (index < 0 || index >= tiers.length - 1) return 'Gezgin';
    return GamificationConstants.tierLabels[tiers[index + 1]] ?? 'Gezgin';
  }

  /// Points remaining to reach the next tier, based on canonical thresholds.
  int get pointsToNextTier {
    final score = discoveryScore;
    const thresholds = [200, 500, 1000, 2500];
    for (final t in thresholds) {
      if (score < t) return t - score;
    }
    return 0;
  }

  /// Progress (0.0 – 1.0) within the current tier band.
  double get tierProgress => GamificationConstants.progressForScore(discoveryScore);

  /// Whether this user has no routes yet (true for brand-new users).
  bool get isNewUser =>
      activeRoute == null && recentRoutes.isEmpty;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async {
    final authState = ref.watch(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) {
      throw Exception('Kullan\u0131c\u0131 oturumu bulunamad\u0131.');
    }

    final userId = authState.user!.id;
    final userRepo = ref.read(userRepositoryProvider);
    final homeRepo = ref.read(homeRepositoryProvider);

    // Fire all requests in parallel for speed.
    final (user, activeRoute, recentRoutes, persona, usageStats) = await (
      userRepo.getUser(userId),
      homeRepo.getActiveRoute(userId),
      homeRepo.getRecentRoutes(userId),
      userRepo.getPersona(userId),
      homeRepo.getUsageStats(userId),
    ).wait;

    // Derive display name from the users table, fall back to email prefix.
    String displayName;
    if (user != null &&
        user.displayName != null &&
        user.displayName!.isNotEmpty) {
      displayName = user.displayName!;
    } else if (user != null) {
      final at = user.email.indexOf('@');
      displayName = at > 0 ? user.email.substring(0, at) : user.email;
    } else {
      displayName = 'Gezgin';
    }

    return HomeData(
      displayName: displayName,
      activeRoute: activeRoute,
      recentRoutes: recentRoutes,
      persona: persona,
      usageStats: usageStats,
    );
  }

  /// Refreshes all Home screen data from Supabase.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final homeProvider =
    AsyncNotifierProvider<HomeNotifier, HomeData>(HomeNotifier.new);
