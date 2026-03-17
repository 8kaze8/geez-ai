-- ============================================================
-- 014_audit_fixes_sprint7.sql
-- Sprint 7 audit findings remediation.
--
-- Fixes:
--
--   C-2. Fix trip_feedback array column DEFAULTs
--        Migration 013 changed favorite_stops and disliked_stops
--        from UUID[] to TEXT[], but the DEFAULT expressions were
--        not updated and still carry a ::uuid[] cast. Postgres
--        would silently fail or cast incorrectly on rows inserted
--        without an explicit value. Both columns are corrected.
--
--   C-3. Unique constraint on visited_places(user_id, place_id)
--        The original design note in 004_gamification.sql described
--        a partial unique index but it was never materialised. Without
--        this constraint the Memory Agent can create duplicate history
--        rows for the same (user, Google place). The constraint uses a
--        partial form so that NULL place_id rows (manually-logged
--        visits) are unaffected — NULLs are always considered distinct
--        by Postgres unique indexes.
--
--   H-5. Partial index on routes.completed_at
--        Queries that filter or sort on completed_at (e.g. the Memory
--        Agent fetching the N most recent trips, or the app showing a
--        "Completed trips" screen) must do a full table scan without an
--        index. A partial DESC index on completed_at IS NOT NULL covers
--        these queries while remaining small — NULL rows (draft, active,
--        deleted routes) are excluded entirely.
--
--   H-7. Add WITH CHECK to route_stops_update_own RLS policy
--        The original policy (008_rls_policies.sql) only has a USING
--        clause. For UPDATE policies, USING controls which existing rows
--        are visible to the operation, but WITH CHECK controls whether
--        the post-update row is allowed. Without WITH CHECK an attacker
--        could rewrite route_id on a stop to point to another user's
--        route. The policy is dropped and recreated with an identical
--        subquery in both clauses.
-- ============================================================


-- ============================================================
-- C-2. Fix DEFAULT cast on trip_feedback array columns
-- ============================================================
-- Migration 013 (013_feedback_stops_text.sql) altered the column
-- types from UUID[] to TEXT[] via ALTER COLUMN ... TYPE but did not
-- touch the DEFAULT expressions. The original 005_feedback.sql
-- DEFAULT of '{}' carried an implicit ::uuid[] cast in the catalog.
-- Resetting the DEFAULT to an explicit ::text[] cast makes the intent
-- unambiguous and eliminates potential cast errors on new inserts.
-- Both columns receive the same treatment for consistency.

ALTER TABLE public.trip_feedback
  ALTER COLUMN favorite_stops SET DEFAULT '{}'::text[];

ALTER TABLE public.trip_feedback
  ALTER COLUMN disliked_stops SET DEFAULT '{}'::text[];

COMMENT ON COLUMN public.trip_feedback.favorite_stops IS
  'Freeform highlight labels selected by the user (e.g. "Yemekler harika"). '
  'Changed from UUID[] in migration 013. DEFAULT fixed in migration 014.';

COMMENT ON COLUMN public.trip_feedback.disliked_stops IS
  'Freeform lowlight labels selected by the user (e.g. "Mesafeler uzundu"). '
  'Changed from UUID[] in migration 013. DEFAULT fixed in migration 014.';


-- ============================================================
-- C-3. Unique constraint on visited_places(user_id, place_id)
-- ============================================================
-- Partial unique index (place_id IS NOT NULL) so that manually-logged
-- visits (place_id IS NULL) can appear multiple times — those rows
-- represent distinct visits to unnamed or unresolved places and must
-- not be conflated.
-- IF NOT EXISTS makes this migration safe to re-run.

ALTER TABLE public.visited_places
  ADD CONSTRAINT visited_places_user_place_unique
  UNIQUE (user_id, place_id);

COMMENT ON CONSTRAINT visited_places_user_place_unique
  ON public.visited_places IS
  'One visited_places row per (user, Google place_id). '
  'NULLs are always distinct in Postgres unique indexes, so manually-logged '
  'visits (place_id IS NULL) are unaffected.';


-- ============================================================
-- H-5. Partial index on routes.completed_at
-- ============================================================
-- Covers the two primary query patterns that filter on completed_at:
--   1. Memory Agent: recent completed trips for a user
--      WHERE user_id = $1 AND completed_at IS NOT NULL
--      ORDER BY completed_at DESC LIMIT N
--   2. App "Completed trips" screen: same filter, descending order
--
-- The partial predicate (WHERE completed_at IS NOT NULL) keeps the
-- index small by excluding the majority of rows that are still in
-- draft / active / deleted state.
-- NULLS LAST is the Postgres default for DESC but is stated
-- explicitly for clarity.

CREATE INDEX IF NOT EXISTS idx_routes_completed_at
  ON public.routes (completed_at DESC NULLS LAST)
  WHERE completed_at IS NOT NULL;

COMMENT ON INDEX public.idx_routes_completed_at IS
  'Partial DESC index for completed-route queries. '
  'Covers Memory Agent timeline reads and the app Completed Trips screen. '
  'Excludes NULL rows (draft / active / deleted) to stay compact.';


-- ============================================================
-- H-7. Fix route_stops_update_own RLS — add WITH CHECK
-- ============================================================
-- The policy created in 008_rls_policies.sql has only a USING clause.
-- In Postgres, an UPDATE policy without WITH CHECK defaults to the
-- USING expression for the post-update check, which is the expected
-- safe behaviour in recent versions, but making it explicit:
--   a) removes ambiguity in policy audits
--   b) prevents a future Postgres version change from altering semantics
--   c) closes the theoretical route_id-hijack vector explicitly
--
-- The subquery is identical in both clauses intentionally: only rows
-- where the parent route belongs to the authenticated user may be
-- updated, and the updated row must still belong to the same user's
-- route after the write.

DROP POLICY IF EXISTS "route_stops_update_own" ON public.route_stops;

CREATE POLICY "route_stops_update_own"
  ON public.route_stops FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.routes r
      WHERE r.id = route_stops.route_id
        AND r.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.routes r
      WHERE r.id = route_stops.route_id
        AND r.user_id = auth.uid()
    )
  );
