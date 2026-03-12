-- ============================================================
-- 001_users.sql
-- Users, User Profiles, Travel Personas
-- ============================================================

-- Kullanicilar
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  language TEXT DEFAULT 'tr',               -- 'tr' | 'en'
  subscription_tier TEXT DEFAULT 'free',    -- 'free' | 'premium' | 'pro'
  subscription_expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Kullanici Profili (Memory Layer 1 & 2)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  -- Layer 1: Static
  age_group TEXT,                           -- '18-25' | '25-35' | '35-45' | '45+'
  travel_companion TEXT,                    -- 'solo' | 'couple' | 'friends' | 'family'
  default_budget TEXT,                      -- 'budget' | 'mid' | 'premium'
  -- Layer 2: Learned (AI gunceller)
  preferred_activities JSONB DEFAULT '[]',  -- ["history", "food", "nature"]
  food_preferences JSONB DEFAULT '{}',      -- {"vegetarian": false, "street_food": true}
  pace_preference TEXT DEFAULT 'normal',    -- 'relaxed' | 'normal' | 'intense'
  morning_person BOOLEAN DEFAULT true,
  crowd_tolerance TEXT DEFAULT 'medium',    -- 'low' | 'medium' | 'high'
  UNIQUE(user_id)
);

-- Travel Persona (Memory Layer 4)
CREATE TABLE travel_personas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  foodie_level INT DEFAULT 1,
  history_buff_level INT DEFAULT 1,
  nature_lover_level INT DEFAULT 1,
  adventure_seeker_level INT DEFAULT 1,
  culture_explorer_level INT DEFAULT 1,
  discovery_score INT DEFAULT 0,
  explorer_tier TEXT DEFAULT 'tourist',     -- tourist | traveler | explorer | local | legend
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id)
);

CREATE TRIGGER set_travel_personas_updated_at
  BEFORE UPDATE ON travel_personas
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Yeni kullanici kayit oldugunda otomatik profil ve persona olustur
CREATE OR REPLACE FUNCTION create_user_profile_and_persona()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_profiles (user_id) VALUES (NEW.id);
  INSERT INTO travel_personas (user_id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_created
  AFTER INSERT ON users
  FOR EACH ROW
  EXECUTE FUNCTION create_user_profile_and_persona();
