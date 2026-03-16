/**
 * rate-limit.ts
 *
 * Monthly usage-based rate limiting for Geez AI Edge Functions.
 *
 * Reads and writes the public.usage_tracking table using a service-role
 * client (bypasses RLS) so that the Edge Function can atomically check and
 * increment counters regardless of the user's RLS policies.
 *
 * Free tier  : 3 routes per calendar month.
 * Premium    : effectively unlimited (routes_limit = 9999 as set in the DB).
 *
 * Usage:
 *   import { checkRateLimit, incrementUsage } from '../_shared/rate-limit.ts';
 *
 *   const { allowed, remaining, limit } = await checkRateLimit(
 *     serviceClient, userId, 'generate_route'
 *   );
 *   if (!allowed) return rateLimitResponse(remaining, limit);
 *
 *   // ... do work ...
 *
 *   await incrementUsage(serviceClient, userId, 'generate_route');
 */

import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";
import { AppError } from "./error-handler.ts";
import { corsHeaders } from "./cors.ts";

// ---------------------------------------------------------------------------
// In-memory sliding window rate limiter (per-request frequency throttling)
// ---------------------------------------------------------------------------

/**
 * Configuration for a frequency throttle window.
 *
 * windowMs  — Rolling window duration in milliseconds.
 * maxRequests — Maximum requests allowed within that window.
 */
interface FrequencyLimitConfig {
  windowMs: number;
  maxRequests: number;
}

/**
 * Per-user request timestamps, keyed by "endpoint:userId".
 *
 * Stored in module-level memory so the state persists across requests
 * within the same Deno isolate. Individual Deno isolates are ephemeral
 * (they may be restarted by the runtime), so this is a best-effort guard,
 * not a distributed lock. For production-grade cross-isolate limiting,
 * replace with a Redis/Upstash check.
 */
const _requestLog = new Map<string, number[]>();

/**
 * Named endpoint configurations.
 *
 * Add new entries here when additional endpoints need frequency throttling.
 * Keys match the names passed to checkFrequencyLimit().
 */
const ENDPOINT_CONFIGS: Record<string, FrequencyLimitConfig> = {
  chat: { windowMs: 60_000, maxRequests: 30 },
  "user-context": { windowMs: 60_000, maxRequests: 20 },
};

/**
 * Checks whether a user has exceeded the per-minute request frequency for
 * the given endpoint.
 *
 * Uses a sliding window algorithm: timestamps older than windowMs are pruned
 * before the count is evaluated.
 *
 * @param endpoint - The endpoint name key (must exist in ENDPOINT_CONFIGS).
 * @param userId   - The authenticated user's UUID.
 * @returns `true` when the request is allowed, `false` when throttled.
 * @throws Error if the endpoint name is unknown.
 */
export function checkFrequencyLimit(endpoint: string, userId: string): boolean {
  const config = ENDPOINT_CONFIGS[endpoint];
  if (!config) {
    throw new Error(`Unknown endpoint for frequency limiting: ${endpoint}`);
  }

  const key = `${endpoint}:${userId}`;
  const now = Date.now();
  const windowStart = now - config.windowMs;

  // Retrieve and prune stale timestamps
  const timestamps = (_requestLog.get(key) ?? []).filter(
    (t) => t > windowStart
  );

  if (timestamps.length >= config.maxRequests) {
    // Over the limit — do NOT record this attempt
    _requestLog.set(key, timestamps);
    return false;
  }

  // Under the limit — record this timestamp and allow
  timestamps.push(now);
  _requestLog.set(key, timestamps);
  return true;
}

/**
 * Builds a 429 Too Many Requests response for per-minute frequency throttling.
 *
 * The Turkish message is the canonical user-facing copy used by both the
 * chat and user-context endpoints. A Retry-After header is set to 60 s
 * (the window duration) as a hint to the Flutter client.
 *
 * @param endpoint - Endpoint name, used to derive the human-readable limit.
 * @param origin   - Optional Origin header value for CORS echoing.
 * @returns A Response with status 429.
 */
export function frequencyLimitResponse(
  endpoint: string,
  origin?: string
): Response {
  const config = ENDPOINT_CONFIGS[endpoint];
  const limit = config?.maxRequests ?? 0;
  const windowSec = Math.round((config?.windowMs ?? 60_000) / 1000);

  return new Response(
    JSON.stringify({
      error: {
        code: "FREQUENCY_LIMIT_EXCEEDED",
        message: `Cok fazla istek gonderdiniz. Lutfen ${windowSec} saniye bekleyip tekrar deneyin.`,
        details: {
          limit_per_window: limit,
          window_seconds: windowSec,
        },
      },
    }),
    {
      status: 429,
      headers: {
        ...corsHeaders(origin),
        "Content-Type": "application/json",
        "Retry-After": String(windowSec),
        "X-RateLimit-Limit": String(limit),
        "X-RateLimit-Window": String(windowSec),
      },
    }
  );
}

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/** Default monthly limit applied to free-tier users. */
const FREE_TIER_LIMIT = 3;

/** Effective limit stored in the DB for premium users. */
const PREMIUM_LIMIT = 9999;

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/** Result returned by checkRateLimit(). */
export interface RateLimitResult {
  /** Whether the action is permitted right now. */
  allowed: boolean;
  /** How many more actions the user can perform this month. */
  remaining: number;
  /** The user's monthly limit. */
  limit: number;
  /** Routes generated so far this month. */
  used: number;
}

/** Shape of a row in public.usage_tracking. */
interface UsageTrackingRow {
  id: string;
  user_id: string;
  period_year: number;
  period_month: number;
  routes_generated: number;
  routes_limit: number;
  tier_at_period_start: string;
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

function currentPeriod(): { year: number; month: number } {
  const now = new Date();
  return { year: now.getUTCFullYear(), month: now.getUTCMonth() + 1 };
}

/**
 * Returns the user's current subscription tier from public.users.
 * Falls back to 'free' if the row is not found or the query fails.
 */
async function getUserTier(
  client: SupabaseClient,
  userId: string
): Promise<"free" | "premium"> {
  const { data, error } = await client
    .from("users")
    .select("subscription_tier")
    .eq("id", userId)
    .single();

  if (error || !data) return "free";
  return data.subscription_tier === "premium" ? "premium" : "free";
}

/**
 * Fetches or creates the usage_tracking row for the current calendar month.
 *
 * On first access for a given month the row is created with routes_generated
 * set to 0 and routes_limit set according to the user's current tier.
 */
async function getOrCreateUsageRow(
  client: SupabaseClient,
  userId: string
): Promise<UsageTrackingRow> {
  const { year, month } = currentPeriod();
  const tier = await getUserTier(client, userId);
  const limit = tier === "premium" ? PREMIUM_LIMIT : FREE_TIER_LIMIT;

  // Upsert: insert if missing, do nothing on conflict (keep existing counts).
  const { error: upsertError } = await client.from("usage_tracking").upsert(
    {
      user_id: userId,
      period_year: year,
      period_month: month,
      routes_generated: 0,
      routes_limit: limit,
      tier_at_period_start: tier,
    },
    { onConflict: "user_id,period_year,period_month", ignoreDuplicates: true }
  );

  if (upsertError) {
    throw new AppError(
      "USAGE_TRACKING_ERROR",
      "Failed to initialise usage tracking row.",
      500,
      upsertError.message
    );
  }

  const { data, error } = await client
    .from("usage_tracking")
    .select("*")
    .eq("user_id", userId)
    .eq("period_year", year)
    .eq("period_month", month)
    .single();

  if (error || !data) {
    throw new AppError(
      "USAGE_TRACKING_ERROR",
      "Failed to read usage tracking row.",
      500,
      error?.message
    );
  }

  return data as UsageTrackingRow;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * Checks whether the user is allowed to perform the given action based on
 * their current monthly usage.
 *
 * Currently the only tracked action is 'generate_route'. The action
 * parameter is accepted for forward-compatibility but all actions map to the
 * routes_generated counter for now.
 *
 * @param client  - A Supabase client with service-role privileges (bypasses RLS).
 * @param userId  - The authenticated user's UUID.
 * @param _action - The action being attempted (reserved for future use).
 * @returns A RateLimitResult describing the current quota state.
 * @throws AppError(500) if the DB query fails.
 */
export async function checkRateLimit(
  client: SupabaseClient,
  userId: string,
  _action: string
): Promise<RateLimitResult> {
  const row = await getOrCreateUsageRow(client, userId);

  const used = row.routes_generated;
  const limit = row.routes_limit;
  const allowed = used < limit;
  const remaining = Math.max(0, limit - used);

  return { allowed, remaining, limit, used };
}

/**
 * Increments the routes_generated counter for the current calendar month.
 *
 * Should be called after a route has been successfully generated, not before,
 * so that failed generations do not consume quota.
 *
 * @param client  - A Supabase client with service-role privileges.
 * @param userId  - The authenticated user's UUID.
 * @param _action - Reserved for future multi-action tracking.
 * @throws AppError(500) if the DB update fails.
 */
export async function incrementUsage(
  client: SupabaseClient,
  userId: string,
  _action: string
): Promise<void> {
  const { year, month } = currentPeriod();

  const { error } = await client.rpc("increment_routes_generated", {
    p_user_id: userId,
    p_year: year,
    p_month: month,
  });

  if (error) {
    // Fallback: read current value, then update with +1.
    // Not perfectly atomic but acceptable as a fallback when the RPC is
    // not yet deployed.  The RPC is the preferred path.
    const row = await getOrCreateUsageRow(client, userId);
    const { error: updateError } = await client
      .from("usage_tracking")
      .update({ routes_generated: row.routes_generated + 1 })
      .eq("user_id", userId)
      .eq("period_year", year)
      .eq("period_month", month);

    if (updateError) {
      // Non-fatal: log and continue so the user gets their route even if
      // the counter increment fails. This avoids blocking on a counter bug.
      console.error("[rate-limit] Failed to increment usage counter:", updateError);
    }
  }
}

// ---------------------------------------------------------------------------
// 429 response helper
// ---------------------------------------------------------------------------

/**
 * Builds a 429 Too Many Requests JSON Response.
 *
 * Includes Retry-After (first day of next month) and X-RateLimit-* headers
 * so the Flutter client can display meaningful upgrade prompts.
 *
 * @param remaining - Routes remaining this month (will be 0).
 * @param limit     - The user's monthly limit.
 * @param origin    - Optional Origin header value for CORS echoing.
 * @returns A Response with status 429.
 */
export function rateLimitResponse(
  remaining: number,
  limit: number,
  origin?: string
): Response {
  const now = new Date();
  const firstOfNextMonth = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1)
  );
  const retryAfterSeconds = Math.ceil(
    (firstOfNextMonth.getTime() - now.getTime()) / 1000
  );

  return new Response(
    JSON.stringify({
      error: {
        code: "RATE_LIMIT_EXCEEDED",
        message: `You have used all ${limit} routes for this month. Upgrade to Premium for unlimited routes.`,
        details: {
          limit,
          remaining,
          reset_at: firstOfNextMonth.toISOString(),
        },
      },
    }),
    {
      status: 429,
      headers: {
        ...corsHeaders(origin),
        "Content-Type": "application/json",
        "Retry-After": String(retryAfterSeconds),
        "X-RateLimit-Limit": String(limit),
        "X-RateLimit-Remaining": String(remaining),
        "X-RateLimit-Reset": firstOfNextMonth.toISOString(),
      },
    }
  );
}
