import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/data/base_repository.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/features/route/domain/route_stop_model.dart';

/// Repository for AI-generated travel routes and their stops.
///
/// Maps to:
///   - `public.routes`
///   - `public.route_stops`
///
/// Soft delete policy: `status = 'deleted'` — never issue a real DELETE.
/// All list queries exclude deleted rows automatically.
class RouteRepository extends BaseRepository {
  const RouteRepository(super.client);

  // ---------------------------------------------------------------------------
  // routes
  // ---------------------------------------------------------------------------

  /// Returns all non-deleted routes for [userId].
  ///
  /// Pass [status] to filter to a specific lifecycle value
  /// (`'draft'`, `'active'`, or `'completed'`).
  /// Results are sorted newest-first.
  Future<List<RouteModel>> getUserRoutes(
    String userId, {
    String? status,
  }) async {
    try {
      var query = client
          .from('routes')
          .select()
          .eq('user_id', userId)
          .neq('status', 'deleted');

      if (status != null) {
        query = query.eq('status', status);
      }

      final rows = await query.order('created_at', ascending: false);
      return (rows as List<dynamic>)
          .map((row) => RouteModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'getUserRoutes($userId)',
        cause: e,
      );
    }
  }

  /// Returns the full [RouteModel] for [routeId], or `null` if not found
  /// or already soft-deleted.
  Future<RouteModel?> getRouteDetail(String routeId) async {
    try {
      final row = await client
          .from('routes')
          .select()
          .eq('id', routeId)
          .neq('status', 'deleted')
          .maybeSingle();
      if (row == null) return null;
      return RouteModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'getRouteDetail($routeId)',
        cause: e,
      );
    }
  }

  /// Returns all stops for [routeId] ordered by [stop_order] ascending.
  Future<List<RouteStopModel>> getRouteStops(String routeId) async {
    try {
      final rows = await client
          .from('route_stops')
          .select()
          .eq('route_id', routeId)
          .order('stop_order', ascending: true);
      return (rows as List<dynamic>)
          .map(
            (row) =>
                RouteStopModel.fromJson(row as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw RepositoryException(
        table: 'route_stops',
        operation: 'getRouteStops($routeId)',
        cause: e,
      );
    }
  }

  /// Inserts a new route and returns the persisted [RouteModel]
  /// (with the server-generated `id` and timestamps).
  Future<RouteModel> createRoute(RouteModel route) async {
    try {
      final row =
          await client.from('routes').insert(route.toJson()).select().single();
      return RouteModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'createRoute',
        cause: e,
      );
    }
  }

  /// Transitions [routeId] to [status].
  ///
  /// Valid values: `'draft'`, `'active'`, `'completed'`, `'deleted'`.
  /// The DB trigger `trg_routes_set_completed_at` auto-sets
  /// `completed_at` when [status] is `'completed'`.
  Future<void> updateRouteStatus(String routeId, String status) async {
    try {
      await client
          .from('routes')
          .update({'status': status})
          .eq('id', routeId);
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'updateRouteStatus($routeId, $status)',
        cause: e,
      );
    }
  }

  /// Activates [routeId] and ensures only one active route exists at a time.
  ///
  /// Any route currently in `'active'` state for the same user is moved back
  /// to `'draft'` before [routeId] is transitioned to `'active'`.
  ///
  /// Pass [userId] so we can scope the "deactivate previous" query to the
  /// correct user without an extra fetch.
  Future<void> activateRoute(String routeId, String userId) async {
    try {
      // Move any existing active route back to draft.
      await client
          .from('routes')
          .update({'status': 'draft'})
          .eq('user_id', userId)
          .eq('status', 'active')
          .neq('id', routeId);

      // Activate the requested route.
      await updateRouteStatus(routeId, 'active');
    } catch (e) {
      throw RepositoryException(
        table: 'routes',
        operation: 'activateRoute($routeId)',
        cause: e,
      );
    }
  }

  /// Transitions [routeId] to `'completed'`.
  ///
  /// The DB trigger `trg_routes_set_completed_at` auto-sets `completed_at`.
  Future<void> completeRoute(String routeId) async {
    await updateRouteStatus(routeId, 'completed');
  }

  /// Soft-deletes [routeId] by setting `status = 'deleted'`.
  ///
  /// The route row is preserved for audit history and Memory Agent lookups.
  Future<void> softDeleteRoute(String routeId) async {
    await updateRouteStatus(routeId, 'deleted');
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return RouteRepository(ref.watch(supabaseClientProvider));
});
