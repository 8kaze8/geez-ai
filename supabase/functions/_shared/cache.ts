/**
 * cache.ts
 *
 * AI Route Cache helpers for Geez AI Edge Functions.
 *
 * All operations target the public.ai_route_cache table via a service-role
 * client so that RLS is bypassed — cache entries are shared across users
 * and are never user-owned rows.
 *
 * Cache key format  : city:travelStyle:budgetLevel:transportMode:language
 *                     (all lowercase, trimmed — built by buildCacheKey)
 * Default TTL       : 7 days
 * Lazy cleanup      : cleanExpiredCache() is triggered with 10% probability
 *                     after each cache write; callers must not await it.
 *
 * Error policy      : every exported function catches its own errors and
 *                     returns a safe fallback value (null / void / 0) so
 *                     that a cache failure NEVER blocks route generation.
 */

import { type SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";
import { buildCacheKey, type RouteCacheKey, type RouteResponse } from "./types.ts";

// ---------------------------------------------------------------------------
// Internal types — ai_route_cache row shape
// ---------------------------------------------------------------------------

/**
 * Raw database row returned by a SELECT on public.ai_route_cache.
 *
 * Fields that are not used by the cache layer (id, city, country, …) are
 * omitted; we only project what we actually read.
 */
interface AiRouteCacheRow {
  route_data: RouteResponse;
  expires_at: string;
  ai_model_used: string | null;
  hit_count: number;
}

// ---------------------------------------------------------------------------
// getCachedRoute
// ---------------------------------------------------------------------------

/**
 * Attempts to retrieve a cached RouteResponse from the ai_route_cache table.
 *
 * Steps:
 *  1. Derives the canonical cache key via buildCacheKey.
 *  2. Selects the matching row (if any).
 *  3. Returns null when the row is absent or expires_at < now().
 *  4. Fires an async hit_count increment (not awaited — best effort).
 *  5. Returns the parsed RouteResponse on a cache hit.
 *
 * @param serviceClient - Service-role Supabase client (RLS bypass).
 * @param key           - Decomposed cache key components.
 * @returns The cached RouteResponse, or null on miss / error.
 */
export async function getCachedRoute(
  serviceClient: SupabaseClient,
  key: RouteCacheKey
): Promise<RouteResponse | null> {
  try {
    const cacheKey = buildCacheKey(key);

    const { data, error } = await serviceClient
      .from("ai_route_cache")
      .select("route_data, expires_at, ai_model_used, hit_count")
      .eq("cache_key", cacheKey)
      .maybeSingle<AiRouteCacheRow>();

    if (error) {
      console.warn("[cache] getCachedRoute select error:", error.message);
      return null;
    }

    if (!data) {
      return null; // Cache miss — no row found.
    }

    // Enforce TTL on the application side as a defence-in-depth measure.
    // The pg_cron job may not have run yet when we hit an expired row.
    if (new Date(data.expires_at) < new Date()) {
      console.info("[cache] Stale cache entry skipped:", cacheKey);
      return null;
    }

    // Increment hit_count asynchronously — we do not await so that the
    // main request is not delayed by this analytics write.
    incrementHitCount(serviceClient, cacheKey, data.hit_count).catch(
      (err: unknown) =>
        console.warn("[cache] hit_count increment failed (non-fatal):", err)
    );

    console.info("[cache] Cache hit:", cacheKey);
    return data.route_data;
  } catch (err: unknown) {
    console.error("[cache] getCachedRoute unexpected error (non-fatal):", err);
    return null;
  }
}

// ---------------------------------------------------------------------------
// setCachedRoute
// ---------------------------------------------------------------------------

/**
 * Options accepted by setCachedRoute.
 */
export interface SetCacheOptions {
  /**
   * How many days until the entry expires.
   * Defaults to 7 days, matching the DB column default.
   */
  ttlDays?: number;
}

/**
 * Inserts or updates an ai_route_cache entry for the given key.
 *
 * Uses UPSERT on the cache_key unique constraint so that re-generating a
 * route for the same key refreshes the TTL and replaces the payload.
 *
 * Also triggers lazy cleanup of expired entries with 10% probability
 * (fire-and-forget — the caller must not await this side effect).
 *
 * @param serviceClient - Service-role Supabase client (RLS bypass).
 * @param key           - Decomposed cache key components.
 * @param routeData     - The RouteResponse to cache.
 * @param options       - Optional overrides (e.g. ttlDays).
 */
export async function setCachedRoute(
  serviceClient: SupabaseClient,
  key: RouteCacheKey,
  routeData: RouteResponse,
  options: SetCacheOptions = {}
): Promise<void> {
  try {
    const { ttlDays = 7 } = options;
    const cacheKey = buildCacheKey(key);

    // Compute expiry timestamp in ISO 8601.
    const expiresAt = new Date(
      Date.now() + ttlDays * 24 * 60 * 60 * 1000
    ).toISOString();

    const { error } = await serviceClient
      .from("ai_route_cache")
      .upsert(
        {
          cache_key: cacheKey,
          // Decomposed key parts stored for analytics queries.
          city: key.city.toLowerCase().trim(),
          // country is required by the DB schema; derive from routeData.
          // The schema stores it separately even though it is not part of
          // the lookup key in buildCacheKey.
          country: routeData.country.toLowerCase().trim(),
          travel_style: key.travelStyle,
          transport_mode: key.transportMode,
          budget_level: key.budgetLevel,
          language: key.language.toLowerCase(),
          route_data: routeData,
          ai_model_used: routeData.aiModelUsed,
          expires_at: expiresAt,
          last_hit_at: null,
        },
        {
          onConflict: "cache_key",
          // On conflict we want to refresh all mutable fields.
          ignoreDuplicates: false,
        }
      );

    if (error) {
      console.warn("[cache] setCachedRoute upsert error (non-fatal):", error.message);
      return;
    }

    console.info(
      `[cache] Cached route — key: ${cacheKey}, ttlDays: ${ttlDays}, model: ${routeData.aiModelUsed}`
    );

    // Lazy cleanup: with 10% probability, purge expired rows in the background.
    // Fire-and-forget — the caller must not await this.
    if (Math.random() < 0.1) {
      cleanExpiredCache(serviceClient).catch((err: unknown) =>
        console.warn("[cache] lazy cleanup failed (non-fatal):", err)
      );
    }
  } catch (err: unknown) {
    // Cache write failure must NEVER propagate to the caller.
    console.error("[cache] setCachedRoute unexpected error (non-fatal):", err);
  }
}

// ---------------------------------------------------------------------------
// cleanExpiredCache
// ---------------------------------------------------------------------------

/**
 * Deletes all rows from ai_route_cache where expires_at < now().
 *
 * This is a lightweight maintenance operation. It is called lazily from
 * setCachedRoute (10% probability) and may also be called explicitly from
 * a scheduled Edge Function or admin endpoint.
 *
 * @param serviceClient - Service-role Supabase client (RLS bypass).
 * @returns Number of rows deleted, or 0 on error.
 */
export async function cleanExpiredCache(
  serviceClient: SupabaseClient
): Promise<number> {
  try {
    // Supabase JS v2 does not expose a row count from delete() directly.
    // We first count the matching rows, then delete them.
    const { count, error: countError } = await serviceClient
      .from("ai_route_cache")
      .select("id", { count: "exact", head: true })
      .lt("expires_at", new Date().toISOString());

    if (countError) {
      console.warn("[cache] cleanExpiredCache count error:", countError.message);
      return 0;
    }

    const rowsToDelete = count ?? 0;
    if (rowsToDelete === 0) {
      return 0;
    }

    const { error: deleteError } = await serviceClient
      .from("ai_route_cache")
      .delete()
      .lt("expires_at", new Date().toISOString());

    if (deleteError) {
      console.warn("[cache] cleanExpiredCache delete error:", deleteError.message);
      return 0;
    }

    console.info(`[cache] Cleaned ${rowsToDelete} expired cache entries.`);
    return rowsToDelete;
  } catch (err: unknown) {
    console.error("[cache] cleanExpiredCache unexpected error (non-fatal):", err);
    return 0;
  }
}

// ---------------------------------------------------------------------------
// getCacheStats
// ---------------------------------------------------------------------------

/**
 * Aggregate statistics over the ai_route_cache table.
 *
 * Intended for monitoring dashboards and cost-tracking analytics.
 * All values are computed on the database side via a raw SQL call to avoid
 * pulling every row over the wire.
 *
 * @param serviceClient - Service-role Supabase client (RLS bypass).
 * @returns Cache stats object, or zeroed values on error.
 */
export async function getCacheStats(
  serviceClient: SupabaseClient
): Promise<{ totalEntries: number; hitRate: number; avgHitCount: number }> {
  const zero = { totalEntries: 0, hitRate: 0, avgHitCount: 0 };

  try {
    // Use a single aggregation query to keep it one round-trip.
    // hit_rate: fraction of entries that have been hit at least once.
    const { data, error } = await serviceClient.rpc("get_cache_stats");

    if (error) {
      // RPC may not exist in all environments; fall back to a JS-side query.
      console.warn(
        "[cache] getCacheStats rpc unavailable, falling back to JS aggregation:",
        error.message
      );
      return await getCacheStatsJs(serviceClient);
    }

    // RPC RETURNS TABLE → supabase-js returns an array, not a single object.
    const rows = data as Array<{
      total_entries: number;
      hit_rate: number;
      avg_hit_count: number;
    }> | null;

    const row = rows?.[0];
    if (!row) return zero;

    return {
      totalEntries: row.total_entries ?? 0,
      hitRate: row.hit_rate ?? 0,
      avgHitCount: row.avg_hit_count ?? 0,
    };
  } catch (err: unknown) {
    console.error("[cache] getCacheStats unexpected error (non-fatal):", err);
    return zero;
  }
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/**
 * JavaScript-side fallback aggregation for getCacheStats when the RPC
 * function is not available.
 *
 * Fetches only the hit_count column for all rows (no large payloads).
 *
 * @param serviceClient - Service-role Supabase client.
 * @returns Computed stats object, or zeroed values on error.
 */
async function getCacheStatsJs(
  serviceClient: SupabaseClient
): Promise<{ totalEntries: number; hitRate: number; avgHitCount: number }> {
  const zero = { totalEntries: 0, hitRate: 0, avgHitCount: 0 };

  try {
    const { data, error } = await serviceClient
      .from("ai_route_cache")
      .select("hit_count");

    if (error || !data) {
      console.warn("[cache] getCacheStatsJs select error:", error?.message);
      return zero;
    }

    const rows = data as Array<{ hit_count: number }>;
    const total = rows.length;
    if (total === 0) return zero;

    const hitsAtLeastOnce = rows.filter((r) => r.hit_count > 0).length;
    const sumHits = rows.reduce((acc, r) => acc + r.hit_count, 0);

    return {
      totalEntries: total,
      hitRate: hitsAtLeastOnce / total,
      avgHitCount: sumHits / total,
    };
  } catch (err: unknown) {
    console.error("[cache] getCacheStatsJs unexpected error (non-fatal):", err);
    return zero;
  }
}

/**
 * Increments the hit_count and updates last_hit_at for a cache entry.
 *
 * Tries an atomic RPC first (increment_cache_hit_count). Falls back to a
 * read-then-write update — the minor race condition is acceptable for
 * analytics counters that are fire-and-forget.
 *
 * Called after a cache hit. Callers must not await and must attach .catch().
 *
 * @param serviceClient - Service-role Supabase client.
 * @param cacheKey      - The canonical cache key string.
 * @param currentCount  - The hit_count value read from the SELECT.
 */
async function incrementHitCount(
  serviceClient: SupabaseClient,
  cacheKey: string,
  currentCount: number
): Promise<void> {
  // Attempt atomic increment via RPC first.
  const { error: rpcError } = await serviceClient.rpc(
    "increment_cache_hit_count",
    { p_cache_key: cacheKey }
  );

  if (!rpcError) return;

  // Fallback: read-then-write (minor race acceptable for analytics).
  const { error } = await serviceClient
    .from("ai_route_cache")
    .update({
      hit_count: currentCount + 1,
      last_hit_at: new Date().toISOString(),
    })
    .eq("cache_key", cacheKey);

  if (error) {
    // Non-fatal: analytics write failure should not surface to users.
    throw new Error(`hit_count update failed: ${error.message}`);
  }
}
