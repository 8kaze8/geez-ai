-- ============================================================
-- 007_subscriptions.sql
-- Subscription management and usage tracking.
--
-- Tables:
--   public.subscriptions  — RevenueCat-synced subscription records
--   public.usage_tracking — monthly usage counters per user
--
-- Design notes:
--   • subscriptions is written by the Supabase Edge Function that
--     handles RevenueCat webhooks (service_role). Users can only
--     SELECT their own row.
--
--   • usage_tracking enforces the free-tier limit:
--       free tier: 3 routes/month
--       premium:   unlimited
--     The Edge Function increments routes_generated_this_month
--     and checks against the limit before starting generation.
--     A pg_cron job resets the counter on the 1st of each month.
--
--   • UNIQUE(user_id, period_year, period_month) ensures one
--     row per user per calendar month.
-- ============================================================


-- ========================
-- public.subscriptions
-- ========================
-- One row per user. Upserted by RevenueCat webhook handler.
-- The users.subscription_tier column is the denormalised fast-path
-- used in RLS and rate limit checks; this table is the source of
-- truth with the full RevenueCat payload.

CREATE TABLE IF NOT EXISTS public.subscriptions (
  id                        UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                   UUID          NOT NULL UNIQUE
                              REFERENCES public.users(id) ON DELETE CASCADE,

  -- RevenueCat identifiers
  revenuecat_user_id        TEXT          UNIQUE,        -- RevenueCat's $RCAnonymousID or app user ID
  revenuecat_entitlement_id TEXT,                        -- e.g. 'premium'
  product_id                TEXT,                        -- e.g. 'geez_premium_monthly'
  store                     TEXT
                              CHECK (store IS NULL OR store IN ('app_store', 'play_store', 'stripe', 'promotional')),

  -- Current state
  status                    TEXT          NOT NULL DEFAULT 'inactive'
                              CHECK (status IN ('active', 'inactive', 'expired', 'billing_retry', 'paused')),
  tier                      TEXT          NOT NULL DEFAULT 'free'
                              CHECK (tier IN ('free', 'premium')),

  -- Dates
  started_at                TIMESTAMPTZ,
  expires_at                TIMESTAMPTZ,
  cancelled_at              TIMESTAMPTZ,
  trial_ends_at             TIMESTAMPTZ,                 -- 7-day free trial

  -- Raw webhook payload for audit / debugging
  -- JSONB schema: RevenueCat CustomerInfo object
  raw_payload               JSONB         NOT NULL DEFAULT '{}'::jsonb,

  created_at                TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at                TIMESTAMPTZ   NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.subscriptions                    IS 'RevenueCat subscription records. Written by webhook Edge Function (service_role).';
COMMENT ON COLUMN public.subscriptions.revenuecat_user_id IS 'RevenueCat app user ID or anonymous ID.';
COMMENT ON COLUMN public.subscriptions.status             IS 'active | inactive | expired | billing_retry | paused';
COMMENT ON COLUMN public.subscriptions.raw_payload        IS 'Full RevenueCat CustomerInfo JSONB for audit trail.';
COMMENT ON COLUMN public.subscriptions.trial_ends_at      IS '7-day free premium trial end date. NULL if no trial.';

CREATE TRIGGER trg_subscriptions_set_updated_at
  BEFORE UPDATE ON public.subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();


-- ========================
-- public.usage_tracking
-- ========================
-- Tracks per-user monthly usage for rate limiting.
-- One row per (user_id, period_year, period_month).
-- Reset by pg_cron on the 1st of each month (configured separately).
--
-- Free tier limit: 3 routes/month
-- Premium limit:   no enforced limit (checked in Edge Function)

CREATE TABLE IF NOT EXISTS public.usage_tracking (
  id                          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                     UUID          NOT NULL
                                REFERENCES public.users(id) ON DELETE CASCADE,

  -- Calendar period (UTC)
  period_year                 SMALLINT      NOT NULL
                                CHECK (period_year >= 2024),
  period_month                SMALLINT      NOT NULL
                                CHECK (period_month BETWEEN 1 AND 12),

  -- Counters
  routes_generated            INT           NOT NULL DEFAULT 0
                                CHECK (routes_generated >= 0),
  routes_limit                SMALLINT      NOT NULL DEFAULT 3  -- 3 for free, effectively unlimited (9999) for premium
                                CHECK (routes_limit > 0),

  -- Snapshot of subscription tier at time of last increment
  -- (so we know what limit was in effect if tier changes mid-month)
  tier_at_period_start        TEXT          NOT NULL DEFAULT 'free'
                                CHECK (tier_at_period_start IN ('free', 'premium')),

  -- One row per user per calendar month
  UNIQUE (user_id, period_year, period_month),

  created_at                  TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ   NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.usage_tracking                       IS 'Monthly usage counters. Enforces free-tier 3 routes/month limit.';
COMMENT ON COLUMN public.usage_tracking.routes_generated      IS 'Number of routes generated this calendar month.';
COMMENT ON COLUMN public.usage_tracking.routes_limit          IS '3 for free tier. Set to 9999 for premium on row creation.';
COMMENT ON COLUMN public.usage_tracking.tier_at_period_start  IS 'Subscription tier snapshot. Prevents retroactive limit changes.';

CREATE TRIGGER trg_usage_tracking_set_updated_at
  BEFORE UPDATE ON public.usage_tracking
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();


-- ========================
-- Subscription → users sync
-- ========================
-- When a subscription row becomes active or expires, keep
-- users.subscription_tier in sync so RLS/Edge Functions can
-- use the denormalised value without a JOIN.

CREATE OR REPLACE FUNCTION public.sync_subscription_tier_to_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.users
  SET subscription_tier = NEW.tier,
      subscription_expires_at = NEW.expires_at
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.sync_subscription_tier_to_user() IS
  'SECURITY DEFINER. Keeps users.subscription_tier in sync when subscription changes.';

CREATE TRIGGER trg_subscriptions_sync_tier
  AFTER INSERT OR UPDATE OF status, tier ON public.subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION public.sync_subscription_tier_to_user();
