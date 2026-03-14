-- ============================================================
-- 009_indexes.sql
-- Performance indexes for all tables.
--
-- Naming convention: idx_{table}_{columns}
--
-- Categories:
--   1. Foreign key indexes     — every FK column that isn't already PK
--   2. Single-column indexes   — high-cardinality lookup columns
--   3. Composite indexes       — multi-column query patterns
--   4. Partial indexes         — WHERE-filtered for common subsets
--   5. GIN indexes             — JSONB containment queries
--   6. GIN trigram indexes     — case-insensitive text search
--
-- The IVFFlat vector index on place_embeddings is in 006_ai_cache.sql
-- where the table is defined (keeping table + its main index together).
-- ============================================================


-- ============================================================
-- 1. FOREIGN KEY INDEXES
-- PostgreSQL does NOT auto-create indexes on FK columns.
-- Missing FK indexes cause seq scans on JOIN and CASCADE ops.
-- ============================================================

-- user_profiles.user_id
CREATE INDEX idx_user_profiles_user_id
  ON public.user_profiles (user_id);

-- travel_personas.user_id
CREATE INDEX idx_travel_personas_user_id
  ON public.travel_personas (user_id);

-- routes.user_id
CREATE INDEX idx_routes_user_id
  ON public.routes (user_id);

-- route_stops.route_id
CREATE INDEX idx_route_stops_route_id
  ON public.route_stops (route_id);

-- passport_stamps.user_id
CREATE INDEX idx_passport_stamps_user_id
  ON public.passport_stamps (user_id);

-- passport_stamps.route_id (nullable FK — SET NULL on route delete)
CREATE INDEX idx_passport_stamps_route_id
  ON public.passport_stamps (route_id)
  WHERE route_id IS NOT NULL;

-- visited_places.user_id
CREATE INDEX idx_visited_places_user_id
  ON public.visited_places (user_id);

-- trip_feedback.user_id
CREATE INDEX idx_trip_feedback_user_id
  ON public.trip_feedback (user_id);

-- trip_feedback.route_id
CREATE INDEX idx_trip_feedback_route_id
  ON public.trip_feedback (route_id);

-- subscriptions.user_id  (already UNIQUE, covered by unique index)
-- subscriptions.revenuecat_user_id (already UNIQUE, covered by unique index)

-- usage_tracking.user_id  (covered by UNIQUE(user_id, period_year, period_month))


-- ============================================================
-- 2. SINGLE-COLUMN INDEXES
-- ============================================================

-- routes: status filter (dashboard "active routes" queries)
CREATE INDEX idx_routes_status
  ON public.routes (status);

-- routes: created_at DESC for "recent routes" feed
CREATE INDEX idx_routes_created_at
  ON public.routes (created_at DESC);

-- route_stops: place_id lookup (check if a place is already in a route)
CREATE INDEX idx_route_stops_place_id
  ON public.route_stops (place_id)
  WHERE place_id IS NOT NULL;

-- visited_places: place_id lookup (Memory Agent de-duplication)
CREATE INDEX idx_visited_places_place_id
  ON public.visited_places (place_id)
  WHERE place_id IS NOT NULL;

-- ai_route_cache: expires_at (TTL sweep + RLS expiry filter)
CREATE INDEX idx_ai_route_cache_expires_at
  ON public.ai_route_cache (expires_at);

-- place_embeddings: embedding_model (re-embedding job filters by model)
CREATE INDEX idx_place_embeddings_model
  ON public.place_embeddings (embedding_model);

-- subscriptions: status (webhook handler queries active subscriptions)
CREATE INDEX idx_subscriptions_status
  ON public.subscriptions (status);

-- subscriptions: expires_at (find expiring subscriptions for renewal push)
CREATE INDEX idx_subscriptions_expires_at
  ON public.subscriptions (expires_at)
  WHERE expires_at IS NOT NULL;


-- ============================================================
-- 3. COMPOSITE INDEXES
-- Cover the most common multi-column query patterns.
-- ============================================================

-- routes: user + status — "show me my active/draft routes"
CREATE INDEX idx_routes_user_status
  ON public.routes (user_id, status);

-- routes: user + created_at DESC — "show me my recent routes"
CREATE INDEX idx_routes_user_created_at
  ON public.routes (user_id, created_at DESC);

-- routes: city + country + travel_style + language — cache key lookup
-- (Partial match before checking cache_key string)
CREATE INDEX idx_routes_destination_style
  ON public.routes (city, country, travel_style, language);

-- route_stops: route + order — "get all stops in sequence"
-- (Most frequent query: render the itinerary card list)
CREATE INDEX idx_route_stops_route_order
  ON public.route_stops (route_id, stop_order);

-- route_stops: route + day — "get day N stops"
CREATE INDEX idx_route_stops_route_day
  ON public.route_stops (route_id, day_number);

-- visited_places: user + city — "what did I visit in Istanbul?"
CREATE INDEX idx_visited_places_user_city
  ON public.visited_places (user_id, city);

-- visited_places: user + visited_at DESC — "my recent history"
CREATE INDEX idx_visited_places_user_visited_at
  ON public.visited_places (user_id, visited_at DESC)
  WHERE visited_at IS NOT NULL;

-- passport_stamps: user + stamp_date DESC — "my most recent stamps"
CREATE INDEX idx_passport_stamps_user_date
  ON public.passport_stamps (user_id, stamp_date DESC);

-- place_embeddings: city + category — pre-filter before vector search
CREATE INDEX idx_place_embeddings_city_category
  ON public.place_embeddings (city, country, category);

-- usage_tracking: user + period — "how many routes this month?"
-- (Covered by UNIQUE constraint index, listed here for documentation)
-- CREATE INDEX idx_usage_tracking_user_period  ← already covered by UNIQUE


-- ============================================================
-- 4. PARTIAL INDEXES
-- Smaller, faster indexes that cover the most-queried subsets.
-- ============================================================

-- routes: active routes only — the hot path (users currently on a trip)
CREATE INDEX idx_routes_active
  ON public.routes (user_id, created_at DESC)
  WHERE status = 'active';

-- routes: non-deleted routes — excludes soft-deleted from common queries
CREATE INDEX idx_routes_not_deleted
  ON public.routes (user_id, created_at DESC)
  WHERE status <> 'deleted';

-- route_stops: stops with Google place_id (Research Agent enrichment queries)
CREATE INDEX idx_route_stops_with_place_id
  ON public.route_stops (place_id)
  WHERE place_id IS NOT NULL;

-- ai_route_cache: composite index for cache key + expiry lookups
-- Note: now() is not IMMUTABLE so it cannot be used in a partial index WHERE clause.
-- Instead we use a composite index on (cache_key, expires_at) and filter at query time.
CREATE INDEX idx_ai_route_cache_valid
  ON public.ai_route_cache (cache_key, expires_at);

-- subscriptions: active subscriptions only — used in tier checks
CREATE INDEX idx_subscriptions_active
  ON public.subscriptions (user_id, expires_at)
  WHERE status = 'active';

-- visited_places: places with user ratings — for Memory Agent preference learning
CREATE INDEX idx_visited_places_rated
  ON public.visited_places (user_id, user_rating)
  WHERE user_rating IS NOT NULL;


-- ============================================================
-- 5. GIN INDEXES — JSONB containment queries
-- Use the @> operator: column @> '{"key": value}'
-- ============================================================

-- user_profiles.preferred_activities — "find users who like history"
CREATE INDEX idx_user_profiles_preferred_activities
  ON public.user_profiles USING gin (preferred_activities);

-- user_profiles.food_preferences — "find vegetarian users"
CREATE INDEX idx_user_profiles_food_preferences
  ON public.user_profiles USING gin (food_preferences);

-- ai_route_cache.route_data — internal queries on cached stop data
CREATE INDEX idx_ai_route_cache_route_data
  ON public.ai_route_cache USING gin (route_data);

-- place_embeddings.metadata — filter by tag, rating, etc. before vector search
CREATE INDEX idx_place_embeddings_metadata
  ON public.place_embeddings USING gin (metadata);


-- ============================================================
-- 6. GIN TRIGRAM INDEXES — case-insensitive text search
-- Requires pg_trgm extension (loaded in 001_extensions.sql).
-- Use with ILIKE or % operator: column % 'search term'
-- ============================================================

-- routes: search by city name (city autocomplete / search)
CREATE INDEX idx_routes_city_trgm
  ON public.routes USING gin (city gin_trgm_ops);

-- place_embeddings: search by place name
CREATE INDEX idx_place_embeddings_place_name_trgm
  ON public.place_embeddings USING gin (place_name gin_trgm_ops);

-- visited_places: search by place name (history search)
CREATE INDEX idx_visited_places_place_name_trgm
  ON public.visited_places USING gin (place_name gin_trgm_ops);
