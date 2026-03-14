-- ============================================================
-- 012_audit_fixes.sql
-- Audit findings remediation.
--
-- Fixes:
--
--   1. Explorer tier auto-update trigger
--      travel_personas.explorer_tier was a manually-managed TEXT
--      column with no enforcement — it could drift out of sync
--      with discovery_score. This migration adds a BEFORE trigger
--      that recalculates explorer_tier on every INSERT and on
--      every UPDATE that touches discovery_score, making the tier
--      a derived value that is always consistent.
--
--      Thresholds (match the comment on the column definition in
--      002_users.sql):
--        tourist   : discovery_score <  200
--        traveler  : discovery_score >= 200
--        explorer  : discovery_score >= 500
--        local     : discovery_score >= 1000
--        legend    : discovery_score >= 2500
--
--   2. Composite index for trip_feedback timeline queries
--      trip_feedback has an existing FK index on user_id alone
--      (idx_trip_feedback_user_id, 009_indexes.sql) but queries
--      that fetch a user's feedback ordered by time — e.g. the
--      Memory Agent reading the most recent N feedback rows —
--      must scan all rows for that user and then sort. A composite
--      (user_id, created_at DESC) index covers both the equality
--      filter and the sort in one index scan.
-- ============================================================


-- ============================================================
-- 1. Explorer tier auto-update
-- ============================================================

-- Function: recompute explorer_tier from discovery_score.
-- Declared with SET search_path so it is safe even when called
-- from a SECURITY DEFINER context.
CREATE OR REPLACE FUNCTION public.update_explorer_tier()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.explorer_tier := CASE
    WHEN NEW.discovery_score >= 2500 THEN 'legend'
    WHEN NEW.discovery_score >= 1000 THEN 'local'
    WHEN NEW.discovery_score >= 500  THEN 'explorer'
    WHEN NEW.discovery_score >= 200  THEN 'traveler'
    ELSE                                  'tourist'
  END;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.update_explorer_tier() IS
  'BEFORE trigger function. Derives explorer_tier from discovery_score '
  'so the two columns never drift out of sync. '
  'Thresholds: tourist(0) | traveler(200) | explorer(500) | local(1000) | legend(2500).';

-- Trigger: fire on INSERT and on any UPDATE that changes discovery_score.
-- Specifying UPDATE OF discovery_score keeps the trigger silent on unrelated
-- column updates (e.g. persona level increments) to avoid redundant work.
-- The existing trg_travel_personas_set_updated_at trigger (002_users.sql)
-- also fires BEFORE UPDATE; PostgreSQL fires BEFORE triggers in creation
-- order, so updated_at is stamped after the tier is resolved — both are
-- correct within the same statement.
DROP TRIGGER IF EXISTS trg_update_explorer_tier ON public.travel_personas;

CREATE TRIGGER trg_update_explorer_tier
  BEFORE INSERT OR UPDATE OF discovery_score ON public.travel_personas
  FOR EACH ROW
  EXECUTE FUNCTION public.update_explorer_tier();

COMMENT ON TABLE public.travel_personas IS
  'AI Memory Layer 4. Evolving persona updated after each trip. '
  'explorer_tier is auto-derived from discovery_score by trg_update_explorer_tier.';


-- ============================================================
-- 2. Composite index: trip_feedback (user_id, created_at DESC)
-- ============================================================
-- Covers the Memory Agent query pattern:
--   SELECT * FROM trip_feedback
--   WHERE user_id = $1
--   ORDER BY created_at DESC
--   LIMIT N;
--
-- The existing idx_trip_feedback_user_id (single-column, 009_indexes.sql)
-- satisfies the WHERE filter but not the sort. This composite index
-- makes the query an index-only scan with no heap sort.
-- IF NOT EXISTS keeps the migration idempotent.

CREATE INDEX IF NOT EXISTS idx_trip_feedback_user_created_at
  ON public.trip_feedback (user_id, created_at DESC);

COMMENT ON INDEX public.idx_trip_feedback_user_created_at IS
  'Composite index for Memory Agent timeline queries: '
  'WHERE user_id = $1 ORDER BY created_at DESC LIMIT N. '
  'Covers both the equality filter and the sort in one index scan.';
