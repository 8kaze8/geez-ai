-- ============================================================
-- 005_rls_policies.sql
-- Row Level Security Policies for ALL tables
-- ============================================================

-- =========================
-- Enable RLS on all tables
-- =========================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_personas ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE route_stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE passport_stamps ENABLE ROW LEVEL SECURITY;
ALTER TABLE visited_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_feedback ENABLE ROW LEVEL SECURITY;

-- =========================
-- users
-- =========================
CREATE POLICY "Users can view own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- Insert handled by auth trigger; no delete policy (account deletion via admin/edge function)

-- =========================
-- user_profiles
-- =========================
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = user_id);

-- Insert handled by trigger on user creation

-- =========================
-- travel_personas
-- =========================
CREATE POLICY "Users can view own persona"
  ON travel_personas FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own persona"
  ON travel_personas FOR UPDATE
  USING (auth.uid() = user_id);

-- =========================
-- routes
-- =========================
CREATE POLICY "Users can view own routes"
  ON routes FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own routes"
  ON routes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own routes"
  ON routes FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own routes"
  ON routes FOR DELETE
  USING (auth.uid() = user_id);

-- =========================
-- route_stops
-- =========================
-- route_stops access is controlled through the parent route
CREATE POLICY "Users can view own route stops"
  ON route_stops FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM routes
      WHERE routes.id = route_stops.route_id
        AND routes.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own route stops"
  ON route_stops FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM routes
      WHERE routes.id = route_stops.route_id
        AND routes.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own route stops"
  ON route_stops FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM routes
      WHERE routes.id = route_stops.route_id
        AND routes.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own route stops"
  ON route_stops FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM routes
      WHERE routes.id = route_stops.route_id
        AND routes.user_id = auth.uid()
    )
  );

-- =========================
-- passport_stamps
-- =========================
CREATE POLICY "Users can view own stamps"
  ON passport_stamps FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own stamps"
  ON passport_stamps FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own stamps"
  ON passport_stamps FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own stamps"
  ON passport_stamps FOR DELETE
  USING (auth.uid() = user_id);

-- =========================
-- visited_places
-- =========================
CREATE POLICY "Users can view own visited places"
  ON visited_places FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own visited places"
  ON visited_places FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own visited places"
  ON visited_places FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own visited places"
  ON visited_places FOR DELETE
  USING (auth.uid() = user_id);

-- =========================
-- trip_feedback
-- =========================
CREATE POLICY "Users can view own feedback"
  ON trip_feedback FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own feedback"
  ON trip_feedback FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own feedback"
  ON trip_feedback FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own feedback"
  ON trip_feedback FOR DELETE
  USING (auth.uid() = user_id);
