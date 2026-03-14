-- ============================================================
-- 010_atomic_rpc_functions.sql
-- Atomic RPC helper functions for Edge Function use.
--
-- Functions defined:
--   increment_routes_generated  — atomic counter for usage_tracking
--   increment_cache_hit_count   — atomic hit counter for ai_route_cache
--   get_cache_stats             — aggregate stats over ai_route_cache
--
-- Constraint fix:
--   route_stops.travel_mode_from_previous CHECK widened to accept
--   both the legacy DB values ('walk','transit','drive','taxi','bike')
--   and the TypeScript TransportMode values ('walking','public','car','mixed').
--
-- All three functions are called from Edge Functions via supabase.rpc()
-- with a service-role client (RLS bypass). They are defined as
-- SECURITY DEFINER so that they always run with sufficient privileges
-- regardless of which role invokes them, while the underlying tables
-- remain protected by RLS for all direct-table access.
-- ============================================================


-- ============================================================
-- 1. increment_routes_generated
-- ============================================================
-- Called by: supabase/functions/_shared/rate-limit.ts (incrementUsage)
--   await client.rpc('increment_routes_generated', {
--     p_user_id: userId,
--     p_year:    year,     -- UTC calendar year  (e.g. 2026)
--     p_month:   month,    -- UTC calendar month (1-12)
--   });
--
-- Behaviour:
--   - If a matching usage_tracking row already exists for
--     (user_id, period_year, period_month), increment routes_generated
--     by 1 and return the new value.
--   - If no row exists yet, insert one with routes_generated = 1,
--     inheriting routes_limit and tier_at_period_start from whatever
--     the Edge Function already upserted, or defaulting to free-tier
--     values (3 / 'free') when called standalone.
--
-- Returns: INT — the updated routes_generated value.
-- ============================================================

CREATE OR REPLACE FUNCTION public.increment_routes_generated(
  p_user_id UUID,
  p_year    INT,
  p_month   INT
)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_new_count INT;
BEGIN
  -- Attempt atomic increment on the existing row.
  UPDATE public.usage_tracking
  SET    routes_generated = routes_generated + 1
  WHERE  user_id      = p_user_id
    AND  period_year  = p_year
    AND  period_month = p_month
  RETURNING routes_generated INTO v_new_count;

  -- If the row did not exist yet, insert it.
  -- The Edge Function (rate-limit.ts) normally upserts the row before
  -- calling this RPC, but this INSERT guards against any race where
  -- the row is missing (e.g. first-ever generation with no prior check).
  IF NOT FOUND THEN
    INSERT INTO public.usage_tracking (
      user_id,
      period_year,
      period_month,
      routes_generated,
      routes_limit,
      tier_at_period_start
    )
    VALUES (
      p_user_id,
      p_year,
      p_month,
      1,
      3,        -- free-tier default; overwritten if row exists next time
      'free'
    )
    ON CONFLICT (user_id, period_year, period_month) DO UPDATE
      SET routes_generated = usage_tracking.routes_generated + 1
    RETURNING routes_generated INTO v_new_count;
  END IF;

  RETURN v_new_count;
END;
$$;

COMMENT ON FUNCTION public.increment_routes_generated(UUID, INT, INT) IS
  'Atomically increments routes_generated in usage_tracking for the given '
  'user/year/month period. Inserts a free-tier row if none exists. '
  'Called from the rate-limit Edge Function after a successful generation.';


-- ============================================================
-- 2. increment_cache_hit_count
-- ============================================================
-- Called by: supabase/functions/_shared/cache.ts (incrementHitCount)
--   await serviceClient.rpc('increment_cache_hit_count', {
--     p_cache_key: cacheKey,
--   });
--
-- Behaviour:
--   Atomically increments hit_count and sets last_hit_at = now() on
--   the ai_route_cache row matching p_cache_key. If the key does not
--   exist the UPDATE is a no-op (valid: race with a concurrent expiry
--   deletion). Returns void — the caller only checks for an error.
-- ============================================================

CREATE OR REPLACE FUNCTION public.increment_cache_hit_count(
  p_cache_key TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_route_cache
  SET    hit_count  = hit_count + 1,
         last_hit_at = now()
  WHERE  cache_key = p_cache_key;
  -- No error on NOT FOUND: the entry may have been concurrently expired.
END;
$$;

COMMENT ON FUNCTION public.increment_cache_hit_count(TEXT) IS
  'Atomically increments hit_count and refreshes last_hit_at on an '
  'ai_route_cache entry. No-op when the key no longer exists. '
  'Called asynchronously (fire-and-forget) after every cache hit.';


-- ============================================================
-- 3. get_cache_stats
-- ============================================================
-- Called by: supabase/functions/_shared/cache.ts (getCacheStats)
--   const { data, error } = await serviceClient.rpc('get_cache_stats');
--   // data is read as a single row: { total_entries, hit_rate, avg_hit_count }
--
-- The TypeScript fallback (getCacheStatsJs) computes:
--   hit_rate    = count(rows where hit_count > 0) / total
--   avgHitCount = sum(hit_count) / total
--
-- This SQL mirrors that exact logic so the RPC and JS paths agree.
-- RETURNS TABLE so supabase-js receives a row-set; the caller reads [0].
-- When the table is empty, a single row of zeroes is returned so the
-- caller always gets a non-null result.
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_cache_stats()
RETURNS TABLE (
  total_entries BIGINT,
  hit_rate      NUMERIC,
  avg_hit_count NUMERIC
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    COUNT(*)::BIGINT                                            AS total_entries,
    CASE COUNT(*)
      WHEN 0 THEN 0::NUMERIC
      ELSE ROUND(
        COUNT(*) FILTER (WHERE hit_count > 0)::NUMERIC
        / COUNT(*)::NUMERIC,
        4
      )
    END                                                         AS hit_rate,
    CASE COUNT(*)
      WHEN 0 THEN 0::NUMERIC
      ELSE ROUND(AVG(hit_count)::NUMERIC, 2)
    END                                                         AS avg_hit_count
  FROM public.ai_route_cache;
$$;

COMMENT ON FUNCTION public.get_cache_stats() IS
  'Returns aggregate cache statistics: total_entries, hit_rate (fraction '
  'of entries hit at least once), avg_hit_count. Always returns exactly '
  'one row; zeroes when the table is empty. '
  'Called from the cache Edge Function for monitoring dashboards.';


-- ============================================================
-- 4. Widen travel_mode_from_previous CHECK constraint
-- ============================================================
-- The original constraint in 003_routes.sql only accepted legacy values:
--   ('walk', 'transit', 'drive', 'taxi', 'bike')
--
-- The TypeScript TransportMode type uses different tokens:
--   ('walking', 'public', 'car', 'mixed')
--
-- This ALTER widens the constraint to accept all eight values so that
-- Edge Functions writing route_stops never hit a CHECK violation.
-- The constraint is dropped by its PostgreSQL-generated name
-- (route_stops_travel_mode_from_previous_check) and re-added inline.
-- ============================================================

ALTER TABLE public.route_stops
  DROP CONSTRAINT IF EXISTS route_stops_travel_mode_from_previous_check;

ALTER TABLE public.route_stops
  ADD CONSTRAINT route_stops_travel_mode_from_previous_check
  CHECK (travel_mode_from_previous IN (
    -- Legacy DB tokens (used by earlier migrations and manual inserts)
    'walk', 'transit', 'drive', 'taxi', 'bike',
    -- TypeScript TransportMode tokens (used by Edge Functions)
    'walking', 'public', 'car', 'mixed'
  ));

COMMENT ON COLUMN public.route_stops.travel_mode_from_previous IS
  'Transport mode from the previous stop. '
  'Legacy tokens: walk | transit | drive | taxi | bike. '
  'TypeScript tokens: walking | public | car | mixed.';
