/**
 * generate-route/index.ts
 *
 * Edge Function: POST /functions/v1/generate-route
 *
 * Orchestrates the V1 AI route generation pipeline:
 *
 *   1. CORS preflight handling
 *   2. JWT authentication
 *   3. Monthly rate-limit check (free: 3/mo, premium: unlimited)
 *   4. Request body parsing + validation
 *   5. Cache lookup (city:style:budget:transport:language)
 *   6. AI route generation via the model router (fallback chain)
 *   7. Persist route + stops to the database
 *   8. Write cache entry (fire-and-forget)
 *   9. Increment usage counter
 *  10. Return the RouteResponse to the client
 *
 * All errors are caught by withErrorHandler and serialised into the
 * canonical { error: { code, message, details? } } envelope.
 */

import { corsHeaders, handleCors } from "../_shared/cors.ts";
import { AppError, withErrorHandler } from "../_shared/error-handler.ts";
import { verifyAuth } from "../_shared/auth.ts";
import {
  createServiceClient,
  createUserClient,
} from "../_shared/supabase-client.ts";
import {
  checkRateLimit,
  incrementUsage,
  rateLimitResponse,
} from "../_shared/rate-limit.ts";
import { getCachedRoute, setCachedRoute } from "../_shared/cache.ts";
import { routeToModel } from "../_shared/model-router.ts";
import type {
  RouteRequest,
  RouteResponse,
  RouteCacheKey,
  DayPlan,
  StopData,
  AiProvider,
} from "../_shared/types.ts";
import type { LLMResponse } from "../_shared/model-router.ts";
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

import { validateRouteRequest } from "./validator.ts";
import { buildSystemPrompt, buildRoutePrompt } from "./prompts.ts";

// ---------------------------------------------------------------------------
// Cost estimation
// ---------------------------------------------------------------------------

/**
 * Per-token pricing in USD for cost tracking.
 *
 * These are approximate list prices as of early 2026.  The values are only
 * used for the generation_cost_usd metadata field -- they do not affect
 * billing.  Update when model pricing changes.
 */
const MODEL_PRICING: Record<string, { input: number; output: number }> = {
  // Gemini 2.5 Flash
  "gemini-2.5-flash": { input: 0.00000015, output: 0.0000006 },
  // OpenAI GPT-4.1-mini
  "gpt-4.1-mini": { input: 0.0000004, output: 0.0000016 },
  // OpenAI GPT-4.1-nano
  "gpt-4.1-nano": { input: 0.0000001, output: 0.0000004 },
  // Anthropic Claude Haiku
  "claude-haiku-4-5-20251001": { input: 0.0000008, output: 0.000004 },
};

/**
 * Calculates the estimated generation cost from the LLM response usage data.
 *
 * @param llmResponse - The response from routeToModel().
 * @returns Cost in USD, rounded to 5 decimal places.
 */
function calculateCost(llmResponse: LLMResponse): number {
  const pricing = MODEL_PRICING[llmResponse.model];
  if (!pricing) {
    // Unknown model -- return 0 rather than throwing.
    console.warn(
      `[generate-route] Unknown model for cost calc: ${llmResponse.model}`
    );
    return 0;
  }

  const cost =
    llmResponse.usage.inputTokens * pricing.input +
    llmResponse.usage.outputTokens * pricing.output;

  // Round to 5 decimal places to match generation_cost_usd NUMERIC(8,5).
  return Math.round(cost * 100_000) / 100_000;
}

// ---------------------------------------------------------------------------
// AI route generation
// ---------------------------------------------------------------------------

/**
 * Raw shape that the LLM returns within its JSON response.
 * This is parsed and then transformed into our domain types.
 */
interface LLMRouteOutput {
  title: string;
  days: Array<{
    dayNumber: number;
    title: string;
    stops: Array<{
      stopOrder: number;
      placeName: string;
      category: string;
      description: string;
      insiderTip: string;
      funFact: string;
      bestTime: string;
      warnings: string | null;
      estimatedDurationMin: number;
      entryFee: string;
      suggestedStartTime: string;
      suggestedEndTime: string;
      travelFromPreviousMin: number | null;
      discoveryPoints: number;
    }>;
  }>;
}

/**
 * Calls the LLM via the model router and parses the structured JSON
 * response into a RouteResponse.
 *
 * @param request - The validated RouteRequest.
 * @returns A fully-formed RouteResponse (without routeId -- that comes from DB).
 */
async function generateRouteWithAI(
  request: RouteRequest
): Promise<{ response: Omit<RouteResponse, "routeId" | "createdAt">; llmResponse: LLMResponse }> {
  // 1. Build prompts
  const systemPrompt = buildSystemPrompt();
  const userPrompt = buildRoutePrompt(request);

  // 2. Call LLM via model router (with fallback chain)
  const llmResponse = await routeToModel({
    taskType: "route_generation",
    systemPrompt,
    messages: [{ role: "user", content: userPrompt }],
    jsonMode: true,
    temperature: 0.7,
    maxTokens: 4000,
  });

  // 3. Parse JSON response
  let parsed: LLMRouteOutput;
  try {
    // Some models may wrap JSON in markdown fences -- strip them.
    let content = llmResponse.content.trim();
    if (content.startsWith("```")) {
      content = content.replace(/^```(?:json)?\s*/, "").replace(/\s*```$/, "");
    }
    parsed = JSON.parse(content) as LLMRouteOutput;
  } catch {
    throw new AppError(
      "AI_PARSE_ERROR",
      "Failed to parse AI response as valid JSON.",
      502,
      { rawContent: llmResponse.content.substring(0, 500) }
    );
  }

  // 4. Basic structural validation
  if (!parsed.title || !Array.isArray(parsed.days) || parsed.days.length === 0) {
    throw new AppError(
      "AI_INVALID_STRUCTURE",
      "AI response is missing required fields (title, days).",
      502,
      { parsed: JSON.stringify(parsed).substring(0, 500) }
    );
  }

  // 5. Transform to RouteResponse format
  const days: DayPlan[] = parsed.days.map((day) => ({
    dayNumber: day.dayNumber,
    title: day.title,
    stops: day.stops.map((stop): StopData => ({
      dayNumber: day.dayNumber,
      stopOrder: stop.stopOrder,
      placeName: stop.placeName,
      category: normalizeCategory(stop.category),
      description: stop.description,
      insiderTip: stop.insiderTip,
      funFact: stop.funFact,
      bestTime: stop.bestTime,
      warnings: stop.warnings ?? undefined,
      estimatedDurationMin: stop.estimatedDurationMin,
      entryFee: stop.entryFee,
      suggestedStartTime: stop.suggestedStartTime,
      suggestedEndTime: stop.suggestedEndTime,
      travelFromPreviousMin: stop.travelFromPreviousMin ?? undefined,
      discoveryPoints: stop.discoveryPoints ?? 10,
    })),
  }));

  const costUsd = calculateCost(llmResponse);

  return {
    response: {
      title: parsed.title,
      city: request.city,
      country: request.country,
      durationDays: request.durationDays,
      days,
      aiModelUsed: llmResponse.provider as AiProvider,
      generationCostUsd: costUsd,
    },
    llmResponse,
  };
}

// ---------------------------------------------------------------------------
// Category normalisation
// ---------------------------------------------------------------------------

/** Valid categories in the route_stops table. */
const VALID_CATEGORIES = new Set([
  "landmark",
  "restaurant",
  "cafe",
  "museum",
  "park",
  "market",
  "hidden_gem",
  "viewpoint",
  "religious",
  "shopping",
  "entertainment",
  "beach",
  "other",
]);

/**
 * Normalises an AI-generated category string to one of the allowed DB values.
 * Falls back to "other" if the category is unrecognised.
 */
function normalizeCategory(raw: string): string {
  const lower = raw.toLowerCase().trim().replace(/\s+/g, "_");
  if (VALID_CATEGORIES.has(lower)) return lower;

  // Common AI-generated aliases
  const aliases: Record<string, string> = {
    historic: "landmark",
    historical: "landmark",
    monument: "landmark",
    "food_market": "market",
    bazaar: "market",
    garden: "park",
    nature: "park",
    mosque: "religious",
    church: "religious",
    temple: "religious",
    synagogue: "religious",
    bar: "entertainment",
    nightlife: "entertainment",
    theater: "entertainment",
    theatre: "entertainment",
    "hidden gem": "hidden_gem",
    hiddengem: "hidden_gem",
    "street_food": "restaurant",
    food: "restaurant",
    mall: "shopping",
    store: "shopping",
    beach: "beach",
    seaside: "beach",
    coastal: "beach",
    scenic: "viewpoint",
    panoramic: "viewpoint",
    "observation_deck": "viewpoint",
  };

  return aliases[lower] ?? "other";
}

// ---------------------------------------------------------------------------
// Database persistence
// ---------------------------------------------------------------------------

/**
 * Saves a generated route and its stops to the database.
 *
 * @param userClient  - Supabase client with the user's JWT (RLS enforced).
 * @param userId      - The authenticated user's UUID.
 * @param request     - The original RouteRequest.
 * @param routeData   - The generated route data (without routeId).
 * @param llmResponse - The raw LLM response for metadata logging.
 * @returns The UUID of the newly created route row.
 */
async function saveRouteToDb(
  userClient: SupabaseClient,
  userId: string,
  request: RouteRequest,
  routeData: Omit<RouteResponse, "routeId" | "createdAt">,
  llmResponse: LLMResponse
): Promise<{ routeId: string; createdAt: string }> {
  // 1. Insert into public.routes
  const { data: route, error: routeError } = await userClient
    .from("routes")
    .insert({
      user_id: userId,
      city: routeData.city,
      country: routeData.country,
      title: routeData.title,
      duration_days: routeData.durationDays,
      travel_style: request.travelStyle,
      transport_mode: request.transportMode,
      budget_level: request.budgetLevel,
      start_time: request.startTime,
      status: "draft",
      ai_model_used: `${llmResponse.provider}/${llmResponse.model}`,
      generation_cost_usd: routeData.generationCostUsd,
      language: request.language ?? "tr",
    })
    .select("id, created_at")
    .single();

  if (routeError || !route) {
    throw new AppError(
      "DB_INSERT_ERROR",
      `Failed to save route: ${routeError?.message ?? "No data returned."}`,
      500,
      { table: "routes" }
    );
  }

  // 2. Build route_stops rows
  const stopRows = routeData.days.flatMap((day: DayPlan) =>
    day.stops.map((stop: StopData) => ({
      route_id: route.id,
      day_number: stop.dayNumber,
      stop_order: stop.stopOrder,
      place_name: stop.placeName,
      place_id: stop.placeId ?? null,
      latitude: stop.latitude ?? null,
      longitude: stop.longitude ?? null,
      category: stop.category,
      description: stop.description ?? null,
      insider_tip: stop.insiderTip ?? null,
      fun_fact: stop.funFact ?? null,
      best_time: stop.bestTime ?? null,
      warnings: stop.warnings ?? null,
      google_rating: stop.googleRating ?? null,
      review_count: stop.reviewCount ?? null,
      review_summary: stop.reviewSummary ?? null,
      estimated_duration_min: stop.estimatedDurationMin ?? null,
      entry_fee_text: stop.entryFee ?? null,
      entry_fee_amount: stop.entryFeeAmount ?? null,
      entry_fee_currency: stop.entryFeeCurrency ?? null,
      travel_from_previous_min: stop.travelFromPreviousMin ?? null,
      travel_mode_from_previous: stop.travelModeFromPrevious ?? null,
      suggested_start_time: stop.suggestedStartTime ?? null,
      suggested_end_time: stop.suggestedEndTime ?? null,
      discovery_points: stop.discoveryPoints ?? 10,
    }))
  );

  // 3. Bulk insert stops
  if (stopRows.length > 0) {
    const { error: stopsError } = await userClient
      .from("route_stops")
      .insert(stopRows);

    if (stopsError) {
      // Route was created but stops failed -- log and throw so the client
      // knows the generation is incomplete.  The route row remains as a
      // draft and can be retried or cleaned up.
      console.error(
        "[generate-route] Failed to insert route_stops:",
        stopsError
      );
      throw new AppError(
        "DB_INSERT_ERROR",
        `Route saved but stops failed: ${stopsError.message}`,
        500,
        { table: "route_stops", routeId: route.id }
      );
    }
  }

  return { routeId: route.id, createdAt: route.created_at };
}

// ---------------------------------------------------------------------------
// Main handler
// ---------------------------------------------------------------------------

Deno.serve(
  withErrorHandler(async (req: Request): Promise<Response> => {
    // -----------------------------------------------------------------------
    // 1. CORS preflight
    // -----------------------------------------------------------------------
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;

    const origin = req.headers.get("Origin") ?? undefined;

    // -----------------------------------------------------------------------
    // 2. Method check
    // -----------------------------------------------------------------------
    if (req.method !== "POST") {
      throw new AppError(
        "METHOD_NOT_ALLOWED",
        `Method ${req.method} is not allowed. Use POST.`,
        405
      );
    }

    // -----------------------------------------------------------------------
    // 3. Auth verification
    // -----------------------------------------------------------------------
    const serviceClient = createServiceClient();
    const userClient = createUserClient(req);
    const { userId } = await verifyAuth(req, userClient);

    // -----------------------------------------------------------------------
    // 4. Rate limit check
    // -----------------------------------------------------------------------
    const rateLimit = await checkRateLimit(
      serviceClient,
      userId,
      "generate_route"
    );
    if (!rateLimit.allowed) {
      return rateLimitResponse(rateLimit.remaining, rateLimit.limit, origin);
    }

    // -----------------------------------------------------------------------
    // 5. Parse + validate request body
    // -----------------------------------------------------------------------
    let body: RouteRequest;
    try {
      body = await req.json();
    } catch {
      throw new AppError(
        "INVALID_JSON",
        "Request body must be valid JSON.",
        400
      );
    }
    validateRouteRequest(body);

    // Apply defaults
    if (!body.language) {
      body.language = "tr";
    }

    // -----------------------------------------------------------------------
    // 6. Cache check
    // -----------------------------------------------------------------------
    const cacheKey: RouteCacheKey = {
      city: body.city,
      country: body.country,
      travelStyle: body.travelStyle,
      budgetLevel: body.budgetLevel,
      transportMode: body.transportMode,
      language: body.language,
    };

    const cached = await getCachedRoute(serviceClient, cacheKey);
    if (cached) {
      console.info(
        `[generate-route] Cache hit for user=${userId} key=${body.city}:${body.country}:${body.travelStyle}`
      );

      // SECURITY: The cached RouteResponse contains the original user's
      // routeId — which this user cannot access due to RLS.  We must create
      // a fresh route + stops row owned by the current user, using the cached
      // AI data, and return the NEW routeId.
      //
      // The cached entry has generationCostUsd = 0 to indicate no new AI
      // tokens were consumed.  The LLM metadata fields are preserved from the
      // cached data so cost tracking stays consistent.
      const cachedRouteData: Omit<RouteResponse, "routeId" | "createdAt"> = {
        title: cached.title,
        city: cached.city,
        country: cached.country,
        durationDays: cached.durationDays,
        days: cached.days,
        aiModelUsed: cached.aiModelUsed,
        generationCostUsd: 0, // no new tokens consumed
      };

      // Synthesise a minimal LLMResponse so saveRouteToDb has metadata to log.
      // latencyMs and fallbackAttempts are set to sentinel values that make it
      // clear in the DB that this route was served from cache.
      const cachedLlmResponse: LLMResponse = {
        provider: cached.aiModelUsed,
        model: `${cached.aiModelUsed}/cached`,
        content: "",
        usage: { inputTokens: 0, outputTokens: 0 },
        latencyMs: 0,
        fallbackAttempts: 0,
      };

      const { routeId: newRouteId, createdAt: newCreatedAt } =
        await saveRouteToDb(
          userClient,
          userId,
          body,
          cachedRouteData,
          cachedLlmResponse
        );

      await incrementUsage(serviceClient, userId, "generate_route");

      const cacheHitResponse: RouteResponse = {
        ...cachedRouteData,
        routeId: newRouteId,
        createdAt: newCreatedAt,
      };

      console.info(
        `[generate-route] Cache-hit route ${newRouteId} created for user=${userId}`
      );

      return new Response(JSON.stringify(cacheHitResponse), {
        status: 200,
        headers: {
          ...corsHeaders(origin),
          "Content-Type": "application/json",
          "X-Cache": "HIT",
        },
      });
    }

    // -----------------------------------------------------------------------
    // 7. AI route generation
    // -----------------------------------------------------------------------
    console.info(
      `[generate-route] Generating route for user=${userId} city=${body.city} ` +
        `style=${body.travelStyle} days=${body.durationDays}`
    );

    const startTime = Date.now();
    const { response: routeData, llmResponse } = await generateRouteWithAI(body);
    const generationMs = Date.now() - startTime;

    console.info(
      `[generate-route] AI generation complete in ${generationMs}ms ` +
        `model=${llmResponse.provider}/${llmResponse.model} ` +
        `tokens_in=${llmResponse.usage.inputTokens} tokens_out=${llmResponse.usage.outputTokens} ` +
        `cost=$${routeData.generationCostUsd}`
    );

    // -----------------------------------------------------------------------
    // 8. Save to database
    // -----------------------------------------------------------------------
    const { routeId, createdAt } = await saveRouteToDb(
      userClient,
      userId,
      body,
      routeData,
      llmResponse
    );

    // -----------------------------------------------------------------------
    // 9. Cache write (fire-and-forget)
    // -----------------------------------------------------------------------
    const fullResponse: RouteResponse = {
      routeId,
      ...routeData,
      createdAt,
    };

    setCachedRoute(serviceClient, cacheKey, fullResponse).catch((err) =>
      console.warn("[generate-route] Cache write failed (non-fatal):", err)
    );

    // -----------------------------------------------------------------------
    // 10. Increment usage counter
    // -----------------------------------------------------------------------
    await incrementUsage(serviceClient, userId, "generate_route");

    // -----------------------------------------------------------------------
    // 11. Return response
    // -----------------------------------------------------------------------
    console.info(
      `[generate-route] Route ${routeId} created for user=${userId} ` +
        `(${routeData.days.reduce((sum, d) => sum + d.stops.length, 0)} stops, ` +
        `${routeData.durationDays} days)`
    );

    return new Response(JSON.stringify(fullResponse), {
      status: 200,
      headers: {
        ...corsHeaders(origin),
        "Content-Type": "application/json",
        "X-Cache": "MISS",
        "X-Generation-Ms": String(generationMs),
        "X-AI-Model": `${llmResponse.provider}/${llmResponse.model}`,
      },
    });
  })
);
