-- ============================================================
-- 008_rls_policies.sql
-- Row Level Security policies for ALL tables.
--
-- Rules applied:
--   • Every user-data table: auth.uid() = user_id (or id for users)
--   • routes: soft delete enforced — UPDATE allowed, no DELETE policy
--   • route_stops: access gated through parent route ownership
--   • place_embeddings: public SELECT, service_role-only write
--   • ai_route_cache: public SELECT (non-expired only), service_role write
--   • subscriptions: user SELECT only, service_role write
--   • usage_tracking: user SELECT only, service_role write
--
-- Naming convention: "table_action_scope"
-- Each policy has an inline comment explaining its intent.
-- ============================================================


-- ========================
-- public.users
-- ========================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Users can read their own row only.
CREATE POLICY "users_select_own"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own row (display_name, avatar_url, language).
-- subscription_tier changes go through the webhook trigger, not direct updates.
CREATE POLICY "users_update_own"
  ON public.users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- INSERT is handled by the auth sync trigger (SECURITY DEFINER).
-- DELETE is handled by Supabase Auth account deletion (CASCADE).


-- ========================
-- public.user_profiles
-- ========================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Users can read their own profile.
CREATE POLICY "user_profiles_select_own"
  ON public.user_profiles FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own profile (onboarding answers, learned preferences).
CREATE POLICY "user_profiles_update_own"
  ON public.user_profiles FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- INSERT is handled by handle_new_public_user() trigger (SECURITY DEFINER).


-- ========================
-- public.travel_personas
-- ========================
ALTER TABLE public.travel_personas ENABLE ROW LEVEL SECURITY;

-- Users can read their own persona.
CREATE POLICY "travel_personas_select_own"
  ON public.travel_personas FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own persona (Memory Agent also updates via service_role).
CREATE POLICY "travel_personas_update_own"
  ON public.travel_personas FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- INSERT is handled by handle_new_public_user() trigger (SECURITY DEFINER).


-- ========================
-- public.routes
-- ========================
ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;

-- Users can read their own routes (including soft-deleted ones so the app
-- can show "this route has been removed" without a 404).
CREATE POLICY "routes_select_own"
  ON public.routes FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert routes for themselves.
CREATE POLICY "routes_insert_own"
  ON public.routes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own routes.
-- Soft delete = UPDATE status to 'deleted'. No DELETE policy below.
CREATE POLICY "routes_update_own"
  ON public.routes FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- No DELETE policy: physical deletion is not exposed to end users.
-- Hard delete (if ever needed for GDPR erasure) goes through
-- a service_role Edge Function with appropriate audit logging.


-- ========================
-- public.route_stops
-- ========================
ALTER TABLE public.route_stops ENABLE ROW LEVEL SECURITY;

-- Access to stops is gated through ownership of the parent route.
-- A subquery is used because route_stops has no direct user_id column.

CREATE POLICY "route_stops_select_own"
  ON public.route_stops FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.routes r
      WHERE r.id = route_stops.route_id
        AND r.user_id = auth.uid()
    )
  );

CREATE POLICY "route_stops_insert_own"
  ON public.route_stops FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.routes r
      WHERE r.id = route_stops.route_id
        AND r.user_id = auth.uid()
    )
  );

CREATE POLICY "route_stops_update_own"
  ON public.route_stops FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.routes r
      WHERE r.id = route_stops.route_id
        AND r.user_id = auth.uid()
    )
  );

-- No DELETE policy on route_stops — stops are deleted only when their
-- parent route is hard-deleted (via CASCADE), which is a service_role op.


-- ========================
-- public.passport_stamps
-- ========================
ALTER TABLE public.passport_stamps ENABLE ROW LEVEL SECURITY;

CREATE POLICY "passport_stamps_select_own"
  ON public.passport_stamps FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users can add stamps (e.g. from the manual "I visited this city" flow).
CREATE POLICY "passport_stamps_insert_own"
  ON public.passport_stamps FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: users can edit stamp metadata (e.g. upload a custom image).
CREATE POLICY "passport_stamps_update_own"
  ON public.passport_stamps FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can remove a stamp if they wish.
CREATE POLICY "passport_stamps_delete_own"
  ON public.passport_stamps FOR DELETE
  USING (auth.uid() = user_id);


-- ========================
-- public.visited_places
-- ========================
ALTER TABLE public.visited_places ENABLE ROW LEVEL SECURITY;

CREATE POLICY "visited_places_select_own"
  ON public.visited_places FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "visited_places_insert_own"
  ON public.visited_places FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "visited_places_update_own"
  ON public.visited_places FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can remove entries from their history.
CREATE POLICY "visited_places_delete_own"
  ON public.visited_places FOR DELETE
  USING (auth.uid() = user_id);


-- ========================
-- public.trip_feedback
-- ========================
ALTER TABLE public.trip_feedback ENABLE ROW LEVEL SECURITY;

CREATE POLICY "trip_feedback_select_own"
  ON public.trip_feedback FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "trip_feedback_insert_own"
  ON public.trip_feedback FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE allows re-submission of feedback (the UNIQUE constraint prevents
-- duplicate rows; the Edge Function uses ON CONFLICT DO UPDATE).
CREATE POLICY "trip_feedback_update_own"
  ON public.trip_feedback FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- No DELETE: feedback is permanent for memory integrity.


-- ========================
-- public.ai_route_cache
-- ========================
-- Cache is public-readable (all authenticated users can hit the cache).
-- Writes come only from service_role (Edge Function / AI Orchestrator).
ALTER TABLE public.ai_route_cache ENABLE ROW LEVEL SECURITY;

-- Any authenticated user can read non-expired cache entries.
-- This allows the Edge Function to query the cache on behalf of the user.
CREATE POLICY "ai_route_cache_select_authenticated"
  ON public.ai_route_cache FOR SELECT
  TO authenticated
  USING (expires_at > now());

-- Service role (Edge Function) can insert and update cache entries.
-- No explicit service_role policies needed — service_role bypasses RLS.
-- The USING clause above intentionally blocks reads of expired rows
-- from the client SDK.


-- ========================
-- public.place_embeddings
-- ========================
-- Embeddings are global (not per-user) — any authenticated user or
-- the anon key can read them for similarity queries.
-- Writes come only from the Research Agent via service_role.
ALTER TABLE public.place_embeddings ENABLE ROW LEVEL SECURITY;

-- Public read: any authenticated user can query embeddings.
CREATE POLICY "place_embeddings_select_authenticated"
  ON public.place_embeddings FOR SELECT
  TO authenticated
  USING (true);

-- Anon read allowed for public similarity search endpoints (if any).
CREATE POLICY "place_embeddings_select_anon"
  ON public.place_embeddings FOR SELECT
  TO anon
  USING (true);

-- INSERT / UPDATE / DELETE go through service_role only (bypasses RLS).


-- ========================
-- public.subscriptions
-- ========================
-- Written exclusively by the RevenueCat webhook Edge Function (service_role).
-- Users can only read their own subscription record.
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "subscriptions_select_own"
  ON public.subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- No INSERT/UPDATE/DELETE policies for end users.
-- All writes come from service_role webhook handler.


-- ========================
-- public.usage_tracking
-- ========================
-- Written by the route generation Edge Function (service_role).
-- Users can read their own usage to display "2/3 routes used" in the UI.
ALTER TABLE public.usage_tracking ENABLE ROW LEVEL SECURITY;

CREATE POLICY "usage_tracking_select_own"
  ON public.usage_tracking FOR SELECT
  USING (auth.uid() = user_id);

-- No INSERT/UPDATE/DELETE policies for end users.
-- All writes come from service_role route generation handler.
