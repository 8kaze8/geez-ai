/**
 * user-context/index.ts
 *
 * Edge Function: GET /functions/v1/user-context
 *
 * Assembles the authenticated user's full Memory Agent context:
 *
 *   1. CORS preflight handling
 *   2. JWT authentication
 *   3. Rate-limit check (shared counter: "user_context")
 *   4. Fetch user data from five tables in parallel:
 *      - public.users          -> subscription_tier, language
 *      - public.user_profiles  -> preferences, pace, activities, food prefs
 *      - public.travel_personas -> persona levels, discovery score, tier
 *      - public.visited_places -> recent places (limit 100)
 *      - public.trip_feedback  -> recent feedback (limit 10)
 *   5. Derive pacePreference (majority vote from pace_feedback history)
 *   6. Derive strongPreferences (categories with 3+ highly-rated places)
 *   7. Return assembled UserContext as JSON
 *
 * The returned UserContext is consumed by:
 *   - Flutter client (profile screens, persona display)
 *   - generate-route (prompt personalization, inline)
 *   - Future agent endpoints (research, content enrichment)
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
import { fetchUserContext } from "../_shared/user-context.ts";
import {
  checkFrequencyLimit,
  frequencyLimitResponse,
} from "../_shared/rate-limit.ts";

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
    if (req.method !== "GET") {
      throw new AppError(
        "METHOD_NOT_ALLOWED",
        `Method ${req.method} is not allowed. Use GET.`,
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
    // 4. Frequency rate limit (20 req/min per user)
    // -----------------------------------------------------------------------
    if (!checkFrequencyLimit("user-context", userId)) {
      console.warn(
        `[user-context] Frequency limit exceeded for userId=${userId}`
      );
      return frequencyLimitResponse("user-context", origin);
    }

    // -----------------------------------------------------------------------
    // 5. Fetch and assemble UserContext
    // -----------------------------------------------------------------------
    console.info(
      `[user-context] Fetching context for user=${userId}`
    );

    const startTime = Date.now();
    const userContext = await fetchUserContext(serviceClient, userId);
    const fetchMs = Date.now() - startTime;

    console.info(
      `[user-context] Context assembled for user=${userId} in ${fetchMs}ms ` +
        `(${userContext.visitedPlaces.length} places, ` +
        `${userContext.recentFeedback.length} feedback, ` +
        `pace=${userContext.pacePreference}, ` +
        `strongPrefs=[${userContext.strongPreferences.join(",")}])`
    );

    // -----------------------------------------------------------------------
    // 6. Return response
    // -----------------------------------------------------------------------
    return new Response(JSON.stringify(userContext), {
      status: 200,
      headers: {
        ...corsHeaders(origin),
        "Content-Type": "application/json",
        "X-Fetch-Ms": String(fetchMs),
      },
    });
  })
);
