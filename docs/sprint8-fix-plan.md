# Sprint 8: Audit Remediation Plan

**Source:** Sprint 7 Post-Mortem Audit (11 CRITICAL, 33 HIGH, 38 MEDIUM, 20+ LOW)

## Dependency Graph

```
PHASE A (Security) ────────────────> GATE
    A1: .env removal         (backend-architect)
    A2: auth.ts debug logs   (backend-architect)
    A3: Content-Type         (backend-architect)
    A4: Rate limiting        (backend-architect)
    A5: Input sanitization   (backend-architect + ai-engineer)

                GATE PASSED
                    |
          ┌─────────┴─────────┐
          v                   v
    PHASE B (DB)         PHASE C (UI) ── parallel
    B1: migration 014       C1: nav fixes (mobile-dev)
        (db-architect)      C2: send button (mobile-dev)
    B2: cache key fix       C3: Turkish chips (backend)
        (backend)           C4: route detail (mobile-dev)
                            C5: nav label (mobile-dev)
                            C6: auth expiry (mobile-dev)
          |                   |
          └─────────┬─────────┘
                    v
              PHASE D (Architecture)
              D1: folder restructure
              D2: deps + imports
              D3: state management
                    |
                    v
              PHASE E (Polish) ── all parallel
              E1: colors (ui-designer)
              E2: a11y (mobile-dev)
              E3: Turkish text (ui-designer + mobile-dev)
              E4: Sentry + tests (qa-engineer)
              E5: shimmer + dedup (ui-designer)
```

## Agent Assignments

| Agent | Phase A | Phase B | Phase C | Phase D | Phase E |
|-------|---------|---------|---------|---------|---------|
| backend-architect | A1-A5 | B2 | C3 | -- | -- |
| database-architect | -- | B1 | -- | -- | -- |
| ai-engineer | A5 (collab) | -- | -- | -- | -- |
| mobile-developer | -- | -- | C1,C2,C4,C5,C6 | D1,D2,D3 | E2,E3 |
| ui-designer | -- | -- | -- | -- | E1,E3,E5 |
| qa-engineer | -- | -- | -- | -- | E4 |

## Phase A: Security Hotfix (BLOCKING)

### A1: Remove .env from APK/IPA (C-1)
- Remove `- .env` from `pubspec.yaml` assets
- Create `lib/core/config/env.dart` with `String.fromEnvironment`
- Update all env var reads to new config class
- Build with `--dart-define-from-file=.env`

### A2: Strip auth.ts debug logs (H-1)
- Remove ALL `console.log("[auth-debug]"...)` from `_shared/auth.ts`

### A3: Content-Type validation (C-8)
- Add `Content-Type: application/json` check before `req.json()` in all Edge Functions

### A4: Rate limiting (H-2, H-3)
- Add per-user request throttle to `/chat` (60/min) and `/user-context` (30/min)

### A5: Input sanitization (H-4)
- Create `_shared/sanitize.ts`
- Sanitize city, country, preferences, lastUserMsg before LLM prompts

## Phase B: Database (after A)

### B1: Migration 014 (C-2, C-3, H-5, H-7)
- Fix trip_feedback.favorite_stops DEFAULT to TEXT[]
- Add unique constraint on visited_places(user_id, place_id)
- Add index on routes.completed_at
- Fix route_stops_update_own RLS WITH CHECK

### B2: Cache key fix (H-19)
- Add durationDays to cache key in `_shared/types.ts`

## Phase C: Critical UI (parallel with B)

### C1: Navigation (C-6, C-10, H-20, H-23)
- context.go() -> context.pop() in route_detail
- ref.watch -> ref.read in routerProvider
- Move detail routes out of ShellRoute

### C2: Chat send button (C-7)
- Wrap with ValueListenableBuilder

### C3: Turkish chips (H-31)
- Fix suggestion strings in chat Edge Function

### C4: Route detail UI (H-26-29, H-32-33, M-12)
- Strip seconds from time
- Fix text overflow on stop names/prices
- Map "public" -> "Toplu Taşıma"
- Fix stop numbering per-day
- Fix FAB overlap
- Add feedback button on completed routes

### C5: Nav bar label (H-30)
- "Keşfet" -> "Rotalarım", explore icon -> history icon

### C6: Auth session expiry (C-9)
- Check session.isExpired in auth provider init
- Handle tokenRefreshFailed event

## Phase D: Architecture (after C)
- D1: Move feedback files from chat/ to feedback/
- D2: Remove unused deps, fix cross-feature imports
- D3: autoDispose, mounted guards, listener cleanup

## Phase E: Polish (after D)
- E1: Hardcoded colors -> GeezColors
- E2: Semantics labels, touch targets
- E3: Turkish text fixes (persona labels, button text)
- E4: Sentry + first tests
- E5: Shimmer consolidation, isDark extension
