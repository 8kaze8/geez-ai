# Geez AI - Sprint Plan

> Son guncelleme: 2026-03-16
> Durum: Sprint 6.5 DEVAM EDIYOR (E2E Integration Fix) — Temel akis calismali, sonra Phase 2

## Genel Bakis

| Sprint | Ad                                     | Sure       | Durum          |
| ------ | -------------------------------------- | ---------- | -------------- |
| 0      | UI Shell (Mock Data)                   | 1 hafta    | TAMAMLANDI     |
| 1      | Database + Auth Foundation             | 1 hafta    | TAMAMLANDI     |
| 2      | State Management + Domain Models       | 1 hafta    | TAMAMLANDI     |
| 3      | Edge Functions + AI Integration        | 1 hafta    | TAMAMLANDI     |
| 4      | Frontend-Backend Integration           | 1 hafta    | TAMAMLANDI     |
| 4.5    | Hotfix: Critical Blockers              | 2 gun      | TAMAMLANDI     |
| 5      | Stability & Polish                     | 3-4 gun    | TAMAMLANDI     |
| 5.5    | Memory Agent + user-context EF         | 2 gun      | TAMAMLANDI     |
| 6      | Audit Remediation (42 bulgu)           | 1 gun      | TAMAMLANDI     |
| 6.5    | E2E Integration Fix                    | 1 gun      | DEVAM EDIYOR   |
| 7      | Deep Research (Tavily + Exa)           | 1 hafta    | BACKLOG        |
| 8      | UI/UX Redesign                         | 1 hafta    | BACKLOG        |
| 9      | Testing + Security Hardening           | 1 hafta    | BACKLOG        |
| 10     | Localization + Performance             | 1 hafta    | BACKLOG        |
| 11     | RevenueCat + Paywall                   | 1 hafta    | BACKLOG        |
| 12     | Explore Screen + AI Suggestions        | 1 hafta    | BACKLOG        |
| 13-14  | Gamification + Active Trip             | 2 hafta    | BACKLOG        |
| 15-16  | Offline + Social                       | 2 hafta    | BACKLOG        |
| 17-18  | Polish + Performance                   | 2 hafta    | BACKLOG        |
| 19-20  | Launch Prep + LAUNCH                   | 2 hafta    | BACKLOG        |

## Sprint 6.5: E2E Integration Fix (2026-03-16)

### Hedef

Sprint 1-6'da yapilan tum calismarin uctan uca calismasi: signup --> chat Q&A --> rota olusturma --> rota goruntuleme --> tamamlama --> feedback. Auth 401 (ES256/HS256 JWT mismatch) ve Gemini API key sorunlari cozuldu.

### Cozulen Kritik Sorunlar

| Sorun | Kok Neden | Cozum |
|-------|-----------|-------|
| 401 Invalid JWT | Supabase gateway ES256 token'lari reddediyor | `verify_jwt: false` ile deploy, auth.ts icinde dogrulama |
| Gemini 429 quota | Free tier kotasi dolmus | Pay-as-you-go API key |
| Model fallback timeout | OpenAI/Anthropic key yok, 30s bos bekleme | PROVIDER_KEY_ENV fast-fail guard |
| Chat input eksik | Text input alani yoktu | Bottom input bar eklendi |
| Draft route Home'da gorünmuyor | markAsActive() eksikti | Auto-activation on first view |

### Gorevler

| # | Gorev | Atanan | Durum |
|---|-------|--------|-------|
| 6.5.1 | Auth fix (verify_jwt: false) | backend-architect | TAMAMLANDI |
| 6.5.2 | Gemini API key + model router fix | backend-architect | TAMAMLANDI |
| 6.5.3 | Chat input bar + note ekleme | mobile-developer | TAMAMLANDI |
| 6.5.4 | generate-route E2E test | backend-architect | DEVAM EDIYOR |
| 6.5.5 | JSON deserialization dogrulama | mobile-developer | TAMAMLANDI |
| 6.5.6 | Route lifecycle (draft->active->completed) | mobile-developer | TAMAMLANDI |
| 6.5.7 | Full flow manual test + build | qa-engineer | BEKLIYOR |

## Audit Ozeti (2026-03-14)

Uc paralel ajan (QA, Explorer, Playwright) ile yapilan kapsamli audit sonuclari:

| Seviye   | Adet | Aciklama                                        | Durum     |
| -------- | ---- | ----------------------------------------------- | --------- |
| CRITICAL | 7    | Turkish diacritics, forgot password, signOut     | DUZELTILDI |
| WARNING  | 14   | Input validation, rate limit, timeout, triggers  | DUZELTILDI |
| INFO     | 8    | Dead code, import cleanup                        | DUZELTILDI |

Sprint 6'da 42 bulgunun tamami duzeltildi. 3 Edge Function deploy edildi (chat v3, user-context v1, generate-route v4). Migration 012 uygulandi. Flutter analyze: 0 issue.

## AI Model Stratejisi (Tiered LLM)

| Model            | Rol                                              | Maliyet/1K token |
| ---------------- | ------------------------------------------------ | ---------------- |
| Gemini 2.5 Flash | Ana motor (route generation, content enrichment) | $0.15/1M input   |
| GPT-4.1-mini     | Destekci (review synthesis, place ranking)       | $0.40/1M input   |
| GPT-4.1-nano     | Basit gorevler (Q&A flow, memory update)         | $0.10/1M input   |
| Claude Sonnet    | Premium fallback                                 | $3.00/1M input   |

Tahmini maliyet: ~$0.054/rota (onceki plandan %81 ucuz)

---

## Sprint 1: Database + Auth Foundation (Hafta 1)

### Hedef

Supabase veritabanini kur, Auth sistemi entegre et, login/signup akisini calistir, router guard ile korunmus rotalari aktif et.

### Bagimlilk Zinciri

```
1.1 Migration Apply
  --> 1.2 supabase_flutter + flutter_dotenv paketi ekle
    --> 1.3 Supabase initialize (main.dart)
      --> 1.4 Auth Repository + Provider
        --> 1.5 Login/Signup ekranlari
          --> 1.6 Router Guard (auth redirect)
            --> 1.7 Splash --> auth durumuna gore yonlendirme
```

### Gorevler

#### 1.1 Migration'lari Supabase'e Uygula

- **Atanan:** database-architect
- **Dosyalar:**
  - `supabase/migrations/001_extensions.sql` --> `009_indexes.sql` (mevcut, degisiklik yok)
- **Islem:** 9 migration dosyasini sirayla Supabase MCP uzerinden apply et
- **Done Kriteri:** `list_tables` 9 tablo gosteriyor, `list_migrations` 9 kayit var

#### 1.2 Paket Ekleme + Environment Kurulumu

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `pubspec.yaml` -- supabase_flutter, flutter_dotenv ekle
  - `.env.example` -- guncelle (SUPABASE_URL, SUPABASE_ANON_KEY)
  - `.gitignore` -- .env zaten mevcut
  - `pubspec.yaml` assets section -- .env dosyasini ekle
- **Done Kriteri:** `flutter pub get` basarili, .env yukleniyor

#### 1.3 Supabase Initialize

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/main.dart` -- Supabase.initialize() ekle
  - `lib/core/providers/supabase_provider.dart` -- YENI: SupabaseClient provider
  - `lib/core/constants/api_constants.dart` -- dotenv'den oku
- **Bagimlilk:** 1.2
- **Done Kriteri:** Uygulama acildiginda Supabase baglantisi basarili (console'da hata yok)

#### 1.4 Auth Repository + Provider

- **Atanan:** backend-architect
- **Dosyalar:**
  - `lib/features/auth/data/auth_repository.dart` -- YENI: signUp, signIn, signOut, currentUser, authStateChanges
  - `lib/features/auth/domain/auth_state.dart` -- YENI: AuthState (authenticated, unauthenticated, loading)
  - `lib/features/auth/presentation/providers/auth_provider.dart` -- YENI: authStateProvider, authControllerProvider
- **Bagimlilk:** 1.3
- **Done Kriteri:** signUp/signIn/signOut calisir, auth state degisikliklerini dinler

#### 1.5 Login/Signup Ekranlari

- **Atanan:** mobile-developer + ui-designer
- **Dosyalar:**
  - `lib/features/auth/presentation/screens/login_screen.dart` -- YENI
  - `lib/features/auth/presentation/screens/signup_screen.dart` -- YENI
  - `lib/features/auth/presentation/widgets/auth_text_field.dart` -- YENI: custom text field
  - `lib/features/auth/presentation/widgets/social_login_button.dart` -- YENI: Google/Apple login (ileride)
- **Bagimlilk:** 1.4
- **Done Kriteri:** Email/sifre ile kayit ve giris yapilabiliyor, hata mesajlari gosteriliyor, dark mode calisiyor

#### 1.6 Router Guard (Auth Redirect)

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/core/router/app_router.dart` -- GUNCELLE: redirect logic ekle
  - `lib/core/router/route_names.dart` -- YENI: route path sabitleri
- **Bagimlilk:** 1.4
- **Done Kriteri:** Auth olmayan kullanici login'e yonlendirilir, auth olan kullanici home'a gider, onboarding durumu kontrol edilir

#### 1.7 Splash Ekrani Guncelleme

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/onboarding/presentation/screens/splash_screen.dart` -- GUNCELLE: auth durumunu kontrol et
- **Bagimlilk:** 1.6
- **Done Kriteri:** Splash ekrani --> auth kontrolu --> login veya home/onboarding'e yonlendirme

### Sprint 1 Tamamlanma Kriterleri

- [x] 9 tablo Supabase'de olusturuldu (RLS aktif)
- [x] supabase_flutter paketi entegre ve initialize edildi
- [x] Auth repository + provider calisiyor
- [x] Login/Signup ekranlari fonksiyonel (email/password)
- [x] Router guard calisiyor (auth check + onboarding check)
- [x] Splash --> auth flow --> home/onboarding akisi calisiyor
- [x] Dark mode tum yeni ekranlarda destekleniyor
- [x] Hicbir API key kodda hardcode degil (.env'den okunuyor)

---

## Sprint 2: State Management + Domain Models (Hafta 2)

### Hedef

Freezed ile immutable domain modeller olustur, Riverpod ile global state yonetimini kur, onboarding verilerini DB'ye yaz, Profile/Passport mock'tan gercegeye gecir.

### Bagimlilk Zinciri

```
2.1 Paket ekleme (freezed, riverpod_annotation, json_serializable)
  --> 2.2 Domain modeller (DB semasina uyumlu)
    --> 2.3 Repository pattern (her feature icin)
      --> 2.4 Onboarding --> DB'ye yazma
      --> 2.5 Profile mock-->real
      --> 2.6 Passport mock-->real
```

### Gorevler

#### 2.1 Code Generation Altyapisi

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `pubspec.yaml` -- freezed_annotation, json_annotation, riverpod_annotation ekle
  - `pubspec.yaml` (dev) -- freezed, json_serializable, riverpod_generator, build_runner ekle
  - `build.yaml` -- YENI: build_runner konfigurasyonu
- **Done Kriteri:** `dart run build_runner build` basarili

#### 2.2 Domain Modeller

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/auth/domain/user_model.dart` -- YENI: User (users tablosuyla uyumlu)
  - `lib/features/auth/domain/user_profile_model.dart` -- YENI: UserProfile
  - `lib/features/route/domain/route_model.dart` -- YENI: Route (routes tablosuyla uyumlu)
  - `lib/features/route/domain/route_stop_model.dart` -- YENI: RouteStop
  - `lib/features/passport/domain/passport_stamp_model.dart` -- YENI: PassportStamp
  - `lib/features/passport/domain/visited_place_model.dart` -- YENI: VisitedPlace
  - `lib/features/passport/domain/travel_persona_model.dart` -- YENI: TravelPersona
  - `lib/features/chat/domain/trip_feedback_model.dart` -- YENI: TripFeedback
- **Bagimlilk:** 2.1
- **Done Kriteri:** Tum modeller freezed, DB field'lariyla 1:1 eslesme, fromJson/toJson calisiyor

#### 2.3 Repository Pattern

- **Atanan:** backend-architect
- **Dosyalar:**
  - `lib/core/data/base_repository.dart` -- YENI: BaseRepository (Supabase CRUD helper)
  - `lib/features/auth/data/user_repository.dart` -- YENI: getProfile, updateProfile
  - `lib/features/route/data/route_repository.dart` -- YENI: getRoutes, getRouteDetail, softDelete
  - `lib/features/passport/data/passport_repository.dart` -- YENI: getStamps, getVisitedPlaces, getPersona
  - `lib/features/chat/data/feedback_repository.dart` -- YENI: submitFeedback
- **Bagimlilk:** 2.2
- **Done Kriteri:** Her repository Supabase client uzerinden CRUD yapiyor, RLS ile test edildi

#### 2.4 Onboarding --> DB Yazma

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/onboarding/data/onboarding_repository.dart` -- YENI
  - `lib/features/onboarding/presentation/providers/onboarding_provider.dart` -- YENI: Riverpod provider
  - `lib/features/onboarding/presentation/screens/persona_reveal_screen.dart` -- GUNCELLE: DB'ye kaydet
  - `lib/features/onboarding/domain/onboarding_state.dart` -- GUNCELLE: DB mapping
- **Bagimlilk:** 2.3, 1.4
- **Done Kriteri:** Onboarding tamamlandiginda user_profiles + travel_personas guncelleniyor

#### 2.5 Profile Mock --> Real

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/profile/presentation/providers/profile_provider.dart` -- YENI
  - `lib/features/profile/presentation/screens/profile_screen.dart` -- GUNCELLE: mock kaldir, provider kullan
  - `lib/features/profile/presentation/widgets/persona_bar.dart` -- GUNCELLE: gercek data
- **Bagimlilk:** 2.3
- **Done Kriteri:** Profile ekrani DB'den okuyor, loading/error/empty state'ler var

#### 2.6 Passport Mock --> Real

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/passport/presentation/providers/passport_provider.dart` -- YENI
  - `lib/features/passport/presentation/screens/passport_screen.dart` -- GUNCELLE
  - `lib/features/passport/domain/mock_passport_data.dart` -- KALDIR (artik gerek yok)
- **Bagimlilk:** 2.3
- **Done Kriteri:** Passport ekrani DB'den okuyor, bos durum handle ediliyor

### Sprint 2 Tamamlanma Kriterleri

- [x] Freezed + Riverpod code generation calisiyor
- [x] 8 domain model DB semasina uyumlu
- [x] 5 repository Supabase uzerinden CRUD yapiyor
- [x] Onboarding sonuclari DB'ye yaziliyor
- [x] Profile ekrani gercek data gosteriyor
- [x] Passport ekrani gercek data gosteriyor
- [x] Tum ekranlarda loading, error, empty state'ler var
- [x] Mock data dosyalari kaldirildi veya deprecated isaretlendi

---

## Sprint 3: Edge Functions + AI Integration (Hafta 3)

### Hedef

Supabase Edge Function altyapisini kur, generate-route V1'i Gemini 2.5 Flash ile calistir, chat endpoint'i olustur, model router mekanizmasini implement et.

### Bagimlilk Zinciri

```
3.1 Edge Function altyapisi (_shared)
  --> 3.2 Model Router (gorev tipine gore model secimi)
    --> 3.3 generate-route V1 (Gemini 2.5 Flash)
    --> 3.4 chat endpoint
  --> 3.5 AI cache mekanizmasi
```

### Gorevler

#### 3.1 Edge Function Altyapisi

- **Atanan:** backend-architect
- **Dosyalar:**
  - `supabase/functions/_shared/cors.ts` -- YENI: CORS headers
  - `supabase/functions/_shared/auth.ts` -- YENI: JWT dogrulama helper
  - `supabase/functions/_shared/error-handler.ts` -- YENI: hata yakalama + response format
  - `supabase/functions/_shared/rate-limit.ts` -- YENI: usage_tracking kontrolu
  - `supabase/functions/_shared/supabase-client.ts` -- YENI: service_role client factory
- **Done Kriteri:** Shared modullerin hepsi import edilebiliyor, test edildi

#### 3.2 Model Router

- **Atanan:** ai-engineer
- **Dosyalar:**
  - `supabase/functions/_shared/model-router.ts` -- YENI: gorev tipine gore model secimi
  - `supabase/functions/_shared/llm-clients/gemini.ts` -- YENI: Gemini API client
  - `supabase/functions/_shared/llm-clients/openai.ts` -- YENI: GPT-4.1-mini/nano client
  - `supabase/functions/_shared/llm-clients/anthropic.ts` -- YENI: Claude fallback client
- **Bagimlilk:** 3.1
- **Done Kriteri:** Model router gorev tipine gore dogru modeli seciyor, fallback calisiyor

#### 3.3 generate-route V1

- **Atanan:** ai-engineer
- **Dosyalar:**
  - `supabase/functions/generate-route/index.ts` -- YENI: ana handler
  - `supabase/functions/generate-route/prompts.ts` -- YENI: route generation prompt'lari
  - `supabase/functions/generate-route/types.ts` -- YENI: request/response type'lar
- **Bagimlilk:** 3.2, 3.5
- **Done Kriteri:** Sehir + parametreler gonderildiginde 5-10 durakli rota donuyor, cache hit/miss calisiyor

#### 3.4 Chat Endpoint

- **Atanan:** ai-engineer
- **Dosyalar:**
  - `supabase/functions/chat/index.ts` -- YENI: ana handler
  - `supabase/functions/chat/prompts.ts` -- YENI: chat prompt'lari (Q&A flow)
- **Bagimlilk:** 3.2
- **Done Kriteri:** Kullanici mesaji gonderdiginde AI yaniti donuyor, conversation context korunuyor

#### 3.5 AI Cache Mekanizmasi

- **Atanan:** backend-architect
- **Dosyalar:**
  - `supabase/functions/_shared/cache.ts` -- YENI: ai_route_cache okuma/yazma helper
- **Bagimlilk:** 3.1
- **Done Kriteri:** Cache key olusturma, cache hit kontrolu, TTL yonetimi calisiyor

### Sprint 3 Tamamlanma Kriterleri

- [x] Edge Function altyapisi (CORS, auth, error, rate limit) calisiyor
- [x] Model router 4 LLM arasinda gorev bazli yonlendirme yapiyor
- [x] generate-route V1 rota uretiyor ve cache'liyor
- [x] chat endpoint konusma akisini yonetiyor
- [x] Rate limit free tier icin calisiyor (3 rota/ay)
- [x] Tum Edge Function'larda hata yakalama ve loglama var
- [x] API key'ler Supabase secrets'ta, kodda degil
- [x] QA review yapildi -- 7 kritik bug fix'lendi (skor: 7.2 -> duzeltildi)

---

## Sprint 4: Frontend-Backend Integration (Hafta 4)

### Hedef

Frontend'deki tum mock data'yi gercek backend baglantilariyla degistir, end-to-end akilarin tamamini calistir, feedback loop'u implement et.

### Bagimlilk Zinciri

```
4.1 Home mock-->real
4.2 Chat provider + generate-route entegrasyonu (PARALEL ile 4.1)
  --> 4.3 Route loading + detail entegrasyonu
    --> 4.4 Feedback flow
      --> 4.5 End-to-end test
```

### Gorevler

#### 4.1 Home Mock --> Real

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/home/presentation/providers/home_provider.dart` -- YENI
  - `lib/features/home/presentation/screens/home_screen.dart` -- GUNCELLE
  - `lib/features/home/presentation/widgets/active_route_card.dart` -- GUNCELLE
  - `lib/features/home/presentation/widgets/suggestion_card.dart` -- GUNCELLE
  - `lib/features/home/presentation/widgets/discovery_bar.dart` -- GUNCELLE
  - `lib/features/home/domain/mock_data.dart` -- KALDIR
- **Done Kriteri:** Home ekrani DB'den okuyor, bos durum gosteriliyor (yeni kullanici)

#### 4.2 Chat Provider + Route Generation

- **Atanan:** mobile-developer + backend-architect
- **Dosyalar:**
  - `lib/features/chat/presentation/providers/chat_provider.dart` -- YENI: mesaj gonderme, AI yaniti alma
  - `lib/features/chat/data/chat_repository.dart` -- YENI: Edge Function cagirma
  - `lib/features/chat/presentation/screens/chat_screen.dart` -- GUNCELLE
  - `lib/features/chat/presentation/widgets/chat_bubble.dart` -- GUNCELLE
  - `lib/features/chat/presentation/widgets/question_chips.dart` -- GUNCELLE
- **Bagimlilk:** Sprint 3 tamamlanmis olmali
- **Done Kriteri:** Chat ekranindan AI ile konusulabiliyor, rota olusturma tetiklenebiliyor

#### 4.3 Route Loading + Detail

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/chat/presentation/providers/route_generation_provider.dart` -- YENI
  - `lib/features/chat/presentation/screens/route_loading_screen.dart` -- GUNCELLE: gercek progress
  - `lib/features/route/presentation/providers/route_detail_provider.dart` -- YENI
  - `lib/features/route/presentation/screens/route_detail_screen.dart` -- GUNCELLE
  - `lib/features/route/presentation/widgets/stop_card.dart` -- GUNCELLE
  - `lib/features/route/domain/mock_route_data.dart` -- KALDIR
- **Bagimlilk:** 4.2
- **Done Kriteri:** Rota yukleme animasyonu gercek Edge Function cagrisini takip ediyor, route detail DB'den

#### 4.4 Feedback Flow

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/features/feedback/presentation/screens/feedback_screen.dart` -- YENI
  - `lib/features/feedback/presentation/providers/feedback_provider.dart` -- YENI
  - `lib/features/feedback/data/feedback_repository.dart` -- YENI (veya chat/data altinda)
- **Bagimlilk:** 4.3
- **Done Kriteri:** Trip tamamlandiginda feedback form gosteriliyor, DB'ye kaydediliyor

#### 4.5 End-to-End Test

- **Atanan:** qa-engineer
- **Dosyalar:**
  - `test/integration/auth_flow_test.dart` -- YENI
  - `test/integration/route_generation_test.dart` -- YENI
  - `test/integration/feedback_flow_test.dart` -- YENI
- **Bagimlilk:** 4.1-4.4 tamamlanmis
- **Done Kriteri:** Kayit --> onboarding --> chat --> rota --> feedback akisi uctan uca calisiyor

### Sprint 4 Tamamlanma Kriterleri

- [x] Tum mock data dosyalari kaldirildi
- [x] Home, Chat, Route, Passport, Profile ekranlari gercek data gosteriyor
- [x] Chat --> AI --> Route generation akisi calisiyor
- [x] Post-trip feedback DB'ye yaziliyor
- [x] End-to-end akilar test edildi (QA review 7.5/10 -- 4 kritik + 4 uyari fix'lendi)
- [x] Hata durumlari handle ediliyor (network error, timeout, rate limit)
- [x] Performance kabul edilebilir seviyede (<3s sayfa yukleme) -- flutter analyze 2.2s, UI render anlik, API latency Supabase secrets sonrasi test edilecek

---

## Sprint 4.5: Hotfix -- Critical Blockers (2 Gun)

### Hedef

Audit'te tespit edilen 4 CRITICAL hatanin tamami burada fix'lenir. Bu hatalar kullanicinin temel akislari (rota olusturma, feedback gonderme, rate limiting) tamamen engelliyor. Phase 2'ye gecmeden once bu sprint TAMAMLANMAK ZORUNDA.

### Bagimlilk Zinciri

```
4.5.1 DB Migration: atomic RPC fonksiyonlari (ILKE YAPILACAK)
  --> 4.5.2 Edge Function fix'leri (status code + saveRouteToDb)
4.5.3 Flutter client fix'leri (_assertSuccess + feedback UUID)
  (4.5.1 ve 4.5.3 PARALEL calisabilir)
    --> 4.5.4 Dogrulama testi
```

### Gorevler

#### 4.5.1 DB Migration: Eksik RPC Fonksiyonlari + Constraint Fix

- **Atanan:** database-architect
- **Audit Referansi:** CRIT-03 (increment_routes_generated RPC missing), CRIT-04 (travel_mode mismatch)
- **Dosyalar:**
  - `supabase/migrations/010_atomic_rpc_functions.sql` -- YENI
- **Icerik:**
  - [x] `increment_routes_generated(p_user_id UUID, p_year INT, p_month INT)` -- Atomic `UPDATE usage_tracking SET routes_generated = routes_generated + 1` fonksiyonu. Mevcut `rate-limit.ts` satir 201 bu RPC'yi cagiriyor ama DB'de tanimli degil; fallback olan read-then-write race condition iceriyor
  - [x] `increment_cache_hit_count(p_cache_key TEXT)` -- Atomic `UPDATE ai_route_cache SET hit_count = hit_count + 1, last_hit_at = now()`. Mevcut `cache.ts` satir 370 bu RPC'yi cagiriyor ama DB'de tanimli degil
  - [x] `get_cache_stats()` -- `RETURNS TABLE(total_entries BIGINT, hit_rate NUMERIC, avg_hit_count NUMERIC)`. Mevcut `cache.ts` satir 274 bu RPC'yi cagiriyor; suan JS-side full table scan fallback kullaniliyor
  - [x] `route_stops.travel_mode_from_previous` CHECK constraint'ine 'walking' ve 'public' ekle VEYA TypeScript enum'larini DB'ye uyumlu hale getir
- **Karar Notu (CRIT-04):** DB CHECK su anda `('walk', 'transit', 'drive', 'taxi', 'bike')` kullanirken TypeScript `TransportMode` tipi `('walking', 'public', 'car', 'mixed')` kullanir. Bunlar birbirinden tamamen farkli degerler. `route_stops.travel_mode_from_previous` navigasyon icin (duraklar arasi) kullanilir, `routes.transport_mode` ise genel trip tercihi icindir -- farkli semantikleri temsil ediyorlar, bu dogru. Ancak `saveRouteToDb` bu alani hic yazmadigi icin (WARN-03) sorun henuz tetiklenmemis. Cozum: TypeScript `StopData.travelModeFromPrevious` tipini DB'ye uyumlu stop-level degerler icin ayri bir union type yapmak (`'walk' | 'transit' | 'drive' | 'taxi' | 'bike'`) veya DB CHECK'i genisletmek. Tercih: DB'yi genisletmek cunku AI modellerinin urettigi degerler olusabilir.
  - [x] ALTER route_stops travel_mode_from_previous CHECK --> `('walk', 'transit', 'drive', 'taxi', 'bike', 'walking', 'public', 'car', 'mixed')` ile degistir
- **Done Kriteri:**
  - `SELECT increment_routes_generated(...)` hatasiz calisiyor
  - `SELECT increment_cache_hit_count(...)` hatasiz calisiyor
  - `SELECT * FROM get_cache_stats()` doner
  - travel_mode constraint hem eski hem yeni degerleri kabul ediyor
- **Dogrulama:** `supabase/migrations/` icinde `010_` dosyasi olusturuldu, apply edildi, `execute_sql` ile test edildi

#### 4.5.2 Edge Function Fix: Status Code + Missing Stop Fields

- **Atanan:** backend-architect
- **Audit Referansi:** CRIT-01 (HTTP 201 vs 200), WARN-03 (saveRouteToDb omits fields)
- **Bagimlilk:** 4.5.1 (travel_mode constraint duzenlenmiS olmali)
- **Dosyalar:**
  - `supabase/functions/generate-route/index.ts` -- GUNCELLE
- **Degisiklikler:**
  - [x] Satir 526-527: `status: 201` --> `status: 200` olarak degistir. Rota basariyla olusturulsa bile, API tasarimi acisindan 200 kullanmak Flutter client ile uyumlu. Alternatif olarak Flutter tarafinda 201 kabul edilebilir (4.5.3), ama her iki tarafi da fix'lemek en guvenli yaklasim
  - [x] `saveRouteToDb` fonksiyonu (satir 332-351) `stopRows` map'ine su eksik alanlari ekle:
    - `place_id: stop.placeId ?? null`
    - `latitude: stop.latitude ?? null`
    - `longitude: stop.longitude ?? null`
    - `google_rating: stop.googleRating ?? null`
    - `review_count: stop.reviewCount ?? null`
    - `review_summary: stop.reviewSummary ?? null`
    - `travel_mode_from_previous: stop.travelModeFromPrevious ?? null`
    - `entry_fee_amount: stop.entryFeeAmount ?? null`
    - `entry_fee_currency: stop.entryFeeCurrency ?? null`
- **Done Kriteri:**
  - generate-route 200 dondurur
  - route_stops satirlari tum alanlari icerir (null olanlar dahil)
  - Mevcut rotalarin yapisal butunlugu bozulmaz
- **Dogrulama:** Edge Function deploy, `curl` ile test, response status ve DB satir kontrolu

#### 4.5.3 Flutter Client Fix: _assertSuccess + Feedback UUID

- **Atanan:** mobile-developer
- **Audit Referansi:** CRIT-01 (HTTP 200/201 mismatch), CRIT-02 (empty string UUID)
- **Dosyalar:**
  - `lib/features/chat/data/chat_repository.dart` -- GUNCELLE
  - `lib/features/feedback/presentation/providers/feedback_provider.dart` -- GUNCELLE
  - `lib/features/chat/data/feedback_repository.dart` -- GUNCELLE
- **Degisiklikler -- chat_repository.dart:**
  - [x] Satir 169: `_assertSuccess` metodu `if (status == 200) return;` --> `if (status == 200 || status == 201) return;` olarak degistir. Edge Function'lar 201 Created donebilir (yeni kaynak olusturma); bunu reject etmek tum route generation akisini kiriyordu
- **Degisiklikler -- feedback_provider.dart:**
  - [x] Satir 172-173: `TripFeedbackModel(id: '', ...)` yapilmamali. Bos string `''` PostgreSQL'de gecerli bir UUID degil, `gen_random_uuid()` default'u sadece `id` kolonuna deger verilmediginde devreye girer
  - [x] Cozum: feedback_repository.dart'ta toJson()'dan `id` alanini sil (`..remove('id')`)
- **Degisiklikler -- feedback_repository.dart:**
  - [x] `submitFeedback` metodu (satir 28-36): `feedback.toJson()` yerine id alanini cikararak gonder. Yontem: `final json = feedback.toJson()..remove('id');` ile upsert'e gonder. Bu DB'nin `gen_random_uuid()` default'unu devreye sokar
- **Done Kriteri:**
  - Route generation 201 donuste hata vermez, flow tamamlanir
  - Feedback submit edildiginde UUID hatasi olusmaz
  - Mevcut feedback'ler bozulmaz (upsert on user_id,route_id calismaya devam eder)
- **Dogrulama:** Uygulama uzerinden tam akim testi: chat --> rota --> feedback

#### 4.5.4 End-to-End Dogrulama

- **Atanan:** qa-engineer
- **Bagimlilk:** 4.5.1, 4.5.2, 4.5.3 tamamlanmis
- **Islem:**
  - [x] Rota olusturma akisi: chat --> AI cevap --> generate-route --> 200 OK --> route detail gorunur
  - [x] Feedback akisi: feedback form doldur --> submit --> DB'de trip_feedback satirinda gecerli UUID
  - [x] Rate limit: 3 rota olustur --> 4. istek 429 donmeli
  - [x] Yeni kullanici akisi: kayit --> onboarding --> ilk rota --> feedback --> tumu calisiyor
- **Done Kriteri:** 4 kritik hata tamami cozulmus, regresyon yok

### Sprint 4.5 Tamamlanma Kriterleri

- [x] CRIT-01: generate-route 200 donuyor, _assertSuccess 200 ve 201 kabul ediyor
- [x] CRIT-02: Feedback upsert'te UUID hatasi yok, id alani DB tarafindan olusturuluyor
- [x] CRIT-03: 3 RPC fonksiyonu (increment_routes_generated, increment_cache_hit_count, get_cache_stats) DB'de tanimli ve calisiyor
- [x] CRIT-04: travel_mode_from_previous CHECK constraint hem DB hem TS degerlerini kabul ediyor
- [x] End-to-end akim regresyonsuz calisiyor
- [x] BONUS: build.yaml field_rename:snake eklendi — tum Freezed modelleri Supabase snake_case JSON ile uyumlu

---

## Sprint 5: Stability & Polish (3-4 Gun)

### Hedef

Audit'teki WARNING ve INFO seviye bulgulari fix'le. Guvenlik aciklarini kapat, UX bozukluklarini onar, kod kalitesini artir. Sprint sonunda uygulama beta-ready seviyesine ulasmali.

### Bagimlilk Zinciri

```
5.1 Backend fix'leri (cache, rate limit, timeout) -- PARALEL
5.2 Theme + UI fix'leri (GeezTheme, empty states)  -- PARALEL
5.3 Navigation fix'leri (dead buttons, explore)     -- PARALEL (5.2 ile)
5.4 Kod kalitesi (imports, constants, dead code)    -- PARALEL
  --> 5.5 QA validation
```

### Gorevler

#### 5.1 Backend: Cache Security + Rate Limit + Timeout

- **Atanan:** backend-architect
- **Audit Referansi:** WARN-01, WARN-02, WARN-04, WARN-05, WARN-06, WARN-07, WARN-08
- **Dosyalar:**
  - `supabase/functions/_shared/cache.ts` -- GUNCELLE
  - `supabase/functions/_shared/types.ts` -- GUNCELLE
  - `supabase/functions/generate-route/index.ts` -- GUNCELLE
  - `supabase/functions/chat/index.ts` -- GUNCELLE
  - `supabase/functions/_shared/llm-clients/gemini.ts` -- GUNCELLE (veya timeout config)
  - `supabase/migrations/011_cache_and_category_fixes.sql` -- YENI
- **Degisiklikler:**
  - [x] **WARN-01 (Cache hit returns wrong routeId):** `getCachedRoute` donusunde, cache hit oldugunda hala mevcut kullanici icin yeni bir route satiri olustur. `generate-route/index.ts`'deki cache-hit dalinda: cached route_data'yi al, mevcut user_id ile yeni `routes` + `route_stops` satirlari insert et, yeni routeId'yi response'a yaz. Bu sayede her kullanici kendi route'una sahip olur ve RLS engeli olusmaz
  - [x] **WARN-02 (Cache key omits country):** `RouteCacheKey` interface'ine `country: string` ekle. `buildCacheKey` fonksiyonunda country'yi key'e dahil et: `${city}:${country}:${travelStyle}:...`. Bu "Rome, Italy" ile "Rome, Georgia"'nin ayni cache entry'yi paylasmasini onler
  - [x] **WARN-04 (Chat rate limiting):** `chat/index.ts`'e rate limiting ekle. `checkRateLimit` yerine mesaj-bazli throttle kullan: kullanici basina dakikada max 20 mesaj (token maliyeti sinirlama icin). Basit yaklasim: `usage_tracking` tablosuna `chat_messages_today INT DEFAULT 0` ekle veya in-memory Map kullan
  - [x] **WARN-05 (get_cache_stats RPC):** Bu zaten 4.5.1'de cozuluyor (migration 010). Burada sadece dogrula
  - [x] **WARN-06 (Gemini 30s timeout):** LLM client'ta timeout'u 30s --> 90s'ye artir. 7-gunluk rotalar 45-90s surer. `AbortController` veya `fetch` timeout parametresini guncelle
  - [x] **WARN-07 (PlaceCategory 'beach' not in DB):** Migration ile `route_stops.category` ve `visited_places.category` CHECK constraint'lerine `'beach'` ekle. TypeScript'te zaten var, DB'de eksik
  - [x] **WARN-08 (Stale JSONB schema comment):** `ai_route_cache.route_data` kolonundaki COMMENT'i guncelle. Mevcut yorum yanlis/eski, `RouteResponse` interface'inin gercek yapisini yansitmali
- **Done Kriteri:**
  - Cache hit'te her kullanici kendi routeId'sini alir
  - Farkli ulkelerdeki ayni isimli sehirler ayri cache key'e sahip
  - Chat endpoint rate limit uyguluyor
  - Gemini timeout 90s
  - 'beach' kategorisi DB INSERT'te hata vermez

#### 5.2 Theme Birlesimi + Mock Data Temizligi

- **Atanan:** mobile-developer + ui-designer
- **Audit Referansi:** WARN-11 (app.dart bypasses GeezTheme), WARN-12 (mock data shown to real users), WARN-14 (quiz_screen double padding), WARN-16 (profile shimmer non-scrollable)
- **Dosyalar:**
  - `lib/app.dart` -- GUNCELLE
  - `lib/features/profile/presentation/screens/profile_screen.dart` -- GUNCELLE
  - `lib/features/onboarding/presentation/screens/quiz_screen.dart` -- GUNCELLE
  - `lib/features/passport/domain/mock_passport_data.dart` -- GUNCELLE veya KALDIR
- **Degisiklikler:**
  - [x] **WARN-11 (GeezTheme bypass):** `app.dart` satir 18-19'daki `theme: _lightTheme()` ve `darkTheme: _darkTheme()` yerine `theme: GeezTheme.lightTheme` ve `darkTheme: GeezTheme.darkTheme` kullan. `_lightTheme()` ve `_darkTheme()` private metotlarini sil. `GeezTheme` zaten `lib/core/theme/theme.dart`'ta tam ve dogru sekilde tanimli: AppBar, Card, Chip, Input, Navigation, Dialog, Snackbar temalari dahil. Mevcut inline tema bunlarin cogunlugunu icermiyor. Ayrica font: `GeezTheme` lokal `'Inter'` fontFamily kullanirken mevcut `app.dart` CDN'den `GoogleFonts.interTextTheme()` kullaniyor -- bunu birlestirmek tutarlilik saglar
  - [x] **WARN-12 (Mock data for real users):** `profile_screen.dart` satir 8'deki `MockPassportData` import'unu kaldir. tripHistory ve personaCategories icin mock fallback yerine empty state widget'lari goster. Yeni kullanici profil ekranina geldiginde "Henuz gezin yok" gibi empty state gorunmeli, sahte gezi verileri degil
  - [x] **WARN-14 (Quiz double padding):** `quiz_screen.dart` satir 132'deki `SizedBox(height: MediaQuery.of(context).padding.top + ...)` ifadesini kaldir. Bu ekran zaten bir parent widget tarafindan SafeArea ile sarildigi icin status bar padding'i iki kez uygulanarak icerik asagi kayiyor
  - [x] **WARN-16 (Shimmer non-scrollable):** Profile loading state'teki `NeverScrollableScrollPhysics()` ifadesini `ClampingScrollPhysics()` ile degistir veya kaldir. Kucuk ekranlarda shimmer placeholder'lar overflow edebilir
- **Done Kriteri:**
  - `GeezTheme.lightTheme`/`darkTheme` tum uygulama genelinde aktif
  - Yeni kullanici profil ekraninda mock data gosterilmiyor
  - Quiz ekraninda cift padding yok
  - Profile loading state scroll edilebilir

#### 5.3 Navigation: Dead Buttons + Explore Screen

- **Atanan:** mobile-developer
- **Audit Referansi:** WARN-10 (empty onTap handlers), WARN-13 (empty Explore screen), VIS-01 (desktop layout)
- **Dosyalar:**
  - `lib/features/home/presentation/screens/home_screen.dart` -- GUNCELLE
  - `lib/features/passport/presentation/screens/passport_screen.dart` -- GUNCELLE
  - `lib/features/profile/presentation/screens/profile_screen.dart` -- GUNCELLE
  - `lib/features/explore/presentation/screens/explore_screen.dart` -- GUNCELLE
- **Degisiklikler:**
  - [x] **WARN-10 (Dead buttons):** Asagidaki `onTap: () {}` handler'larini gecerli GoRouter navigation'lari ile degistir:
    - `home_screen.dart` satir 616: "Rota Olustur" (welcome banner) --> `context.go('/new-route')` veya `/chat`
    - `home_screen.dart` satir 277: ActiveRouteCard "Continue" --> `context.go('/route/${route.id}')`
    - `home_screen.dart` satir 319: SuggestionCard "Plan" --> `context.go('/chat?city=${suggestion.city}')`
    - `passport_screen.dart` satir 141: "First Route" butonu --> `context.go('/chat')`
    - `profile_screen.dart` satir 235, 660: Settings items ve "Share Persona" --> Henuz implement edilmemis olanlar icin `// TODO: Sprint N` yorum birak + kullaniciya "Yaklasimda" SnackBar goster
    - `home_screen.dart` satir 454, 462: Notification ve Settings icon butonlari --> `// TODO: Sprint 7` yorum + SnackBar
  - [x] **WARN-13 (Empty Explore screen):** Bos `Text('Explore')` yerine "Yaklasimda" placeholder ekrani olustur. GeezColors + GeezTypography kullan, bir ikon + "Kesfet ozelligi yaklasimda" mesaji + "Bildirim al" butonu (no-op). Dark mode destekli
  - [x] **VIS-01 (Desktop maxWidth):** Login formu ve ana icerik alanlari icin `maxWidth: 480` constraint ekle (sadece tablet/desktop icin). `ConstrainedBox` veya `Center` + `SizedBox` ile sar
- **Done Kriteri:**
  - Tum "dead" butonlar ya dogru sayfaya yonlendirir ya da "Yaklasimda" SnackBar gosterir
  - Explore tab'i "coming soon" ekrani gosterir
  - Desktop'ta form tam genislik kaplamaz

#### 5.4 Kod Kalitesi + Constants Birlestirme

- **Atanan:** mobile-developer
- **Audit Referansi:** INFO-01 (import inconsistency), INFO-03 (duplicated thresholds), INFO-05 (dead code), WARN-09 (explorer_tier legend threshold), WARN-15 (PassportNotifier sequential awaits)
- **Dosyalar:**
  - `lib/core/constants/gamification_constants.dart` -- YENI
  - `lib/features/home/presentation/providers/home_provider.dart` -- GUNCELLE
  - `lib/features/profile/presentation/providers/profile_provider.dart` -- GUNCELLE
  - `lib/features/profile/presentation/screens/profile_screen.dart` -- GUNCELLE
  - `lib/features/passport/presentation/providers/passport_provider.dart` -- GUNCELLE
  - `lib/features/home/domain/mock_data.dart` -- GUNCELLE (sampleSuggestions)
  - Coklu dosya: import duzeltmeleri
- **Degisiklikler:**
  - [x] **INFO-01 (Imports):** Relative import kullanan dosyalari `package:geez_ai/...` formatina gecir. Onceligle: `passport/`, `profile/`, `shared/widgets/` dosyalari. `analysis_options.yaml`'a `prefer_relative_imports: false` veya `always_use_package_imports: true` lint kuralini ekle
  - [x] **INFO-03 + WARN-09 (Duplicated discovery thresholds):** Yeni `gamification_constants.dart` dosyasinda tum tier esiklerini ve label'larini tanimla. DB comment'teki esik: `tourist(0) -> traveler(200) -> explorer(500) -> local(1000) -> legend(2500)`. Kod'daki esik: `legend` icin 2000 kullaniliyor (3 farkli dosyada). DB degerini kaynak olarak kabul et, kodu 2500'e guncelle. Bu yeni constants dosyasindan her 3 dosyanin da import etmesini sagla
  - [x] **INFO-05 (Dead code):** `lib/features/home/domain/mock_data.dart`'taki `sampleSuggestions` (veya benzer isimde unreferenced degisken) icin: eger `kSampleSuggestions` farkli bir degiskense ve `sampleSuggestions` hicbir yerde kullanilmiyorsa kaldir
  - [x] **WARN-15 (PassportNotifier sequential awaits):** `PassportNotifier` icindeki ardisik `await` cagrilarini `Future.wait([...])` veya Dart 3 record `.wait` syntax'i ile paralellestir. Ornek: stamps, visited_places, persona fetch'lerini ayni anda yap
- **Done Kriteri:**
  - Tum import'lar `package:geez_ai/` formatinda
  - Discovery score threshold'lari tek bir yerde tanimli (2500 for legend)
  - Dead code kaldirildi
  - PassportNotifier fetch'ler paralel

#### 5.5 QA Validation + Regression Test

- **Atanan:** qa-engineer
- **Bagimlilk:** 5.1, 5.2, 5.3, 5.4 tamamlanmis
- **Islem:**
  - [x] Tum WARN ve INFO fix'lerinin regresyon testi
  - [x] Dark mode: tum ekranlar (Home, Chat, Route, Passport, Profile, Explore, Login, Signup, Onboarding) dark mode'da dogru gorunuyor
  - [x] Empty state: yeni kullanici acisindan tum ekranlar test et (profil, pasaport, home -- hicbirinde mock data gorunmemeli)
  - [x] Cache testi: ayni sehir/farkli ulke --> farkli cache key (buildCacheKey country iceriyor)
  - [x] Rate limit: chat endpoint checkRateLimit calisiyor
  - [x] Navigation: tum butonlar dogru sayfaya gidiyor veya "Yaklasimda" gosteriyor (0 dead button)
  - [x] Explore ekrani "coming soon" gosteriyor
  - [x] Desktop: form genisligi 480px'i asmiyor (ConstrainedBox maxWidth: 480)
  - [x] `flutter analyze` -- 0 error, 0 warning, 3 info (pre-existing, acceptable)
- **Done Kriteri:** Sprint 5 tamamlanma kriterleri karsilandi, beta-ready

### Sprint 5 Tamamlanma Kriterleri

- [x] WARN-01: Cache hit'te her kullanici kendi route'una sahip
- [x] WARN-02: Cache key country iceriyor
- [x] WARN-03: saveRouteToDb tum alanlari yaziyor (4.5.2'de cozuldu, burada dogrulama)
- [x] WARN-04: Chat endpoint rate limited
- [x] WARN-06: Gemini timeout 90s
- [x] WARN-07: 'beach' kategorisi DB'de gecerli
- [x] WARN-09: Explorer tier thresholds DB ile uyumlu (legend = 2500)
- [x] WARN-10: Dead button sayisi = 0 (ya navigation ya "Yaklasimda")
- [x] WARN-11: GeezTheme.lightTheme/darkTheme kullaniliyor
- [x] WARN-12: Mock data yeni kullanicilara gosterilmiyor
- [x] WARN-13: Explore ekrani placeholder iceriyor
- [x] WARN-14: Quiz ekraninda cift padding yok
- [x] WARN-15: PassportNotifier paralel fetch yapiyor
- [x] WARN-16: Profile shimmer scrollable
- [x] INFO-01: Tum import'lar package formatinda
- [x] INFO-03: Threshold constants tek dosyada
- [x] INFO-05: Dead code temizlendi
- [x] flutter analyze clean (0 error, 0 warning, 4 info)

---

## Sprint 5.5: Memory Agent + user-context (2 Gun) -- TAMAMLANDI

### Ozet

Sprint 5.5'te Memory Agent ve user-context Edge Function implement edildi:
- 4-layer user context (profile, persona, visited places, feedback)
- `user-context` Edge Function deployed (v1)
- `generate-route` prompt'a UserContext entegrasyonu (personalization)
- `fetchUserContext()` shared helper (paralel DB sorguları)
- `derivePacePreference()` + `deriveStrongPreferences()` derived fields

Bu sprint, asagidaki eski Sprint 6 planindaki 6.1-6.3 gorevlerini kapsadi.

---

## Sprint 6: Audit Remediation (1 Gun) -- TAMAMLANDI

### Ozet

3 perspektifli audit (QA, Explorer, Playwright) sonucu 42 bulgu tespit edildi. Tumu duzeltildi:

**Yapilan duzeltmeler:**
- **Turkish diacritics:** 14 dosyada Turkce karakter duzeltmeleri (ş, ı, ö, ü, ç, ğ, İ)
- **Forgot password:** Login ekranina `resetPasswordForEmail` akisi eklendi
- **signOut robustness:** try/catch/finally ile her zaman unauthenticated'a gecis
- **Input validation:** chat mesaj uzunlugu (2000), preferences (max 10, 200 char)
- **Rate limit cleanup:** chat ve user-context'ten yanlis paylasimli rate limit kaldirildi
- **Timeout:** generate-route'a `timeoutMs: 45_000`, chat'e `timeoutMs: 30_000` eklendi
- **Category aliases:** normalizeCategory'ye 15+ yeni alias eklendi
- **DB trigger:** `update_explorer_tier()` — discovery_score degisince explorer_tier otomatik guncellenir
- **DB index:** `idx_trip_feedback_user_created_at` composite index
- **Dead code:** `feedbackSubmitPath` constant kaldirildi
- **Import fix:** AuthState ambiguity (`hide AuthState` on supabase_flutter import)

**Deploy edilen Edge Functions:**
- `chat` v3
- `user-context` v1
- `generate-route` v4

**Uygulanan migration:** `012_audit_fixes.sql`

### On Kosullar

- Sprint 5.5 TAMAMLANMIS ✓

### Eski Sprint 6 Gorevleri (Yeniden Dagitildi)

Asagidaki gorevler orijinal Sprint 6 planindaydi. Sprint 5.5'te 6.1-6.3 tamamlandi (Memory Agent). Kalan gorevler gelecek sprint'lere tasindi:

| Eski Gorev | Durum | Yeni Sprint |
|------------|-------|-------------|
| 6.1 DB Migration (memory_agent) | TAMAMLANDI (Sprint 5.5) | - |
| 6.2 Memory Agent Edge Function | TAMAMLANDI (Sprint 5.5, user-context olarak) | - |
| 6.3 generate-route V2 (Memory-Aware) | TAMAMLANDI (Sprint 5.5) | - |
| 6.4 Prompt Engineering V2 | BACKLOG | Sprint 7 (Deep Research) |
| 6.5 Post-trip Memory Update pipeline | BACKLOG | Sprint 7 |
| 6.6 Home onerilerini kisiye ozel yap | BACKLOG | Sprint 12 (Explore) |
| 6.7 Cache stratejisi iyilestirme | BACKLOG | Sprint 7 |
| 6.8 QA review | BACKLOG | Sprint 9 (Testing) |

<details>
<summary>Eski detayli gorev planlari (referans icin)</summary>

### Eski Gorevler

#### 6.1 DB Migration: Memory Agent Altyapisi

- **Atanan:** database-architect
- **Dosyalar:**
  - `supabase/migrations/012_memory_agent.sql` -- YENI
- **Icerik:**
  - [x] `user_memory_context` VIEW olustur: `user_profiles` + `travel_personas` + son 10 `trip_feedback` + son 50 `visited_places` birlesimi. Memory Agent bu VIEW'i tek sorguda okuyacak
  - [x] `update_user_preferences(p_user_id UUID, p_preferred_activities JSONB, p_food_preferences JSONB, p_pace_preference TEXT, p_crowd_tolerance TEXT)` RPC fonksiyonu -- Memory Agent'in feedback'ten ogrendiklerini `user_profiles` Layer 2 alanlarini guncellemesi icin. SECURITY DEFINER olmali (service_role ile calisacak)
  - [x] `update_persona_levels(p_user_id UUID, p_foodie INT, p_history INT, p_nature INT, p_adventure INT, p_culture INT, p_score_delta INT)` RPC fonksiyonu -- persona seviyelerini ve discovery_score'u atomik gunceller. explorer_tier'i score'a gore otomatik hesaplar (0-199: tourist, 200-499: traveler, 500-999: explorer, 1000-2499: local, 2500+: legend)
  - [x] `upsert_visited_places(p_user_id UUID, p_places JSONB)` RPC fonksiyonu -- JSONB array olarak gelen visited_places kayitlarini toplu upsert eder (place_id varsa ON CONFLICT guncelle, yoksa INSERT)
  - [x] `user_profiles.preferred_activities` ve `food_preferences` uzerinde GIN index ekle (JSONB sorgu performansi icin)
- **Done Kriteri:**
  - `SELECT * FROM user_memory_context WHERE user_id = $1` tek satirda tum 4 katman verisini donuyor
  - 3 RPC fonksiyonu hatasiz calisiyor
  - RLS: VIEW sadece kendi verisini doner (`auth.uid() = user_id`)
- **Dogrulama:** Migration apply, `execute_sql` ile her RPC test

#### 6.2 Memory Agent Edge Function

- **Atanan:** ai-engineer
- **Bagimlilk:** 6.1
- **Dosyalar:**
  - `supabase/functions/memory-agent/index.ts` -- YENI: ana handler
  - `supabase/functions/memory-agent/context-builder.ts` -- YENI: UserContext olusturma
  - `supabase/functions/memory-agent/prompts.ts` -- YENI: memory update prompt'lari
  - `supabase/functions/memory-agent/types.ts` -- YENI: request/response tipler
  - `supabase/functions/_shared/types.ts` -- GUNCELLE: `MemoryAgentRequest`, `MemoryAgentResponse` interface'leri ekle
- **Islem:**
  - [x] **GET /functions/v1/memory-agent?action=get_context**: `user_memory_context` VIEW'indan kullanici context'i oku, `UserContext` tipine donustur, JSON olarak don. Bu endpoint generate-route V2 tarafindan cagrilacak
  - [x] **POST /functions/v1/memory-agent?action=update_from_feedback**: `trip_feedback` verisini al, LLM ile analiz et (memory_update task type, GPT-4.1-nano), sonuclari 3 RPC fonksiyonu uzerinden DB'ye yaz:
    - `update_user_preferences`: feedback'ten cikarilan tercih guncellemeleri
    - `update_persona_levels`: ziyaret edilen yerlerin kategori dagilimina gore persona level artislari
    - `upsert_visited_places`: rota duraklarini visited_places'e ekle (favorite_stops --> rating 5, disliked_stops --> rating 2, diger --> rating 3)
  - [x] Context builder: `strongPreferences` alanini hesapla (visited_places category frekans analizi + feedback rating ortalamalari)
  - [x] Rate limiting: `checkRateLimit` ile memory_update action'i icin max 10/gun
  - [x] Error handling + CORS + JWT auth (standart shared moduller)
- **Done Kriteri:**
  - `get_context` endpoint'i 200ms altinda UserContext donuyor
  - `update_from_feedback` endpoint'i feedback'i isliyor, user_profiles + travel_personas + visited_places DB'de guncelleniyor
  - Bos kullanici icin graceful empty context (null'lar, bos array'ler)

#### 6.3 generate-route V2: Memory-Aware Rota Olusturma

- **Atanan:** ai-engineer + backend-architect
- **Bagimlilk:** 6.2
- **Dosyalar:**
  - `supabase/functions/generate-route/index.ts` -- GUNCELLE
  - `supabase/functions/generate-route/prompts.ts` -- GUNCELLE
  - `supabase/functions/_shared/types.ts` -- GUNCELLE (RouteRequest'e `userContext` opsiyonel alan ekle)
- **Degisiklikler:**
  - [x] `index.ts` adim 5.5 (cache check'ten sonra, AI generation'dan once): Memory Agent'in `get_context` endpoint'ini cagir. Context bos degilse prompt'a ekle
  - [x] `prompts.ts` -- `buildRoutePrompt` fonksiyonuna yeni `userContext?: UserContext` parametresi ekle. Context varsa prompt'a su bolumleri ekle:
    - `=== USER PROFILE ===`: yas grubu, companion, budget tercihi, sabahci/gece kusu, kalabalik toleransi
    - `=== TRAVEL HISTORY ===`: son 10 sehir + kategori dagilimlari + ortalama puanlar. "Bu kullanici daha once su sehirleri ziyaret etmis, farkli yerler oner"
    - `=== PERSONA ===`: en yuksek 3 persona kategori + seviyeleri. "Bu kullanici foodie_level=7, history_buff_level=4 -- yeme icme agirlikli rota olustur"
    - `=== PREFERENCES ===`: strongPreferences listesi, pace_preference
  - [x] Cache key'i degistirME -- kullanici bazli cache kullanmiyoruz, genel cache + Memory Agent context'i prompt'ta. Cache hit'te bile kullanici context'i uygulanmaz (bu tasarim karari: cache maliyet tasarrufu icin)
- **Done Kriteri:**
  - Yeni kullanici (bos context) icin rota olusturma degisiklik yok (backward compatible)
  - Dolmus profili olan kullanici icin prompt'ta context bloku gorunuyor (Edge Function log'larindan dogrulanir)
  - Rota kalitesi: context'li rota duraklar icin insider tip ve fun fact icerigi daha spesifik

#### 6.4 Prompt Engineering V2

- **Atanan:** ai-engineer
- **Bagimlilk:** Yok (6.1 ile paralel baslayabilir)
- **Dosyalar:**
  - `supabase/functions/generate-route/prompts.ts` -- GUNCELLE
  - `supabase/functions/chat/prompts.ts` -- GUNCELLE
- **Degisiklikler:**
  - [x] **Route generation prompt iyilestirmeleri:**
    - `insiderTip` alani icin daha spesifik talimatlar: "Give a tip that a local friend would share, not something found on the first page of Google. Include specific vendor names, order recommendations, or timing tricks"
    - `funFact` alani icin: "Share a surprising historical or cultural fact that would make the user say 'I didn't know that!'. Cite the approximate date or source when possible"
    - `reviewSummary` alani icin YENI talimat: "Synthesise the general sentiment from online reviews in 1-2 sentences. Mention common praises and complaints"
    - `warnings` alani icin: "Include dress code requirements, common scams in the area, seasonal closures, and reservation requirements"
    - Gune ozel tema tutarliligi: "Each day must have a clear thematic arc. Do not randomly mix food stops with museum visits unless the user chose 'mixed' style"
  - [x] **Chat Q&A prompt iyilestirmeleri:**
    - Daha dogal Turkce: AI cevaplarinin ceviri kokusu vermemesi icin, Turkce prompt'larda dogal konusma dili ornekleri ekle
    - Sehir oneri mekanizmasi: Kullanici "Nereye gideyim?" dediginde, AI'in 3-5 sehir onerebilmesi icin step 0 prompt'una fallback ekle
  - [x] **Output schema genisletme:** `OUTPUT_SCHEMA` sabitine su alanlari ekle:
    - `reviewSummary: "string | null -- 1-2 sentence review synthesis"`
    - `photoTip: "string | null -- Best spot/angle for photos at this location"`
- **Done Kriteri:**
  - 3 farkli sehir icin test rotasi olustur, insider tip ve fun fact kalitesini karsilastir (onceki vs sonraki)
  - Chat Q&A akisinda Turkce cevaplarin daha dogal oldugu dogrulanir
  - reviewSummary ve photoTip alanlari route response'ta doluyor

#### 6.5 Post-Trip Memory Update Pipeline

- **Atanan:** ai-engineer + backend-architect
- **Bagimlilk:** 6.2 (Memory Agent calisiyor olmali)
- **Dosyalar:**
  - `supabase/functions/generate-route/index.ts` -- GUNCELLE (opsiyonel: rota tamamlandiktan sonra trigger)
  - `supabase/functions/memory-agent/index.ts` -- Mevcut (6.2'de olusturuldu)
  - `lib/features/feedback/presentation/providers/feedback_provider.dart` -- GUNCELLE
  - `lib/features/feedback/data/feedback_repository.dart` -- GUNCELLE
- **Degisiklikler:**
  - [x] **Flutter tarafinda:** Feedback submit edildikten sonra, `feedback_repository` icinden `memory-agent?action=update_from_feedback` endpoint'ini cagir. Request body: `{ routeId, userId }`. Bu fire-and-forget -- kullanici beklemez
  - [x] **Edge Function tarafinda (6.2'de implement):** Feedback verisini + rota duraklarini oku, LLM ile analiz et:
    - `favorite_stops` UUID'lerinden kategori dagilimiini cikar --> persona level artislari hesapla
    - `pace_feedback` --> `user_profiles.pace_preference` guncelle
    - `food_rating` --> `food_preferences` JSONB guncelle
    - `overall_rating` --> discovery_score delta hesapla (5 yildiz: +50, 4: +30, 3: +15, 2: +5, 1: 0)
    - Rota'daki tum duraldari `visited_places`'e ekle
  - [x] **Discovery score hesaplama:** Her durak icin `discovery_points` topla, `overall_rating` carpani uygula (5: x1.5, 4: x1.2, 3: x1.0, 2: x0.8, 1: x0.5)
- **Done Kriteri:**
  - Feedback submit sonrasi: `user_profiles`, `travel_personas`, `visited_places` tablolarinda guncelleme gozleniyor
  - Discovery score artisi dogru hesaplaniyor
  - Persona level'lari kategori dagilimina uygun sekilde artiyor
  - explorer_tier otomatik terfi ediyor (ornegin score 200 gectiginde tourist --> traveler)

#### 6.6 Home Onerilerini Kisiye Ozel Yap (INFO-06)

- **Atanan:** mobile-developer + backend-architect
- **Bagimlilk:** 6.2 (Memory Agent context'i kullanilacak)
- **Dosyalar:**
  - `supabase/functions/suggestions/index.ts` -- YENI: kisiye ozel oneri endpoint'i
  - `supabase/functions/suggestions/prompts.ts` -- YENI: oneri prompt'lari
  - `lib/features/home/data/home_repository.dart` -- GUNCELLE: suggestions endpoint cagirma
  - `lib/features/home/presentation/providers/home_provider.dart` -- GUNCELLE: suggestions verisi ekleme
  - `lib/features/home/presentation/screens/home_screen.dart` -- GUNCELLE: kisisel oneriler gosterme
  - `lib/features/home/domain/suggestion_model.dart` -- YENI: Freezed model
  - `lib/features/home/domain/suggestion_model.freezed.dart` -- YENI (code gen)
  - `lib/features/home/domain/suggestion_model.g.dart` -- YENI (code gen)
- **Degisiklikler:**
  - [x] **Edge Function:** `GET /functions/v1/suggestions` -- Memory Agent'in `get_context` endpoint'inden kullanici context'i al, LLM'e (GPT-4.1-nano, content_enrichment yerine qa_flow task type) su prompt'u gonder: "Bu kullanicinin profilini ve gecmis gezilerini inceleyerek, henuz ziyaret etmedigi 3-5 sehir oner. Her oneri icin 1 cumle neden onerdigini acikla." Sonucu JSON olarak don
  - [x] **Yeni kullanici fallback:** Context bos ise populer sehirlerin statik listesini don (Istanbul, Roma, Barcelona, Tokyo, Paris). Sehir listesi Edge Function'da hardcode, LLM cagrilmaz
  - [x] **Flutter:** `SuggestionModel` Freezed modeli olustur: `city`, `country`, `reason`, `imageUrl` (opsiyonel) alanlari. `home_provider`'a `suggestions` alani ekle, paralel fetch ile yukle. `home_screen`'deki suggestion card'larini gercek veriye bagla
  - [x] **Cache:** Oneri sonuclarini 24 saat cache'le (kullanici bazli, `ai_route_cache` tablosunda `suggestion:userId` key'i ile). Her login'de bir kez guncellensin
- **Done Kriteri:**
  - Yeni kullanici: populer sehir onerilerini goruyor (LLM cagrilmadan)
  - Gezileri olan kullanici: kisisel oneriler goruyor (ziyaret etmedigi sehirler)
  - Oneriler Home ekraninda dogru render ediliyor
  - 24 saat icinde ayni kullanici icin LLM tekrar cagrilmiyor (cache hit)

#### 6.7 Cache Stratejisi Iyilestirme

- **Atanan:** backend-architect
- **Bagimlilk:** Yok (6.1 ile paralel)
- **Dosyalar:**
  - `supabase/functions/_shared/cache.ts` -- GUNCELLE
  - `supabase/migrations/012_memory_agent.sql` -- GUNCELLE (veya ayri migration): cache istatistik RPC iyilestirmesi
- **Degisiklikler:**
  - [x] **Partial cache hit:** Ayni sehir + stil icin mevcut cache varsa ama butce/transport farkli ise, cache'teki genel durak bilgilerini yeniden kullan, sadece butce/transport spesifik alanlari LLM'den iste. Bu "warm start" yaklasimi token kullanimini %30-50 azaltabilir. Implementasyon: cache'te sadece `city:country:travelStyle` ile eşlesen entry varsa, route_data.stops'tan place_name ve description'lari cikar, yeni prompt'ta "Bu duraklar biliniyor, sadece su parametrelere gore guncellenecek alanlari uret" talimati ver
  - [x] **Cache analytics dashboard endpoint:** `GET /functions/v1/cache-stats` -- `get_cache_stats()` RPC'sinin sonuclarini JSON olarak don. Admin panel icin (ileride). Sadece service_role ile erisilebilir
  - [x] **Cache TTL stratejisi:** Populer sehirler (hit_count > 10) icin TTL'i 14 gune uzat. Az talep goren sehirler (hit_count = 0, 3+ gun eski) icin TTL'i kisalt. `setCachedRoute` fonksiyonunu guncelle
  - [x] **Cache key normalizasyon:** Sehir isimlerinde Turkce karakter normalizasyonu ekle (`Istanbul` vs `İstanbul` vs `istanbul` hepsi ayni key'e dussun). `buildCacheKey` fonksiyonunda `.normalize('NFKD').replace(/[\u0300-\u036f]/g, '')` ekle
- **Done Kriteri:**
  - Cache hit rate: test ortaminda %40+ (5 farkli kullanicinin ayni sehir/stil icin rota olusturmasini simule et)
  - Turkce karakter normalizasyonu calisiyor (`get_cache_stats` ile dogrula)
  - Populer sehirlerde TTL uzamasi logundan gorulur

#### 6.8 QA Review + Entegrasyon Testi

- **Atanan:** qa-engineer
- **Bagimlilk:** 6.1-6.7 tamamlanmis
- **Islem:**
  - [x] **Memory Agent testi:** Yeni kullanici kaydi --> onboarding --> rota olusturma --> feedback --> Memory Agent update --> ikinci rota olusturma (context'li) akisini uctan uca test et
  - [x] **Persona level ilerleme testi:** 3 farkli feedback (foodie agirlikli, history agirlikli, karisik) submit et, persona level'larinin dogru arttigini dogrula
  - [x] **Cache hit rate testi:** Ayni parametrelerle 5 kez rota olustur, ilk haricindekilerin X-Cache: HIT header'i dondurmesini dogrula
  - [x] **Home oneriler testi:** Yeni kullanici icin statik oneriler, gezi gecmisi olan kullanici icin kisisel oneriler gorundugunu dogrula
  - [x] **Prompt V2 kalite testi:** 3 farkli sehir (Istanbul, Roma, Tokyo) icin rota olustur, insider tip ve fun fact alanlarinin daha spesifik ve yerel bilgi icerdigini dogrula (subjektif review)
  - [x] **Regresyon:** Mevcut chat + rota olusturma + feedback akislari bozulmamis olmali
  - [x] **Edge Function hata senaryolari:** Memory Agent'a gecersiz userId gonder (401), rate limit asan istek gonder (429), LLM baglanti hatasi simule et (fallback calismali)
- **Done Kriteri:** Sprint 6 tamamlanma kriterleri karsilandi

### Sprint 6 Tamamlanma Kriterleri

- [ ] Memory Agent Edge Function calisiyor (get_context + update_from_feedback)
- [ ] user_memory_context VIEW tek sorguda 4 katman verisini donuyor
- [ ] generate-route V2 kullanici context'ini prompt'a entegre ediyor
- [ ] Prompt V2: insiderTip, funFact, reviewSummary kalitesi olculebilir sekilde iyilesmis
- [ ] Post-trip feedback --> Memory Agent --> DB guncelleme pipeline'i calisiyor
- [ ] Home oneriler: yeni kullanici icin statik, mevcut kullanici icin kisisel
- [ ] Cache hit rate %40+ hedefine ulasildi (test ortaminda)
- [ ] Cache key Turkce karakter normalizasyonu calisiyor
- [ ] Tum yeni Edge Function'larda CORS, auth, rate limiting, error handling var
- [ ] QA review tamamlandi, regresyon yok

</details>

---

## Sprint 7: Deep Research + Prompt V2 (Hafta 7) -- BACKLOG

> NOT: Eski plandaki "Sprint 7: UI/UX Redesign" simdi Sprint 8'e kayddi. Bu sprint eski Sprint 6'nin kalan AI gorevlerini kapsar.

### Hedef

Tavily + Exa entegrasyonu ile Deep Research pipeline kur (review synthesis, insider tips). Prompt Engineering V2 ile rota icerik kalitesini artir. Post-trip Memory Update pipeline'ini tamamla. Cache stratejisi iyilestirme.

### On Kosullar

- Sprint 6 TAMAMLANMIS ✓
- Memory Agent (user-context) calisiyor ✓

---

## Sprint 8: UI/UX Redesign (Hafta 8) -- BACKLOG

### Hedef

Mevcut "AI tarafindan uretilmis" gorunumlu UI'yi insanin elle yaptirilmis hissi veren, modern ve cilali bir tasarima donustur. Tum ekranlarda visual overhaul, animasyonlar, ve micro-interaction'lar ekle.

### On Kosullar

- Sprint 7 TAMAMLANMIS olmali

### Bagimlilk Zinciri

```
7.1 Design system overhaul (GeezColors V2, typography, spacing, components)
  --> 7.2 Home ekrani redesign
  --> 7.3 Chat ekrani redesign
  --> 7.4 Route detail redesign
  --> 7.5 Passport + Profile redesign
7.6 Animasyon ve micro-interaction sistemi (7.1 ile paralel)
7.7 Widget test altyapisi (INFO-04) -- bagimsiz
7.8 Playwright test altyapisi (VIS-03) -- bagimsiz
  --> 7.9 QA review + gorsel dogrulama
```

### Gorevler

#### 7.1 Design System V2

- **Atanan:** ui-designer
- **Dosyalar:**
  - `lib/core/theme/colors.dart` -- GUNCELLE: GeezColors V2 (daha sofistike palet)
  - `lib/core/theme/typography.dart` -- GUNCELLE: GeezTypography V2 (daha iyi hiyerarsi)
  - `lib/core/theme/spacing.dart` -- GUNCELLE: GeezSpacing V2 (8px grid sistemi)
  - `lib/core/theme/theme.dart` -- GUNCELLE: GeezTheme V2 (component theme'lari)
  - `lib/core/theme/shadows.dart` -- YENI: GeezShadows (elevation sistemi)
  - `lib/core/theme/radius.dart` -- YENI: GeezRadius (border radius sabitleri)
  - `lib/core/theme/animations.dart` -- YENI: GeezAnimations (duration, curve sabitleri)
  - `lib/shared/widgets/geez_card.dart` -- GUNCELLE: V2 styling
  - `lib/shared/widgets/geez_button.dart` -- GUNCELLE: V2 styling (gradient, hover state)
  - `lib/shared/widgets/geez_chip.dart` -- GUNCELLE: V2 styling
- **Tasarim Prensipleri:**
  - [x] **Renk paleti:** Mevcut flat mavi (`#1A73E8`) yerine daha sicak ve ozgun bir gradient-tabanli palet. Primary: koyu lacivert --> turkuaz gradient. Secondary: sicak amber. Dark mode'da gercek siyah (`#000000`) yerine koyu gri-mavi (`#0A1628`)
  - [x] **Tipografi:** Font boyutlari arasinda daha net hiyerarsi. Basliklar bold ve buyuk (24-32sp), body normal (14-16sp), caption kucuk (12sp). Inter fontunu sakla ama letter spacing ve line height'lari ince ayarla
  - [x] **Spacing:** 4px base grid. Tum bosluklar 4'un katlari (4, 8, 12, 16, 20, 24, 32, 48, 64). Mevcut rastgele padding'leri standartlastir
  - [x] **Card tasarimi:** Flat card'lardan subtle shadow + border radius (16px) + ince border'a gec. Dark mode'da border opak beyaz (0.08 opacity)
  - [x] **Buton tasarimi:** Primary buton gradient background + shadow. Secondary buton outline. Tum butonlarda press state (scale 0.98 + opacity 0.8)
- **Done Kriteri:**
  - `GeezColors`, `GeezTypography`, `GeezSpacing` V2 versiyonlari tanimli
  - `GeezShadows`, `GeezRadius`, `GeezAnimations` yeni dosyalar olusturuldu
  - Theme sabitleri tum widget'larda kullanilabilir durumda
  - Dark mode'da tum yeni renkler test edildi (kontrast orani WCAG AA uyumlu)

#### 7.2 Home Ekrani Redesign

- **Atanan:** mobile-developer + ui-designer
- **Bagimlilk:** 7.1
- **Dosyalar:**
  - `lib/features/home/presentation/screens/home_screen.dart` -- GUNCELLE: tamamen yeniden tasarla
  - `lib/features/home/presentation/widgets/active_route_card.dart` -- GUNCELLE: V2 card tasarimi
  - `lib/features/home/presentation/widgets/suggestion_card.dart` -- GUNCELLE: V2 (gorsel oncelikli, resim arka plan)
  - `lib/features/home/presentation/widgets/discovery_bar.dart` -- GUNCELLE: V2 (animasyonlu progress)
  - `lib/features/home/presentation/widgets/greeting_header.dart` -- YENI: kisisel karsilama widget'i
  - `lib/features/home/presentation/widgets/quick_actions.dart` -- YENI: hizli islem butonlari
- **Degisiklikler:**
  - [x] **Header:** Gradient arka plan (primary --> transparent), "Merhaba, {isim}" buyuk baslik, tarih + hava durumu ikonu (ileride gercek veri, simdilik tarih)
  - [x] **Active route card:** Eger aktif rota varsa, buyuk hero card (resim arka plan + gradient overlay + rota baslik + progress). Yoksa "Yeni rota olustur" CTA
  - [x] **Discovery score bar:** Animasyonlu progress bar (tier gecisinde confetti efekti), mevcut skor + sonraki tier bilgisi
  - [x] **Oneri section:** Horizontal scroll, her card yuksek gorsel kalite (sehir resmi arka plan + gradient overlay + sehir ismi + 1 cumle neden)
  - [x] **Gecmis rotalar:** Kompakt liste gorunumu (tarih + sehir + rating yildizlari)
  - [x] **Yeni kullanici:** Bos state ekrani tamamen yeniden tasarla -- ilham verici gorsel + "Ilk rotani olustur" CTA + 3 adimlik aciklama
- **Done Kriteri:**
  - Home ekrani modern, cilali ve "insan eli degmis" gorunuyor
  - Yeni kullanici icin ilham verici bos state
  - Dark mode tam uyumlu
  - Scroll performansi akici (60fps, jank yok)

#### 7.3 Chat Ekrani Redesign

- **Atanan:** mobile-developer + ui-designer
- **Bagimlilk:** 7.1
- **Dosyalar:**
  - `lib/features/chat/presentation/screens/chat_screen.dart` -- GUNCELLE
  - `lib/features/chat/presentation/widgets/chat_bubble.dart` -- GUNCELLE: V2 bubble tasarimi
  - `lib/features/chat/presentation/widgets/question_chips.dart` -- GUNCELLE: V2 chip tasarimi
  - `lib/features/chat/presentation/widgets/typing_indicator.dart` -- YENI: AI yazma animasyonu
  - `lib/features/chat/presentation/widgets/chat_input.dart` -- YENI: modern input bar
- **Degisiklikler:**
  - [x] **Bubble tasarimi:** Kullanici mesajlari: sag hizali, gradient arka plan (primary renkleri), yuvarlatilmis koseler. AI mesajlari: sol hizali, acik gri/koyu gri arka plan, Geez AI avatari
  - [x] **Typing indicator:** AI dusunurken 3 nokta animasyonu (bounce effect)
  - [x] **Suggestion chips:** Pill seklinde, outline border, secildiginde dolgu animasyonu
  - [x] **Input bar:** Modern metin girisi, "Gonder" butonuyla (ikon), asagida sabit pozisyon, keyboard uyumlu
  - [x] **Adim gostergesi:** Ekranin ustunde step indicator (5 adimlik ince progress bar)
- **Done Kriteri:**
  - Chat ekrani WhatsApp/Telegram kalitesinde gorunuyor
  - Typing indicator akici animasyonla calisiyor
  - Chip secimi animasyonlu
  - Dark mode tam uyumlu

#### 7.4 Route Detail Redesign

- **Atanan:** mobile-developer + ui-designer
- **Bagimlilk:** 7.1
- **Dosyalar:**
  - `lib/features/route/presentation/screens/route_detail_screen.dart` -- GUNCELLE
  - `lib/features/route/presentation/widgets/stop_card.dart` -- GUNCELLE: V2 tasarim
  - `lib/features/route/presentation/widgets/day_header.dart` -- YENI: gun baslik widget'i
  - `lib/features/route/presentation/widgets/route_hero.dart` -- YENI: rota hero section
  - `lib/features/route/presentation/widgets/stop_timeline.dart` -- YENI: timeline gorunumu
- **Degisiklikler:**
  - [x] **Hero section:** Sehir gorseli (ileride gercek, simdilik gradient placeholder) + rota basligi + gun sayisi + stil badge'leri
  - [x] **Gun secici:** Horizontal tab bar (Day 1, Day 2, ...) ile gun degistirme
  - [x] **Timeline gorunumu:** Sol tarafta dikey cizgi + daire noktalar (durak siralamasi), sag tarafta stop card'lari. Duraklar arasi yurume/tasima suresi gosterimi
  - [x] **Stop card V2:** Kategori renk kodu (sol kenar), durak ismi bold, aciklama 2 satir (expand edilebilir), insider tip ikon ile isaretli, fun fact ikon ile isaretli, sure + ucret bilgisi kompakt
  - [x] **Expand/collapse:** Stop card'a dokunuldiginda insider tip, fun fact, warnings, review summary gibi detaylar animasyonlu acilir
- **Done Kriteri:**
  - Route detail ekrani gorsel olarak TripAdvisor/Google Maps kalitesinde
  - Timeline gorunumu anlasilir ve akici
  - Stop card expand/collapse animasyonu dogal
  - Dark mode tam uyumlu

#### 7.5 Passport + Profile Redesign

- **Atanan:** mobile-developer + ui-designer
- **Bagimlilk:** 7.1
- **Dosyalar:**
  - `lib/features/passport/presentation/screens/passport_screen.dart` -- GUNCELLE
  - `lib/features/passport/presentation/widgets/stamp_card.dart` -- GUNCELLE: V2
  - `lib/features/passport/presentation/widgets/collection_card.dart` -- GUNCELLE: V2
  - `lib/features/passport/presentation/widgets/stats_row.dart` -- GUNCELLE: V2
  - `lib/features/passport/presentation/widgets/passport_header.dart` -- YENI: animasyonlu header
  - `lib/features/profile/presentation/screens/profile_screen.dart` -- GUNCELLE
  - `lib/features/profile/presentation/widgets/persona_bar.dart` -- GUNCELLE: V2 (radar chart)
  - `lib/features/profile/presentation/widgets/settings_section.dart` -- YENI: ayarlar bolumu
- **Degisiklikler:**
  - [x] **Passport:** Gercek pasaport hissi -- ust tarafta "dijital pasaport" header'i (lacivert arka plan, altin detaylar), stamp'lar grid gorunumunde (3 sutun), her stamp ulke bayragi + sehir ismi + tarih
  - [x] **Passport stats:** Toplam sehir, ulke, gidilen mesafe (ileride), discovery score -- animasyonlu sayaclar
  - [x] **Profile:** Ust tarafta buyuk avatar + isim + tier badge. Persona radar chart (5 eksenli: foodie, history, nature, adventure, culture). Ayarlar listesi (dil, bildirimler, hesap, hakkinda)
  - [x] **Persona bar:** Basit linear bar yerine, kucuk radar/spider chart widget'i. 5 kategori icin gorsellestirme
- **Done Kriteri:**
  - Passport ekrani "dijital pasaport" hissi veriyor
  - Profile ekrani temiz ve organize
  - Persona radar chart 5 eksende dogru render ediyor
  - Dark mode tam uyumlu

#### 7.6 Animasyon ve Micro-Interaction Sistemi

- **Atanan:** ui-designer + mobile-developer
- **Bagimlilk:** 7.1
- **Dosyalar:**
  - `lib/core/theme/animations.dart` -- GUNCELLE (7.1'de olusturuldu)
  - `lib/shared/widgets/animated_counter.dart` -- YENI: sayac animasyonu widget'i
  - `lib/shared/widgets/fade_slide_transition.dart` -- YENI: sayfa gecis animasyonu
  - `lib/shared/widgets/shimmer_loading.dart` -- YENI: genel shimmer placeholder
  - `lib/shared/widgets/confetti_overlay.dart` -- GUNCELLE: daha iyi efekt
- **Degisiklikler:**
  - [x] **Sayfa gecisleri:** GoRouter'a custom page transition ekle -- FadeSlideTransition (asagidan yukari slide + fade in, 300ms, easeOutCubic)
  - [x] **Liste animasyonlari:** Route stop'lari, passport stamp'lari, home oneriler icin staggered list animasyonu (her item 50ms arayla gorünur)
  - [x] **Sayi animasyonlari:** Discovery score, trip sayisi gibi sayilarda animated counter (rakami yukaridan asagiya yuklerken gosterir)
  - [x] **Pull-to-refresh:** Home ve Passport ekranlarinda RefreshIndicator ile refresh animasyonu
  - [x] **Skeleton loading:** Tum async ekranlar icin shimmer placeholder (mevcut shimmer'lari standartlastir)
- **Done Kriteri:**
  - Sayfa gecisleri akici (jank yok, 60fps)
  - Liste animasyonlari dogal gorunuyor
  - Shimmer loading tum async ekranlarda tutarli
  - Animasyon suresi ve curve'leri GeezAnimations sabitlerinden okunuyor

#### 7.7 Widget Test Altyapisi (INFO-04)

- **Atanan:** qa-engineer
- **Bagimlilk:** Yok (bagimsiz, diger gorevlerle paralel)
- **Dosyalar:**
  - `test/core/theme/colors_test.dart` -- YENI
  - `test/features/auth/presentation/widgets/auth_text_field_test.dart` -- YENI
  - `test/features/home/presentation/providers/home_provider_test.dart` -- YENI
  - `test/features/chat/presentation/providers/chat_provider_test.dart` -- YENI
  - `test/features/passport/presentation/providers/passport_provider_test.dart` -- YENI
  - `test/shared/widgets/geez_button_test.dart` -- YENI
  - `test/shared/widgets/geez_card_test.dart` -- YENI
  - `test/helpers/test_utils.dart` -- YENI: ProviderScope wrapper, mock supabase client
  - `test/helpers/mock_providers.dart` -- YENI: mock Riverpod provider'lar
- **Islem:**
  - [x] Test helper altyapisi olustur: mock SupabaseClient, mock AuthState, ProviderScope test wrapper
  - [x] GeezColors sabitleri icin unit test (renk degerlerinin dogru oldugunu dogrula)
  - [x] Shared widget'lar icin widget test (GeezButton, GeezCard -- render, onTap callback, disabled state)
  - [x] Provider'lar icin unit test (HomeNotifier, ChatProvider, PassportNotifier -- mock repository ile state gecisleri)
  - [x] Minimum 20 test dosyasi, toplam 50+ test case hedefi
- **Done Kriteri:**
  - `flutter test` basarili (0 failure)
  - Provider unit test'leri loading --> data ve loading --> error gecislerini kapsliyor
  - Widget test'leri render + interaction'i kapsliyor
  - Test coverage: core/ %80+, shared/widgets/ %70+, provider'lar %60+

#### 7.8 Playwright Test Altyapisi (VIS-03)

- **Atanan:** qa-engineer
- **Bagimlilk:** Yok (bagimsiz)
- **Dosyalar:**
  - `test/e2e/playwright.config.ts` -- YENI
  - `test/e2e/auth.setup.ts` -- YENI: test kullanicisi login (Supabase test credentials)
  - `test/e2e/onboarding.spec.ts` -- YENI
  - `test/e2e/chat-flow.spec.ts` -- YENI
  - `test/e2e/home.spec.ts` -- YENI
  - `test/e2e/package.json` -- YENI: playwright dependency
- **Islem:**
  - [x] Playwright + Flutter web driver kurulumu (flutter build web --> Playwright ile test)
  - [x] Auth setup: Supabase test kullanicisi ile login, session token'i kaydet
  - [x] Onboarding flow testi: splash --> welcome --> quiz --> persona reveal --> home (screenshot capture)
  - [x] Chat flow testi: home --> chat --> 5 adimlik Q&A --> rota olusturma tetikleme
  - [x] Home ekrani testi: login --> home render --> suggestion card'lar gorunur --> discovery bar gorunur
  - [x] Her test icin screenshot capture (gorsel regresyon icin baseline)
- **Done Kriteri:**
  - `npx playwright test` basarili
  - Auth-guarded sayfalar test edilebiliyor (session token ile)
  - 3 temel akim (onboarding, chat, home) otomatik test ediliyor
  - Baseline screenshot'lar `test/e2e/screenshots/` klasorunde

#### 7.9 QA Review + Gorsel Dogrulama

- **Atanan:** qa-engineer
- **Bagimlilk:** 7.1-7.8 tamamlanmis
- **Islem:**
  - [x] Tum ekranlar light + dark mode'da screenshot al, gorsel karsilastirma yap
  - [x] Accessibility: tum interactive element'lerde `Semantics` label kontrolu, minimum dokunma alani 48x48
  - [x] Responsive: 360px (kucuk telefon), 390px (iPhone 14), 428px (iPhone 14 Pro Max), 768px (tablet) genisliklerinde layout kontrolu
  - [x] Animasyon performansi: DevTools Performance tab ile 60fps kontrolu (Home scroll, chat mesajlari, route detail scroll)
  - [x] Design system tutarliligi: tum ekranlarda GeezColors V2, GeezSpacing V2, GeezRadius kullanildigini dogrula (hardcode renk/spacing kalmamis olmali)
  - [x] Regresyon: Sprint 5.5-7'deki Memory Agent + cache + feedback akislari bozulmamis olmali
- **Done Kriteri:** Sprint 7 tamamlanma kriterleri karsilandi

### Sprint 8 Tamamlanma Kriterleri

- [ ] Design system V2 (renkler, tipografi, spacing, shadow, radius, animasyon) tanimli ve tutarli
- [ ] Home, Chat, Route Detail, Passport, Profile ekranlari gorsel olarak yeniden tasarlandi
- [ ] Dark mode tum ekranlarda tam uyumlu (WCAG AA kontrast)
- [ ] Animasyonlar: sayfa gecisi, liste stagger, sayi counter, shimmer loading calisiyor
- [ ] Timeline gorunumu route detail'da calisiyor
- [ ] Persona radar chart profile'da calisiyor
- [ ] Widget test: 50+ test case, `flutter test` basarili
- [ ] Playwright test: 3 temel akim otomatik test ediliyor
- [ ] Gorsel regresyon baseline'lari kaydedildi
- [ ] Performans: tum ekranlarda 60fps scroll (jank yok)
- [ ] Hardcode renk/spacing kullanan dosya sayisi = 0

---

## Sprint 9: Testing + Security Hardening (Hafta 9) -- BACKLOG

### Hedef

Entegrasyon testlerini yaz, guvenlik auditini tamamla (RLS, input validation, OWASP Mobile Top 10), hata yonetimini guclendirm, rate limiting'i rafine et. Sprint sonunda uygulama guvenlik acisindan production-ready olmali.

### On Kosullar

- Sprint 8 TAMAMLANMIS olmali
- Widget + Playwright test altyapisi calisiyor olmali

### Bagimlilk Zinciri

```
8.1 Entegrasyon testleri (auth, route gen, feedback, memory) -- PARALEL
8.2 RLS guvenlik auditi (her tablo icin penetration test)   -- PARALEL
8.3 Input validation hardening (Flutter + Edge Functions)   -- PARALEL
8.4 Rate limiting refinement                                -- PARALEL
  --> 8.5 Error handling ve crash reporting altyapisi
    --> 8.6 QA review + security sign-off
```

### Gorevler

#### 8.1 Entegrasyon Testleri

- **Atanan:** qa-engineer + mobile-developer
- **Dosyalar:**
  - `test/integration/auth_flow_test.dart` -- GUNCELLE (Sprint 4'te olusturuldu, genislet)
  - `test/integration/route_generation_test.dart` -- GUNCELLE (genislet)
  - `test/integration/feedback_flow_test.dart` -- GUNCELLE (genislet)
  - `test/integration/memory_agent_test.dart` -- YENI
  - `test/integration/cache_flow_test.dart` -- YENI
  - `test/integration/onboarding_flow_test.dart` -- YENI
  - `test/helpers/supabase_test_client.dart` -- YENI: test ortami icin Supabase client
- **Islem:**
  - [x] **Auth flow:** Kayit --> email dogrulama --> login --> token refresh --> logout --> re-login
  - [x] **Route generation:** Chat Q&A (5 adim) --> parameter extraction --> generate-route call --> DB'de route + stops dogrulama --> cache'te entry dogrulama
  - [x] **Feedback flow:** Rota tamamla --> feedback submit --> Memory Agent trigger --> user_profiles + travel_personas + visited_places guncelleme dogrulamasi
  - [x] **Memory Agent:** Bos kullanici context --> feedback sonrasi context --> ikinci rota'da context prompt'ta gorunuyor
  - [x] **Cache flow:** Ilk istek MISS --> ayni parametrelerle ikinci istek HIT --> TTL sonrasi istek MISS
  - [x] **Onboarding:** Splash --> welcome --> quiz (4 soru) --> persona reveal --> DB'de user_profiles guncelleme dogrulama
  - [x] **Negatif senaryolar:** Gecersiz JWT ile istek (401), bos body ile istek (400), rate limit asimi (429), olmayan route ID ile istek (404 veya 403)
- **Done Kriteri:**
  - Tum entegrasyon testleri basarili (mock backend yerine Supabase local veya test project ile)
  - Negatif senaryolar dogru hata kodlarini donduruyor
  - Test coverage: Edge Function handler'lari %80+

#### 8.2 RLS Guvenlik Auditi

- **Atanan:** database-architect + qa-engineer
- **Dosyalar:**
  - `supabase/migrations/013_rls_hardening.sql` -- YENI (gerekirse)
  - `test/security/rls_audit_test.sql` -- YENI: SQL bazli RLS test senaryolari
- **Islem:**
  - [x] **Cross-user data access testi:** User A'nin JWT'si ile User B'nin routes, user_profiles, trip_feedback, passport_stamps, visited_places tablolarindan veri okuma denemesi. Hepsinde 0 satir donmeli
  - [x] **Privilege escalation testi:** Normal kullanici JWT'si ile subscriptions tablosuna INSERT/UPDATE denemesi (basarisiz olmali). usage_tracking tablosuna UPDATE denemesi (basarisiz olmali)
  - [x] **Service role isolation:** service_role key'inin sadece Edge Function'larda kullanildigini dogrula (Flutter kodunda service_role key OLMAMALI)
  - [x] **ai_route_cache testi:** Expired cache entry'leri authenticated kullanicilara gorunmemeli (expires_at > now() kontrolu)
  - [x] **Soft delete testi:** Kullanici `routes` tablosunda DELETE (hard delete) yapamamali, sadece status UPDATE edebilmeli
  - [x] **route_stops cross-owner testi:** User A'nin route'undaki stop'lara User B erismemeli (subquery RLS)
- **Done Kriteri:**
  - 0 RLS bypass tespit edildi
  - Her tablo icin en az 3 guvenlik testi yazildi ve basarili
  - Service role key Flutter kodunda kullanilmiyor (grep ile dogrulama)

#### 8.3 Input Validation Hardening

- **Atanan:** backend-architect + mobile-developer
- **Dosyalar:**
  - `supabase/functions/generate-route/validator.ts` -- GUNCELLE: daha katki validasyon
  - `supabase/functions/chat/index.ts` -- GUNCELLE: message content sanitization
  - `supabase/functions/memory-agent/index.ts` -- GUNCELLE: input validation
  - `supabase/functions/_shared/sanitize.ts` -- YENI: input sanitization helper'lari
  - `lib/features/auth/presentation/screens/login_screen.dart` -- GUNCELLE: client-side validation
  - `lib/features/auth/presentation/screens/signup_screen.dart` -- GUNCELLE: client-side validation
  - `lib/features/feedback/presentation/screens/feedback_screen.dart` -- GUNCELLE: input validation
- **Degisiklikler:**
  - [x] **Edge Function input sanitization:**
    - Tum string input'lardan HTML/script tag'larini strip et (`<script>`, `<img onerror>`, vb.)
    - City/country isimlerini max 100 karakter ile sinirla
    - Chat message content'ini max 2000 karakter ile sinirla
    - RouteRequest.preferences array'ini max 10 item, her item max 200 karakter ile sinirla
    - JSON body boyutunu max 50KB ile sinirla
  - [x] **Flutter client-side validation:**
    - Email format kontrolu (regex)
    - Sifre minimum gereksinimleri (8 karakter, 1 buyuk harf, 1 rakam)
    - Feedback free_text alani max 1000 karakter
    - Tum TextFormField'larda maxLength property
  - [x] **SQL injection korunmasi:** Tum Edge Function'larda parameterized query kullanildigini dogrula (Supabase client zaten bunu yapiyor ama RPC cagrilarinda kontrol et)
- **Done Kriteri:**
  - XSS payload iceren city ismiyle rota olusturma denemesi sanitize ediliyor
  - Asiri uzun input'lar reddediliyor (400 Bad Request)
  - Client-side validation kullaniciya anlik geri bildirim veriyor
  - SQL injection payload'i hicbir endpoint'te calismaz

#### 8.4 Rate Limiting Refinement

- **Atanan:** backend-architect
- **Dosyalar:**
  - `supabase/functions/_shared/rate-limit.ts` -- GUNCELLE
  - `supabase/migrations/013_rls_hardening.sql` -- GUNCELLE (gerekirse): usage_tracking'e chat_messages_count kolonu ekle
- **Degisiklikler:**
  - [x] **Ayri chat ve route limitleri:** `usage_tracking` tablosuna `chat_messages_count INT DEFAULT 0` kolonu ekle. Chat ve route generation'i ayri sayaclarla takip et. Mevcut `routes_generated` + yeni `chat_messages_count`
  - [x] **Premium tier limitleri:** Free: 3 rota/ay + 100 chat mesaji/ay. Premium: 50 rota/ay + 2000 chat mesaji/ay (sinirsiz yerine yuksek limit -- maliyet kontrolu)
  - [x] **Burst korumasi:** Ayni kullanicidan 1 saniye icinde birden fazla generate-route istegi gelirse, ikincisini 429 ile reddet (in-memory rate limiter, token bucket)
  - [x] **Rate limit response header'lari:** `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` header'larini tum response'lara ekle (RFC 6585 uyumlu)
  - [x] **Flutter tarafinda:** Rate limit hatalarinda kullaniciya anlasilir mesaj goster: "Bu ay {limit} rota limitine ulastiniz. Premium'a gececek misiniz?" dialog'u
- **Done Kriteri:**
  - Chat ve route limitleri ayri takip ediliyor
  - Burst korumasi calisiyor (1s icinde 2. istek 429)
  - Rate limit header'lari tum response'larda mevcut
  - Flutter'da rate limit hatasi UX dostu sekilde gosteriliyor

#### 8.5 Error Handling ve Crash Reporting Altyapisi

- **Atanan:** mobile-developer + backend-architect
- **Dosyalar:**
  - `lib/core/error/app_exceptions.dart` -- YENI: typed exception hierarchy
  - `lib/core/error/error_handler.dart` -- YENI: global error handler
  - `lib/core/error/error_messages.dart` -- YENI: kullanici dostu hata mesajlari (TR/EN)
  - `lib/shared/widgets/error_widget.dart` -- YENI: yeniden kullanilabilir hata widget'i
  - `lib/shared/widgets/retry_widget.dart` -- YENI: "Tekrar dene" butonu ile hata widget'i
  - `lib/main.dart` -- GUNCELLE: FlutterError.onError + PlatformDispatcher.onError
  - `supabase/functions/_shared/error-handler.ts` -- GUNCELLE: daha detayli error logging
- **Degisiklikler:**
  - [x] **Exception hierarchy:** `AppException` base class, alt siniflar: `NetworkException`, `AuthException`, `RateLimitException`, `AIException`, `ValidationException`. Her exception `userMessage` (kullaniciya gosterilecek) ve `technicalMessage` (loglara yazilacak) icerir
  - [x] **Global error handler:** `FlutterError.onError` ve `PlatformDispatcher.instance.onError` ile yakalanamayan hatalari kaydet. Simdilik console'a yaz, Sprint 10'da Sentry'ye gonder
  - [x] **Error widget:** Hata mesaji + tekrar dene butonu + opsiyonel detay (debug modda). Tum provider `AsyncValue.error` durumlarinda kullan
  - [x] **Edge Function error enrichment:** Her hata loguna `userId`, `action`, `timestamp`, `requestId` ekle. `X-Request-Id` header'i olustur ve response'a yaz (debugging icin)
  - [x] **Retry logic:** Network ve AI hatalarinda otomatik 1 kez retry (exponential backoff: 1s --> 2s). 2. basarisizlikta kullaniciya goster
- **Done Kriteri:**
  - Tum provider'larda error state dogru handle ediliyor (crash yok)
  - Error widget tutarli ve kullanici dostu
  - Edge Function log'lari structured ve filtrelenebilir
  - Network hatalarinda otomatik retry calisiyor

#### 8.6 QA Review + Security Sign-off

- **Atanan:** qa-engineer
- **Bagimlilk:** 8.1-8.5 tamamlanmis
- **Islem:**
  - [x] Tum entegrasyon testlerini calistir (0 failure)
  - [x] RLS audit testlerini calistir (0 bypass)
  - [x] OWASP Mobile Top 10 kontrol listesi:
    - M1 (Improper Platform Usage): API key'ler .env'de, kodda yok
    - M2 (Insecure Data Storage): hassas veri SharedPreferences'ta plain text depolanmiyor
    - M3 (Insecure Communication): tum trafik HTTPS (Supabase varsayilan)
    - M4 (Insecure Authentication): JWT expiry, refresh token mantigi calisiyor
    - M5 (Insufficient Cryptography): parolalar Supabase Auth ile hash'leniyor
    - M6 (Insecure Authorization): RLS tum tablolarda aktif, cross-user erisim yok
    - M7 (Client Code Quality): flutter analyze 0 error, 0 warning
    - M8 (Code Tampering): release build'de debug modu kapali olmali
    - M9 (Reverse Engineering): API key'ler .env'de, obfuscation ileride
    - M10 (Extraneous Functionality): debug endpoint yok, console.log'lar production build'de devre disi
  - [x] Penetration test raporu hazirlama (bulgu + oneri + oncelik)
  - [x] `flutter analyze` -- 0 error, 0 warning
- **Done Kriteri:** Sprint 8 tamamlanma kriterleri karsilandi, security sign-off verildi

### Sprint 9 Tamamlanma Kriterleri

- [ ] Entegrasyon testleri: 7+ test dosyasi, tumu basarili
- [ ] RLS auditi: 0 bypass, her tablo icin 3+ guvenlik testi
- [ ] Input validation: XSS, SQL injection, oversize input korunmasi aktif
- [ ] Rate limiting: chat ve route ayri, burst korumasi, header'lar RFC uyumlu
- [ ] Error handling: typed exception hierarchy, global handler, retry logic
- [ ] Error widget: tum async ekranlarda tutarli hata gosterimi
- [ ] OWASP Mobile Top 10: tum maddeler kontrol edildi, kritik bulgu yok
- [ ] `flutter analyze` clean (0 error, 0 warning)
- [ ] Security sign-off verildi

---

## Sprint 10: Localization + Performance (Hafta 10) -- BACKLOG

### Hedef

Hardcode Turkce string'leri .arb localization dosyalarina tasi (INFO-02), Ingilizce destek ekle, uygulamanin cold start suresini <1s hedefine dusur, gorsel/asset optimizasyonu yap, temel offline destek ekle.

### On Kosullar

- Sprint 9 TAMAMLANMIS olmali
- Security sign-off verilmis olmali

### Bagimlilk Zinciri

```
9.1 .arb dosyalari + flutter_localizations altyapisi
  --> 9.2 Tum ekranlardaki Turkce string'leri .arb key'lere tasi
  --> 9.3 Ingilizce ceviri (.arb)
9.4 Cold start optimizasyonu -- PARALEL (9.1 ile)
9.5 Gorsel/asset optimizasyonu -- PARALEL
9.6 Temel offline destek -- PARALEL
  --> 9.7 QA review + performans olcumu
```

### Gorevler

#### 9.1 Localization Altyapisi

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/l10n/app_tr.arb` -- YENI: Turkce string'ler
  - `lib/l10n/app_en.arb` -- YENI: Ingilizce string'ler
  - `l10n.yaml` -- YENI: flutter_localizations konfigurasyonu
  - `pubspec.yaml` -- GUNCELLE: flutter_localizations dependency ekle, generate: true
  - `lib/app.dart` -- GUNCELLE: localizationsDelegates + supportedLocales ekle
  - `lib/core/providers/locale_provider.dart` -- YENI: dil secimi provider'i
- **Islem:**
  - [x] `flutter_localizations` ve `intl` paketlerini ekle
  - [x] `l10n.yaml` konfigurasyonu: `arb-dir: lib/l10n`, `template-arb-file: app_tr.arb`, `output-localization-file: app_localizations.dart`
  - [x] `app.dart`'a `localizationsDelegates` ve `supportedLocales` ekle
  - [x] `locale_provider`: kullanicinin DB'deki `language` alanini oku, cihaz dilini fallback olarak kullan, dil degisikligini hem DB'ye hem provider'a yaz
  - [x] Temel .arb yapisi: `app_tr.arb`'de en az 200 string key tanimla (tum ekranlardan toplanan metinler)
- **Done Kriteri:**
  - `flutter gen-l10n` basarili, `AppLocalizations` sinifi olusturuldu
  - `AppLocalizations.of(context)!.greeting` seklinde erisilebilir
  - Turkce ve Ingilizce locale'ler tanimli
  - Dil degisikligi uygulamayi yeniden baslatmadan etkili oluyor

#### 9.2 Hardcode String'leri .arb Key'lere Tasima

- **Atanan:** mobile-developer
- **Dosyalar:** Tum `lib/features/*/presentation/screens/*.dart` ve `lib/features/*/presentation/widgets/*.dart` dosyalari. Tahmini 40+ dosya etkilenecek
- **Islem:**
  - [x] Her ekrandaki hardcode Turkce string'leri tespit et (ornek: "Merhaba", "Rota Olustur", "Devam Et", "Henuz gezin yok", "Yaklasimda")
  - [x] Her string icin `app_tr.arb`'ye key ekle: `"greeting": "Merhaba, {name}"`, `"createRoute": "Rota Olustur"`, vb.
  - [x] Ekranlarda `Text('Merhaba')` --> `Text(AppLocalizations.of(context)!.greeting)` formatina gecir
  - [x] Placeholder destegi: `{name}`, `{count}`, `{city}` gibi dinamik degerler icin .arb placeholder syntax'i kullan
  - [x] Pluralizasyon: "1 rota" vs "3 rota" gibi durumlarda ICU plural syntax kullan
  - [x] Edge Function'lardaki kullaniciya gorunur mesajlari (chat yanıtları haric -- onlar zaten dil parametresi aliyor) kontrol et
- **Done Kriteri:**
  - `lib/` icinde hardcode Turkce string kalmamis (`grep` ile dogrulama -- `'TODO:'` ve test dosyalari haric)
  - 200+ string key `app_tr.arb`'de tanimli
  - Placeholder ve plural syntax dogru calisiyor

#### 9.3 Ingilizce Ceviri

- **Atanan:** mobile-developer (veya Kaze manual)
- **Bagimlilk:** 9.2
- **Dosyalar:**
  - `lib/l10n/app_en.arb` -- GUNCELLE: tum key'lerin Ingilizce karsiliklari
- **Islem:**
  - [x] `app_tr.arb`'deki tum key'lerin Ingilizce karsiligini yaz
  - [x] Placeholder ve plural syntax'in Ingilizce icin de dogru calistigini dogrula
  - [x] Dil secimi: Profile ayarlarindan dil degistirme testi (TR --> EN --> TR)
- **Done Kriteri:**
  - Uygulama tamamen Ingilizce modda calisiyor
  - Hicbir ekranda Turkce metin kalmiyor (EN modda)
  - Dil gecisi aninda etkili

#### 9.4 Cold Start Optimizasyonu

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/main.dart` -- GUNCELLE: lazy initialization
  - `lib/core/router/app_router.dart` -- GUNCELLE: deferred loading
  - `lib/app.dart` -- GUNCELLE: splash-->home gecis optimizasyonu
  - `pubspec.yaml` -- GUNCELLE (gerekirse): tree-shaking ayarlari
- **Degisiklikler:**
  - [x] **Supabase initialize:** `main()` icindeki `Supabase.initialize()` cagrisinin sure olcumu. Eger >500ms ise, splash ekraninda paralel olarak baslatmayi dene (FutureBuilder ile)
  - [x] **Deferred import:** Buyuk ekranlari (route_detail, passport, profile) deferred import ile yukle: `import 'package:geez_ai/features/route/...' deferred as route_detail;`
  - [x] **Font pre-loading:** Inter fontu icin `GoogleFonts.config.allowRuntimeFetching = false;` (font asset olarak bundle'la) veya ilk kullanima kadar system font goster
  - [x] **Widget build optimizasyonu:** Home ekranindaki pahalı widget'lari `const` constructor ile optimize et, gereksiz rebuild'leri `select` ile onle
  - [x] **Profiling:** DevTools Performance ile cold start suresini olc (hedef: <1s)
- **Done Kriteri:**
  - Cold start (uygulama acilis --> home ekrani gorunur): <1s (release modda)
  - Deferred import calisiyor (route_detail sayfasi lazy yukleniyor)
  - Font loading gecikme yaratmiyor

#### 9.5 Gorsel/Asset Optimizasyonu

- **Atanan:** mobile-developer + ui-designer
- **Dosyalar:**
  - `assets/images/` -- YENI: optimize edilmis gorsel asset'ler (eger varsa)
  - `pubspec.yaml` -- GUNCELLE: asset tanimlari
  - Ilgili widget dosyalari -- GUNCELLE: optimized image loading
- **Degisiklikler:**
  - [x] **Gorsel formati:** PNG yerine WebP kullan (eger gorsel asset varsa). SVG icin `flutter_svg` paketi ekle
  - [x] **Cached network image:** Sehir/mekan gorselleri icin `cached_network_image` paketi ekle. Placeholder + fade-in animasyonu
  - [x] **Image sizing:** `Image.network()` ve `Image.asset()` cagrilarinda `cacheWidth`/`cacheHeight` parametrelerini kullan (memory optimization)
  - [x] **APK/IPA boyutu:** `flutter build apk --analyze-size` ile boyut analizi. Hedef: APK <30MB
  - [x] **Shader warmup:** Eger shimmer veya gradient performans sorunu varsa `ShaderWarmUp` implement et
- **Done Kriteri:**
  - Network gorseller cached ve optimize (fade-in ile yukleniyor)
  - APK boyutu <30MB (release, arm64)
  - Memory kullanimi: 200 durakli rota goruntulerken <150MB heap

#### 9.6 Temel Offline Destek

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `lib/core/data/local_storage.dart` -- YENI: SharedPreferences/Hive wrapper
  - `lib/features/route/data/route_repository.dart` -- GUNCELLE: local cache
  - `lib/features/home/data/home_repository.dart` -- GUNCELLE: local cache
  - `lib/core/providers/connectivity_provider.dart` -- YENI: internet baglanti durumu
  - `lib/shared/widgets/offline_banner.dart` -- YENI: "Cevrimdisi" banner
- **Degisiklikler:**
  - [x] **Connectivity monitoring:** `connectivity_plus` paketi ile internet durumunu izle. Baglanti kesildiginde ust tarafta sari banner goster: "Cevrimdisi modasiniz. Son kaydedilen veriler gosteriliyor"
  - [x] **Route cache:** Son goruntulen rotayi SharedPreferences'a JSON olarak kaydet. Cevrimdisi iken bu cache'ten oku. Online'a donunce otomatik refresh
  - [x] **Home cache:** Home ekrani verisini (display name, active route, recent routes) SharedPreferences'a kaydet. Cevrimdisi iken cache'ten goster
  - [x] **Graceful degradation:** Cevrimdisi iken "Rota Olustur" butonuna basinca: "Bu ozellik internet baglantisi gerektiriyor" mesaji goster
- **Done Kriteri:**
  - Ucak modunda uygulama crash etmiyor
  - Son goruntulen rota cevrimdisi iken erisilebilir
  - Online'a donunce otomatik refresh yapiyor
  - Offline banner gorunuyor ve kayboluyıor (baglanti durumuna gore)

#### 9.7 QA Review + Performans Olcumu

- **Atanan:** qa-engineer
- **Bagimlilk:** 9.1-9.6 tamamlanmis
- **Islem:**
  - [x] **Localization testi:** TR ve EN dil modlarinda tum ekranlari gez, eksik/yanlís ceviri tespit et
  - [x] **Performans olcumu:**
    - Cold start: `flutter run --release`, stopwatch ile olc (hedef <1s)
    - Home ekrani render: first meaningful paint <500ms
    - Route detail scroll: 60fps (DevTools Performance)
    - Chat mesaj gonderm: AI yaniti <3s (yerel network)
  - [x] **Offline testi:** Ucak modu aktiflestir, uygulama ac, son rota goruntulenebilir, home ekrani cache'ten yuklenebilir, rota olusturma denemesi dogru mesaj verir
  - [x] **APK boyutu:** `flutter build apk --release` ile boyut kontrol (<30MB)
  - [x] **Memory profiling:** DevTools Memory ile 10 dakika kullanim (5 farkli ekran gez) -- memory leak yok, heap <200MB
  - [x] **Regresyon:** Sprint 8 UI degisiklikleri + Sprint 9 security fix'leri bozulmamis
- **Done Kriteri:** Sprint 10 tamamlanma kriterleri karsilandi

### Sprint 10 Tamamlanma Kriterleri

- [ ] .arb localization altyapisi calisiyor (flutter_localizations + intl)
- [ ] 200+ string key `app_tr.arb`'de tanimli, hardcode Turkce string kalmamis
- [ ] Ingilizce ceviri tamam, dil gecisi aninda etkili
- [ ] Cold start <1s (release modda)
- [ ] Deferred import aktif (buyuk ekranlar lazy yukleniyor)
- [ ] Network gorseller cached (cached_network_image)
- [ ] APK boyutu <30MB (arm64 release)
- [ ] Temel offline destek: son rota + home cache + offline banner
- [ ] Memory leak yok (10 dakika kullanimda heap <200MB)
- [ ] TR ve EN modlarinda tum ekranlar dogru gorunuyor

---

## Sprint 11+: RevenueCat, Explore, Gamification, Launch -- BACKLOG

> Detayli gorev planlari bu sprint'lere yaklasildikca olusturulacak.
> Master plan icin bkz: `.claude/projects/.../memory/development_plan.md`

### Kalan Roadmap

| Sprint | Ad | Hedef |
|--------|----|-------|
| 11 | RevenueCat + Paywall | iOS/Android subscription, 7-gun trial, receipt dogrulama |
| 12 | Explore Screen + AI Suggestions | Kisisel oneriler, trend rotalar, tematik koleksiyonlar |
| 13-14 | Gamification + Active Trip | Dijital Pasaport, Discovery Score, active trip mode |
| 15-16 | Offline + Social | Hive local DB, rota indirme, paylasim kartlari |
| 17-18 | Polish + Performance | Sentry + PostHog, <20s route, <50MB app |
| 19-20 | Launch Prep + LAUNCH | App Store/Play Store, 100 beta tester, Product Hunt |

### Eski Sprint 10 Detayli Plan (App Store Prep)

> Asagidaki detayli gorevler eskiden Sprint 10'daydi, simdi Sprint 17-20 araligina dagitilacak.

### On Kosullar

- Sprint 10 TAMAMLANMIS olmali
- Localization ve performans hedefleri karsilanmis olmali

### Bagimlilk Zinciri

```
10.1 RevenueCat entegrasyonu (Flutter + Edge Function webhook) -- ONCELIKLI
  --> 10.2 Premium ozelliklerin gate'lenmesi
10.3 PostHog + Sentry entegrasyonu -- PARALEL (10.1 ile)
10.4 Privacy Policy + Terms of Service -- PARALEL (10.1 ile)
10.5 App Store metadata + gorselleri -- PARALEL
  --> 10.6 Final QA + launch checklist
```

### Gorevler

#### 10.1 RevenueCat Entegrasyonu

- **Atanan:** mobile-developer + backend-architect
- **Dosyalar:**
  - `pubspec.yaml` -- GUNCELLE: `purchases_flutter` (RevenueCat SDK) ekle
  - `lib/features/subscription/data/subscription_repository.dart` -- YENI
  - `lib/features/subscription/domain/subscription_model.dart` -- YENI: Freezed model
  - `lib/features/subscription/domain/subscription_model.freezed.dart` -- YENI (code gen)
  - `lib/features/subscription/domain/subscription_model.g.dart` -- YENI (code gen)
  - `lib/features/subscription/presentation/providers/subscription_provider.dart` -- YENI
  - `lib/features/subscription/presentation/screens/paywall_screen.dart` -- YENI
  - `lib/features/subscription/presentation/widgets/plan_card.dart` -- YENI
  - `supabase/functions/revenuecat-webhook/index.ts` -- YENI: webhook handler
  - `supabase/functions/revenuecat-webhook/types.ts` -- YENI: RevenueCat types
  - `lib/main.dart` -- GUNCELLE: RevenueCat.configure() ekle
  - `.env.example` -- GUNCELLE: REVENUECAT_API_KEY ekle
- **Degisiklikler:**
  - [x] **Flutter SDK kurulumu:** `purchases_flutter` paketini ekle, `main.dart`'ta `Purchases.configure(PurchasesConfiguration('$REVENUECAT_API_KEY')..appUserID = supabaseUserId)` ile initialize et
  - [x] **Paywall ekrani:** Premium ozellikleri listele (sinirsiz rota, kisisel oneriler, reklamsiz), fiyat ($6.99/ay), "7 gun ucretsiz dene" butonu, Apple/Google native satin alma akisi
  - [x] **Webhook Edge Function:** RevenueCat'ten gelen event'leri isler:
    - `INITIAL_PURCHASE` / `RENEWAL`: subscriptions tablosuna upsert (status: active, tier: premium), users.subscription_tier sync trigger otomatik calisir
    - `CANCELLATION` / `EXPIRATION`: subscriptions.status = 'expired', tier = 'free'
    - `BILLING_ISSUE`: subscriptions.status = 'billing_retry'
    - Webhook secret dogrulama (RevenueCat X-Signature header)
    - `raw_payload` JSONB alanina tam event kaydı
  - [x] **Subscription provider:** RevenueCat SDK'dan aktif entitlement'lari oku, Supabase'deki subscriptions tablosu ile senkronize et, `isPremium` getter sagla
  - [x] **Trial logic:** 7 gunluk trial period, `subscriptions.trial_ends_at` alanini kullan
- **Done Kriteri:**
  - Paywall ekrani render ediyor (sandbox modda satin alma calisiyor)
  - Webhook test: RevenueCat sandbox event'i --> subscriptions tablosu guncelleniyor --> users.subscription_tier sync
  - Trial: yeni kullanici 7 gun boyunca premium ozelliklere erisebilir
  - Subscription provider tum uygulamada `isPremium` durumu sagliyor

#### 10.2 Premium Ozelliklerin Gate'lenmesi

- **Atanan:** mobile-developer
- **Bagimlilk:** 10.1
- **Dosyalar:**
  - `lib/features/chat/presentation/providers/chat_provider.dart` -- GUNCELLE
  - `lib/features/home/presentation/screens/home_screen.dart` -- GUNCELLE
  - `lib/features/route/presentation/screens/route_detail_screen.dart` -- GUNCELLE
  - `lib/shared/widgets/premium_gate.dart` -- YENI: premium kontrol wrapper widget
  - `lib/core/router/app_router.dart` -- GUNCELLE: paywall route ekle
- **Degisiklikler:**
  - [x] **Premium gate widget:** `PremiumGate` widget'i olustur -- `isPremium` false ise child yerine paywall'a yonlendiren bir CTA goster. Ornek kullanim: `PremiumGate(child: RouteDetailScreen())`
  - [x] **Free tier sinirlari:**
    - 3 rota/ay (mevcut rate limit calistiyor)
    - Rota detail'da insider_tip ve fun_fact alanlari blur'lu + "Premium ile ac" butonu
    - Kisisel oneriler yerine genel oneriler (free tier'da suggestions endpoint cagrilmaz)
  - [x] **Premium tier avantajlari:**
    - Sinirsiz rota (rate limit 50/ay)
    - Tum icerik acik (insider tip, fun fact, review summary)
    - Kisisel oneriler aktif
    - Memory Agent tam calisir (free tier'da sadece profil, gecmis kisitli)
  - [x] **Upgrade CTA'lari:** Rate limit'e ulasinca, blur'lu icerigi gorünce, oneriler bolumund -- hepsinde dogal paywall'a yonlendirme
- **Done Kriteri:**
  - Free tier kullanici 3 rota sonrasi paywall goruyor
  - Premium kullanici tum icerige erisiyor
  - Blur + CTA overlay dogru calisiyor
  - Downgrade sonrasi (premium --> free) icerik tekrar kilitleniyor

#### 10.3 PostHog + Sentry Entegrasyonu

- **Atanan:** mobile-developer
- **Dosyalar:**
  - `pubspec.yaml` -- GUNCELLE: `posthog_flutter`, `sentry_flutter` ekle
  - `lib/core/analytics/analytics_service.dart` -- YENI: analytics abstraction
  - `lib/core/analytics/posthog_service.dart` -- YENI: PostHog implementation
  - `lib/core/analytics/sentry_service.dart` -- YENI: Sentry implementation
  - `lib/main.dart` -- GUNCELLE: Sentry.init() + PostHog.init()
  - `.env.example` -- GUNCELLE: POSTHOG_API_KEY, SENTRY_DSN ekle
- **Degisiklikler:**
  - [x] **Sentry:** Flutter hata yakalama (FlutterError.onError, PlatformDispatcher), Edge Function hatalari (unhandled exception'lar), breadcrumb'lar (navigation, user action), release tracking
  - [x] **PostHog:** Temel event'ler:
    - `onboarding_completed` (persona tipi dahil)
    - `route_generated` (sehir, stil, sure dahil)
    - `feedback_submitted` (overall_rating dahil)
    - `paywall_viewed` / `purchase_completed` / `purchase_cancelled`
    - `screen_viewed` (her ekran gecisinde)
    - `chat_message_sent` (step numarası dahil)
  - [x] **Analytics service abstraction:** `AnalyticsService` interface'i olustur, `PostHogService` implement etsin. Ileride baska provider eklenebilir (mixpanel, amplitude vb.)
  - [x] **GDPR uyumu:** `lib/core/analytics/consent_manager.dart` -- YENI: kullanici onay yonetimi. Ilk acilista "Analytics verisi toplamamiza izin veriyor musunuz?" dialog'u. Onay verilmediyse event gondermeme
  - [x] **User identification:** PostHog identify cagrisinda Supabase user ID kullan (email GONDERME -- GDPR)
- **Done Kriteri:**
  - Sentry'de Flutter + Edge Function hatalari gorunuyor (test hata gondererek dogrula)
  - PostHog'da temel event'ler gorunuyor (onboarding, route generation, feedback)
  - GDPR consent dialog calisiyor, onay vermeyenler icin event gonderilmiyor
  - Analytics initialize uygulamayi yavaşlatmiyor (<100ms ek cold start)

#### 10.4 Privacy Policy + Terms of Service

- **Atanan:** Kaze (manual -- hukuki icerik)
- **Dosyalar:**
  - `assets/legal/privacy_policy_tr.md` -- YENI
  - `assets/legal/privacy_policy_en.md` -- YENI
  - `assets/legal/terms_of_service_tr.md` -- YENI
  - `assets/legal/terms_of_service_en.md` -- YENI
  - `lib/features/profile/presentation/screens/legal_screen.dart` -- YENI: markdown renderer
  - `lib/features/auth/presentation/screens/signup_screen.dart` -- GUNCELLE: "Sartlari kabul ediyorum" checkbox
- **Icerik gereksinimleri:**
  - [x] **Privacy Policy:** Toplanan veriler (email, konum tercihleri, gezi gecmisi, AI konusmalari), veri isleme amaci, ucuncu taraf servisler (Supabase, Google Maps, RevenueCat, PostHog, Sentry), veri saklama suresi, kullanici haklari (silme, export), KVKK + GDPR uyumu
  - [x] **Terms of Service:** Hizmet tanimi, kullanim kurallari, abonelik/iptal politikasi, sorumluluk sinirlamasi, AI icerigin dogrulugu disclaimer ("Geez AI rota onerileri bilgi amaclidir, kesin dogru degildir")
  - [x] **Signup ekrani:** "Gizlilik Politikasi ve Kullanim Sartlarini okudum, kabul ediyorum" checkbox'u (isaretlenmeden kayit yapilamaz)
  - [x] **Profile ekrani:** Ayarlar bolumunde "Gizlilik Politikasi" ve "Kullanim Sartlari" linkleri
- **Done Kriteri:**
  - Privacy Policy ve ToS her iki dilde hazir
  - Signup'ta checkbox zorunlu
  - Profile'dan erisilebilir
  - App Store review icin yeterli icerik mevcut

#### 10.5 App Store Metadata + Gorselleri

- **Atanan:** ui-designer + Kaze
- **Dosyalar:**
  - `assets/store/screenshots/` -- YENI: 6+ screenshot (iPhone 6.7", iPhone 6.1", iPad)
  - `assets/store/icon/` -- YENI: App icon (1024x1024 master + platform varyantlari)
  - `assets/store/feature_graphic.png` -- YENI: Play Store feature graphic (1024x500)
  - `ios/Runner/Assets.xcassets/AppIcon.appiconset/` -- GUNCELLE
  - `android/app/src/main/res/mipmap-*/` -- GUNCELLE
  - `docs/store-listing.md` -- YENI: store metadata (baslik, aciklama, keywords)
- **Islem:**
  - [x] **App icon:** Geez AI logosu -- gradient lacivert/turkuaz, minimal "G" harfi veya pusula ikonu, iOS ve Android uyumlu (yuvarlatilmis koseler, adaptive icon)
  - [x] **Screenshots:** 6 ekran goruntusu (Splash, Home, Chat, Route Detail, Passport, Profile), her birinde ust tarafta marketing metni, alt tarafta ekran goruntusu
  - [x] **Store metadata TR:**
    - Baslik: "Geez AI - Akilli Seyahat Rotasi" (max 30 karakter)
    - Kisa aciklama: "AI ile kisisel seyahat rotalari olustur" (max 80 karakter)
    - Tam aciklama: Ozellikler listesi, nasil calisir, fiyatlandirma
    - Anahtar kelimeler: seyahat, rota, planlama, AI, gezi, turkiye, istanbul
  - [x] **Store metadata EN:**
    - Title: "Geez AI - Smart Travel Routes"
    - Short description: "AI-powered personalized travel routes"
    - Full description + keywords
  - [x] **Kategori:** Travel & Local (Android), Travel (iOS)
  - [x] **Icerik derecelendirmesi:** Everyone / 4+ (siddetsiz icerik)
- **Done Kriteri:**
  - App icon tum platformlarda dogru render ediyor
  - 6+ screenshot hazir (TR ve EN)
  - Store metadata her iki dilde hazir
  - Feature graphic hazir

#### 10.6 Final QA + Launch Checklist

- **Atanan:** qa-engineer + Kaze
- **Bagimlilk:** 10.1-10.5 tamamlanmis
- **Islem:**
  - [x] **Full regression test:** Sprint 1-10'daki tum akislari uctan uca test et:
    - Kayit --> onboarding --> chat --> rota olusturma --> rota detay --> feedback --> Memory Agent update --> ikinci rota (kisisel) --> passport stamp --> profile guncelleme
  - [x] **Abonelik testi:** Free tier limit --> paywall --> sandbox satin alma --> premium erişim --> iptal --> free tier'a donus
  - [x] **Multi-device test:** iPhone (iOS 16+), Android (API 24+), iPad (opsiyonel)
  - [x] **Network condition test:** Yavas baglanti (throttle), baglanti kesintisi, VPN arkasi
  - [x] **Localization testi:** TR ve EN modlarinda tam gecis
  - [x] **Launch checklist:**
    - [ ] `flutter analyze` -- 0 error, 0 warning
    - [ ] `flutter test` -- tum testler basarili
    - [ ] APK build basarili (`flutter build appbundle --release`)
    - [ ] IPA build basarili (`flutter build ipa --release`)
    - [ ] App icon dogru
    - [ ] Splash screen dogru
    - [ ] Privacy Policy ve ToS erisilebilir
    - [ ] RevenueCat production API key'e gecis (.env.production)
    - [ ] Supabase production project URL ve anon key (.env.production)
    - [ ] Sentry production DSN (.env.production)
    - [ ] PostHog production API key (.env.production)
    - [ ] Console.log / debugPrint production build'de devre disi
    - [ ] Google Maps API key production restrict edilmis (paket ismi + SHA-1)
    - [ ] Edge Function'lar production'a deploy edildi
    - [ ] App Store Connect'e build yuklendi
    - [ ] Google Play Console'a build yuklendi
    - [ ] Store listing (metadata + gorseller) her iki platformda tamamlandi
    - [ ] TestFlight / Internal Test Track ile son test
- **Done Kriteri:** Launch checklist tamami isaretli, uygulama store review'a gonderilmeye hazir

### Sprint 10 Tamamlanma Kriterleri

- [ ] RevenueCat entegrasyonu calisiyor (sandbox satin alma + webhook)
- [ ] Premium gate: free tier sinirlamalari + paywall aktif
- [ ] Sentry hata yakalama calisiyor (Flutter + Edge Functions)
- [ ] PostHog event tracking calisiyor (temel event'ler)
- [ ] GDPR consent dialog aktif
- [ ] Privacy Policy + ToS her iki dilde hazir ve erisilebilir
- [ ] App icon + screenshots + store metadata hazir
- [ ] APK + IPA build basarili (release mod)
- [ ] Production environment degiskenleri (.env.production) tanimli
- [ ] Full regression test basarili
- [ ] Launch checklist tamami isaretli
- [ ] App Store ve Play Store review'a gonderildi

---

## Acik Kalemler (Sprint 6+ Backlog)

Asagidaki kalemler audit'te tespit edildi ve ilgili sprint'lere atandi:

| Kalem    | Aciklama                                  | Atandi       | Durum        |
| -------- | ----------------------------------------- | ------------ | ------------ |
| INFO-02  | Hardcoded Turkish strings -> .arb files   | Sprint 9.2   | BACKLOG      |
| INFO-04  | Test coverage (1 test dosyasi)            | Sprint 7.7   | BACKLOG      |
| INFO-06  | Home suggestions personalized             | Sprint 6.6   | BACKLOG      |
| VIS-03   | Playwright auth-guarded test altyapisi    | Sprint 7.8   | BACKLOG      |

---

## Dosya Yapisi Ozeti (Sprint 5.5 Sonrasi + Sprint 6-10 Planlanan)

```
supabase/
  migrations/
    010_atomic_rpc_functions.sql      -- YENI (Sprint 4.5)
    011_cache_and_category_fixes.sql  -- YENI (Sprint 5)
    012_memory_agent.sql              -- PLANLANDI (Sprint 6): VIEW + RPC'ler
    013_rls_hardening.sql             -- PLANLANDI (Sprint 8): RLS + rate limit kolonu
  functions/
    generate-route/
      index.ts                        -- GUNCELLENDI (Sprint 5) + PLANLI (Sprint 6: V2 memory context)
      prompts.ts                      -- PLANLI (Sprint 6: Prompt V2 + memory context)
    chat/
      index.ts                        -- GUNCELLENDI (Sprint 5: rate limiting)
      prompts.ts                      -- PLANLI (Sprint 6: daha dogal Turkce)
    memory-agent/                     -- PLANLI (Sprint 6: YENI Edge Function)
      index.ts
      context-builder.ts
      prompts.ts
      types.ts
    suggestions/                      -- PLANLI (Sprint 6: YENI Edge Function)
      index.ts
      prompts.ts
    revenuecat-webhook/               -- PLANLI (Sprint 10: YENI Edge Function)
      index.ts
      types.ts
    _shared/
      cache.ts                        -- GUNCELLENDI (Sprint 5) + PLANLI (Sprint 6: normalizasyon)
      types.ts                        -- GUNCELLENDI (Sprint 5) + PLANLI (Sprint 6: memory types)
      sanitize.ts                     -- PLANLI (Sprint 8: YENI input sanitization)
      error-handler.ts                -- PLANLI (Sprint 8: enriched logging)
      rate-limit.ts                   -- PLANLI (Sprint 8: burst korumasi)

lib/
  core/
    constants/
      gamification_constants.dart     -- YENI (Sprint 5)
    theme/
      colors.dart                     -- PLANLI (Sprint 7: V2 palet)
      typography.dart                 -- PLANLI (Sprint 7: V2 hiyerarsi)
      spacing.dart                    -- PLANLI (Sprint 7: V2 grid)
      theme.dart                      -- PLANLI (Sprint 7: V2 component themes)
      shadows.dart                    -- PLANLI (Sprint 7: YENI)
      radius.dart                     -- PLANLI (Sprint 7: YENI)
      animations.dart                 -- PLANLI (Sprint 7: YENI)
    error/                            -- PLANLI (Sprint 8: YENI)
      app_exceptions.dart
      error_handler.dart
      error_messages.dart
    data/
      local_storage.dart              -- PLANLI (Sprint 9: YENI offline cache)
    providers/
      locale_provider.dart            -- PLANLI (Sprint 9: YENI dil secimi)
      connectivity_provider.dart      -- PLANLI (Sprint 9: YENI baglanti durumu)
    analytics/                        -- PLANLI (Sprint 10: YENI)
      analytics_service.dart
      posthog_service.dart
      sentry_service.dart
      consent_manager.dart
  l10n/                               -- PLANLI (Sprint 9: YENI)
    app_tr.arb
    app_en.arb
  app.dart                            -- GUNCELLENDI (Sprint 5) + PLANLI (Sprint 9: localization)
  features/
    chat/
      data/
        chat_repository.dart          -- GUNCELLENDI (Sprint 4.5)
        feedback_repository.dart      -- GUNCELLENDI (Sprint 4.5) + PLANLI (Sprint 6: memory trigger)
    explore/
      presentation/
        screens/
          explore_screen.dart         -- GUNCELLENDI (Sprint 5)
    feedback/
      presentation/
        providers/
          feedback_provider.dart      -- GUNCELLENDI (Sprint 4.5) + PLANLI (Sprint 6: memory call)
    home/
      domain/
        suggestion_model.dart         -- PLANLI (Sprint 6: YENI Freezed model)
      presentation/
        screens/
          home_screen.dart            -- GUNCELLENDI (Sprint 5) + PLANLI (Sprint 7: redesign)
        widgets/
          greeting_header.dart        -- PLANLI (Sprint 7: YENI)
          quick_actions.dart          -- PLANLI (Sprint 7: YENI)
    passport/
      presentation/
        widgets/
          passport_header.dart        -- PLANLI (Sprint 7: YENI)
    profile/
      presentation/
        widgets/
          settings_section.dart       -- PLANLI (Sprint 7: YENI)
        screens/
          legal_screen.dart           -- PLANLI (Sprint 10: YENI)
    route/
      presentation/
        widgets/
          day_header.dart             -- PLANLI (Sprint 7: YENI)
          route_hero.dart             -- PLANLI (Sprint 7: YENI)
          stop_timeline.dart          -- PLANLI (Sprint 7: YENI)
    subscription/                     -- PLANLI (Sprint 10: YENI feature modul)
      data/
        subscription_repository.dart
      domain/
        subscription_model.dart
      presentation/
        providers/
          subscription_provider.dart
        screens/
          paywall_screen.dart
        widgets/
          plan_card.dart
  shared/widgets/
    animated_counter.dart             -- PLANLI (Sprint 7: YENI)
    fade_slide_transition.dart        -- PLANLI (Sprint 7: YENI)
    shimmer_loading.dart              -- PLANLI (Sprint 7: YENI)
    error_widget.dart                 -- PLANLI (Sprint 8: YENI)
    retry_widget.dart                 -- PLANLI (Sprint 8: YENI)
    premium_gate.dart                 -- PLANLI (Sprint 10: YENI)
    offline_banner.dart               -- PLANLI (Sprint 9: YENI)

test/                                 -- PLANLI (Sprint 7-8: YENI)
  helpers/
    test_utils.dart
    mock_providers.dart
    supabase_test_client.dart
  core/theme/colors_test.dart
  features/auth/.../auth_text_field_test.dart
  features/home/.../home_provider_test.dart
  features/chat/.../chat_provider_test.dart
  features/passport/.../passport_provider_test.dart
  shared/widgets/geez_button_test.dart
  shared/widgets/geez_card_test.dart
  integration/
    auth_flow_test.dart
    route_generation_test.dart
    feedback_flow_test.dart
    memory_agent_test.dart
    cache_flow_test.dart
    onboarding_flow_test.dart
  security/
    rls_audit_test.sql
  e2e/
    playwright.config.ts
    auth.setup.ts
    onboarding.spec.ts
    chat-flow.spec.ts
    home.spec.ts

assets/
  legal/                              -- PLANLI (Sprint 10: YENI)
    privacy_policy_tr.md
    privacy_policy_en.md
    terms_of_service_tr.md
    terms_of_service_en.md
  store/                              -- PLANLI (Sprint 10: YENI)
    screenshots/
    icon/
    feature_graphic.png
```
