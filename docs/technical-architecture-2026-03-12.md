# Geez AI — Technical Architecture

**Tarih:** 12 Mart 2026
**Durum:** Pre-launch / Architecture Design

---

## 1. System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER                           │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   iOS App    │  │ Android App  │  │  Web App     │     │
│  │  (Flutter)   │  │  (Flutter)   │  │  (Flutter W) │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         └─────────────────┼─────────────────┘              │
│                           │                                 │
└───────────────────────────┼─────────────────────────────────┘
                            │ HTTPS / WebSocket
┌───────────────────────────┼─────────────────────────────────┐
│                      API GATEWAY                            │
│                    (Supabase Edge)                           │
└───────────────────────────┼─────────────────────────────────┘
                            │
┌───────────────────────────┼─────────────────────────────────┐
│                   BACKEND SERVICES                          │
│                                                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐  │
│  │ Auth        │ │ User        │ │ Route Generation    │  │
│  │ Service     │ │ Service     │ │ Service (AI Core)   │  │
│  │ (Supabase)  │ │ (Supabase)  │ │ (Edge Functions)    │  │
│  └─────────────┘ └─────────────┘ └──────────┬──────────┘  │
│                                              │              │
│  ┌─────────────┐ ┌─────────────┐ ┌──────────▼──────────┐  │
│  │ Gamification│ │ Payment     │ │ AI Agent            │  │
│  │ Service     │ │ Service     │ │ Orchestrator        │  │
│  │             │ │ (RevenueCat)│ │                     │  │
│  └─────────────┘ └─────────────┘ └──────────┬──────────┘  │
│                                              │              │
└──────────────────────────────────────────────┼──────────────┘
                                               │
┌──────────────────────────────────────────────┼──────────────┐
│                   AI AGENT LAYER                            │
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Research  │  │ Memory   │  │ Route    │  │ Content  │  │
│  │ Agent     │  │ Agent    │  │ Agent    │  │ Agent    │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
│       │              │              │              │        │
└───────┼──────────────┼──────────────┼──────────────┼────────┘
        │              │              │              │
┌───────┼──────────────┼──────────────┼──────────────┼────────┐
│       │         DATA & EXTERNAL APIS               │        │
│       │              │              │              │        │
│  ┌────▼─────┐  ┌─────▼────┐  ┌─────▼────┐  ┌─────▼────┐  │
│  │ Google   │  │ Supabase │  │ Google   │  │ Claude   │  │
│  │ Maps     │  │ DB       │  │ Directions│ │ API      │  │
│  │ Places   │  │ pgvector │  │ API      │  │ + GPT-4o │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │ Tavily   │  │ Exa      │  │ Weather  │                 │
│  │ Search   │  │ Search   │  │ API      │                 │
│  └──────────┘  └──────────┘  └──────────┘                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Tech Stack Kararları

### Frontend: Flutter

| Karar | Gerekçe |
|-------|---------|
| **Flutter (Dart)** | Tek codebase → iOS + Android + Web |
| Neden React Native değil | Flutter'ın animasyon/UI performansı daha iyi, Geez AI'da UX kritik |
| Neden Native değil | Tek developer, 2 platform maintain etmek impractical |
| State Management | Riverpod (modern, testable, scalable) |
| Navigation | GoRouter (deep linking, guard support) |
| Maps | google_maps_flutter paketi |
| Offline | Hive (local DB) + flutter_cache_manager |
| HTTP | Dio (interceptors, retry, caching) |
| Animations | Rive veya Lottie (gamification animasyonları) |

### Backend: Supabase

| Karar | Gerekçe |
|-------|---------|
| **Supabase** | Auth + DB + Storage + Edge Functions + Realtime tek platformda |
| Neden Firebase değil | PostgreSQL (relational + pgvector), open-source, data ownership |
| Neden custom backend değil | Hız — Supabase ile haftalarca backend yazmaktan kaçın |
| Database | PostgreSQL + pgvector extension |
| Auth | Supabase Auth (email + Google + Apple) |
| Storage | Supabase Storage (offline harita cache, kullanıcı verileri) |
| Edge Functions | Deno/TypeScript — AI orchestration, route generation |
| Realtime | WebSocket — push notifications, canlı güncellemeler |

### AI Layer

| Karar | Gerekçe |
|-------|---------|
| **Claude API (primary)** | En iyi reasoning, research kalitesi, structured output |
| **GPT-4o-mini (fallback)** | Ucuz, hızlı — basit görevler (fun facts, çeviri) |
| **Tavily (search)** | Ucuz ($0.005/arama), AI-optimized, hızlı |
| **Exa (deep search)** | Semantic arama, complex queries (hidden gems) |
| **Google Maps Platform** | Places, Directions, Geocoding, Popular Times |

### Payment & Subscription

| Karar | Gerekçe |
|-------|---------|
| **RevenueCat** | iOS + Android subscription yönetimi tek SDK |
| Neden direkt Stripe değil | App Store/Play Store in-app purchase zorunluluğu, RevenueCat bunu yönetir |
| Trial | 7 gün ücretsiz premium deneme |

### Analytics & Monitoring

| Tool | Kullanım |
|------|----------|
| **PostHog** | Product analytics (open-source, self-hostable) |
| **Sentry** | Error tracking, crash reports |
| **Supabase Analytics** | DB performance, API metrics |

---

## 3. Database Schema

### Core Tables

```sql
-- Kullanıcılar
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  language TEXT DEFAULT 'tr', -- 'tr' | 'en'
  subscription_tier TEXT DEFAULT 'free', -- 'free' | 'premium' | 'pro'
  subscription_expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Kullanıcı Profili (Memory Layer 1 & 2)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  -- Layer 1: Static
  age_group TEXT, -- '18-25' | '25-35' | '35-45' | '45+'
  travel_companion TEXT, -- 'solo' | 'couple' | 'friends' | 'family'
  default_budget TEXT, -- 'budget' | 'mid' | 'premium'
  -- Layer 2: Learned (AI günceller)
  preferred_activities JSONB DEFAULT '[]', -- ["history", "food", "nature"]
  food_preferences JSONB DEFAULT '{}', -- {"vegetarian": false, "street_food": true}
  pace_preference TEXT DEFAULT 'normal', -- 'relaxed' | 'normal' | 'intense'
  morning_person BOOLEAN DEFAULT true,
  crowd_tolerance TEXT DEFAULT 'medium', -- 'low' | 'medium' | 'high'
  UNIQUE(user_id)
);

-- Travel Persona (Memory Layer 4)
CREATE TABLE travel_personas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  foodie_level INT DEFAULT 1,
  history_buff_level INT DEFAULT 1,
  nature_lover_level INT DEFAULT 1,
  adventure_seeker_level INT DEFAULT 1,
  culture_explorer_level INT DEFAULT 1,
  discovery_score INT DEFAULT 0,
  explorer_tier TEXT DEFAULT 'tourist', -- tourist|traveler|explorer|local|legend
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id)
);

-- Rotalar
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  title TEXT NOT NULL,
  duration_days INT NOT NULL,
  travel_style TEXT, -- 'historical' | 'food' | 'adventure' | 'mixed'
  transport_mode TEXT, -- 'walking' | 'public' | 'car' | 'mixed'
  budget_level TEXT,
  status TEXT DEFAULT 'draft', -- 'draft' | 'active' | 'completed'
  ai_model_used TEXT,
  generation_cost_usd DECIMAL(6,4),
  created_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ
);

-- Rota Durakları
CREATE TABLE route_stops (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
  stop_order INT NOT NULL,
  day_number INT NOT NULL,
  -- Mekan bilgisi
  place_name TEXT NOT NULL,
  place_id TEXT, -- Google Maps place_id
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  category TEXT, -- 'landmark' | 'restaurant' | 'museum' | 'park' | 'market' | 'hidden_gem'
  -- AI tarafından üretilen içerik
  description TEXT,
  insider_tip TEXT,
  fun_fact TEXT,
  best_time TEXT, -- "Sabah 9-10, kalabalık az"
  warnings TEXT, -- "Cuma 12-14 kapalı"
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
  travel_mode_from_previous TEXT, -- 'walk' | 'transit' | 'drive' | 'taxi'
  -- Gamification
  discovery_points INT DEFAULT 0, -- hidden gem = yüksek
  -- Metadata
  suggested_start_time TIME,
  suggested_end_time TIME
);

-- Dijital Pasaport (Damgalar)
CREATE TABLE passport_stamps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  country_code TEXT, -- 'TR', 'IT', 'FR'
  route_id UUID REFERENCES routes(id),
  stamp_date DATE NOT NULL,
  stamp_image_url TEXT, -- Özel damga görseli
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, city, stamp_date)
);

-- Post-Trip Feedback (Memory Layer 3)
CREATE TABLE trip_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
  overall_rating INT CHECK (overall_rating BETWEEN 1 AND 5),
  favorite_stops UUID[], -- route_stop id'leri
  disliked_stops UUID[],
  food_rating TEXT, -- 'amazing' | 'good' | 'average' | 'poor'
  pace_feedback TEXT, -- 'too_intense' | 'just_right' | 'too_slow'
  free_text TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Kullanıcı Gezi Geçmişi (Memory Layer 3)
CREATE TABLE visited_places (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  place_id TEXT, -- Google Maps place_id
  place_name TEXT NOT NULL,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  category TEXT,
  user_rating INT CHECK (user_rating BETWEEN 1 AND 5),
  visited_at DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Vector Search (Benzer Mekan Önerileri)

```sql
-- pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Mekan embeddings cache
CREATE TABLE place_embeddings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id TEXT UNIQUE NOT NULL,
  place_name TEXT NOT NULL,
  city TEXT NOT NULL,
  category TEXT,
  description TEXT,
  embedding vector(1536), -- OpenAI veya Claude embedding boyutu
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Benzer mekan arama
CREATE INDEX ON place_embeddings
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);
```

### Row Level Security (RLS)

```sql
-- Kullanıcılar sadece kendi verilerini görsün
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE passport_stamps ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own data" ON routes
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own data" ON routes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own data" ON routes
  FOR UPDATE USING (auth.uid() = user_id);
```

---

## 4. AI Agent Architecture (Detaylı)

### Orchestrator Flow

```typescript
// Edge Function: generate-route

interface RouteRequest {
  userId: string;
  city: string;
  country: string;
  durationDays: number;
  travelStyle: string;   // 'historical' | 'food' | 'adventure' | 'mixed'
  transportMode: string; // 'walking' | 'public' | 'car' | 'mixed'
  budgetLevel: string;   // 'budget' | 'mid' | 'premium'
  startTime: string;     // '08:00' | '10:00' | '12:00'
  preferences: string[]; // Kullanıcının ek notları
}

async function generateRoute(req: RouteRequest): Promise<Route> {

  // 1. Memory Agent — Kullanıcı context'i topla
  const userContext = await memoryAgent.getUserContext(req.userId);
  // → geçmiş geziler, beğeniler, persona, feedback

  // 2. Research Agent — Paralel araştırma başlat
  const [places, insights] = await Promise.all([
    researchAgent.findPlaces(req.city, req.travelStyle, userContext),
    researchAgent.getCityInsights(req.city, req.country),
  ]);

  // 3. Her mekan için deep research (paralel)
  const enrichedPlaces = await Promise.all(
    places.map(place => researchAgent.enrichPlace(place))
  );
  // → review sentezi, insider tips, fun facts, zamanlama

  // 4. Route Agent — Optimal sıralama
  const optimizedRoute = await routeAgent.optimize({
    places: enrichedPlaces,
    durationDays: req.durationDays,
    transportMode: req.transportMode,
    startTime: req.startTime,
    userPace: userContext.pacePreference,
  });

  // 5. Content Agent — Final polish
  const finalRoute = await contentAgent.polish(optimizedRoute, userContext);
  // → gamification puanları, discovery score, presentation

  // 6. Kaydet ve döndür
  await saveRoute(req.userId, finalRoute);
  return finalRoute;
}
```

### Research Agent Detail

```typescript
class ResearchAgent {

  // Ana mekan arama
  async findPlaces(city: string, style: string, context: UserContext) {
    // Step 1: Google Maps text search
    const googlePlaces = await googleMaps.textSearch({
      query: `best ${style} places in ${city}`,
      type: this.getPlaceType(style),
    });

    // Step 2: Tavily — blog/travel site araması
    const webResults = await tavily.search({
      query: `hidden gems ${style} ${city} local recommendations`,
      searchDepth: 'advanced',
      maxResults: 10,
    });

    // Step 3: Exa — semantic arama (deep)
    const semanticResults = await exa.search({
      query: `insider tips ${city} ${style} off the beaten path`,
      numResults: 5,
      type: 'neural',
    });

    // Step 4: Memory filter — zaten gittiği yerleri çıkar
    const filtered = this.filterVisited(
      [...googlePlaces, ...webResults, ...semanticResults],
      context.visitedPlaces
    );

    // Step 5: LLM ile skorla ve sırala
    return await this.rankPlaces(filtered, context);
  }

  // Mekan zenginleştirme
  async enrichPlace(place: Place): Promise<EnrichedPlace> {
    const [reviews, details, funFact, timing] = await Promise.all([
      this.synthesizeReviews(place.placeId),
      googleMaps.placeDetails(place.placeId),
      this.generateFunFact(place),
      this.getBestTiming(place.placeId),
    ]);

    return {
      ...place,
      reviewSummary: reviews.summary,
      insiderTip: reviews.insiderTip,
      funFact: funFact,
      bestTime: timing.bestTime,
      crowdLevel: timing.crowdLevel,
      warnings: timing.warnings,
      entryFee: details.price_level,
      photos: details.photos?.slice(0, 3),
    };
  }

  // Review sentezi
  async synthesizeReviews(placeId: string): Promise<ReviewSynthesis> {
    const reviews = await googleMaps.placeReviews(placeId, {
      sort: 'newest',
      maxResults: 50
    });

    const synthesis = await claude.messages.create({
      model: 'claude-haiku-4-5-20251001', // Hızlı + ucuz
      messages: [{
        role: 'user',
        content: `Analyze these ${reviews.length} reviews and provide:
          1. One-sentence summary of what people love
          2. One-sentence summary of common complaints
          3. One insider tip that appears in reviews
          4. Best time to visit based on reviews

          Reviews: ${JSON.stringify(reviews.map(r => r.text))}`,
      }],
    });

    return parseSynthesis(synthesis);
  }
}
```

### Memory Agent Detail

```typescript
class MemoryAgent {

  async getUserContext(userId: string): Promise<UserContext> {
    const [profile, persona, history, feedback] = await Promise.all([
      supabase.from('user_profiles').select('*').eq('user_id', userId).single(),
      supabase.from('travel_personas').select('*').eq('user_id', userId).single(),
      supabase.from('visited_places').select('*').eq('user_id', userId),
      supabase.from('trip_feedback').select('*').eq('user_id', userId)
        .order('created_at', { ascending: false }).limit(10),
    ]);

    return {
      profile: profile.data,
      persona: persona.data,
      visitedPlaces: history.data,
      recentFeedback: feedback.data,
      pacePreference: this.inferPace(feedback.data),
      strongPreferences: this.extractStrongPreferences(feedback.data, history.data),
    };
  }

  // Post-trip sonrası memory güncelle
  async updateFromFeedback(userId: string, feedback: TripFeedback) {
    // Persona level güncelle
    const personaUpdates = this.calculatePersonaChanges(feedback);
    await supabase.from('travel_personas')
      .update(personaUpdates)
      .eq('user_id', userId);

    // Visited places ekle
    for (const stopId of [...feedback.favoriteStops, ...feedback.dislikedStops]) {
      const stop = await this.getStopDetails(stopId);
      await supabase.from('visited_places').upsert({
        user_id: userId,
        place_id: stop.place_id,
        place_name: stop.place_name,
        city: stop.city,
        country: stop.country,
        category: stop.category,
        user_rating: feedback.favoriteStops.includes(stopId) ? 5 : 2,
        visited_at: new Date(),
      });
    }

    // Profile preferences öğren
    if (feedback.paceFeedback === 'too_intense') {
      await supabase.from('user_profiles')
        .update({ pace_preference: 'relaxed' })
        .eq('user_id', userId);
    }
  }
}
```

### Route Agent Detail

```typescript
class RouteAgent {

  async optimize(input: RouteInput): Promise<OptimizedRoute> {
    const { places, durationDays, transportMode, startTime, userPace } = input;

    // Durak sayısı hesapla (pace'e göre)
    const stopsPerDay = userPace === 'relaxed' ? 4 :
                        userPace === 'intense' ? 8 : 6;

    // Google Directions ile mesafe matriksi
    const distanceMatrix = await googleMaps.distanceMatrix({
      origins: places.map(p => `${p.latitude},${p.longitude}`),
      destinations: places.map(p => `${p.latitude},${p.longitude}`),
      mode: this.getTransportMode(transportMode),
    });

    // TSP (Travelling Salesman) yaklaşımıyla optimal sıralama
    // Nearest neighbor heuristic (basit, hızlı, yeterli)
    const orderedStops = this.nearestNeighborTSP(places, distanceMatrix);

    // Günlere böl
    const dailyRoutes = this.splitIntoDays(orderedStops, {
      durationDays,
      stopsPerDay,
      startTime,
      breakForLunch: true,
    });

    // Zamanlama ekle
    return dailyRoutes.map(day => ({
      ...day,
      stops: day.stops.map((stop, i) => ({
        ...stop,
        suggestedStartTime: this.calculateStartTime(day.stops, i, startTime),
        suggestedEndTime: this.calculateEndTime(stop),
        travelFromPrevious: i > 0 ? distanceMatrix[i-1][i] : null,
      })),
    }));
  }

  // Basit TSP — Nearest Neighbor
  private nearestNeighborTSP(places: Place[], matrix: number[][]): Place[] {
    const visited = new Set<number>();
    const route: Place[] = [];
    let current = 0; // İlk mekan

    while (route.length < places.length) {
      visited.add(current);
      route.push(places[current]);

      let nearest = -1;
      let minDist = Infinity;
      for (let i = 0; i < places.length; i++) {
        if (!visited.has(i) && matrix[current][i] < minDist) {
          minDist = matrix[current][i];
          nearest = i;
        }
      }
      current = nearest;
    }

    return route;
  }
}
```

---

## 5. API Endpoints

### Route Generation

```
POST   /functions/v1/generate-route     → Yeni rota oluştur
GET    /functions/v1/route/:id          → Rota detayı
PATCH  /functions/v1/route/:id          → Rota güncelle (durak değiştir)
POST   /functions/v1/route/:id/complete → Rotayı tamamla
DELETE /functions/v1/route/:id          → Rota sil
```

### User & Memory

```
GET    /functions/v1/me                 → Kullanıcı profili
PATCH  /functions/v1/me/profile         → Profil güncelle
GET    /functions/v1/me/persona         → Travel Persona
GET    /functions/v1/me/passport        → Dijital Pasaport
POST   /functions/v1/me/feedback        → Post-trip feedback gönder
GET    /functions/v1/me/history         → Gezi geçmişi
```

### Gamification

```
GET    /functions/v1/me/discovery-score  → Discovery Score
GET    /functions/v1/me/stamps           → Pasaport damgaları
POST   /functions/v1/me/stamps           → Yeni damga ekle
GET    /functions/v1/leaderboard         → Leaderboard (V1.2)
```

### Subscription

```
POST   /functions/v1/subscription/verify → RevenueCat receipt doğrulama
GET    /functions/v1/subscription/status  → Abonelik durumu
```

---

## 6. Offline Architecture

```
┌──────────────────────────────────┐
│          ONLINE MODE             │
│                                  │
│  Cloud DB ←→ Sync ←→ Local DB   │
│  (Supabase)    ↕      (Hive)    │
│                ↕                 │
│            Sync Queue            │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│          OFFLINE MODE            │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Local DB (Hive)            │  │
│  │ ├── Route data (JSON)      │  │
│  │ ├── Stop cards (cached)    │  │
│  │ ├── Map tiles (downloaded) │  │
│  │ └── User preferences       │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Offline Map Tiles          │  │
│  │ (flutter_map + tile cache) │  │
│  └────────────────────────────┘  │
│                                  │
│  Feature: "Rotayı İndir" butonu │
│  → Tüm kart bilgileri + harita  │
│    tiles'ı local'e kaydet        │
│  → ~5-15 MB per rota            │
└──────────────────────────────────┘
```

### Ne Offline Çalışır

| Feature | Offline | Not |
|---------|---------|-----|
| Rota görüntüleme | ✅ | İndirilmiş rotalar |
| Harita navigasyon | ✅ | Cached tiles |
| Durak kartları | ✅ | Cached content |
| Fun facts | ✅ | Cached |
| Yeni rota oluşturma | ❌ | AI + internet gerekli |
| Review güncelleme | ❌ | Real-time data |
| Gamification sync | ⏳ | Online olunca sync |

---

## 7. Caching Strategy

### Multi-Layer Cache

```
Layer 1: In-Memory (Flutter)
├── Aktif rota verileri
├── Kullanıcı profili
└── TTL: Session boyunca

Layer 2: Local DB (Hive)
├── Son 10 rota
├── Favori mekanlar
├── Offline indirilen rotalar
└── TTL: 30 gün (rotalar), sınırsız (offline)

Layer 3: CDN (Supabase Storage)
├── Mekan fotoğrafları
├── Damga görselleri
└── TTL: 7 gün

Layer 4: Server Cache (Redis / Supabase)
├── Popüler şehir verileri
├── Google Maps API responses
├── Review sentez sonuçları
└── TTL: 24 saat (reviews), 7 gün (mekan bilgisi)
```

### AI Response Caching

```
Aynı şehir + aynı stil = cache hit
(İstanbul + food tour = cached response varsa kullan)

Cache key: city:style:budget:transport:language
TTL: 7 gün
Hit ratio hedefi: %40+ (maliyet düşürme)
```

---

## 8. Security

### Authentication

```
Supabase Auth
├── Email/password
├── Google OAuth
├── Apple Sign In (iOS zorunlu)
└── JWT token (60 dk expiry, refresh token)
```

### Data Protection

| Önlem | Detay |
|-------|-------|
| **Encryption at rest** | Supabase default (AES-256) |
| **Encryption in transit** | TLS 1.3 |
| **RLS (Row Level Security)** | Her tablo için aktif |
| **API rate limiting** | Free: 3 rota/ay, Premium: unlimited |
| **Input sanitization** | Server-side validation |
| **PII handling** | Email + location data → GDPR compliant |
| **API keys** | Supabase Edge Functions env vars |

### Rate Limiting

```
Free tier:
├── 3 rota/ay
├── 10 mekan araması/gün
└── 429 Too Many Requests → upgrade prompt

Premium tier:
├── Sınırsız rota
├── Sınırsız arama
└── Priority AI queue
```

---

## 9. Cost Estimates (Monthly)

### Infrastructure (10K users)

| Servis | Plan | Maliyet/ay |
|--------|------|------------|
| Supabase | Pro | $25 |
| Google Maps Platform | Pay-as-you-go | ~$200 |
| Claude API | Pay-per-token | ~$150 |
| GPT-4o-mini (fallback) | Pay-per-token | ~$50 |
| Tavily | Starter | ~$50 |
| Exa | Growth | ~$100 |
| RevenueCat | Free tier | $0 |
| PostHog | Free tier | $0 |
| Sentry | Developer | $0 |
| App Store (Apple) | Annual | $8.25 ($99/yr) |
| Play Store (Google) | One-time | ~$2 ($25 total) |
| **Toplam** | | **~$585/ay** |

### Infrastructure (50K users)

| Servis | Plan | Maliyet/ay |
|--------|------|------------|
| Supabase | Pro (scaled) | $75 |
| Google Maps | Scaled | ~$800 |
| Claude API | Scaled | ~$600 |
| GPT-4o-mini | Scaled | ~$200 |
| Tavily | Business | ~$200 |
| Exa | Business | ~$400 |
| **Toplam** | | **~$2,275/ay** |

### Revenue vs Cost (50K users)

```
Revenue:
├── Premium (5% × 50K × $6.99)  = $17,475/ay
├── Affiliate (est.)              = $5,000/ay
└── Total                         = $22,475/ay

Cost:
├── Infrastructure                = $2,275/ay
├── App Store fees (30%)          = $5,243/ay
└── Total                         = $7,518/ay

Gross Margin: ~66% ✅
```

---

## 10. Monitoring & Observability

```
┌─────────────────────────────────┐
│        MONITORING STACK         │
│                                 │
│  ┌───────────┐  ┌───────────┐  │
│  │ PostHog   │  │ Sentry    │  │
│  │ (Product) │  │ (Errors)  │  │
│  │           │  │           │  │
│  │ • Funnels │  │ • Crashes │  │
│  │ • Retent. │  │ • API err │  │
│  │ • Feature │  │ • AI fail │  │
│  │   flags   │  │           │  │
│  └───────────┘  └───────────┘  │
│                                 │
│  ┌───────────┐  ┌───────────┐  │
│  │ Supabase  │  │ Custom    │  │
│  │ Dashboard │  │ Metrics   │  │
│  │           │  │           │  │
│  │ • DB perf │  │ • AI cost │  │
│  │ • API lat │  │ • Cache   │  │
│  │ • Storage │  │   hit %   │  │
│  │           │  │ • Rota/   │  │
│  │           │  │   user    │  │
│  └───────────┘  └───────────┘  │
└─────────────────────────────────┘
```

### Key Alerts

| Alert | Threshold | Action |
|-------|-----------|--------|
| API error rate | >5% | PagerDuty |
| AI generation time | >30s | Scale/fallback |
| AI cost per route | >$0.50 | Check prompts |
| Cache hit rate | <30% | Tune TTLs |
| D7 retention | <10% | Product review |

---

## 11. Development Environment

### Local Setup

```bash
# Prerequisites
flutter --version  # 3.x+
supabase --version # CLI installed
node --version     # 20+

# Clone & Setup
git clone https://github.com/geez-ai/geez-app
cd geez-app
flutter pub get

# Supabase local
supabase init
supabase start
supabase db push  # Apply migrations

# Environment
cp .env.example .env
# → SUPABASE_URL, SUPABASE_ANON_KEY
# → CLAUDE_API_KEY, GOOGLE_MAPS_KEY
# → TAVILY_API_KEY, EXA_API_KEY

# Run
flutter run
```

### CI/CD Pipeline

```
GitHub Actions:
├── PR → Lint + Test + Build check
├── main merge → Build → Deploy Supabase Edge Functions
├── release tag → Build iOS + Android → TestFlight + Play Console
└── weekly → Dependency audit + security scan
```

---

## Sonraki Adımlar

1. ✅ Market opportunity analysis
2. ✅ Competitive landscape analysis
3. ✅ MVP feature specification
4. ✅ Technical architecture
5. ✅ Financial projections (3-5 yıl detaylı)
6. ✅ Go-to-market strategy
7. ✅ UI/UX wireframes
8. ✅ Development kickoff

---

*Bu doküman Geez AI'ın teknik mimarisini tanımlar. Development sürecinde iteratif olarak güncellenecektir.*
