# Geez AI

AI-powered personalized travel route planning mobile app.

## Project

- **Stack:** Flutter 3.41 + Supabase + Claude API + Google Maps Platform
- **Architecture:** Feature-based folder structure with Riverpod state management
- **Backend:** Supabase Edge Functions (Deno/TypeScript) with AI Agent orchestration
- **Developer:** Solo (Kaze) + AI Agent Team (vibe coding)

## Architecture Rules

- Feature-based modules: `lib/features/{feature}/data|domain|presentation/`
- State management: Riverpod (flutter_riverpod + riverpod_annotation)
- Navigation: GoRouter with bottom nav shell
- Theme: GeezColors, GeezTypography, GeezSpacing from `lib/core/theme/`
- Dark mode must work on every screen
- All AI responses must be cached (city:style:budget:transport:language key)

## Tech Stack

- **Frontend:** Flutter + Dart
- **Backend:** Supabase (PostgreSQL + pgvector + Auth + Edge Functions + Storage)
- **AI:** Claude API (primary) + GPT-4o-mini (fallback for simple tasks)
- **Maps:** Google Maps Platform (Places, Directions, Popular Times)
- **Search:** Tavily (general) + Exa (semantic/deep)
- **Payments:** RevenueCat (iOS + Android subscriptions)
- **Analytics:** PostHog + Sentry

## Coding Standards

- Dart: follow flutter_lints, prefer const constructors
- Edge Functions: TypeScript strict mode, error handling + rate limiting on every function
- Database: RLS enabled on all user-data tables
- API keys: never in code, always in .env / Supabase secrets
- Commit messages: conventional commits (feat:, fix:, chore:, docs:)

## Key Features (MVP)

1. AI Q&A Flow — 4-6 smart questions to understand travel preferences
2. Deep Research Routes — review synthesis, insider tips, fun facts per stop
3. AI Memory — 4-layer system (Profile, Preferences, History, Persona)
4. Gamification — Digital Passport, Discovery Score, Travel Persona
5. Post-Trip Feedback Loop — learn from every trip
6. Global Day 1 — AI on-demand research, no city limits

## Reference Docs

All planning documents are in `docs/` folder:
- MVP spec, technical architecture, financial projections
- Go-to-market strategy, competitive analysis, UI/UX wireframes
- Development kickoff with sprint plan

## AI Agent System

- Research Agent: Google Maps + Tavily + Exa → place discovery + review synthesis
- Memory Agent: user context, past trips, preferences → personalization
- Route Agent: distance matrix + TSP → optimal ordering + timing
- Content Agent: fun facts, insider tips, cultural context → rich stop cards
- Orchestrator: coordinates all agents for route generation

## Development Team (Subagents)

I (main Claude instance) act as **Project Manager** — I delegate tasks to specialized team members:

| Role | Agent | Model | When to Use |
|------|-------|-------|-------------|
| Tech Lead | tech-lead | opus | BEFORE features (plan) + AFTER (review) |
| Flutter Dev | mobile-developer | sonnet | Frontend screens, widgets, Riverpod |
| Backend Dev | backend-architect | sonnet | Edge Functions, Auth, Supabase client |
| AI Engineer | ai-engineer | opus | Claude API, agent system, embeddings |
| UI Designer | ui-designer | sonnet | Visual design, animations, dark mode |
| DB Architect | database-architect | sonnet | Schema, migrations, RLS, pgvector |
| QA Engineer | qa-engineer | sonnet | Tests, security audit, code review |
| Debugger | debugger | sonnet | Error diagnosis, bug fixes |

### Orchestration Rules

- **Plan first:** Tech Lead reviews architecture BEFORE implementation starts
- **Parallel when independent:** Flutter Dev + Backend Dev can work simultaneously on separate concerns
- **Sequential when dependent:** DB schema → Backend API → Frontend integration
- **QA after every feature:** QA Engineer reviews AFTER implementation, BEFORE merge
- **Debugger on demand:** Only when errors occur, not preventively
