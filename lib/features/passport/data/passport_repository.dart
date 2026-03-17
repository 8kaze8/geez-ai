import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/data/base_repository.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/passport/domain/passport_stamp_model.dart';
import 'package:geez_ai/features/passport/domain/visited_place_model.dart';

/// Repository for the Digital Passport gamification layer.
///
/// Maps to:
///   - `public.passport_stamps`  — one stamp per unique city
///   - `public.visited_places`   — Memory Layer 3, full visit history
class PassportRepository extends BaseRepository {
  const PassportRepository(super.client);

  // ---------------------------------------------------------------------------
  // passport_stamps
  // ---------------------------------------------------------------------------

  /// Returns all stamps for [userId] ordered by [stamp_date] descending
  /// (most recent city visited first).
  Future<List<PassportStampModel>> getStamps(String userId) async {
    try {
      final rows = await client
          .from('passport_stamps')
          .select()
          .eq('user_id', userId)
          .order('stamp_date', ascending: false);
      return (rows as List<dynamic>)
          .map(
            (row) =>
                PassportStampModel.fromJson(row as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw RepositoryException(
        table: 'passport_stamps',
        operation: 'getStamps($userId)',
        cause: e,
      );
    }
  }

  /// Inserts [stamp].
  ///
  /// The DB has `UNIQUE(user_id, city, country)` — if a stamp already
  /// exists for this city the insert is silently ignored via
  /// `ON CONFLICT DO NOTHING` at the DB level (upsert-safe).
  ///
  /// Server-generated columns (`id`, `created_at`) are intentionally
  /// excluded from the payload so the DB supplies them on insert and does
  /// not overwrite them on a conflict update.
  Future<void> addStamp(PassportStampModel stamp) async {
    try {
      final payload = <String, dynamic>{
        'user_id': stamp.userId,
        'city': stamp.city,
        'country': stamp.country,
        'stamp_date': stamp.stampDate,
        if (stamp.routeId != null) 'route_id': stamp.routeId,
        if (stamp.countryCode != null) 'country_code': stamp.countryCode,
        if (stamp.stampImageUrl != null) 'stamp_image_url': stamp.stampImageUrl,
      };
      await client
          .from('passport_stamps')
          .upsert(payload, onConflict: 'user_id,city,country');
    } catch (e) {
      throw RepositoryException(
        table: 'passport_stamps',
        operation: 'addStamp',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // visited_places
  // ---------------------------------------------------------------------------

  /// Returns all visited places for [userId] ordered by [created_at]
  /// descending.
  Future<List<VisitedPlaceModel>> getVisitedPlaces(String userId) async {
    try {
      final rows = await client
          .from('visited_places')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (rows as List<dynamic>)
          .map(
            (row) =>
                VisitedPlaceModel.fromJson(row as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw RepositoryException(
        table: 'visited_places',
        operation: 'getVisitedPlaces($userId)',
        cause: e,
      );
    }
  }

  /// Inserts [place] into `visited_places`.
  ///
  /// When `place_id` is not null the DB's partial unique index prevents
  /// duplicate entries for the same Google Maps place per user.
  Future<void> addVisitedPlace(VisitedPlaceModel place) async {
    try {
      await client.from('visited_places').insert(place.toJson());
    } catch (e) {
      throw RepositoryException(
        table: 'visited_places',
        operation: 'addVisitedPlace',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Aggregated stats
  // ---------------------------------------------------------------------------

  /// Returns a summary map for [userId]:
  ///
  /// ```dart
  /// {
  ///   'city_count':    int,   // distinct cities with a stamp
  ///   'country_count': int,   // distinct countries with a stamp
  ///   'total_stops':   int,   // total visited_places rows
  /// }
  /// ```
  Future<Map<String, int>> getStats(String userId) async {
    try {
      // Fetch stamps for city/country counts.
      final stampsResponse = await client
          .from('passport_stamps')
          .select('city, country')
          .eq('user_id', userId);

      final stamps = stampsResponse as List<dynamic>;

      final cities = <String>{};
      final countries = <String>{};
      for (final row in stamps) {
        final r = row as Map<String, dynamic>;
        cities.add(r['city'] as String);
        countries.add(r['country'] as String);
      }

      // Fetch visited_places count.
      final placesResponse = await client
          .from('visited_places')
          .select('id')
          .eq('user_id', userId);

      final totalStops = (placesResponse as List<dynamic>).length;

      return {
        'city_count': cities.length,
        'country_count': countries.length,
        'total_stops': totalStops,
      };
    } catch (e) {
      throw RepositoryException(
        table: 'passport_stamps / visited_places',
        operation: 'getStats($userId)',
        cause: e,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final passportRepositoryProvider = Provider<PassportRepository>((ref) {
  return PassportRepository(ref.watch(supabaseClientProvider));
});
