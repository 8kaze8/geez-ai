-- ============================================================
-- 011_cache_and_category_fixes.sql
--
-- Fixes:
--
--   1. Add 'beach' to the category CHECK constraint on
--      route_stops.category, visited_places.category, and
--      place_embeddings.category so that beach destinations
--      (e.g. Bodrum, Antalya, Bali) are stored with the correct
--      category value instead of falling back to 'other'.
--
--   2. Update the COMMENT on ai_route_cache.route_data to match
--      the actual RouteResponse shape used by the Edge Functions
--      (RouteResponse interface from _shared/types.ts):
--        { routeId, title, city, country, durationDays, days,
--          aiModelUsed, generationCostUsd, createdAt }
--      The previous comment described a stale internal schema.
--
-- Strategy: DROP the old constraint by name, ADD the new one.
--   PostgreSQL does not support ALTER ... CHECK in-place; the
--   drop-and-recreate pattern is the standard approach.
--   All three tables use the same category value set.
-- ============================================================


-- ============================================================
-- 1a. route_stops.category — add 'beach'
-- ============================================================

ALTER TABLE public.route_stops
  DROP CONSTRAINT IF EXISTS route_stops_category_check;

ALTER TABLE public.route_stops
  ADD CONSTRAINT route_stops_category_check
  CHECK (category IN (
    'landmark', 'restaurant', 'cafe', 'museum',
    'park', 'market', 'hidden_gem', 'viewpoint',
    'religious', 'shopping', 'entertainment',
    'beach',
    'other'
  ));

COMMENT ON COLUMN public.route_stops.category IS
  'landmark | restaurant | cafe | museum | park | market | hidden_gem | viewpoint | religious | shopping | entertainment | beach | other';


-- ============================================================
-- 1b. visited_places.category — add 'beach'
-- ============================================================

ALTER TABLE public.visited_places
  DROP CONSTRAINT IF EXISTS visited_places_category_check;

ALTER TABLE public.visited_places
  ADD CONSTRAINT visited_places_category_check
  CHECK (category IN (
    'landmark', 'restaurant', 'cafe', 'museum',
    'park', 'market', 'hidden_gem', 'viewpoint',
    'religious', 'shopping', 'entertainment',
    'beach',
    'other'
  ));

COMMENT ON COLUMN public.visited_places.category IS
  'landmark | restaurant | cafe | museum | park | market | hidden_gem | viewpoint | religious | shopping | entertainment | beach | other';


-- ============================================================
-- 1c. place_embeddings.category — add 'beach'
--     (defined in 006_ai_cache.sql, same value set)
-- ============================================================

ALTER TABLE public.place_embeddings
  DROP CONSTRAINT IF EXISTS place_embeddings_category_check;

ALTER TABLE public.place_embeddings
  ADD CONSTRAINT place_embeddings_category_check
  CHECK (category IN (
    'landmark', 'restaurant', 'cafe', 'museum',
    'park', 'market', 'hidden_gem', 'viewpoint',
    'religious', 'shopping', 'entertainment',
    'beach',
    'other'
  ));

COMMENT ON COLUMN public.place_embeddings.category IS
  'landmark | restaurant | cafe | museum | park | market | hidden_gem | viewpoint | religious | shopping | entertainment | beach | other';


-- ============================================================
-- 2. Fix stale JSONB schema comment on ai_route_cache.route_data
--
--    Previous (stale): {stops:[...], city_intro:string, ai_model:string}
--    Correct shape is the full RouteResponse from _shared/types.ts:
--      {
--        routeId:           string   (UUID of the originating route row),
--        title:             string,
--        city:              string,
--        country:           string,
--        durationDays:      number,
--        days:              DayPlan[],     -- [{dayNumber, title, stops:[StopData]}]
--        aiModelUsed:       string,        -- "gemini" | "openai" | "anthropic"
--        generationCostUsd: number,
--        createdAt:         string         -- ISO 8601
--      }
--
--    Note: when served on a cache HIT, the consuming Edge Function creates
--    a fresh route row for the current user and returns a new routeId — the
--    routeId stored inside route_data is the original generator's routeId
--    and must NOT be returned directly to any other user.
-- ============================================================

COMMENT ON COLUMN public.ai_route_cache.route_data IS
  'Full RouteResponse payload (types.ts). JSONB shape: {routeId:string, title:string, city:string, country:string, durationDays:number, days:[{dayNumber,title,stops:[StopData]}], aiModelUsed:string, generationCostUsd:number, createdAt:string}. WARNING: routeId is the original generator''s row — never return it directly to another user on a cache hit.';
