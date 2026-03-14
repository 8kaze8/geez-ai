import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/constants/gamification_constants.dart';
import 'package:geez_ai/features/auth/data/user_repository.dart';
import 'package:geez_ai/features/auth/domain/user_model.dart';
import 'package:geez_ai/features/auth/domain/user_profile_model.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/passport/domain/travel_persona_model.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class ProfileData {
  const ProfileData({
    required this.user,
    this.profile,
    this.persona,
  });

  final UserModel user;
  final UserProfileModel? profile;
  final TravelPersonaModel? persona;

  /// Display name — prefer displayName, fall back to email prefix.
  String get displayName {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    final atIndex = user.email.indexOf('@');
    if (atIndex > 0) return user.email.substring(0, atIndex);
    return user.email;
  }

  /// Persona title shown under the avatar. Falls back to "Gezgin".
  String get personaTitle {
    if (persona == null) return 'Gezgin';
    return GamificationConstants.tierLabels[persona!.explorerTier.toLowerCase()] ??
        persona!.explorerTier;
  }

  /// Discovery score, 0 when no persona yet.
  int get discoveryScore => persona?.discoveryScore ?? 0;

  /// Number of filled stars (1-5) based on discovery score.
  int get starCount => GamificationConstants.starsForScore(discoveryScore);

  /// Tier label for the discovery score badge.
  String get tierLabel =>
      GamificationConstants.tierLabels[persona?.explorerTier.toLowerCase()] ??
      'Turist';
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ProfileNotifier extends AsyncNotifier<ProfileData> {
  @override
  Future<ProfileData> build() async {
    final authState = ref.watch(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) {
      throw Exception('Kullan\u0131c\u0131 oturumu bulunamad\u0131.');
    }

    final userId = authState.user!.id;
    final repo = ref.read(userRepositoryProvider);

    // Fire all three requests in parallel for performance.
    final (user, profile, persona) = await (
      repo.getUser(userId),
      repo.getProfile(userId),
      repo.getPersona(userId),
    ).wait;

    if (user == null) {
      throw Exception('Kullan\u0131c\u0131 verisi bulunamad\u0131.');
    }

    return ProfileData(
      user: user,
      profile: profile,
      persona: persona,
    );
  }

  /// Refreshes the profile data from Supabase.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Updates user_profiles and refreshes state.
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return;

    final userId = authState.user!.id;
    final repo = ref.read(userRepositoryProvider);

    await repo.updateProfile(userId, data);
    await refresh();
  }

  /// Signs the user out via the auth notifier.
  Future<void> signOut() async {
    await ref.read(authStateProvider.notifier).signOut();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileData>(ProfileNotifier.new);
