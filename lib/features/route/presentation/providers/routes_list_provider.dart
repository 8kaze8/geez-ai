import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/route/data/route_repository.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

/// Loads all non-deleted routes for the current user, sorted newest-first.
///
/// Used by any screen that shows a list of routes (home, passport, etc.).
class RoutesListNotifier extends AsyncNotifier<List<RouteModel>> {
  @override
  Future<List<RouteModel>> build() async {
    final authState = ref.watch(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) {
      return [];
    }

    final repo = ref.read(routeRepositoryProvider);
    return repo.getUserRoutes(authState.user!.id);
  }

  /// Refreshes the list from Supabase.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Soft-deletes a route and removes it from the local list immediately.
  Future<void> deleteRoute(String routeId) async {
    final repo = ref.read(routeRepositoryProvider);
    await repo.softDeleteRoute(routeId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((r) => r.id != routeId).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final routesListProvider =
    AsyncNotifierProvider<RoutesListNotifier, List<RouteModel>>(
  RoutesListNotifier.new,
);
