-- ============================================================
-- 002_routes.sql
-- Routes, Route Stops
-- ============================================================

-- Rotalar
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  title TEXT NOT NULL,
  duration_days INT NOT NULL,
  travel_style TEXT,                        -- 'historical' | 'food' | 'adventure' | 'mixed'
  transport_mode TEXT,                      -- 'walking' | 'public' | 'car' | 'mixed'
  budget_level TEXT,                        -- 'budget' | 'mid' | 'premium'
  status TEXT DEFAULT 'draft',              -- 'draft' | 'active' | 'completed'
  ai_model_used TEXT,
  generation_cost_usd DECIMAL(6,4),
  created_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ
);

-- Rota Duraklari
CREATE TABLE route_stops (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  stop_order INT NOT NULL,
  day_number INT NOT NULL,
  -- Mekan bilgisi
  place_name TEXT NOT NULL,
  place_id TEXT,                            -- Google Maps place_id
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  category TEXT,                            -- 'landmark' | 'restaurant' | 'museum' | 'park' | 'market' | 'hidden_gem'
  -- AI tarafindan uretilen icerik
  description TEXT,
  insider_tip TEXT,
  fun_fact TEXT,
  best_time TEXT,                           -- "Sabah 9-10, kalabalik az"
  warnings TEXT,                            -- "Cuma 12-14 kapali"
  -- Review sentezi
  review_summary TEXT,
  google_rating DECIMAL(2,1),
  review_count INT,
  -- Pratik bilgi
  estimated_duration_min INT,
  entry_fee TEXT,
  entry_fee_amount DECIMAL(8,2),
  entry_fee_currency TEXT DEFAULT 'TRY',
  -- Navigasyon
  travel_from_previous_min INT,
  travel_mode_from_previous TEXT,           -- 'walk' | 'transit' | 'drive' | 'taxi'
  -- Gamification
  discovery_points INT DEFAULT 0,           -- hidden gem = yuksek puan
  -- Metadata
  suggested_start_time TIME,
  suggested_end_time TIME
);
