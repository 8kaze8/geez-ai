# Geez AI — Development Kickoff

**Tarih:** 12 Mart 2026
**Developer:** Kaze (solo) + AI Agent Team (Claude Code)
**Yaklaşım:** Vibe Coding — hızlı prototipleme, AI-assisted development

---

## 1. Pre-Development Checklist

### Hesap & API Key'ler

| Servis | Hesap | Maliyet | Öncelik |
|--------|-------|---------|---------|
| **Flutter SDK** | flutter.dev | Ücretsiz | Phase 1 |
| **Supabase** | supabase.com | Free tier (başlangıç) | Phase 1 |
| **Claude API** | console.anthropic.com | Pay-per-use | Phase 1 |
| **Google Maps Platform** | console.cloud.google.com | $200 free credit/ay | Phase 1 |
| **Apple Developer** | developer.apple.com | $99/yıl | Phase 4 |
| **Google Play Console** | play.google.com/console | $25 one-time | Phase 4 |
| **Tavily** | tavily.com | Free tier (1K req/ay) | Phase 2 |
| **Exa** | exa.ai | Free trial | Phase 2 |
| **RevenueCat** | revenuecat.com | Free tier | Phase 4 |
| **PostHog** | posthog.com | Free tier (1M events) | Phase 2 |
| **Sentry** | sentry.io | Free tier | Phase 2 |
| **GitHub** | github.com | Free (private repo) | Phase 1 |

**Phase 1 maliyeti: $0** (free tier'lar yeterli)

### Geliştirme Ortamı

```bash
# macOS (Kaze'nin makinesi)

# 1. Flutter
flutter doctor  # hepsinin ✅ olduğunu doğrula
flutter channel stable
flutter upgrade

# 2. IDE
# VS Code + Flutter extension + Dart extension
# veya Android Studio + Flutter plugin

# 3. Supabase CLI
brew install supabase/tap/supabase

# 4. Node.js (Edge Functions)
nvm install 20
nvm use 20

# 5. Emülatör
# iOS: Xcode → Simulator
# Android: Android Studio → AVD Manager
```

---

## 2. Project Structure

```
geez-ai/
├── app/                          # Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart              # MaterialApp, theme, router
│   │   │
│   │   ├── core/                 # Shared core
│   │   │   ├── theme/
│   │   │   │   ├── colors.dart   # GeezColors
│   │   │   │   ├── typography.dart
│   │   │   │   ├── spacing.dart
│   │   │   │   └── theme.dart    # Light + Dark ThemeData
│   │   │   ├── router/
│   │   │   │   └── app_router.dart  # GoRouter config
│   │   │   ├── constants/
│   │   │   │   └── api_constants.dart
│   │   │   ├── extensions/
│   │   │   └── utils/
│   │   │
│   │   ├── features/             # Feature-based modules
│   │   │   ├── auth/
│   │   │   │   ├── data/         # Repository, data sources
│   │   │   │   ├── domain/       # Models, entities
│   │   │   │   └── presentation/ # Screens, widgets
│   │   │   │       ├── screens/
│   │   │   │       │   ├── login_screen.dart
│   │   │   │       │   └── signup_screen.dart
│   │   │   │       └── widgets/
│   │   │   │
│   │   │   ├── onboarding/
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   ├── welcome_screen.dart
│   │   │   │       │   ├── quiz_screen.dart
│   │   │   │       │   └── persona_reveal_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── style_chip.dart
│   │   │   │           └── persona_card.dart
│   │   │   │
│   │   │   ├── home/
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   └── home_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── discovery_bar.dart
│   │   │   │           ├── active_route_card.dart
│   │   │   │           └── suggestion_card.dart
│   │   │   │
│   │   │   ├── chat/             # AI Chat + Route Creation
│   │   │   │   ├── data/
│   │   │   │   │   └── chat_repository.dart
│   │   │   │   ├── domain/
│   │   │   │   │   ├── chat_message.dart
│   │   │   │   │   └── route_request.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   ├── chat_screen.dart
│   │   │   │       │   └── route_loading_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── chat_bubble.dart
│   │   │   │           ├── question_chips.dart
│   │   │   │           ├── memory_insight_card.dart
│   │   │   │           └── loading_progress.dart
│   │   │   │
│   │   │   ├── route/            # Route Detail + Map
│   │   │   │   ├── data/
│   │   │   │   │   └── route_repository.dart
│   │   │   │   ├── domain/
│   │   │   │   │   ├── route_model.dart
│   │   │   │   │   └── stop_model.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   ├── route_detail_screen.dart
│   │   │   │       │   └── active_trip_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── stop_card.dart
│   │   │   │           ├── stop_card_collapsed.dart
│   │   │   │           ├── route_map.dart
│   │   │   │           ├── day_tab_bar.dart
│   │   │   │           └── trip_banner.dart
│   │   │   │
│   │   │   ├── passport/         # Gamification
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── stamp_model.dart
│   │   │   │   │   └── persona_model.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   ├── passport_screen.dart
│   │   │   │       │   └── stamp_detail_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── stamp_grid.dart
│   │   │   │           ├── discovery_score_widget.dart
│   │   │   │           └── collection_card.dart
│   │   │   │
│   │   │   ├── profile/
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   ├── profile_screen.dart
│   │   │   │       │   └── settings_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── persona_chart.dart
│   │   │   │           └── trip_history_list.dart
│   │   │   │
│   │   │   ├── feedback/         # Post-Trip Feedback
│   │   │   │   └── presentation/
│   │   │   │       ├── screens/
│   │   │   │       │   └── feedback_flow_screen.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── rating_stars.dart
│   │   │   │           ├── stop_select_grid.dart
│   │   │   │           └── reward_overlay.dart
│   │   │   │
│   │   │   └── explore/
│   │   │       └── presentation/
│   │   │           ├── screens/
│   │   │           │   └── explore_screen.dart
│   │   │           └── widgets/
│   │   │               ├── destination_card.dart
│   │   │               └── trending_list.dart
│   │   │
│   │   ├── shared/               # Shared widgets & services
│   │   │   ├── widgets/
│   │   │   │   ├── geez_button.dart
│   │   │   │   ├── geez_card.dart
│   │   │   │   ├── geez_chip.dart
│   │   │   │   ├── bottom_nav_bar.dart
│   │   │   │   ├── loading_indicator.dart
│   │   │   │   └── confetti_overlay.dart
│   │   │   └── services/
│   │   │       ├── supabase_service.dart
│   │   │       ├── location_service.dart
│   │   │       └── notification_service.dart
│   │   │
│   │   └── providers/            # Riverpod providers
│   │       ├── auth_provider.dart
│   │       ├── user_provider.dart
│   │       ├── route_provider.dart
│   │       ├── chat_provider.dart
│   │       └── gamification_provider.dart
│   │
│   ├── assets/
│   │   ├── animations/           # Lottie/Rive files
│   │   │   ├── splash.json
│   │   │   ├── confetti.json
│   │   │   ├── stamp_press.json
│   │   │   ├── level_up.riv
│   │   │   └── plane_loading.json
│   │   ├── images/
│   │   │   ├── logo.png
│   │   │   ├── onboarding/
│   │   │   └── stamps/           # Şehir damga görselleri
│   │   └── fonts/
│   │       └── Inter/
│   │
│   ├── test/                     # Flutter tests
│   │   ├── unit/
│   │   ├── widget/
│   │   └── integration/
│   │
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   └── .env.example
│
├── supabase/                     # Supabase backend
│   ├── migrations/
│   │   ├── 001_users.sql
│   │   ├── 002_routes.sql
│   │   ├── 003_gamification.sql
│   │   ├── 004_feedback.sql
│   │   └── 005_rls_policies.sql
│   │
│   ├── functions/                # Edge Functions (Deno/TypeScript)
│   │   ├── generate-route/
│   │   │   └── index.ts          # Orchestrator
│   │   ├── _shared/
│   │   │   ├── agents/
│   │   │   │   ├── research-agent.ts
│   │   │   │   ├── memory-agent.ts
│   │   │   │   ├── route-agent.ts
│   │   │   │   └── content-agent.ts
│   │   │   ├── services/
│   │   │   │   ├── claude.ts
│   │   │   │   ├── google-maps.ts
│   │   │   │   ├── tavily.ts
│   │   │   │   └── exa.ts
│   │   │   └── types.ts
│   │   ├── user-profile/
│   │   │   └── index.ts
│   │   ├── feedback/
│   │   │   └── index.ts
│   │   └── subscription/
│   │       └── index.ts
│   │
│   ├── seed.sql                  # Test data
│   └── config.toml
│
├── docs/                         # Documentation
│   ├── market-opportunity-analysis.md
│   ├── competitive-landscape-analysis.md
│   ├── mvp-feature-specification.md
│   ├── technical-architecture.md
│   ├── financial-projections.md
│   ├── go-to-market-strategy.md
│   └── ui-ux-wireframes.md
│
├── .github/
│   └── workflows/
│       ├── ci.yml                # Lint + Test on PR
│       └── deploy.yml            # Build + Deploy on merge
│
├── .gitignore
├── README.md
└── CLAUDE.md                     # AI assistant context
```

---

## 3. Sprint Plan (22 Hafta)

### Sprint 1-2: Foundation (Hafta 1-2)

**Hedef:** Projeyi ayağa kaldır, her şey çalışır durumda

```
[ ] Flutter proje oluştur (flutter create geez_ai)
[ ] Proje yapısını kur (yukarıdaki feature-based structure)
[ ] Theme system (GeezColors, GeezTypography, light/dark)
[ ] GoRouter + bottom navigation shell
[ ] Supabase projesi oluştur
[ ] Database migration'ları yaz (users, profiles, personas)
[ ] Supabase Auth entegrasyonu (email + Google + Apple)
[ ] Login / Signup ekranları
[ ] Temel shared widget'lar (GeezButton, GeezCard, GeezChip)
[ ] .env yapısı + Supabase service
[ ] GitHub repo + CI pipeline (lint + test)
```

**Sprint 1-2 çıktısı:** Login olabilen, theme'li, navigasyonu çalışan boş app

---

### Sprint 3-4: Onboarding + Home (Hafta 3-4)

**Hedef:** İlk kez açan kullanıcı onboarding'den geçip Home'a ulaşsın

```
[ ] Splash screen (logo animasyonu)
[ ] Onboarding flow (3 ekran swipe)
    [ ] Welcome ekranı
    [ ] Quick Quiz (style chips — multi-select)
    [ ] Persona Reveal (confetti + persona kartı)
[ ] user_profiles tablosuna quiz sonuçlarını kaydet
[ ] travel_personas tablosuna ilk persona oluştur
[ ] Home screen (iskelet)
    [ ] Header (kullanıcı adı + bildirim)
    [ ] Discovery Score bar (statik başlangıç)
    [ ] "İlk rotanı oluştur!" CTA kartı
[ ] Profile screen (iskelet)
    [ ] Persona chart (progress bar'lar)
    [ ] Settings (dil, tema, hesap)
```

**Sprint 3-4 çıktısı:** Onboarding → Home → Profile akışı çalışıyor

---

### Sprint 5-7: AI Chat + Route Core (Hafta 5-7) ← CRITICAL PATH

**Hedef:** "İstanbul'a gideceğim" → AI rota üretsin

```
[ ] Chat screen UI
    [ ] Chat bubble'lar (user + AI)
    [ ] Destinasyon input (text + popüler şehir chip'leri)
    [ ] Soru chip'leri (stil, ulaşım, bütçe, zaman)
[ ] Supabase Edge Function: generate-route
    [ ] Orchestrator ana akış
    [ ] Claude API entegrasyonu
    [ ] Basit Research Agent (Google Maps Places API)
    [ ] Basit Route Agent (sıralama + zamanlama)
[ ] Route loading screen
    [ ] Progress animasyonu (step-by-step)
    [ ] AI'ın ne yaptığını gösteren mesajlar
[ ] Route Detail screen
    [ ] Gün tab'ları
    [ ] Stop card (collapsed) — isim, saat, rating
    [ ] Stop card (expanded) — description, insider tip
    [ ] Harita görünümü (Google Maps + route polyline)
[ ] routes + route_stops tablolarına kaydet
[ ] Rota listeleme (Home → son rotalar)
```

**Sprint 5-7 çıktısı:** Çalışan MVP! Şehir yaz → AI rota üretsin → kartlarda gör

---

### Sprint 8-9: Deep Research + Fun Facts (Hafta 8-9)

**Hedef:** Rota kalitesini "WOW" seviyesine çıkar

```
[ ] Research Agent geliştir
    [ ] Tavily entegrasyonu (blog/forum araması)
    [ ] Review sentezi (Claude Haiku ile)
    [ ] Insider tips extraction
    [ ] Fun fact generation
[ ] Stop card zenginleştir
    [ ] AI Insight bölümü
    [ ] Review Özeti bölümü
    [ ] Fun Fact bölümü
    [ ] Pratik bilgi (fiyat, saat, uyarı)
    [ ] Mekan fotoğrafı (Google Maps Photos)
[ ] Zamanlama Zekası
    [ ] Google Maps Popular Times (kalabalık saatleri)
    [ ] En iyi zaman önerisi
    [ ] Kalabalık uyarısı
[ ] AI Response caching implementasyonu
    [ ] Cache key: city:style:budget:transport:language
    [ ] TTL: 7 gün
```

**Sprint 8-9 çıktısı:** Her durak zengin bilgi kartı — reviews, tips, fun facts

---

### Sprint 10-11: Memory + Feedback (Hafta 10-11)

**Hedef:** AI seni tanısın, her geziden öğrensin

```
[ ] Memory Agent implementasyonu
    [ ] getUserContext (profile + persona + history + feedback)
    [ ] Rota oluştururken memory'i kullan
    [ ] Memory Insight kartı (chat içinde)
[ ] Post-Trip Feedback flow
    [ ] Push notification trigger (gezi bitiş + 2 saat)
    [ ] 5 ekranlı feedback flow (puan, favori, beğenmediğin, serbest, reward)
    [ ] Feedback → Memory Agent update
    [ ] Persona level güncelleme
[ ] "Aynı şehre tekrar" akıllı davranış
    [ ] Gittiği yerleri filtrele
    [ ] "Bunları zaten gördün, hidden gems'e bakalım"
[ ] Notification sistemi (Firebase Cloud Messaging)
    [ ] Post-trip feedback push
    [ ] Re-engagement push (7 gün sessiz → "Yeni keşifler seni bekliyor")
```

**Sprint 10-11 çıktısı:** AI hatırlıyor, feedback loop çalışıyor

---

### Sprint 12-14: Gamification (Hafta 12-14)

**Hedef:** Keşfi eğlenceli kıl — passport, skor, persona

```
[ ] Dijital Pasaport screen
    [ ] Pasaport kapağı (deri texture, emboss efekti)
    [ ] Damga grid (şehir bayrakları)
    [ ] Damga detay ekranı (vintage stil damga + trip stats)
    [ ] İstatistikler (şehir, ülke, kıta, durak, km)
    [ ] Koleksiyonlar (tematik: Antik Dünya, Food Capital, vb.)
    [ ] Rota tamamlandığında otomatik damga
    [ ] Damga "vurulma" animasyonu (Lottie)
[ ] Discovery Score
    [ ] Score hesaplama (hidden gem = çok, turistik = az)
    [ ] Explorer tier sistemi (Tourist → Legend)
    [ ] Home screen'de kompakt widget
    [ ] Score odometer animasyonu
[ ] Travel Persona
    [ ] Level bar'lar (5 kategori)
    [ ] Post-trip sonrası level güncelleme
    [ ] "Dominant persona" otomatik hesaplama
    [ ] Level Up overlay (glow + particle + haptic)
[ ] Share kartları
    [ ] Pasaport paylaş (sosyal medya ready görsel)
    [ ] Persona paylaş
    [ ] Rota paylaş
```

**Sprint 12-14 çıktısı:** Tam gamification deneyimi, paylaşılabilir kartlar

---

### Sprint 15-16: Active Trip + Offline (Hafta 15-16)

**Hedef:** Gezi sırasında da yanında ol

```
[ ] Active Trip Mode
    [ ] Sticky banner (sonraki durak + navigate + gezdim)
    [ ] Full screen trip view (progress, mevcut durak, sıradakiler)
    [ ] "Gezdim" → confetti + score popup
    [ ] "Atla" → durak skip
    [ ] "Geziyi Bitir" → feedback flow'a yönlendir
[ ] Google Maps Navigation deep link
    [ ] "Navigate" → Google Maps / Apple Maps açılsın
[ ] Offline rota indirme (P1)
    [ ] "Rotayı İndir" butonu
    [ ] Hive'a route data + stop cards kaydet
    [ ] Map tiles cache (flutter_map)
    [ ] Offline indicator badge
    [ ] Online olunca sync
```

**Sprint 15-16 çıktısı:** Gezi sırasında aktif yol arkadaşı + offline destek

---

### Sprint 17-18: Premium + Explore (Hafta 17-18)

**Hedef:** Monetizasyon + keşif deneyimi

```
[ ] RevenueCat entegrasyonu
    [ ] iOS + Android subscription setup
    [ ] Free tier: 3 rota/ay limiti
    [ ] Premium: sınırsız rota, deep research, offline
    [ ] 7 gün trial
    [ ] Paywall ekranı (aylık vs yıllık)
    [ ] Receipt doğrulama Edge Function
[ ] Explore / Keşfet screen
    [ ] Kişiselleştirilmiş öneriler (Memory Agent)
    [ ] Trend rotalar (popüler, en çok planlanan)
    [ ] Tematik koleksiyonlar
    [ ] Şehir/ülke arama
[ ] Rate limiting implementasyonu
    [ ] Free: 3 rota/ay → upgrade prompt
    [ ] Premium: unlimited
```

**Sprint 17-18 çıktısı:** Para kazanmaya hazır app + zengin keşif deneyimi

---

### Sprint 19-20: Polish + Testing (Hafta 19-20)

**Hedef:** Store-ready kalite

```
[ ] UI Polish
    [ ] Tüm ekranlarda dark mode
    [ ] Tüm animasyonlar (Lottie/Rive)
    [ ] Edge case'ler (boş state, error state, loading state)
    [ ] Responsive test (iPhone SE → Pro Max + Android)
    [ ] Accessibility (font scaling, screen reader labels)
    [ ] Haptic feedback (stamp, level up, complete)
[ ] Performance
    [ ] Image lazy loading + caching
    [ ] Route generation optimization (<20 saniye hedef)
    [ ] Memory leak check
    [ ] App size optimization (<50 MB hedef)
[ ] Error Handling
    [ ] Sentry entegrasyonu
    [ ] Global error boundary
    [ ] AI fallback (Claude → GPT-4o-mini)
    [ ] Network error retry logic
[ ] PostHog Analytics
    [ ] Key event tracking (route_created, trip_completed, feedback_submitted)
    [ ] Funnel setup (onboarding → first_route → trip_complete → feedback)
    [ ] Feature flags
```

**Sprint 19-20 çıktısı:** Pürüzsüz, hatasız, güzel app

---

### Sprint 21-22: Launch Prep (Hafta 21-22)

**Hedef:** Store'lara yükle, beta test, launch

```
[ ] App Store hazırlık
    [ ] App icon (1024x1024)
    [ ] Screenshots (6.7" + 6.5" + 5.5" iPhone, Pixel)
    [ ] App Store description (TR + EN)
    [ ] Privacy policy sayfası
    [ ] Terms of service
    [ ] App Store Connect setup
    [ ] TestFlight beta (100 kişi)
[ ] Play Store hazırlık
    [ ] Play Console setup
    [ ] Internal testing track
    [ ] Store listing (TR + EN)
[ ] Beta test (2 hafta)
    [ ] 100 beta tester recruit
    [ ] Feedback toplama (Google Form + in-app)
    [ ] Critical bug fix sprint
[ ] Product Hunt hazırlık
    [ ] Maker profili
    [ ] Product page draft
    [ ] First comment hazırla
    [ ] Hunter bul (veya self-hunt)
    [ ] Launch day assets (GIF, video)
[ ] Landing page
    [ ] geez.ai veya geezai.app domain
    [ ] Basit Framer/Carrd landing
    [ ] Email waitlist
    [ ] App Store + Play Store badge'leri
```

**Sprint 21-22 çıktısı:** App Store + Play Store'da yayında!

---

## 4. Key Dependencies (Flutter Packages)

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Navigation
  go_router: ^14.0.0

  # Backend
  supabase_flutter: ^2.5.0

  # Maps
  google_maps_flutter: ^2.6.0

  # HTTP
  dio: ^5.4.0

  # Local Storage
  hive_flutter: ^1.1.0

  # Animations
  lottie: ^3.1.0
  rive: ^0.13.0

  # UI
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  share_plus: ^9.0.0
  url_launcher: ^6.2.0
  confetti_widget: ^0.4.0

  # Notifications
  firebase_messaging: ^15.0.0
  firebase_core: ^3.0.0

  # Payments
  purchases_flutter: ^7.0.0  # RevenueCat

  # Analytics
  posthog_flutter: ^4.0.0
  sentry_flutter: ^8.0.0

  # Fonts
  google_fonts: ^6.2.0

  # Utils
  intl: ^0.19.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.0
  riverpod_generator: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  mockito: ^5.4.0
```

---

## 5. Environment Variables

```bash
# .env.example

# Supabase
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbG...
SUPABASE_SERVICE_ROLE_KEY=eyJhbG...  # Only for Edge Functions

# AI
CLAUDE_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...  # GPT-4o-mini fallback

# Maps
GOOGLE_MAPS_API_KEY=AIza...
GOOGLE_MAPS_IOS_KEY=AIza...    # iOS restricted
GOOGLE_MAPS_ANDROID_KEY=AIza... # Android restricted

# Search
TAVILY_API_KEY=tvly-...
EXA_API_KEY=exa-...

# Firebase (Push Notifications)
# google-services.json (Android)
# GoogleService-Info.plist (iOS)

# RevenueCat
REVENUECAT_API_KEY_APPLE=appl_...
REVENUECAT_API_KEY_GOOGLE=goog_...

# Analytics
POSTHOG_API_KEY=phc_...
SENTRY_DSN=https://xxx@sentry.io/xxx
```

---

## 6. Database Migrations (Sıralı)

```
supabase/migrations/
├── 001_users.sql           # users + user_profiles + travel_personas
├── 002_routes.sql          # routes + route_stops
├── 003_gamification.sql    # passport_stamps + visited_places
├── 004_feedback.sql        # trip_feedback
├── 005_rls_policies.sql    # Row Level Security tüm tablolar
├── 006_pgvector.sql        # place_embeddings (Phase 2)
└── 007_indexes.sql         # Performance indexes
```

---

## 7. Vibe Coding Workflow

### Günlük Rutin

```
1. Sprint backlog'dan task seç
2. Claude Code'a context ver:
   - "Geez AI projesi, [feature X] üzerinde çalışıyoruz"
   - CLAUDE.md'de proje context'i hazır
3. AI ile pair programming:
   - UI: wireframe dokümanından referans ver
   - Backend: technical architecture'dan referans ver
   - Test: her feature sonrası temel test
4. Her gün sonunda:
   - git commit + push
   - Çalışan feature'ın screen recording'i (progress tracking)
```

### AI Agent Team Kullanımı

| Görev | AI Tool | Nasıl |
|-------|---------|-------|
| **UI geliştirme** | Claude Code | "Bu wireframe'e göre X screen'i yap" |
| **Backend logic** | Claude Code | "Technical architecture'daki Y agent'ı implement et" |
| **Bug fixing** | Claude Code | "Bu hatayı systematic-debugging ile bul" |
| **Code review** | Claude Code | "requesting-code-review skill'ini çalıştır" |
| **Test yazma** | Claude Code | "Bu feature için unit test yaz" |
| **Asset üretim** | Cursor + AI | Lottie/Rive animasyon fine-tuning |
| **Copy writing** | Claude | Store description, onboarding copy |
| **Research** | Claude Code | "Bu API'nin Flutter entegrasyonunu araştır" |

### CLAUDE.md (Proje İçi)

```markdown
# Geez AI — CLAUDE.md

## Proje
AI-powered gezi rota planlama mobil uygulaması.
Flutter + Supabase + Claude API.

## Mimari
- Feature-based folder structure (features/)
- Riverpod state management
- GoRouter navigation
- Supabase Edge Functions (Deno/TypeScript)

## Kurallar
- Tüm UI wireframe'e sadık kalmalı (docs/ui-ux-wireframes.md)
- Dark mode her ekranda çalışmalı
- GeezColors, GeezTypography, GeezSpacing kullan (core/theme/)
- Her Edge Function'da error handling + rate limiting olmalı
- AI response'ları her zaman cache'lenmeli

## Referans
- docs/ klasöründe tüm proje belgeleri var
- MVP spec: features/priorities bilgisi
- Tech arch: database schema, agent code, API endpoints
```

---

## 8. Risk Mitigation (Development)

| Risk | Mitigation | Fallback |
|------|-----------|----------|
| **Google Maps API pahalı** | Cache agresif, rate limit | OpenStreetMap (ücretsiz) alternatif |
| **Claude API latency yüksek** | Streaming response, parallel agent calls | Sonuçları göster-bitince-geç değil, hazır olanı anında göster |
| **Flutter build sorunları** | Sabit Flutter version, CI ile catch | Expo/React Native'e geçiş (son çare) |
| **Supabase Edge Function limitleri** | Function'ları küçük tut, timeout ayarla | Vercel Edge Functions alternatif |
| **App Store rejection** | Guidelines'ı önceden oku, beta test | Web app (PWA) olarak da yayınla |
| **AI hallucination** | Google Maps grounding, review-based validation | User report butonu + manual review queue |

---

## 9. Launch Checklist (Final)

### Pre-Launch (2 hafta önce)
- [ ] Tüm P0 feature'lar tamamlandı
- [ ] 100 beta tester geri bildirimi alındı
- [ ] Critical bug'lar fix'lendi
- [ ] Performance test (route generation <20s)
- [ ] Security audit (RLS, API keys, rate limiting)
- [ ] Privacy policy + Terms of Service yayında
- [ ] Landing page yayında (geezai.app)

### App Store Submission
- [ ] App icon final
- [ ] Screenshots hazır (4+ device size)
- [ ] App description (TR + EN) yazıldı
- [ ] Keywords optimized
- [ ] App Review Notes hazır
- [ ] TestFlight'ta son build test edildi
- [ ] App Store Connect'e submit

### Play Store Submission
- [ ] Store listing tamamlandı
- [ ] Internal testing track'te test edildi
- [ ] Content rating questionnaire
- [ ] Play Console'a submit

### Launch Day
- [ ] Product Hunt post yayında (Salı-Perşembe, PST 00:01)
- [ ] Twitter/X announcement thread
- [ ] Reddit (r/travel, r/digitalnomad, r/Turkey)
- [ ] Instagram Reels (app demo)
- [ ] Email listesine bildirim
- [ ] Analytics dashboard açık (PostHog)
- [ ] Sentry alerts açık
- [ ] Customer support ready

---

## 10. Başlangıç Komutu

```bash
# Proje oluşturma — Day 1
flutter create --org com.geezai --project-name geez_ai geez-ai-app
cd geez-ai-app
git init
git remote add origin https://github.com/geez-ai/geez-app.git

# İlk commit
git add .
git commit -m "Initial Flutter project setup"
git push -u origin main
```

**Development start date hedefi:** MVP spec'e göre Q3 2026 (Temmuz-Ağustos)
**Launch hedefi:** Q1 2027

---

*Geez AI development kickoff dokümanı tamamlandır. Bu belge sprint planlaması ve daily development workflow'u için ana referanstır.*
