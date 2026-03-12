-- ============================================================
-- 007_indexes.sql
-- Performance Indexes
-- ============================================================

-- =========================
-- Single-column indexes
-- =========================

-- routes: user_id ile sorgulama (kullanicinin rotalari)
CREATE INDEX idx_routes_user_id
  ON routes(user_id);

-- route_stops: route_id ile sorgulama (rotanin duraklari)
CREATE INDEX idx_route_stops_route_id
  ON route_stops(route_id);

-- passport_stamps: user_id ile sorgulama (kullanicinin damgalari)
CREATE INDEX idx_passport_stamps_user_id
  ON passport_stamps(user_id);

-- visited_places: user_id ile sorgulama (kullanicinin gezdigi yerler)
CREATE INDEX idx_visited_places_user_id
  ON visited_places(user_id);

-- trip_feedback: route_id ile sorgulama (rotanin feedbackleri)
CREATE INDEX idx_trip_feedback_route_id
  ON trip_feedback(route_id);

-- trip_feedback: user_id ile sorgulama (kullanicinin feedbackleri)
CREATE INDEX idx_trip_feedback_user_id
  ON trip_feedback(user_id);

-- =========================
-- Composite indexes
-- =========================

-- route_stops: route_id + stop_order (rota icinde sirayla getirme)
CREATE INDEX idx_route_stops_route_order
  ON route_stops(route_id, stop_order);

-- route_stops: route_id + day_number (gun bazli getirme)
CREATE INDEX idx_route_stops_route_day
  ON route_stops(route_id, day_number);

-- routes: user_id + status (kullanicinin aktif/draft rotalari)
CREATE INDEX idx_routes_user_status
  ON routes(user_id, status);

-- routes: user_id + created_at DESC (son olusturulan rotalar)
CREATE INDEX idx_routes_user_created
  ON routes(user_id, created_at DESC);

-- visited_places: user_id + city (sehir bazli gecmis sorgulama)
CREATE INDEX idx_visited_places_user_city
  ON visited_places(user_id, city);

-- passport_stamps: user_id + stamp_date DESC (son damgalar)
CREATE INDEX idx_passport_stamps_user_date
  ON passport_stamps(user_id, stamp_date DESC);

-- place_embeddings: city + category (sehir ve kategori bazli filtreleme)
CREATE INDEX idx_place_embeddings_city_category
  ON place_embeddings(city, category);

-- =========================
-- Partial indexes
-- =========================

-- routes: sadece aktif rotalar (status = 'active')
CREATE INDEX idx_routes_active
  ON routes(user_id)
  WHERE status = 'active';
