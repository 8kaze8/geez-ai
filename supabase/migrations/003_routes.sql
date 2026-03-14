-- ============================================================
-- 003_routes.sql
-- Route and stop tables.
--
-- Tables:
--   public.routes      — AI-generated travel itineraries
--   public.route_stops — individual stops within a route
--
-- Soft delete strategy: status = 'deleted' instead of DELETE.
--   A DELETE RLS policy is intentionally omitted — the soft
--   delete UPDATE policy enforces this at the API level.
--
-- completed_at: auto-set by trigger when status transitions
--   to 'completed'.
--
-- route_stops UNIQUE(route_id, stop_order): prevents duplicate
--   stop positions within the same route.
-- ============================================================


-- ========================
-- public.routes
-- ========================

CREATE TABLE IF NOT EXISTS public.routes (
  id                   UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID          NOT NULL
                         REFERENCES public.users(id) ON DELETE CASCADE,

  -- Destination
  city                 TEXT          NOT NULL,
  country              TEXT          NOT NULL,
  title                TEXT          NOT NULL,         -- AI-generated, e.g. "3 Days in Istanbul: Food & History"
  duration_days        SMALLINT      NOT NULL
                         CHECK (duration_days BETWEEN 1 AND 30),

  -- Trip parameters (used as cache key components)
  travel_style         TEXT          NOT NULL
                         CHECK (travel_style IN ('historical', 'food', 'adventure', 'nature', 'mixed')),
  transport_mode       TEXT          NOT NULL
                         CHECK (transport_mode IN ('walking', 'public', 'car', 'mixed')),
  budget_level         TEXT          NOT NULL
                         CHECK (budget_level IN ('budget', 'mid', 'premium')),
  start_time           TEXT          NOT NULL DEFAULT '09:00'
                         CHECK (start_time ~ '^\d{2}:\d{2}$'),  -- 'HH:MM' format

  -- Lifecycle — soft delete via 'deleted' status
  -- draft: created, not yet confirmed by user
  -- active: user is actively using this route
  -- completed: user marked trip as done
  -- deleted: soft deleted (never physically removed)
  status               TEXT          NOT NULL DEFAULT 'draft'
                         CHECK (status IN ('draft', 'active', 'completed', 'deleted')),
  completed_at         TIMESTAMPTZ,

  -- AI generation metadata
  ai_model_used        TEXT,                           -- e.g. 'claude-sonnet-4-5', 'gpt-4o-mini'
  generation_cost_usd  NUMERIC(8, 5)
                         CHECK (generation_cost_usd IS NULL OR generation_cost_usd >= 0),

  -- Language the route content was generated in
  language             TEXT          NOT NULL DEFAULT 'tr'
                         CHECK (language IN ('tr', 'en')),

  created_at           TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ   NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.routes                    IS 'AI-generated travel itineraries. Soft delete via status=deleted.';
COMMENT ON COLUMN public.routes.travel_style       IS 'historical | food | adventure | nature | mixed';
COMMENT ON COLUMN public.routes.transport_mode     IS 'walking | public | car | mixed';
COMMENT ON COLUMN public.routes.budget_level       IS 'budget | mid | premium';
COMMENT ON COLUMN public.routes.status             IS 'draft | active | completed | deleted — never use DELETE';
COMMENT ON COLUMN public.routes.start_time         IS 'Preferred daily start time in HH:MM format, e.g. 09:00';
COMMENT ON COLUMN public.routes.generation_cost_usd IS 'Actual Claude/GPT API cost for this route generation.';

CREATE TRIGGER trg_routes_set_updated_at
  BEFORE UPDATE ON public.routes
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();


-- ========================
-- Auto-set completed_at
-- ========================
-- When a route transitions to status = 'completed', set
-- completed_at to now() if not already set.

CREATE OR REPLACE FUNCTION public.handle_route_completed()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.status = 'completed' AND OLD.status <> 'completed' THEN
    NEW.completed_at = COALESCE(NEW.completed_at, now());
  END IF;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.handle_route_completed() IS
  'Auto-sets completed_at when route status transitions to completed.';

CREATE TRIGGER trg_routes_set_completed_at
  BEFORE UPDATE ON public.routes
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_route_completed();


-- ========================
-- public.route_stops
-- ========================
-- Each stop belongs to exactly one route.
-- stop_order is 1-based and unique within a route.
-- day_number is 1-based (day 1, day 2, …).

CREATE TABLE IF NOT EXISTS public.route_stops (
  id                          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id                    UUID          NOT NULL
                                REFERENCES public.routes(id) ON DELETE CASCADE,

  -- Ordering
  stop_order                  SMALLINT      NOT NULL
                                CHECK (stop_order >= 1),
  day_number                  SMALLINT      NOT NULL
                                CHECK (day_number >= 1),

  -- Place identity
  place_name                  TEXT          NOT NULL,
  place_id                    TEXT,                       -- Google Maps place_id
  latitude                    NUMERIC(10, 7),
  longitude                   NUMERIC(10, 7),
  category                    TEXT
                                CHECK (category IN (
                                  'landmark', 'restaurant', 'cafe', 'museum',
                                  'park', 'market', 'hidden_gem', 'viewpoint',
                                  'religious', 'shopping', 'entertainment', 'other'
                                )),

  -- AI-generated content
  description                 TEXT,
  insider_tip                 TEXT,
  fun_fact                    TEXT,
  best_time                   TEXT,                       -- Human-readable, e.g. "Weekday mornings 09-11"
  warnings                    TEXT,                       -- e.g. "Closed Fridays 12:30-14:00"

  -- Review synthesis (from Research Agent)
  review_summary              TEXT,
  google_rating               NUMERIC(2, 1)
                                CHECK (google_rating IS NULL OR google_rating BETWEEN 0.0 AND 5.0),
  review_count                INT
                                CHECK (review_count IS NULL OR review_count >= 0),

  -- Practical info
  estimated_duration_min      SMALLINT
                                CHECK (estimated_duration_min IS NULL OR estimated_duration_min > 0),
  entry_fee_text              TEXT,                       -- Human-readable, e.g. "Free" or "₺200 adults"
  entry_fee_amount            NUMERIC(10, 2)
                                CHECK (entry_fee_amount IS NULL OR entry_fee_amount >= 0),
  entry_fee_currency          TEXT          DEFAULT 'TRY',

  -- Navigation from the previous stop
  travel_from_previous_min    SMALLINT
                                CHECK (travel_from_previous_min IS NULL OR travel_from_previous_min >= 0),
  travel_mode_from_previous   TEXT
                                CHECK (travel_mode_from_previous IN ('walk', 'transit', 'drive', 'taxi', 'bike')),

  -- Gamification
  discovery_points            SMALLINT      NOT NULL DEFAULT 0
                                CHECK (discovery_points >= 0),

  -- Suggested timing (local time, no date)
  suggested_start_time        TIME,
  suggested_end_time          TIME,

  -- Ensure each stop has a unique position within its route
  UNIQUE (route_id, stop_order),

  created_at                  TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ   NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.route_stops                       IS 'Individual stops within a route. UNIQUE(route_id, stop_order).';
COMMENT ON COLUMN public.route_stops.stop_order            IS '1-based position within the full itinerary.';
COMMENT ON COLUMN public.route_stops.day_number            IS '1-based day number within the trip.';
COMMENT ON COLUMN public.route_stops.discovery_points      IS 'Gamification points. Hidden gems = high. Tourist traps = low.';
COMMENT ON COLUMN public.route_stops.entry_fee_text        IS 'Human-readable fee string, e.g. "Free" or "₺200 adults / ₺100 students".';
COMMENT ON COLUMN public.route_stops.google_rating         IS 'Snapshot from Research Agent. Range 0.0–5.0.';

CREATE TRIGGER trg_route_stops_set_updated_at
  BEFORE UPDATE ON public.route_stops
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();
