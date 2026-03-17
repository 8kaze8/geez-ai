import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/features/auth/data/user_repository.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/passport/data/passport_repository.dart';
import 'package:geez_ai/features/passport/domain/passport_stamp_model.dart';
import 'package:geez_ai/features/passport/domain/travel_persona_model.dart';
import 'package:geez_ai/features/passport/domain/visited_place_model.dart';

// ---------------------------------------------------------------------------
// PassportStats
// ---------------------------------------------------------------------------

class PassportStats {
  const PassportStats({
    required this.cityCount,
    required this.countryCount,
    required this.totalStops,
  });

  final int cityCount;
  final int countryCount;
  final int totalStops;

  static const empty = PassportStats(
    cityCount: 0,
    countryCount: 0,
    totalStops: 0,
  );
}

// ---------------------------------------------------------------------------
// PersonaLevel — UI view of one persona axis
// ---------------------------------------------------------------------------

class PersonaLevel {
  const PersonaLevel({
    required this.icon,
    required this.name,
    required this.level,
    required this.progress,
    required this.color,
  });

  final IconData icon;
  final String name;
  final int level;

  /// Fractional progress within the current level (0.0 – 1.0).
  final double progress;
  final Color color;
}

// ---------------------------------------------------------------------------
// PassportState
// ---------------------------------------------------------------------------

class PassportState {
  const PassportState({
    required this.stamps,
    required this.visitedPlaces,
    required this.persona,
    required this.stats,
    required this.displayName,
  });

  final List<PassportStampModel> stamps;
  final List<VisitedPlaceModel> visitedPlaces;
  final TravelPersonaModel? persona;
  final PassportStats stats;
  final String displayName;

  bool get isEmpty => stamps.isEmpty;

  /// Maps [persona] levels into the ordered list consumed by the persona bars.
  List<PersonaLevel> get personaLevels {
    if (persona == null) return [];
    return [
      PersonaLevel(
        icon: Icons.restaurant_rounded,
        name: 'Gurme',
        level: persona!.foodieLevel,
        progress: _levelProgress(persona!.foodieLevel),
        color: GeezColors.foodie,
      ),
      PersonaLevel(
        icon: Icons.account_balance_rounded,
        name: 'Tarih Sever',
        level: persona!.historyBuffLevel,
        progress: _levelProgress(persona!.historyBuffLevel),
        color: GeezColors.history,
      ),
      PersonaLevel(
        icon: Icons.hiking_rounded,
        name: 'Maceraperest',
        level: persona!.adventureSeekerLevel,
        progress: _levelProgress(persona!.adventureSeekerLevel),
        color: GeezColors.adventure,
      ),
      PersonaLevel(
        icon: Icons.palette_rounded,
        name: 'Kültür',
        level: persona!.cultureExplorerLevel,
        progress: _levelProgress(persona!.cultureExplorerLevel),
        color: GeezColors.culture,
      ),
      PersonaLevel(
        icon: Icons.park_rounded,
        name: 'Doğa Sever',
        level: persona!.natureLoverLevel,
        progress: _levelProgress(persona!.natureLoverLevel),
        color: GeezColors.nature,
      ),
    ];
  }

  /// Returns a human-readable title for the user's strongest persona axis.
  String get personaTitle {
    if (persona == null) return 'Gezgin';
    final entries = {
      'Foodie': persona!.foodieLevel,
      'History Buff': persona!.historyBuffLevel,
      'Adventurer': persona!.adventureSeekerLevel,
      'Culture Explorer': persona!.cultureExplorerLevel,
      'Nature Lover': persona!.natureLoverLevel,
    };
    return entries.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  /// Goal progress as a fraction. Goal = 10 cities.
  double get goalProgress => (stats.cityCount / 10).clamp(0.0, 1.0);

  String get goalLabel => 'Hedef: 10 sehir';

  /// Cosmetic progress within a level (each level = 10 xp steps).
  static double _levelProgress(int level) =>
      ((level % 10) / 10.0).clamp(0.0, 1.0);
}

// ---------------------------------------------------------------------------
// PassportNotifier
// ---------------------------------------------------------------------------

class PassportNotifier extends AsyncNotifier<PassportState> {
  @override
  Future<PassportState> build() async {
    final authState = ref.watch(authStateProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      return PassportState(
        stamps: const [],
        visitedPlaces: const [],
        persona: null,
        stats: PassportStats.empty,
        displayName: '',
      );
    }

    final passportRepo = ref.read(passportRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    // Run all independent requests concurrently using Dart 3 record .wait.
    final (stamps, visitedPlaces, rawStats, persona, user) = await (
      passportRepo.getStamps(userId),
      passportRepo.getVisitedPlaces(userId),
      passportRepo.getStats(userId),
      userRepo.getPersona(userId),
      userRepo.getUser(userId),
    ).wait;

    final stats = PassportStats(
      cityCount: rawStats['city_count'] ?? 0,
      countryCount: rawStats['country_count'] ?? 0,
      totalStops: rawStats['total_stops'] ?? 0,
    );

    return PassportState(
      stamps: stamps,
      visitedPlaces: visitedPlaces,
      persona: persona,
      stats: stats,
      displayName: user?.displayName ?? 'Gezgin',
    );
  }

  /// Pull-to-refresh: invalidates self.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final passportProvider =
    AsyncNotifierProvider<PassportNotifier, PassportState>(
  PassportNotifier.new,
);
