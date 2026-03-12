-- ============================================================
-- seed.sql
-- Sample test data: 1 user, 1 route, 3 stops in Istanbul
-- ============================================================

-- Test user
-- NOT: Gercek ortamda kullanici Supabase Auth uzerinden olusturulur.
-- Local development icin sabit UUID kullaniyoruz.
INSERT INTO users (id, email, display_name, language, subscription_tier)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'test@geez.ai',
  'Test Gezgin',
  'tr',
  'premium'
);

-- User profile (trigger ile otomatik olusur ama seed icin manuel ayarliyoruz)
UPDATE user_profiles
SET
  age_group = '25-35',
  travel_companion = 'solo',
  default_budget = 'mid',
  preferred_activities = '["history", "food", "culture"]',
  food_preferences = '{"vegetarian": false, "street_food": true, "local_cuisine": true}',
  pace_preference = 'normal',
  morning_person = true,
  crowd_tolerance = 'medium'
WHERE user_id = '00000000-0000-0000-0000-000000000001';

-- Travel persona
UPDATE travel_personas
SET
  foodie_level = 3,
  history_buff_level = 4,
  nature_lover_level = 2,
  adventure_seeker_level = 2,
  culture_explorer_level = 4,
  discovery_score = 120,
  explorer_tier = 'traveler'
WHERE user_id = '00000000-0000-0000-0000-000000000001';

-- Istanbul route
INSERT INTO routes (id, user_id, city, country, title, duration_days, travel_style, transport_mode, budget_level, status, ai_model_used, generation_cost_usd, created_at)
VALUES (
  '10000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001',
  'Istanbul',
  'Turkiye',
  'Tarihi Yarimada: Sultanahmet & Civarinda Bir Gun',
  1,
  'historical',
  'walking',
  'mid',
  'active',
  'claude-sonnet-4-20250514',
  0.0342,
  now()
);

-- Route stops (3 stops in Istanbul)
INSERT INTO route_stops (id, route_id, stop_order, day_number, place_name, place_id, latitude, longitude, category, description, insider_tip, fun_fact, best_time, warnings, review_summary, google_rating, review_count, estimated_duration_min, entry_fee, entry_fee_amount, entry_fee_currency, travel_from_previous_min, travel_mode_from_previous, discovery_points, suggested_start_time, suggested_end_time)
VALUES
  (
    '20000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    1, 1,
    'Ayasofya Camii',
    'ChIJYRGZT0C5yhQRHE3mKngL3pM',
    41.0086340, 28.9802010,
    'landmark',
    '537 yilinda insa edilen, yaklasik 1500 yillik tarihi ile dunyanin en onemli yapilarindan biri. Bizans, Osmanli ve Cumhuriyet donemlerinin izlerini tasiyor.',
    'Sabah 9''da kapida olun — ilk 30 dakika kalabalik cok az. Ust galeriye cikmadan gitmeyin, mozaikler oradan cok daha etkileyici.',
    '537''den 1453''e kadar dunyanin en buyuk katedrali olma unvanini korudu. Kubbesinin capi 31 metre!',
    'Sabah 09:00-10:00 arasi en az kalabalik',
    'Cuma namazi sirasinda (12:00-14:00) ziyarete kapali olabilir. Omuz ve dizleri orten kiyafet gerekli.',
    'Ziyaretciler mimari ihtisami ve tarihi atmosferi oniyor. Kubbe alti deneyim buyuleyici.',
    4.8, 98500,
    90,
    'Ucretsiz', 0.00, 'TRY',
    NULL, NULL,
    10,
    '09:00', '10:30'
  ),
  (
    '20000000-0000-0000-0000-000000000002',
    '10000000-0000-0000-0000-000000000001',
    2, 1,
    'Basilica Sarnici (Yerebatan)',
    'ChIJ8xOPvkC5yhQRxxWFrXN0VpY',
    41.0084260, 28.9779490,
    'landmark',
    '532 yilinda Justinianus tarafindan yaptirilan yeralti sarnaci. 336 sutun, Medusa baslari ve atmosferik aydinlatmasiyla buyuleyici bir yeralti deneyimi.',
    'Giris kapisi kucuk ve gozden kacabilir — Ayasofya''nin tam karsisinda. Iceride fotograf cekmek icin tripod yasak ama elde uzun pozlama deneyin.',
    'Saricin icindeki iki Medusa basinin neden biri yana, digeri ters dondurulmus hala bir gizem!',
    'Ogle 11:00-12:00 veya aksam 16:00 sonrasi',
    'Yaz aylarinda kuyruk 30-60 dk olabilir. Online bilet alin.',
    'Atmosferi ve aydinlatmasi cok begeniyor. Medusa baslari en populer fotograf noktasi.',
    4.6, 45200,
    45,
    'Ucretli', 450.00, 'TRY',
    5, 'walk',
    15,
    '10:35', '11:20'
  ),
  (
    '20000000-0000-0000-0000-000000000003',
    '10000000-0000-0000-0000-000000000001',
    3, 1,
    'Kapalicarsi',
    'ChIJm3SnfEC5yhQRp6oJiOxVbgc',
    41.0107570, 28.9680280,
    'market',
    'Dunyanin en eski ve en buyuk kapali carsilarindan biri. 4000''den fazla dukkan, 61 sokak. 1461''den beri kesintisiz ticaret yapilan canli bir labirent.',
    'Nuruosmaniye Kapisi''ndan girin — en az kalabalik giris. Ic sokaklara sapinca fiyatlar yarisina duser. Cay teklif edilirse kabul edin, zorunlu alis yok.',
    '1894 depreminden sonra yeniden insa edildi. Her gun yaklasik 250.000-400.000 kisi ziyaret ediyor!',
    'Sabah 10:00-11:00 arasi veya kapanisa yakin 17:00',
    'Pazar gunu KAPALI. Pazarlik yapmazsaniz 2-3 kat fazla odersiniz. Yaninda degerlilerinize dikkat.',
    'Otantik atmosfer ve alisveris deneyimi cok begeniyor. Pazarlik kulturu eglenceli bulunuyor.',
    4.4, 120300,
    120,
    'Ucretsiz', 0.00, 'TRY',
    15, 'walk',
    20,
    '11:30', '13:30'
  );

-- Passport stamp for Istanbul
INSERT INTO passport_stamps (user_id, city, country, country_code, route_id, stamp_date)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Istanbul',
  'Turkiye',
  'TR',
  '10000000-0000-0000-0000-000000000001',
  CURRENT_DATE
);
