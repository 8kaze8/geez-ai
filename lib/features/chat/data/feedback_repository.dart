import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/data/base_repository.dart';
import 'package:geez_ai/core/providers/supabase_provider.dart';
import 'package:geez_ai/features/chat/domain/trip_feedback_model.dart';

/// Repository for post-trip feedback.
///
/// Maps to `public.trip_feedback`.
///
/// Design constraints from the schema:
///   - `UNIQUE(user_id, route_id)` — one feedback per route per user.
///   - No `updated_at` — feedback is written once; re-submission uses
///     upsert (`ON CONFLICT DO UPDATE`) rather than a separate UPDATE.
///   - No soft-delete — feedback rows are never removed (CASCADE from
///     route deletion is handled at the DB level).
class FeedbackRepository extends BaseRepository {
  const FeedbackRepository(super.client);

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Inserts [feedback] or updates the existing row if one already exists
  /// for the same `(user_id, route_id)` pair.
  ///
  /// Upsert is intentional: the user may submit feedback, leave the app,
  /// and re-submit corrections — both cases should result in a single row.
  Future<void> submitFeedback(TripFeedbackModel feedback) async {
    try {
      await client
          .from('trip_feedback')
          .upsert(
            feedback.toJson(),
            onConflict: 'user_id,route_id',
          );
    } catch (e) {
      throw RepositoryException(
        table: 'trip_feedback',
        operation: 'submitFeedback',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Read — single
  // ---------------------------------------------------------------------------

  /// Returns the [TripFeedbackModel] for the given [userId] and [routeId],
  /// or `null` if the user has not yet submitted feedback for that route.
  Future<TripFeedbackModel?> getFeedback(
    String userId,
    String routeId,
  ) async {
    try {
      final row = await client
          .from('trip_feedback')
          .select()
          .eq('user_id', userId)
          .eq('route_id', routeId)
          .maybeSingle();
      if (row == null) return null;
      return TripFeedbackModel.fromJson(row);
    } catch (e) {
      throw RepositoryException(
        table: 'trip_feedback',
        operation: 'getFeedback($userId, $routeId)',
        cause: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Read — list
  // ---------------------------------------------------------------------------

  /// Returns all feedback rows for [userId] ordered by [created_at]
  /// descending (most recent first).
  ///
  /// Used by the Memory Agent to build the post-trip learning loop.
  Future<List<TripFeedbackModel>> getUserFeedbackHistory(
    String userId,
  ) async {
    try {
      final rows = await client
          .from('trip_feedback')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (rows as List<dynamic>)
          .map(
            (row) =>
                TripFeedbackModel.fromJson(row as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw RepositoryException(
        table: 'trip_feedback',
        operation: 'getUserFeedbackHistory($userId)',
        cause: e,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository(ref.watch(supabaseClientProvider));
});
