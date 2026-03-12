# Geez AI — Project Memory

**Son Güncelleme:** 12 Mart 2026
**Proje Başlangıcı:** 12 Mart 2026
**Developer:** Kaze (solo) + AI Agent Team (Claude Code orchestration)
**Yaklaşım:** Vibe Coding — paralel AI agent dispatch, hızlı prototipleme

---

## Proje Özeti

AI-powered kişiselleştirilmiş gezi rotası planlama mobil uygulaması.
Flutter + Supabase + Claude API + Google Maps Platform.

---

## Mevcut Durum: Sprint 1 TAMAMLANDI (kısmen)

### Genel İlerleme

| Alan | Durum | Detay |
|------|-------|-------|
| **Planlama Dokümanları** | ✅ Tamamlandı | 8 belge (market, competitive, MVP, tech arch, financial, GTM, wireframes, kickoff) |
| **Flutter Proje** | ✅ Oluşturuldu | Flutter 3.41.4, Dart 3.11.1 |
| **Theme Sistemi** | ✅ Tamamlandı | GeezColors, GeezTypography, GeezSpacing, Light/Dark tema |
| **Router + Navigation** | ✅ Tamamlandı | GoRouter + ShellRoute + Bottom Nav (5 tab + FAB) |
| **Shared Widget'lar** | ✅ Tamamlandı | Button, Card, Chip, Loading, Confetti, BottomNav |
| **Onboarding Flow** | ✅ Tamamlandı | Splash → Welcome → Quiz → Persona Reveal (animasyonlu) |
| **Home Screen** | ✅ Tamamlandı | Discovery bar, active route card, suggestions, discoveries |
| **Chat / Route Creation** | ✅ Tamamlandı | 5 adımlı Q&A → Loading → Route Detail |
| **Route Detail** | ✅ Tamamlandı | SliverAppBar, day tabs, expandable stop cards |
| **Passport** | ✅ Tamamlandı | Stamp grid, stats, collections, trip history |
| **Profile** | ✅ Tamamlandı | Avatar, persona bars, trip history, settings |
| **Explore** | ❌ Placeholder | Sadece "Explore" text, UI yok |
| **Auth** | ❌ Boş | Klasör yapısı var, implementation yok |
| **Feedback** | ❌ Boş | Klasör yapısı var, implementation yok |
| **Supabase Bağlantısı** | ⏸️ Ertelendi | Migrations hazır (7 adet), bağlantı kurulmadı |
| **Git** | ⚠️ Repo var | .git mevcut, commit durumu belirsiz |

---

## Tamamlanan İşler (Detaylı)

### 1. Planlama & Dokümantasyon

Tüm belgeler `docs/` klasöründe:

| Dosya | İçerik |
|-------|--------|
| `market-opportunity-analysis-2026-03-12.md` | TAM/SAM/SOM, pazar büyüklüğü |
| `competitive-landscape-analysis-2026-03-12.md` | Rakip analizi, Porter's Five Forces |
| `mvp-feature-specification-2026-03-12.md` | Tüm MVP özellikleri, user journey, agent rolleri |
| `technical-architecture-2026-03-12.md` | Teknik mimari, DB schema, agent yapısı |
| `financial-projections-2026-03-12.md` | 3-5 yıl finansal projeksiyonlar |
| `go-to-market-strategy-2026-03-12.md` | GTM planı, pricing, launch stratejisi |
| `ui-ux-wireframes-2026-03-12.md` | Tüm ekranların wireframe'leri |
| `development-kickoff-2026-03-12.md` | 22 haftalık sprint planı, dependency listesi |

### 2. Core Altyapı (5 dosya)

```
lib/core/
├── theme/
│   ├── colors.dart          ✅ Primary #1A73E8, Secondary #FF6D00, Accent #00C853, persona renkleri
│   ├── typography.dart      ✅ Inter font, h1-h3, body, bodySmall, caption, funFact, aiChat
│   ├── spacing.dart         ✅ xs=4 → xxl=48, GeezRadius (card=16, chip=24, button=12)
│   ├── theme.dart           ✅ Material 3, lightTheme + darkTheme, component theming
│   └── theme_exports.dart   ✅ Barrel export
├── router/
│   └── app_router.dart      ✅ GoRouter: /splash, /onboarding, / (shell), /route-loading, /route-detail
└── constants/
    └── api_constants.dart   ✅ API endpoint paths, timeouts
```

### 3. App Entry (2 dosya)

```
lib/
├── main.dart               ✅ ProviderScope → GeezApp
└── app.dart                ✅ MaterialApp.router, Google Fonts Inter, light/dark theme
```

### 4. Shared Widget'lar (6 dosya)

```
lib/shared/widgets/
├── bottom_nav_bar.dart     ✅ 5 tab, center FAB (elevated circular), animated pill
├── geez_button.dart        ✅ Primary/secondary/text variants, loading state
├── geez_card.dart          ✅ Consistent shadow, AnimatedContainer
├── geez_chip.dart          ✅ Selectable, scale bounce animation
├── loading_indicator.dart  ✅ Travel-themed, rotating plane icon
└── confetti_overlay.dart   ✅ CustomPainter, 3 particle shapes, brand colors
```

### 5. Onboarding Feature (6 dosya)

```
lib/features/onboarding/
├── domain/
│   └── onboarding_state.dart       ✅ Quiz state, selectedStyles, budget, companion, personaName
└── presentation/screens/
    ├── splash_screen.dart          ✅ "G E E Z AI" animasyon + plane rotation, 2.5s auto-nav
    ├── welcome_screen.dart         ✅ Gradient illustration, staggered fade/scale, "Merhaba ben Geez!"
    ├── quiz_screen.dart            ✅ 3 soru (style multi-select, budget, companion) + GeezChips
    ├── persona_reveal_screen.dart  ✅ Animated persona card, 5 progress bars, Discovery Score
    └── onboarding_screen.dart      ✅ PageView parent, dot indicators
```

### 6. Home Feature (5 dosya)

```
lib/features/home/
├── domain/
│   └── mock_data.dart              ✅ MockRoute, MockSuggestion, MockDiscovery, MockDiscoveryScore
└── presentation/
    ├── screens/home_screen.dart    ✅ CustomScrollView: header, discovery bar, active route, suggestions
    └── widgets/
        ├── discovery_bar.dart      ✅ Score 847, gradient progress bar, Explorer tier
        ├── active_route_card.dart  ✅ Blue left border, progress bar, "Devam Et" button
        └── suggestion_card.dart    ✅ 180px horizontal card, gradient + flag + city
```

### 7. Chat Feature (4 dosya)

```
lib/features/chat/
└── presentation/
    ├── screens/
    │   ├── chat_screen.dart          ✅ Step-based state machine (destination→style→transport→budget→loading)
    │   └── route_loading_screen.dart ✅ 5-step progress, simulated delays, auto-nav to route detail
    └── widgets/
        ├── chat_bubble.dart          ✅ AI (left, grey-blue, plane avatar) / User (right, primary)
        └── question_chips.dart       ✅ Animated fade-in chip selector
```

### 8. Route Feature (3 dosya)

```
lib/features/route/
├── domain/
│   └── mock_route_data.dart          ✅ Istanbul Day 1: 6 stops (Süleymaniye, Kapalıçarşı, Yerebatan, Ayasofya, Sultanahmet, Balat)
└── presentation/
    ├── screens/route_detail_screen.dart ✅ SliverAppBar, day tabs, stop card list, FAB
    └── widgets/stop_card.dart          ✅ Expandable: collapsed/expanded (description, tips, fun facts)
```

### 9. Passport Feature (5 dosya)

```
lib/features/passport/
├── domain/
│   └── mock_passport_data.dart       ✅ Stamps, collections, stats, trip history models
└── presentation/
    ├── screens/passport_screen.dart  ✅ Passport cover, stamp grid, stats, goal progress, collections
    └── widgets/
        ├── stamp_card.dart           ✅ Completed (colored) / Locked (grey)
        ├── stats_row.dart            ✅ Horizontal stat items
        └── collection_card.dart      ✅ Themed collection + progress bar
```

### 10. Profile Feature (2 dosya)

```
lib/features/profile/
└── presentation/
    ├── screens/profile_screen.dart   ✅ Avatar, persona title, discovery score, 5 persona bars, settings
    └── widgets/persona_bar.dart      ✅ Animated progress bar, persona-specific color
```

### 11. Database Migrations (7 dosya — HENÜZ BAĞLANMADI)

```
supabase/migrations/
├── 001_users.sql           ✅ users, user_profiles, travel_personas + auto-triggers
├── 002_routes.sql          ✅ routes, route_stops
├── 003_gamification.sql    ✅ passport_stamps, visited_places
├── 004_feedback.sql        ✅ trip_feedback
├── 005_rls_policies.sql    ✅ RLS on all 8 tables
├── 006_pgvector.sql        ✅ place_embeddings vector(1536)
└── 007_indexes.sql         ✅ Performance indexes
supabase/config.toml        ✅ Local dev config
supabase/seed.sql           ✅ Test data (1 user, 1 Istanbul route, 3 stops)
```

---

## Bilinen Sorunlar & Buglar

| # | Sorun | Dosya | Durum | Detay |
|---|-------|-------|-------|-------|
| 1 | WelcomeScreen overflow | `welcome_screen.dart:98` | ✅ Fix uygulandı | `illustrationSize` artık `clamp(180, height*0.35)` |
| 2 | Xcode yüklü değil | Sistem | ⚠️ Blocker (iOS) | iOS simulator için Xcode gerekli, Chrome'da çalışıyor |
| 3 | widget_test.dart | `test/widget_test.dart` | ✅ Düzeltildi | MyApp → ProviderScope + GeezApp |

---

## Boş Klasörler (Skeleton)

Klasör yapısı oluşturuldu ama içi boş:
- `lib/features/auth/data/` — Auth repository
- `lib/features/auth/domain/` — Auth models
- `lib/features/auth/presentation/screens/` — Login, Signup
- `lib/features/auth/presentation/widgets/` — Auth widgets
- `lib/features/feedback/presentation/screens/` — Feedback flow
- `lib/features/feedback/presentation/widgets/` — Rating stars, stop select
- `lib/features/explore/presentation/widgets/` — Destination card, trending
- `lib/shared/services/` — Supabase service, location service
- `lib/providers/` — Riverpod providers (auth, user, route, chat, gamification)
- `lib/core/extensions/` — Dart extensions
- `lib/core/utils/` — Utility functions

---

## Yapılacaklar — Sprint Bazlı

### Sprint 1-2: Foundation (Kalan İşler)

```
[x] Flutter proje oluştur
[x] Proje yapısını kur (feature-based structure)
[x] Theme system (GeezColors, GeezTypography, light/dark)
[x] GoRouter + bottom navigation shell
[x] Temel shared widget'lar (GeezButton, GeezCard, GeezChip)
[x] .env yapısı
[ ] Supabase projesi oluştur — ERTELENDI (Kaze'nin kararı)
[ ] Supabase Auth entegrasyonu — ERTELENDI
[ ] Login / Signup ekranları — ERTELENDI (auth feature boş)
[ ] GitHub remote repo + CI pipeline — YAPILMADI
[ ] Git commit'leri düzenlenmeli
```

### Sprint 3-4: Onboarding + Home (Tamamlandı!)

```
[x] Splash screen (logo animasyonu)
[x] Onboarding flow (3+ ekran swipe)
[x] Welcome ekranı
[x] Quick Quiz (style chips — multi-select)
[x] Persona Reveal (confetti + persona kartı)
[ ] user_profiles tablosuna quiz sonuçlarını kaydet — ERTELENDI (Supabase yok)
[ ] travel_personas tablosuna ilk persona oluştur — ERTELENDI
[x] Home screen
[x] Header (kullanıcı adı + greeting)
[x] Discovery Score bar
[x] Active route card
[x] Suggestion cards
[x] Profile screen (persona bars, settings, trip history)
```

### Sprint 5-7: AI Chat + Route Core (UI Tamamlandı, Backend Yok)

```
[x] Chat screen UI
[x] Chat bubble'lar (user + AI)
[x] Destinasyon input + soru chip'leri
[x] Route loading screen (progress animasyonu)
[x] Route Detail screen (gün tab'ları, stop cards)
[x] Stop card (collapsed + expanded — description, insider tip, fun fact)
[ ] Supabase Edge Function: generate-route — YAPILMADI
[ ] Claude API entegrasyonu — YAPILMADI
[ ] Research Agent (Google Maps Places API) — YAPILMADI
[ ] Route Agent (sıralama + zamanlama) — YAPILMADI
[ ] routes + route_stops tablolarına kaydet — ERTELENDI
[ ] Harita görünümü (Google Maps polyline) — YAPILMADI
```

### Sprint 8-9: Deep Research + Fun Facts — YAPILMADI

```
[ ] Research Agent geliştir (Tavily + review sentezi)
[ ] Stop card zenginleştir (mekan fotoğrafı, pratik bilgi)
[ ] Google Maps Popular Times (kalabalık saatleri)
[ ] AI Response caching
```

### Sprint 10-11: Memory + Feedback — YAPILMADI

```
[ ] Memory Agent implementasyonu
[ ] Post-Trip Feedback flow (5 ekran)
[ ] Push notification trigger
[ ] "Aynı şehre tekrar" akıllı davranış
```

### Sprint 12-14: Gamification (UI Tamamlandı, Logic Yok)

```
[x] Dijital Pasaport screen (kapak, damga grid, istatistikler)
[x] Stamp card (completed/locked states)
[x] Collection card (tematik koleksiyonlar)
[x] Discovery Score widget (Home'da)
[x] Travel Persona bar'ları (Profile'da)
[ ] Score hesaplama logic — YAPILMADI
[ ] Rota tamamlandığında otomatik damga — YAPILMADI
[ ] Level up overlay + haptic — YAPILMADI
[ ] Share kartları (sosyal medya) — YAPILMADI
```

### Sprint 15-16: Active Trip + Offline — YAPILMADI

```
[ ] Active Trip Mode (sticky banner, "gezdim" buton)
[ ] Google Maps Navigation deep link
[ ] Offline rota indirme (Hive)
```

### Sprint 17-18: Premium + Explore — KISMEN

```
[ ] RevenueCat entegrasyonu — YAPILMADI
[ ] Explore / Keşfet screen — PLACEHOLDER (sadece text)
[ ] Trend rotalar, tematik koleksiyonlar — YAPILMADI
[ ] Rate limiting — YAPILMADI
```

### Sprint 19-22: Polish, Testing, Launch — YAPILMADI

```
[ ] UI Polish (animasyonlar, edge cases, responsive)
[ ] Performance optimization
[ ] Sentry + PostHog entegrasyonu
[ ] App Store / Play Store hazırlık
[ ] Beta test
[ ] Landing page
[ ] Product Hunt launch
```

---

## Dependency Durumu

### Yüklü (pubspec.yaml'da)

| Paket | Versiyon | Kullanım |
|-------|----------|----------|
| flutter_riverpod | ^2.6.1 | State management |
| go_router | ^14.8.1 | Navigation |
| google_fonts | ^6.2.1 | Inter font |
| cupertino_icons | ^1.0.8 | iOS-style icons |

### Henüz Eklenmemiş (Sprint planında var)

| Paket | Sprint | Kullanım |
|-------|--------|----------|
| supabase_flutter | 1-2 | Backend |
| google_maps_flutter | 5-7 | Harita |
| dio | 5-7 | HTTP client |
| hive_flutter | 15-16 | Offline storage |
| lottie | 12-14 | Animasyonlar |
| rive | 12-14 | Animasyonlar |
| cached_network_image | 8-9 | Image caching |
| shimmer | 8-9 | Loading placeholders |
| share_plus | 12-14 | Sosyal paylaşım |
| firebase_messaging | 10-11 | Push notifications |
| purchases_flutter | 17-18 | RevenueCat payments |
| posthog_flutter | 19-20 | Analytics |
| sentry_flutter | 19-20 | Error tracking |
| freezed | 5-7 | Immutable models |
| riverpod_annotation | 5-7 | Riverpod codegen |

---

## Teknik Kararlar & Notlar

| Karar | Detay |
|-------|-------|
| **Mock Data** | Tüm ekranlar hardcoded mock data ile çalışıyor — Supabase bağlantısı yok |
| **Web Test** | iOS simulator yok (Xcode eksik), Chrome'da test ediliyor |
| **Paralel Build** | Tüm Sprint 1 UI'ları 4 paralel agent ile ~10 dakikada build edildi |
| **Orchestration** | Kaze kod yazmıyor, Claude Code orkestrasyon yapıyor, subagent'lar build ediyor |
| **flutter analyze** | 41 Dart dosya, 0 hata, 0 uyarı |
| **WelcomeScreen Fix** | `size.width * 0.7` → `clamp(180, height*0.35)` ile responsive yapıldı |

---

## Dosya Sayıları

| Kategori | Dosya Sayısı |
|----------|-------------|
| Dart dosyaları (lib/) | 42 |
| Supabase migrations | 7 |
| Supabase diğer | 2 (config.toml, seed.sql) |
| Docs | 8 |
| Toplam proje dosyası | ~60+ |

---

## Acil Sonraki Adımlar (Önerilen)

1. **Git commit** — Tüm çalışma commit'lenmeli
2. **Explore screen** — Tek placeholder kalan ekran, UI build edilmeli
3. **Xcode kurulumu** — iOS simulator için gerekli (veya Android emulator)
4. **Auth flow** — Login/Signup (mock, Supabase'siz)
5. **Feedback flow** — Post-trip feedback (5 ekran)
6. **Riverpod providers** — State management bağlantıları (şimdilik mock)

---

## Proje Yapısı (Özet Ağaç)

```
geez-ai/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── theme/ (5 dosya)
│   │   ├── router/ (1 dosya)
│   │   └── constants/ (1 dosya)
│   ├── features/
│   │   ├── onboarding/ (6 dosya) ✅
│   │   ├── home/ (5 dosya) ✅
│   │   ├── chat/ (4 dosya) ✅
│   │   ├── route/ (3 dosya) ✅
│   │   ├── passport/ (5 dosya) ✅
│   │   ├── profile/ (2 dosya) ✅
│   │   ├── explore/ (1 dosya) ⚠️ placeholder
│   │   ├── auth/ (0 dosya) ❌ boş
│   │   └── feedback/ (0 dosya) ❌ boş
│   ├── shared/widgets/ (6 dosya) ✅
│   ├── shared/services/ (boş)
│   └── providers/ (boş)
├── supabase/
│   ├── migrations/ (7 dosya) ✅ hazır, bağlanmadı
│   ├── config.toml ✅
│   └── seed.sql ✅
├── docs/ (8 dosya) ✅
├── test/widget_test.dart ✅
├── CLAUDE.md ✅
├── pubspec.yaml ✅
└── .env.example ✅
```

---

*Bu belge her sprint sonunda güncellenmelidir.*
