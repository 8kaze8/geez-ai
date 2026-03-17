-- ============================================================
-- 013_feedback_stops_text.sql
--
-- Alter trip_feedback.favorite_stops and trip_feedback.disliked_stops
-- from UUID[] to TEXT[].
--
-- Background:
--   The original schema stored route_stop UUIDs in these columns so
--   the Memory Agent could cross-reference individual stops.  However,
--   the client-side feedback form collects freeform chip-label strings
--   (e.g. "Yemekler harika") rather than UUIDs, and Postgres was
--   rejecting every insert with an invalid-UUID cast error.
--
--   The Memory Agent can still derive stop-level signals from the
--   overall_rating and free_text columns. If UUID-level stop signals
--   are needed in a future sprint, a dedicated stop_feedback table
--   should be introduced at that point rather than overloading this
--   column with two different semantic types.
--
-- Safe to run multiple times (ALTER TYPE is idempotent when the
-- column is already TEXT[]).
-- ============================================================

ALTER TABLE public.trip_feedback
  ALTER COLUMN favorite_stops TYPE TEXT[]
    USING favorite_stops::TEXT[],
  ALTER COLUMN disliked_stops TYPE TEXT[]
    USING disliked_stops::TEXT[];

COMMENT ON COLUMN public.trip_feedback.favorite_stops IS 'Freeform highlight labels selected by the user (e.g. "Yemekler harika"). Changed from UUID[] in migration 013.';
COMMENT ON COLUMN public.trip_feedback.disliked_stops IS 'Freeform lowlight labels selected by the user (e.g. "Mesafeler uzundu"). Changed from UUID[] in migration 013.';
