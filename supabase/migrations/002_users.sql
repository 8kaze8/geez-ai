-- ============================================================
-- 002_users.sql
-- Core user tables and auth sync.
--
-- Tables:
--   public.users          — mirrors auth.users, app-level profile data
--   public.user_profiles  — Memory Layer 1 (static) + Layer 2 (learned)
--   public.travel_personas — Memory Layer 4 (evolving persona + gamification)
--
-- Auth sync:
--   trg_on_auth_user_created fires AFTER INSERT on auth.users
--   (SECURITY DEFINER so it can write to public schema from auth trigger)
--
-- Auto-created rows:
--   Every new auth.users row → public.users + user_profiles + travel_personas
-- ============================================================


-- ========================
-- public.users
-- ========================
-- id is NOT gen_random_uuid() — it comes directly from auth.users.
-- ON DELETE CASCADE ensures the public row is cleaned up when the
-- auth account is deleted.

CREATE TABLE IF NOT EXISTS public.users (
  id                     UUID         PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email                  TEXT         NOT NULL UNIQUE,
  display_name           TEXT,
  avatar_url             TEXT,
  language               TEXT         NOT NULL DEFAULT 'tr'
                           CHECK (language IN ('tr', 'en')),
  subscription_tier      TEXT         NOT NULL DEFAULT 'free'
                           CHECK (subscription_tier IN ('free', 'premium')),
  subscription_expires_at TIMESTAMPTZ,
  created_at             TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.users                      IS 'Application-level user record. Mirrors auth.users.';
COMMENT ON COLUMN public.users.id                   IS 'Same UUID as auth.users.id — not generated here.';
COMMENT ON COLUMN public.users.language             IS 'UI language: tr | en';
COMMENT ON COLUMN public.users.subscription_tier    IS 'free (3 routes/month) | premium (unlimited)';
COMMENT ON COLUMN public.users.subscription_expires_at IS 'NULL for free tier. Set by subscription webhook.';

CREATE TRIGGER trg_users_set_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();


-- ========================
-- public.user_profiles
-- ========================
-- Memory Layer 1 (static demographic, set during onboarding)
-- Memory Layer 2 (learned preferences, updated by Memory Agent)
-- One row per user — enforced with UNIQUE(user_id).

CREATE TABLE IF NOT EXISTS public.user_profiles (
  id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID        NOT NULL UNIQUE
                         REFERENCES public.users(id) ON DELETE CASCADE,

  -- Layer 1: Static (set during onboarding Q&A)
  age_group            TEXT
                         CHECK (age_group IN ('18-25', '25-35', '35-45', '45+')),
  travel_companion     TEXT
                         CHECK (travel_companion IN ('solo', 'couple', 'friends', 'family')),
  default_budget       TEXT
                         CHECK (default_budget IN ('budget', 'mid', 'premium')),

  -- Layer 2: Learned (written by Memory Agent after each trip)
  -- JSONB schema: ["history", "food", "nature", "adventure", "culture"]
  preferred_activities JSONB        NOT NULL DEFAULT '[]'::jsonb,
  -- JSONB schema: {"vegetarian": bool, "vegan": bool, "street_food": bool, "fine_dining": bool}
  food_preferences     JSONB        NOT NULL DEFAULT '{}'::jsonb,
  pace_preference      TEXT         NOT NULL DEFAULT 'normal'
                         CHECK (pace_preference IN ('relaxed', 'normal', 'intense')),
  morning_person       BOOLEAN      NOT NULL DEFAULT true,
  crowd_tolerance      TEXT         NOT NULL DEFAULT 'medium'
                         CHECK (crowd_tolerance IN ('low', 'medium', 'high')),

  created_at           TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.user_profiles                    IS 'AI Memory Layers 1 & 2. One row per user.';
COMMENT ON COLUMN public.user_profiles.preferred_activities IS 'JSONB array: ["history","food","nature","adventure","culture"]';
COMMENT ON COLUMN public.user_profiles.food_preferences     IS 'JSONB object: {"vegetarian":bool,"vegan":bool,"street_food":bool,"fine_dining":bool}';

CREATE TRIGGER trg_user_profiles_set_updated_at
  BEFORE UPDATE ON public.user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();


-- ========================
-- public.travel_personas
-- ========================
-- Memory Layer 4 — the evolving travel persona.
-- Level columns go from 1 (min) to 10 (max), updated by Memory Agent
-- after every completed trip + feedback cycle.
-- One row per user — enforced with UNIQUE(user_id).

CREATE TABLE IF NOT EXISTS public.travel_personas (
  id                      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                 UUID        NOT NULL UNIQUE
                            REFERENCES public.users(id) ON DELETE CASCADE,

  -- Persona category levels (1-10)
  foodie_level            SMALLINT    NOT NULL DEFAULT 1
                            CHECK (foodie_level BETWEEN 1 AND 10),
  history_buff_level      SMALLINT    NOT NULL DEFAULT 1
                            CHECK (history_buff_level BETWEEN 1 AND 10),
  nature_lover_level      SMALLINT    NOT NULL DEFAULT 1
                            CHECK (nature_lover_level BETWEEN 1 AND 10),
  adventure_seeker_level  SMALLINT    NOT NULL DEFAULT 1
                            CHECK (adventure_seeker_level BETWEEN 1 AND 10),
  culture_explorer_level  SMALLINT    NOT NULL DEFAULT 1
                            CHECK (culture_explorer_level BETWEEN 1 AND 10),

  -- Gamification
  discovery_score         INT         NOT NULL DEFAULT 0
                            CHECK (discovery_score >= 0),
  explorer_tier           TEXT        NOT NULL DEFAULT 'tourist'
                            CHECK (explorer_tier IN ('tourist', 'traveler', 'explorer', 'local', 'legend')),

  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.travel_personas                   IS 'AI Memory Layer 4. Evolving persona updated after each trip.';
COMMENT ON COLUMN public.travel_personas.explorer_tier     IS 'tourist(0) → traveler(200) → explorer(500) → local(1000) → legend(2500)';
COMMENT ON COLUMN public.travel_personas.discovery_score   IS 'Cumulative points. Hidden gems = high points. Tourist traps = low/negative.';

CREATE TRIGGER trg_travel_personas_set_updated_at
  BEFORE UPDATE ON public.travel_personas
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();


-- ========================
-- Auth sync trigger
-- ========================
-- Fires after a new row is inserted into auth.users (Supabase Auth).
-- Creates the corresponding public.users row, then the profile and
-- persona rows are created by the on_user_created trigger below.
-- SECURITY DEFINER so it runs with the definer's permissions,
-- not the anonymous caller's permissions.

CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (NEW.id, NEW.email)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.handle_new_auth_user() IS
  'SECURITY DEFINER. Syncs a new auth.users row to public.users.';

CREATE OR REPLACE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_auth_user();


-- ========================
-- Profile + persona auto-create trigger
-- ========================
-- After public.users row is created (by the auth sync trigger above),
-- automatically create the user_profiles and travel_personas rows.

CREATE OR REPLACE FUNCTION public.handle_new_public_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.user_profiles (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  INSERT INTO public.travel_personas (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.handle_new_public_user() IS
  'Auto-creates user_profiles and travel_personas when a public.users row is inserted.';

CREATE OR REPLACE TRIGGER trg_on_public_user_created
  AFTER INSERT ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_public_user();
