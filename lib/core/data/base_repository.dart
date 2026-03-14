import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract base class for all feature repositories.
///
/// Holds the [SupabaseClient] and exposes generic CRUD helpers so
/// every subclass can share the same query + error-handling patterns.
///
/// All helpers throw a [RepositoryException] on failure — callers
/// should catch that type and never let raw Supabase/Postgres errors
/// bubble up to the UI.
abstract class BaseRepository {
  const BaseRepository(this.client);

  final SupabaseClient client;

  // ---------------------------------------------------------------------------
  // Generic CRUD helpers
  // ---------------------------------------------------------------------------

  /// Returns all rows from [table].
  ///
  /// Pass [columns] to restrict which columns are fetched (default `'*'`).
  Future<List<Map<String, dynamic>>> selectAll(
    String table, {
    String columns = '*',
  }) async {
    try {
      final response = await client.from(table).select(columns);
      return List<Map<String, dynamic>>.from(response as List<dynamic>);
    } catch (e) {
      throw RepositoryException(
        table: table,
        operation: 'selectAll',
        cause: e,
      );
    }
  }

  /// Returns the single row matching [id] in the `id` column, or `null`.
  Future<Map<String, dynamic>?> selectById(
    String table,
    String id, {
    String columns = '*',
  }) async {
    try {
      final response = await client
          .from(table)
          .select(columns)
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      throw RepositoryException(
        table: table,
        operation: 'selectById($id)',
        cause: e,
      );
    }
  }

  /// Inserts [data] into [table] and returns the inserted row.
  Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response =
          await client.from(table).insert(data).select().single();
      return response;
    } catch (e) {
      throw RepositoryException(
        table: table,
        operation: 'insert',
        cause: e,
      );
    }
  }

  /// Updates columns in [data] for the row identified by [id].
  ///
  /// Returns the updated row.
  Future<Map<String, dynamic>> update(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw RepositoryException(
        table: table,
        operation: 'update($id)',
        cause: e,
      );
    }
  }

  /// Soft-deletes a row by setting `status = 'deleted'`.
  ///
  /// Geez AI never issues a real DELETE — this keeps audit history intact
  /// and satisfies the RLS policy which omits a DELETE grant.
  Future<void> softDelete(String table, String id) async {
    try {
      await client
          .from(table)
          .update({'status': 'deleted'})
          .eq('id', id);
    } catch (e) {
      throw RepositoryException(
        table: table,
        operation: 'softDelete($id)',
        cause: e,
      );
    }
  }

  /// Updates all rows in [table] where [column] equals [value].
  ///
  /// Used internally when you need to filter on something other than `id`.
  Future<void> updateWhere(
    String table, {
    required String column,
    required Object value,
    required Map<String, dynamic> data,
  }) async {
    try {
      await client.from(table).update(data).eq(column, value);
    } catch (e) {
      throw RepositoryException(
        table: table,
        operation: 'updateWhere($column=$value)',
        cause: e,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// RepositoryException
// ---------------------------------------------------------------------------

/// Wraps any Supabase/Postgres error with context that is useful for
/// logging and debugging without leaking raw DB messages to the UI.
class RepositoryException implements Exception {
  const RepositoryException({
    required this.table,
    required this.operation,
    required this.cause,
  });

  final String table;
  final String operation;
  final Object cause;

  @override
  String toString() =>
      'RepositoryException[$table.$operation]: $cause';
}
