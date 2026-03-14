import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/data/base_repository.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';

/// Home-screen specific queries that aggregate data from multiple tables.
///
/// Maps to:
///   - `public.routes`       — active + recent completed routes
///   - `public.usage_tracking` — monthly usage counters
class HomeRepository extends BaseRepository {
  const HomeRepository(super.client);

  // ---------------------------------------------------------------------------
  // Routes
  // ---------------------------------------------------------------------------

  /// Returns the single active route for [userId] (status = 'active'),
  /// ordered newest first. Returns `null` when no active route exists.
  Future<RouteModel?> getActiveRoute(String userId) async {
    try {
      final row = await client
          .from('routes')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;
      return RouteModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'getActiveRoute($userId)',
        cause: e,
      );
    }
  }

  /// Returns up to [limit] completed routes for [userId], most recent first.
  Future<List<RouteModel>> getRecentRoutes(
    String userId, {
    int limit = 3,
  }) async {
    try {
      final rows = await client
          .from('routes')
          .select()
          .eq('user_id', userId)
          .eq('status', 'completed')
          .order('completed_at', ascending: false)
          .limit(limit);
      return (rows as List<dynamic>)
          .map((row) => RouteModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'getRecentRoutes($userId)',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Usage tracking
  // ---------------------------------------------------------------------------

  /// Returns usage stats for [userId] for the current calendar month,
  /// or `null` when no row exists yet (first month, no routes generated).
  Future<UsageStats?> getUsageStats(String userId) async {
    final now = DateTime.now().toUtc();
    try {
      final row = await client
          .from('usage_tracking')
          .select('routes_generated, routes_limit, tier_at_period_start')
          .eq('user_id', userId)
          .eq('period_year', now.year)
          .eq('period_month', now.month)
          .maybeSingle();
      if (row == null) return null;
      return UsageStats(
        routesGenerated: (row['routes_generated'] as num).toInt(),
        routesLimit: (row['routes_limit'] as num).toInt(),
        tier: row['tier_at_period_start'] as String? ?? 'free',
      );
    } catch (e) {
      throw RepositoryException(
        table: 'usage_tracking',
        operation: 'getUsageStats($userId)',
        cause: e,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Value types
// ---------------------------------------------------------------------------

/// Monthly usage counters returned by [HomeRepository.getUsageStats].
class UsageStats {
  const UsageStats({
    required this.routesGenerated,
    required this.routesLimit,
    required this.tier,
  });

  final int routesGenerated;
  final int routesLimit;

  /// Subscription tier snapshot at period start: `'free'` or `'premium'`.
  final String tier;

  int get remaining => (routesLimit - routesGenerated).clamp(0, routesLimit);

  bool get isAtLimit => routesGenerated >= routesLimit;
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(supabaseClientProvider));
});
