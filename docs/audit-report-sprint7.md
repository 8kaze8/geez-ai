# Sprint 7 Post-Mortem Audit (2026-03-16)

**6 agents: Database Architect, Security/QA, Backend Architect, UI Designer, Tech Lead, Mobile Developer**
**~90 files analyzed, 100+ findings**

---

## CRITICAL (8) — Fix Before Any New Feature Work

| #   | Finding                                                                                  | File(s)                           |
| --- | ---------------------------------------------------------------------------------------- | --------------------------------- |
| C-1 | `.env` bundled as Flutter asset — API keys extractable from APK/IPA                      | `pubspec.yaml:68`                 |
| C-2 | `trip_feedback.favorite_stops` DEFAULT still `'{}'::uuid[]` after type changed to TEXT[] | DB migration needed               |
| C-3 | No unique constraint on `visited_places(user_id, place_id)`                              | DB migration needed               |
| C-4 | Zero test files in entire project                                                        | `test/` empty                     |
| C-5 | No Sentry/error monitoring (listed in CLAUDE.md but not in deps)                         | `pubspec.yaml`                    |
| C-6 | `route_detail_screen.dart` back buttons use `context.go()` — destroys nav stack          | `route_detail_screen.dart:94,134` |
| C-7 | Chat send button not reactive — StatelessWidget without ValueListenableBuilder           | `chat_screen.dart:588`            |
| C-8 | No Content-Type validation on POST bodies in Edge Functions                              | All Edge Functions                |

## HIGH (24)

| #    | Finding                                                                                  | Source                     |
| ---- | ---------------------------------------------------------------------------------------- | -------------------------- |
| H-1  | Auth debug logging leaks JWT claims in deployed `auth.ts`                                | Security + Backend         |
| H-2  | No rate limiting on `/chat` endpoint                                                     | Security + Backend         |
| H-3  | No rate limiting on `/user-context` endpoint                                             | Security + Backend         |
| H-4  | Prompt injection via city/country/preferences/lastUserMsg in LLM prompts                 | Backend + Security         |
| H-5  | Missing index on `routes.completed_at`                                                   | Database                   |
| H-6  | `passport_repository.getStats()` N+1 query pattern                                       | Database                   |
| H-7  | `route_stops_update_own` RLS missing `WITH CHECK` clause                                 | Database                   |
| H-8  | 12+ files with hardcoded `Color(0xFF...)` literals — dark mode broken                    | Mobile Dev + UI            |
| H-9  | Zero `Semantics` labels on interactive GestureDetector widgets (6+ files)                | Mobile Dev                 |
| H-10 | `EmailConfirmBanner` dismiss button ~18x18px touch target (min 48x48)                    | Mobile Dev                 |
| H-11 | `welcome_screen.dart` gradient duplicates GeezColors inline                              | Mobile Dev                 |
| H-12 | `GeezTypography` uses raw `'Inter'` string — font fails offline                          | Mobile Dev                 |
| H-13 | Feedback files misplaced in `chat/` instead of `feedback/`                               | Tech Lead                  |
| H-14 | Cross-feature import violations (route -> auth + home + passport)                        | Tech Lead                  |
| H-15 | Unused `riverpod_generator`/`google_fonts` in pubspec                                    | Tech Lead                  |
| H-16 | No localization infrastructure — all strings hardcoded Turkish                           | Tech Lead                  |
| H-17 | Cache `routeId` cross-user leak risk                                                     | Backend                    |
| H-18 | `auth_provider.dart` — raw `e.toString()` English errors shown to users                  | Tech Lead                  |
| H-19 | Cache key missing `durationDays` — wrong itinerary served from cache                     | `_shared/types.ts:329-354` |
| H-20 | Detail screens inside ShellRoute — nested Scaffold issues                                | `app_router.dart`          |
| H-21 | No onboarding completion guard in router redirect                                        | `app_router.dart:38-68`    |
| H-22 | No pagination on any list query — all fetch ALL rows                                     | Multiple repos             |
| H-23 | `routerProvider` uses `ref.watch(authStateProvider)` — recreates GoRouter on auth change | `app_router.dart:31-34`    |
| H-24 | `passport_screen.dart` GridView.builder with shrinkWrap:true defeats lazy rendering      | `passport_screen.dart`     |

## MEDIUM (25) — Key Issues

- **State Management (5):** routeDetailProvider family no autoDispose (memory leak), homeProvider stale data, OnboardingNotifier tuple state, dispose-after-async crash risk in ChatNotifier, \_AuthRefreshNotifier listener leak
- **Navigation (3):** Onboarding route not in \_publicRoutes, RouteLoadingScreen dead route, fragile string-contains nav bar hiding
- **Code Duplication (5):** \_turkishError() duplicated in 2 providers, date formatting in 2 places, travel-style-to-icon in 2 places, ~60 isDark ternaries, ShimmerBox in 3 files
- **Error Handling (3):** auth_repository no try/catch, home_repository silently swallows errors, two exception hierarchies
- **Backend (4):** Recursive retry x fallback can exceed 300s, error details expose internals, TOCTOU race in rate-limit, no request cancellation
- **UI Quality (5):** 5 shimmer implementations, missing GeezColorScheme extension, \_DayTabsDelegate.shouldRebuild always true, chip touch targets <48dp, oversized screen files (870+ lines)

## LIVE UI TEST FINDINGS (Playwright + iOS Simulator)

Tested on Chrome (web) + iPhone 17 Pro simulator.
Screenshots in `/tmp/geez_w_*.png`, `/tmp/geez_ios_*.png`, and `/tmp/geez_chat_*.png`, `/tmp/geez_route_*.png`, `/tmp/geez_*.png`.

**Chat Q&A Flow tested end-to-end:** Paris → Yeme & İçme → Yürüyerek → Orta → 2 Gün → Route generated successfully (13 stops, 2 days). All screens visited: Home, Keşfet, Pasaport, Profil, Route Detail.

### CRITICAL (new)

| #    | Finding                                                                                                  | Screen        |
| ---- | -------------------------------------------------------------------------------------------------------- | ------------- |
| C-9  | Auth guard doesn't catch expired session — user sees blank home instead of login redirect                | Home          |
| C-10 | GlobalKey conflict on auth state change — `Multiple widgets used the same GlobalKey` runtime error (x11) | App-wide      |
| C-11 | Pasaport "Pasaportunuz Boş" even though Tamamlanmış route exists — stamp creation failed or not syncing  | Pasaport      |

### HIGH (new)

| #    | Finding                                                                                                    | Screen          |
| ---- | ---------------------------------------------------------------------------------------------------------- | --------------- |
| H-25 | iOS emoji rendering broken — all emoji (🧭📅📍🚶💰🍕🏛🎒🎨🌿) show as ❓ placeholder boxes               | All screens     |
| H-26 | Stop card text overflow — long place names (e.g. "Eminönü'nden Boğaz Turu") break card layout completely   | Route Detail    |
| H-27 | Price text overflow — "Şehir Hatları Ücreti (değişken)" overflows right side of stop card                  | Route Detail    |
| H-28 | Time format "09:00:00-10:30:00" — seconds unnecessary, wrap breaks mid-number ("10:30:00-1\n1:15:00")     | Route Detail    |
| H-29 | "public" displayed raw instead of Turkish "Toplu Taşıma" for transport mode                                | Route Detail    |
| H-30 | Bottom nav says "Keşfet" with explore icon but screen shows "Rotalarım" (route history)                    | Nav Bar         |
| H-31 | All chat suggestion chips lack Turkish diacritics — "Kultur" not "Kültür", "Yuruyerek" not "Yürüyerek", "Gun" not "Gün" etc. Edge Function `suggestions` array issue | Chat |
| H-32 | Stop numbering gap — Day 1 = stops 1-6, Day 2 = stops 8-13. Stop 7 missing (map marker consumes a number slot) | Route Detail |
| H-33 | "Rotaya Başla" FAB overlaps expanded stop card content — blocks AI Insight and Fun Fact text                | Route Detail    |

### MEDIUM (new)

| #    | Finding                                                                                              | Screen       |
| ---- | ---------------------------------------------------------------------------------------------------- | ------------ |
| M-1  | Home suggestion cards show "kacirma" (missing ç), "Acik" (missing Ç), "antik ruins" (English mixed) | Home         |
| M-2  | "Personami Paylas" button — missing Turkish chars, should be "Personamı Paylaş"                      | Profil       |
| M-3  | Profil "Geçmiş Geziler: Henüz gezi yok" — inconsistent with Keşfet showing Tamamlanmış route        | Profil       |
| M-4  | Suggestion card gradients look AI-generated — dark brown/muddy blue, no visual polish                | Home         |
| M-5  | "Son Rotalar" section cut off at bottom — no scroll hint, user doesn't know there's more             | Home         |
| M-6  | Harita placeholder — colored dots on grey, no real map, looks broken                                 | Route Detail |
| M-7  | Discovery Score emoji 🧭 shows as ❓ on iOS — key branding element broken                            | Home         |
| M-8  | "Istanbul" vs "İstanbul" — DB inconsistency between routes (capital İ missing on one)                | Keşfet       |
| M-9  | Paris route not appearing in Keşfet/Rotalarım after generation — route possibly not saved or filtered | Keşfet       |
| M-10 | Persona labels all English ("Foodie", "History Buff", "Adventure", "Culture", "Nature") — no Turkish  | Profil       |
| M-11 | "Travel Persona" section title in English — should be Turkish                                         | Profil       |
| M-12 | Completed route has no "Geri Bildirim Ver" button — no way to access feedback from route detail        | Route Detail |
| M-13 | Stop numbering also skips between Day 2→3 (İstanbul: Day 2 ends at 11, Day 3 starts at 13)           | Route Detail |

### Updated Totals

**Before live test:** 8 CRITICAL, 24 HIGH, 25 MEDIUM, 20+ LOW
**After live test:** 11 CRITICAL, 33 HIGH, 38 MEDIUM, 20+ LOW

---

## LOW (20+)

Empty scaffold dirs, unnecessary type casts, redundant AnimatedBuilder, missing ValueKey on lists, PassportStampModel with id:'', \_AuthRefreshNotifier storing Ref, Freezed inconsistency on auth/onboarding states, isDark parameter drilling anti-pattern, decorative widgets missing ExcludeSemantics, redundant Scaffold backgroundColor overrides, etc.

---

## Recommended Fix Order

### Phase A: Security Hotfix (1-2 days)

1. C-1: Remove .env from pubspec assets, switch to --dart-define
2. H-1: Redeploy auth.ts without debug logging
3. H-2/H-3: Add rate limiting to chat + user-context
4. H-4: Input sanitization before LLM prompts
5. C-8: Content-Type validation on all Edge Functions

### Phase B: Database Migration 014 (1 day)

6. C-2: Fix trip_feedback.favorite_stops DEFAULT
7. C-3: Add unique constraint on visited_places
8. H-5: Add index on routes.completed_at
9. H-7: Fix RLS WITH CHECK on route_stops_update_own

### Phase C: Critical UI Bugs (1-2 days)

10. C-6: context.go() -> context.canPop()/context.pop()
11. C-7: Wrap send button in ValueListenableBuilder
12. H-18: Map auth errors to Turkish messages
13. H-23: routerProvider ref.watch -> ref.read fix
14. H-30: Rename "Keşfet" tab to "Rotalarım" + change icon to history
15. H-31: Fix Edge Function chat suggestions — add Turkish diacritics
16. H-32: Fix stop numbering — map marker should not consume stop number
17. H-33: Fix FAB overlap on expanded stop card (add bottom padding)
18. H-28: Strip seconds from time format (HH:MM not HH:MM:SS)

### Phase D: Architecture Cleanup (2 days)

19. H-13: Move feedback files to proper feature dir
20. H-15: Remove unused riverpod_generator/google_fonts
21. H-14: Break cross-feature coupling
22. Medium state management fixes (autoDispose, dispose guards)

### Phase E: Polish + Foundation (ongoing)

23. H-8: Replace hardcoded colors with GeezColors
24. H-9/H-10: Accessibility (Semantics, touch targets)
25. C-4/C-5: Add Sentry + first unit tests
26. H-16: Localization infrastructure
27. M-10/M-11: Translate persona labels + section titles to Turkish
28. M-1/M-2: Fix Turkish diacritics in home cards + profile button
