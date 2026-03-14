import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/data/base_repository.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';

/// Repository that persists the onboarding Q&A results to Supabase.
///
/// Maps to:
///   - `public.user_profiles`   — Layer 1 static preferences (quiz answers)
///   - `public.travel_personas` — initial persona scores derived from answers
///
/// Both tables are guaranteed to exist before this repository is called
/// because `trg_on_public_user_created` inserts skeleton rows as soon
/// as a new `public.users` row is created.
class OnboardingRepository extends BaseRepository {
  const OnboardingRepository(super.client);

  // ---------------------------------------------------------------------------
  // Quiz results
  // ---------------------------------------------------------------------------

  /// Persists quiz answers to `user_profiles` for [userId].
  ///
  /// All parameters are optional — only the non-null ones are written,
  /// preserving any values that were already set.
  ///
  /// Parameter names match the DB column names directly so `toJson`-style
  /// mapping is straightforward and future schema changes are easy to spot.
  Future<void> saveQuizResults(
    String userId, {
    String? ageGroup,
    String? travelCompanion,
    String? budget,
    List<String>? activities,
    String? pacePreference,
    String? crowdTolerance,
  }) async {
    final data = <String, dynamic>{};

    if (ageGroup != null) data['age_group'] = ageGroup;
    if (travelCompanion != null) data['travel_companion'] = travelCompanion;
    if (budget != null) data['default_budget'] = budget;
    if (activities != null) data['preferred_activities'] = activities;
    if (pacePreference != null) data['pace_preference'] = pacePreference;
    if (crowdTolerance != null) data['crowd_tolerance'] = crowdTolerance;

    if (data.isEmpty) return;

    try {
      await client
          .from('user_profiles')
          .update(data)
          .eq('user_id', userId);
    } catch (e) {
      throw RepositoryException(
        table: 'user_profiles',
        operation: 'saveQuizResults($userId)',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Initial persona
  // ---------------------------------------------------------------------------

  /// Persists the initial persona level scores to `travel_personas` for [userId].
  ///
  /// The caller is responsible for deriving the dominant persona scores from
  /// the quiz answers — this method simply writes the computed values to the DB.
  ///
  /// All level parameters must be in the range 1–10 (enforced by DB constraint).
  Future<void> saveInitialPersona(
    String userId, {
    int? foodieLevel,
    int? historyBuffLevel,
    int? natureLoverLevel,
    int? adventureSeekerLevel,
    int? cultureExplorerLevel,
  }) async {
    final data = <String, dynamic>{};

    if (foodieLevel != null) data['foodie_level'] = foodieLevel;
    if (historyBuffLevel != null) data['history_buff_level'] = historyBuffLevel;
    if (natureLoverLevel != null) data['nature_lover_level'] = natureLoverLevel;
    if (adventureSeekerLevel != null) {
      data['adventure_seeker_level'] = adventureSeekerLevel;
    }
    if (cultureExplorerLevel != null) {
      data['culture_explorer_level'] = cultureExplorerLevel;
    }

    if (data.isEmpty) return;

    try {
      await client
          .from('travel_personas')
          .update(data)
          .eq('user_id', userId);
    } catch (e) {
      throw RepositoryException(
        table: 'travel_personas',
        operation: 'saveInitialPersona($userId)',
        cause: e,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(supabaseClientProvider));
});
