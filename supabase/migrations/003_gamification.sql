-- ============================================================
-- 003_gamification.sql
-- Passport Stamps, Visited Places
-- ============================================================

-- Dijital Pasaport (Damgalar)
CREATE TABLE passport_stamps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  country_code TEXT,                        -- 'TR', 'IT', 'FR'
  route_id UUID REFERENCES routes(id) ON DELETE SET NULL,
  stamp_date DATE NOT NULL,
  stamp_image_url TEXT,                     -- Ozel damga gorseli
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, city, stamp_date)
);

-- Kullanici Gezi Gecmisi (Memory Layer 3)
CREATE TABLE visited_places (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  place_id TEXT,                            -- Google Maps place_id
  place_name TEXT NOT NULL,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  category TEXT,
  user_rating INT CHECK (user_rating BETWEEN 1 AND 5),
  visited_at DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
