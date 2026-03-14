import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class RouteDetailNotifier extends FamilyAsyncNotifier<RouteDetailData, String> {
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

  /// Transitions the route to "completed" status.
  ///
  /// The DB trigger `trg_routes_set_completed_at` automatically sets
  /// `completed_at` when status becomes "completed".
  Future<void> markAsCompleted() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final repo = ref.read(routeRepositoryProvider);
    await repo.updateRouteStatus(current.route.id, 'completed');
    // Refresh so the local state reflects the new status.
    await refresh();
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

final routeDetailProvider = AsyncNotifierProvider.family<RouteDetailNotifier,
    RouteDetailData, String>(RouteDetailNotifier.new);
