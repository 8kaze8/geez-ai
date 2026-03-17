import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/home/presentation/providers/home_provider.dart';
import 'package:geez_ai/features/passport/data/passport_repository.dart';
import 'package:geez_ai/features/passport/domain/passport_stamp_model.dart';
import 'package:geez_ai/features/route/data/route_repository.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/features/route/domain/route_stop_model.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class RouteDetailData {
  const RouteDetailData({
    required this.route,
    required this.stops,
  });

  final RouteModel route;

  /// All stops sorted by [RouteStopModel.stopOrder] ascending.
  final List<RouteStopModel> stops;

  /// Returns stops whose [RouteStopModel.dayNumber] matches [day].
  List<RouteStopModel> stopsForDay(int day) =>
      stops.where((s) => s.dayNumber == day).toList();

  /// Distinct sorted list of day numbers present in [stops].
  List<int> get days {
    final nums = stops.map((s) => s.dayNumber).toSet().toList()..sort();
    // Always include at least day 1 through route.durationDays.
    final full = List.generate(route.durationDays, (i) => i + 1);
    return {...full, ...nums}.toList()..sort();
  }
}

// ---------------------------------------------------------------------------
// Notifier (family by routeId)
// ---------------------------------------------------------------------------

class RouteDetailNotifier
    extends AutoDisposeFamilyAsyncNotifier<RouteDetailData, String> {
  @override
  Future<RouteDetailData> build(String routeId) async {
    final repo = ref.read(routeRepositoryProvider);

    // Fetch route + stops in parallel using record destructuring.
    final (route, stops) = await (
      repo.getRouteDetail(routeId),
      repo.getRouteStops(routeId),
    ).wait;

    if (route == null) {
      throw Exception('Rota bulunamadı.');
    }

    return RouteDetailData(route: route, stops: stops);
  }

  /// Transitions the route from "draft" to "active" status.
  ///
  /// Uses [RouteRepository.activateRoute] which atomically deactivates any
  /// previously active route for this user (moving it back to 'draft') before
  /// activating this one. This enforces the one-active-at-a-time invariant.
  Future<void> markAsActive() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.route.status != 'draft') return;

    final userId = ref.read(authStateProvider).user?.id;
    if (userId == null) return;

    final repo = ref.read(routeRepositoryProvider);
    await repo.activateRoute(current.route.id, userId);
    await refresh();
    // Refresh home so the active route card updates immediately.
    ref.invalidate(homeProvider);
  }

  /// Transitions the route to "completed" status and creates a passport stamp.
  ///
  /// The DB trigger `trg_routes_set_completed_at` automatically sets
  /// `completed_at` when status becomes "completed".
  ///
  /// Stamp creation is fire-and-forget — a failure does not block navigation.
  /// The DB's `UNIQUE(user_id, city, country)` constraint ensures idempotency
  /// if the user completes the same city twice.
  Future<void> markAsCompleted() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final repo = ref.read(routeRepositoryProvider);
    await repo.completeRoute(current.route.id);

    // Fire-and-forget passport stamp — do not await or block navigation.
    _createPassportStamp(current.route);

    // Refresh local state and home screen.
    await refresh();
    ref.invalidate(homeProvider);
  }

  /// Creates a [PassportStampModel] for [route] if the current user is known.
  ///
  /// Errors are swallowed intentionally — a stamp failure must never
  /// prevent the user from reaching the feedback screen.
  void _createPassportStamp(RouteModel route) {
    final userId = ref.read(authStateProvider).user?.id;
    if (userId == null) return;

    final today = DateTime.now();
    final stampDate =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final stamp = PassportStampModel(
      id: '', // ignored — DB generates this
      userId: userId,
      routeId: route.id,
      city: route.city,
      country: route.country,
      stampDate: stampDate,
    );

    ref
        .read(passportRepositoryProvider)
        .addStamp(stamp)
        .catchError((_) {/* silently swallow — stamp is non-critical */});
  }

  /// Refreshes route + stops from Supabase.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final routeDetailProvider =
    AsyncNotifierProvider.autoDispose.family<RouteDetailNotifier,
        RouteDetailData, String>(RouteDetailNotifier.new);
