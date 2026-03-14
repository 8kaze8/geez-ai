import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/data/base_repository.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/auth/domain/user_model.dart';
import 'package:geez_ai/features/auth/domain/user_profile_model.dart';
import 'package:geez_ai/features/passport/domain/travel_persona_model.dart';

/// Repository for user, profile, and persona data.
///
/// Maps to:
///   - `public.users`
///   - `public.user_profiles`
///   - `public.travel_personas`
///
/// Auth is enforced at the RLS level. userId filters are added
/// explicitly on every query as a defence-in-depth measure.
class UserRepository extends BaseRepository {
  const UserRepository(super.client);

  // ---------------------------------------------------------------------------
  // users
  // ---------------------------------------------------------------------------

  /// Fetches the [UserModel] for [userId], or `null` if not found.
  Future<UserModel?> getUser(String userId) async {
    try {
      final row = await client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (row == null) return null;
      return UserModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'users',
        operation: 'getUser($userId)',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // user_profiles
  // ---------------------------------------------------------------------------

  /// Fetches the [UserProfileModel] for [userId], or `null`.
  Future<UserProfileModel?> getProfile(String userId) async {
    try {
      final row = await client
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return null;
      return UserProfileModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'user_profiles',
        operation: 'getProfile($userId)',
        cause: e,
      );
    }
  }

  /// Updates [data] columns on the `user_profiles` row for [userId].
  ///
  /// Only the supplied keys are touched; everything else stays unchanged.
  Future<void> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await client
          .from('user_profiles')
          .update(data)
          .eq('user_id', userId);
    } catch (e) {
      throw RepositoryException(
        table: 'user_profiles',
        operation: 'updateProfile($userId)',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // travel_personas
  // ---------------------------------------------------------------------------

  /// Fetches the [TravelPersonaModel] for [userId], or `null`.
  Future<TravelPersonaModel?> getPersona(String userId) async {
    try {
      final row = await client
          .from('travel_personas')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return null;
      return TravelPersonaModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'travel_personas',
        operation: 'getPersona($userId)',
        cause: e,
      );
    }
  }

  /// Updates [data] columns on the `travel_personas` row for [userId].
  Future<void> updatePersona(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await client
          .from('travel_personas')
          .update(data)
          .eq('user_id', userId);
    } catch (e) {
      throw RepositoryException(
        table: 'travel_personas',
        operation: 'updatePersona($userId)',
        cause: e,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(supabaseClientProvider));
});
