-- ============================================================
-- 004_feedback.sql
-- Trip Feedback (Post-Trip Memory Layer 3)
-- ============================================================

CREATE TABLE trip_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  overall_rating INT CHECK (overall_rating BETWEEN 1 AND 5),
  favorite_stops UUID[],                    -- route_stop id'leri
  disliked_stops UUID[],                    -- route_stop id'leri
  food_rating TEXT,                         -- 'amazing' | 'good' | 'average' | 'poor'
  pace_feedback TEXT,                       -- 'too_intense' | 'just_right' | 'too_slow'
  free_text TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, route_id)                 -- Bir rota icin tek feedback
);
