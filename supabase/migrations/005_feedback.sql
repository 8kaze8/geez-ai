-- ============================================================
-- 005_feedback.sql
-- Post-trip feedback table.
--
-- Tables:
--   public.trip_feedback — user feedback after completing a route
--
-- Design notes:
--   • UNIQUE(user_id, route_id) — exactly one feedback per route.
--   • favorite_stops / disliked_stops store route_stop UUIDs.
--     Stored as UUID[] — the Memory Agent reads these and calls
--     visited_places upsert for each entry.
--   • Ratings use CHECK constraints; text fields use enum-style
--     CHECK constraints to reject invalid values at the DB level.
--   • No updated_at — feedback is written once. If re-submission
--     is needed, use ON CONFLICT ... DO UPDATE at the API layer.
-- ============================================================


-- ========================
-- public.trip_feedback
-- ========================

CREATE TABLE IF NOT EXISTS public.trip_feedback (
  id               UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID         NOT NULL
                     REFERENCES public.users(id) ON DELETE CASCADE,
  route_id         UUID         NOT NULL
                     REFERENCES public.routes(id) ON DELETE CASCADE,

  -- Ratings
  overall_rating   SMALLINT
                     CHECK (overall_rating IS NULL OR overall_rating BETWEEN 1 AND 5),
  food_rating      TEXT
                     CHECK (food_rating IS NULL OR food_rating IN ('amazing', 'good', 'average', 'poor')),
  pace_feedback    TEXT
                     CHECK (pace_feedback IS NULL OR pace_feedback IN ('too_intense', 'just_right', 'too_slow')),

  -- Stop-level signals (arrays of route_stop UUIDs)
  favorite_stops   UUID[]       NOT NULL DEFAULT '{}',
  disliked_stops   UUID[]       NOT NULL DEFAULT '{}',

  -- Free-text comment from the user
  free_text        TEXT,

  -- One feedback per route per user
  UNIQUE (user_id, route_id),

  created_at       TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.trip_feedback                IS 'Post-trip feedback. One row per (user, route). Feeds Memory Agent learning loop.';
COMMENT ON COLUMN public.trip_feedback.favorite_stops IS 'Array of route_stop IDs the user loved. Memory Agent upserts these to visited_places with rating=5.';
COMMENT ON COLUMN public.trip_feedback.disliked_stops IS 'Array of route_stop IDs the user disliked. Memory Agent upserts these with rating=2.';
COMMENT ON COLUMN public.trip_feedback.pace_feedback  IS 'too_intense | just_right | too_slow — used to update user_profiles.pace_preference.';
COMMENT ON COLUMN public.trip_feedback.food_rating    IS 'amazing | good | average | poor';
