-- ============================================================
-- 004_gamification.sql
-- Gamification layer: Digital Passport and visited place history.
--
-- Tables:
--   public.passport_stamps — one stamp per unique city visited
--   public.visited_places  — Memory Layer 3, all places visited
--
-- Uniqueness:
--   passport_stamps: UNIQUE(user_id, city, country) — one stamp
--     per city regardless of how many times the user visits.
--     stamp_date records the FIRST visit date.
--
--   visited_places: one record per (user_id, place_id) when
--     place_id is not null, enforced by a partial unique index.
--     place_id IS NULL records (manually-logged visits) can repeat.
-- ============================================================


-- ========================
-- public.passport_stamps
-- ========================
-- One stamp per city. Created automatically after a route is
-- completed, or manually from the post-trip feedback flow.

CREATE TABLE IF NOT EXISTS public.passport_stamps (
  id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID         NOT NULL
                    REFERENCES public.users(id) ON DELETE CASCADE,
  route_id        UUID
                    REFERENCES public.routes(id) ON DELETE SET NULL, -- nullable: stamp may outlive the route

  -- City identity
  city            TEXT         NOT NULL,
  country         TEXT         NOT NULL,
  country_code    TEXT                                               -- ISO 3166-1 alpha-2, e.g. 'TR', 'IT'
                    CHECK (country_code IS NULL OR length(country_code) = 2),

  -- Stamp metadata
  stamp_date      DATE         NOT NULL,                            -- date of first visit
  stamp_image_url TEXT,                                            -- custom badge image from Supabase Storage

  created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),

  -- One stamp per city per user (regardless of how many times visited)
  UNIQUE (user_id, city, country)
);

COMMENT ON TABLE  public.passport_stamps              IS 'Digital passport stamps. One per city per user.';
COMMENT ON COLUMN public.passport_stamps.stamp_date   IS 'Date of FIRST visit to this city.';
COMMENT ON COLUMN public.passport_stamps.country_code IS 'ISO 3166-1 alpha-2 code, e.g. TR, IT, FR.';
COMMENT ON COLUMN public.passport_stamps.route_id     IS 'The route that earned this stamp. Nullable — stamp survives route deletion.';


-- ========================
-- public.visited_places
-- ========================
-- Memory Layer 3 — the full history of places a user has visited.
-- Populated by Memory Agent after post-trip feedback.
-- user_rating is the user's subjective rating (1-5), distinct from
-- the google_rating snapshot on route_stops.

CREATE TABLE IF NOT EXISTS public.visited_places (
  id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID         NOT NULL
                 REFERENCES public.users(id) ON DELETE CASCADE,

  -- Place identity
  place_id     TEXT,                             -- Google Maps place_id (may be null for manually logged places)
  place_name   TEXT         NOT NULL,
  city         TEXT         NOT NULL,
  country      TEXT         NOT NULL,
  category     TEXT
                 CHECK (category IN (
                   'landmark', 'restaurant', 'cafe', 'museum',
                   'park', 'market', 'hidden_gem', 'viewpoint',
                   'religious', 'shopping', 'entertainment', 'other'
                 )),

  -- User feedback
  user_rating  SMALLINT
                 CHECK (user_rating IS NULL OR user_rating BETWEEN 1 AND 5),
  visited_at   DATE,
  notes        TEXT,        -- free-text note from post-trip feedback

  created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.visited_places              IS 'AI Memory Layer 3. Full history of places visited by the user.';
COMMENT ON COLUMN public.visited_places.place_id     IS 'Google Maps place_id. NULL for manually-logged places.';
COMMENT ON COLUMN public.visited_places.user_rating  IS 'User subjective rating 1-5. 5 = loved it, 1 = would not return.';
COMMENT ON COLUMN public.visited_places.notes        IS 'User free-text note captured during post-trip feedback.';

CREATE TRIGGER trg_visited_places_set_updated_at
  BEFORE UPDATE ON public.visited_places
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();
