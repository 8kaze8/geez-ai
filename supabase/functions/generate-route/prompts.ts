/**
 * prompts.ts
 *
 * System and user prompt builders for AI route generation.
 *
 * The prompts instruct the LLM to return a well-structured JSON response
 * containing daily stop plans with rich content fields.  The output language
 * is controlled by the `language` parameter in the RouteRequest.
 *
 * All prompts are deterministic pure functions -- no side effects or I/O.
 */

import type { RouteRequest, UserContext } from "../_shared/types.ts";

// ---------------------------------------------------------------------------
// Language label mapping
// ---------------------------------------------------------------------------

const LANGUAGE_LABELS: Record<string, { name: string; instruction: string }> = {
  tr: {
    name: "Turkce",
    instruction: "Tum icerik Turkce olmali.",
  },
  en: {
    name: "English",
    instruction: "All content must be in English.",
  },
};

// ---------------------------------------------------------------------------
// Travel style descriptions (used to guide the LLM's focus)
// ---------------------------------------------------------------------------

const STYLE_DESCRIPTIONS: Record<string, string> = {
  historical:
    "The user loves history, ancient sites, museums, and culturally significant landmarks. Prioritize historically rich locations.",
  food: "The user is a foodie who wants to explore local cuisine, street food, restaurants, food markets, and culinary experiences. Prioritize food-centric stops.",
  adventure:
    "The user seeks adventure, outdoor activities, unique experiences, and off-the-beaten-path locations. Prioritize exciting and active stops.",
  nature:
    "The user enjoys nature, parks, gardens, scenic viewpoints, and peaceful outdoor spaces. Prioritize natural beauty and green spaces.",
  mixed:
    "The user wants a balanced mix of history, food, culture, and sightseeing. Provide variety across categories.",
};

// ---------------------------------------------------------------------------
// Transport mode descriptions
// ---------------------------------------------------------------------------

const TRANSPORT_DESCRIPTIONS: Record<string, string> = {
  walking:
    "The user will walk between all stops. Keep distances between consecutive stops reasonable (under 20 minutes walk). Cluster stops geographically.",
  public:
    "The user will use public transit (metro, tram, bus, ferry). Stops can be further apart but should be near transit stations.",
  car: "The user has a car. Stops can be spread across the city or region. Include parking availability notes when relevant.",
  mixed:
    "The user will use a combination of walking and public transit. Central stops can be walking distance; outer stops via transit.",
};

// ---------------------------------------------------------------------------
// Budget descriptions
// ---------------------------------------------------------------------------

const BUDGET_DESCRIPTIONS: Record<string, string> = {
  budget:
    "The user is on a tight budget. Prioritize free attractions, street food, affordable restaurants, and free viewpoints. Mention entry fees.",
  mid: "The user has a moderate budget. Include a mix of free and paid attractions, mid-range restaurants, and reasonable experiences.",
  premium:
    "The user has a generous budget. Include premium experiences, fine dining, skip-the-line attractions, and exclusive spots.",
};

// ---------------------------------------------------------------------------
// JSON schema definition for the LLM output
// ---------------------------------------------------------------------------

const OUTPUT_SCHEMA = `{
  "title": "string — A creative, catchy route title (e.g. '3 Days in Istanbul: Bazaars, Bosphorus & Beyond')",
  "days": [
    {
      "dayNumber": "number — 1-indexed day number",
      "title": "string — Short thematic title for the day (e.g. 'Old City & Grand Bazaar')",
      "stops": [
        {
          "stopOrder": "number — 1-indexed global position across ALL days",
          "placeName": "string — Official name of the place",
          "category": "string — One of: landmark, restaurant, cafe, museum, park, market, hidden_gem, viewpoint, religious, shopping, entertainment, other",
          "description": "string — 2-3 sentence engaging description of the place",
          "insiderTip": "string — A local insider tip that most tourists would not know",
          "funFact": "string — An interesting, surprising fun fact about this place",
          "bestTime": "string — Best time of day to visit (e.g. 'Early morning before 10am')",
          "warnings": "string | null — Any important warnings (closures, dress codes, crowds)",
          "estimatedDurationMin": "number — Suggested visit duration in minutes (15-180)",
          "entryFee": "string — Entry fee description (e.g. 'Free', '200 TRY adults')",
          "suggestedStartTime": "string — HH:MM format local time",
          "suggestedEndTime": "string — HH:MM format local time",
          "travelFromPreviousMin": "number | null — Travel time from previous stop in minutes (null for first stop of each day)",
          "discoveryPoints": "number — Gamification points: 5 (common tourist spot) to 25 (hidden gem)"
        }
      ]
    }
  ]
}`;

// ---------------------------------------------------------------------------
// System prompt
// ---------------------------------------------------------------------------

/**
 * Builds the system prompt that defines the AI's role and constraints.
 *
 * The system prompt is language-agnostic; language is controlled in the
 * user prompt so the same system prompt works for all languages.
 */
export function buildSystemPrompt(): string {
  return `You are Geez AI, an expert travel route planner with deep local knowledge of cities around the world.

Your core principles:
1. ONLY recommend REAL places that actually exist. Never invent or hallucinate place names.
2. Provide accurate, up-to-date information. If unsure about opening hours or prices, say so.
3. Optimize stop ordering for geographic proximity and time of day (e.g. markets in the morning, viewpoints at sunset).
4. Each day should have a natural, enjoyable flow — avoid zigzagging across the city.
5. Include a healthy mix of popular landmarks and hidden gems.
6. Be conversational, surprising, and locally-informed in your descriptions.
7. Always respect the user's transport mode when planning distances between stops.
8. Provide realistic timing — include travel time between stops.

Output format:
- You MUST respond with valid JSON only — no markdown, no explanation, no wrapping.
- Follow the exact JSON schema provided in the user prompt.
- Do not include any text before or after the JSON object.`;
}

// ---------------------------------------------------------------------------
// Personalization context builder
// ---------------------------------------------------------------------------

/**
 * Explorer tier label mapping for prompt readability.
 */
const TIER_LABELS: Record<string, string> = {
  tourist: "beginner traveler",
  traveler: "experienced traveler",
  explorer: "seasoned explorer",
  local: "local-level expert",
  legend: "legendary explorer",
};

/**
 * Persona level label (1-10 scale) for prompt readability.
 */
function personaLabel(level: number): string {
  if (level >= 8) return "very high";
  if (level >= 6) return "high";
  if (level >= 4) return "moderate";
  if (level >= 2) return "low";
  return "minimal";
}

/**
 * Builds a personalization prompt block from the user's Memory Agent context.
 *
 * Returns an empty string when context is null or contains no meaningful data,
 * so the route generation degrades gracefully for new users.
 *
 * @param ctx - The UserContext from the Memory Agent (may be null).
 * @returns A formatted prompt section, or empty string.
 */
export function buildPersonalizationBlock(ctx: UserContext | null): string {
  if (!ctx) return "";

  const sections: string[] = [];

  // --- Profile section ---
  if (ctx.profile) {
    const p = ctx.profile;
    const profileParts: string[] = [];

    if (p.ageGroup) profileParts.push(`Age group: ${p.ageGroup}`);
    if (p.travelCompanion) profileParts.push(`Traveling: ${p.travelCompanion}`);
    if (p.morningPerson !== undefined) {
      profileParts.push(p.morningPerson ? "Morning person (prefers early starts)" : "Night owl (prefers later starts)");
    }
    if (p.crowdTolerance) profileParts.push(`Crowd tolerance: ${p.crowdTolerance}`);
    if (p.preferredActivities.length > 0) {
      profileParts.push(`Preferred activities: ${p.preferredActivities.join(", ")}`);
    }

    // Food preferences
    const activeFood = Object.entries(p.foodPreferences)
      .filter(([_, enabled]) => enabled)
      .map(([pref]) => pref.replace(/_/g, " "));
    if (activeFood.length > 0) {
      profileParts.push(`Food preferences: ${activeFood.join(", ")}`);
    }

    if (profileParts.length > 0) {
      sections.push(`User profile:\n${profileParts.map((l) => `- ${l}`).join("\n")}`);
    }
  }

  // --- Persona section ---
  if (ctx.persona) {
    const pe = ctx.persona;
    const tierLabel = TIER_LABELS[pe.explorerTier] ?? pe.explorerTier;
    const personaParts = [
      `Explorer tier: ${tierLabel} (score: ${pe.discoveryScore})`,
    ];

    // Only include persona levels that are meaningful (>= 3)
    const levels: [string, number][] = [
      ["Foodie", pe.foodieLevel],
      ["History buff", pe.historyBuffLevel],
      ["Nature lover", pe.natureLoverLevel],
      ["Adventure seeker", pe.adventureSeekerLevel],
      ["Culture explorer", pe.cultureExplorerLevel],
    ];
    const significantLevels = levels
      .filter(([_, level]) => level >= 3)
      .sort((a, b) => b[1] - a[1]);

    if (significantLevels.length > 0) {
      personaParts.push(
        `Persona strengths: ${significantLevels.map(([name, level]) => `${name} (${personaLabel(level)})`).join(", ")}`
      );
    }

    sections.push(`Travel persona:\n${personaParts.map((l) => `- ${l}`).join("\n")}`);
  }

  // --- Pace preference ---
  sections.push(`Inferred pace preference: ${ctx.pacePreference}`);

  // --- Strong preferences ---
  if (ctx.strongPreferences.length > 0) {
    sections.push(
      `Strongly preferred categories (based on past ratings): ${ctx.strongPreferences.join(", ")}`
    );
  }

  // --- Previously visited places in this city (avoid repeats) ---
  // This is injected so the LLM avoids recommending places the user has already seen.
  // We filter to the request city in buildRoutePrompt, not here.

  // --- Recently visited cities (context for variety) ---
  if (ctx.visitedPlaces.length > 0) {
    const recentCities = [
      ...new Set(ctx.visitedPlaces.slice(0, 20).map((p) => p.city)),
    ].slice(0, 5);
    if (recentCities.length > 0) {
      sections.push(`Recently visited cities: ${recentCities.join(", ")}`);
    }
  }

  if (sections.length === 0) return "";

  return `\n=== USER PERSONALIZATION (from Memory Agent) ===\n${sections.join("\n\n")}\n\nUse this context to personalize the route: adjust categories, pacing, food stops, ` +
    `and hidden gem ratio to match the user's preferences. If the user has a high foodie level, ` +
    `include more food-related stops. If they have low crowd tolerance, prefer quieter times ` +
    `and less touristy alternatives. Adapt the pace to their preference.`;
}

/**
 * Builds a block listing places the user has already visited in the target
 * city, so the LLM can avoid recommending them again.
 *
 * @param ctx  - The UserContext (may be null).
 * @param city - The target city for this route request.
 * @returns A formatted prompt section, or empty string.
 */
function buildAlreadyVisitedBlock(
  ctx: UserContext | null,
  city: string
): string {
  if (!ctx || ctx.visitedPlaces.length === 0) return "";

  const cityLower = city.toLowerCase().trim();
  const visitedInCity = ctx.visitedPlaces
    .filter((p) => p.city.toLowerCase().trim() === cityLower)
    .map((p) => p.placeName);

  if (visitedInCity.length === 0) return "";

  return (
    `\n=== ALREADY VISITED (avoid these places) ===\n` +
    `The user has already visited these places in ${city}. ` +
    `Do NOT include them in the route. Suggest alternatives instead:\n` +
    visitedInCity.map((name) => `- ${name}`).join("\n")
  );
}

// ---------------------------------------------------------------------------
// User prompt
// ---------------------------------------------------------------------------

/**
 * Builds the user prompt with all route parameters and constraints.
 *
 * When a UserContext is provided, personalization blocks are injected between
 * the trip parameters and output requirements. This allows the LLM to adapt
 * the route to the user's preferences, pace, and history without changing
 * the base prompt structure.
 *
 * @param request    - The validated RouteRequest from the client.
 * @param userContext - Optional UserContext from the Memory Agent.
 * @returns A fully-formed user prompt string.
 */
export function buildRoutePrompt(
  request: RouteRequest,
  userContext?: UserContext | null
): string {
  const lang = request.language ?? "tr";
  const langInfo = LANGUAGE_LABELS[lang] ?? LANGUAGE_LABELS["tr"];
  const styleDesc = STYLE_DESCRIPTIONS[request.travelStyle] ?? STYLE_DESCRIPTIONS["mixed"];
  const transportDesc = TRANSPORT_DESCRIPTIONS[request.transportMode] ?? TRANSPORT_DESCRIPTIONS["mixed"];
  const budgetDesc = BUDGET_DESCRIPTIONS[request.budgetLevel] ?? BUDGET_DESCRIPTIONS["mid"];

  const stopsPerDay = request.travelStyle === "food" ? "5-7" : "4-6";

  const preferencesBlock =
    request.preferences && request.preferences.length > 0
      ? `\nAdditional user preferences:\n${request.preferences.map((p) => `- ${p}`).join("\n")}`
      : "";

  // Personalization blocks (empty strings for new users / no context)
  const personalizationBlock = buildPersonalizationBlock(userContext ?? null);
  const alreadyVisitedBlock = buildAlreadyVisitedBlock(
    userContext ?? null,
    request.city
  );

  return `Plan a ${request.durationDays}-day travel route in ${request.city}, ${request.country}.

=== TRIP PARAMETERS ===
- City: ${request.city}
- Country: ${request.country}
- Duration: ${request.durationDays} day(s)
- Travel style: ${request.travelStyle} — ${styleDesc}
- Transport: ${request.transportMode} — ${transportDesc}
- Budget: ${request.budgetLevel} — ${budgetDesc}
- Daily start time: ${request.startTime}
${preferencesBlock}${personalizationBlock}${alreadyVisitedBlock}

=== OUTPUT LANGUAGE ===
${langInfo.instruction}
All place descriptions, insider tips, fun facts, warnings, and day titles must be in ${langInfo.name}.
Place names should remain in their original/local form (do not translate place names).

=== REQUIREMENTS ===
1. Generate exactly ${request.durationDays} day(s), with ${stopsPerDay} stops per day.
2. stop_order must be globally sequential across all days (day 1 stop 1 = 1, day 1 stop 2 = 2, day 2 stop 1 = 3, etc.).
3. First stop of each day should start at ${request.startTime}. Last stop should end by 20:00-21:00.
4. Include realistic travel times between consecutive stops.
5. travelFromPreviousMin should be null for the first stop of each day.
6. discoveryPoints: 5-10 for well-known tourist spots, 10-15 for interesting local favorites, 15-25 for true hidden gems.
7. estimatedDurationMin: realistic visit time (restaurants: 45-90min, museums: 60-120min, viewpoints: 15-30min, markets: 30-60min).
8. Each day should have a thematic coherence and geographic clustering.
9. Include at least 1 hidden_gem category stop per day.
10. entryFee should use the local currency symbol.

=== JSON SCHEMA ===
Respond with ONLY this JSON structure (no markdown fences, no extra text):

${OUTPUT_SCHEMA}

Generate the route now.`;
}
