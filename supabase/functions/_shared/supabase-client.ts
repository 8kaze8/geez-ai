/**
 * supabase-client.ts
 *
 * Supabase client factories for Geez AI Edge Functions.
 *
 * Two client flavours are provided:
 *
 *   createServiceClient()
 *     Uses the service-role key. Bypasses Row Level Security.
 *     Use only for admin operations: usage_tracking increments, cache
 *     writes, webhook handlers, etc.
 *     NEVER expose the service-role client or its key to end users.
 *
 *   createUserClient(req)
 *     Forwards the user's Bearer token so that all queries run under
 *     their RLS context. Use for any query that reads or writes user-
 *     owned rows (routes, profiles, feedback …).
 *
 * Usage:
 *   import { createServiceClient, createUserClient } from '../_shared/supabase-client.ts';
 *
 *   const serviceClient = createServiceClient();
 *   const userClient    = createUserClient(req);
 */

import {
  createClient,
  type SupabaseClient,
} from "https://esm.sh/@supabase/supabase-js@2";
import { AppError } from "./error-handler.ts";

// ---------------------------------------------------------------------------
// Environment helpers
// ---------------------------------------------------------------------------

/**
 * Reads a required environment variable and throws a descriptive AppError
 * if it is missing or empty. This surfaces misconfiguration immediately
 * rather than producing cryptic downstream errors.
 */
function requireEnv(name: string): string {
  const value = Deno.env.get(name);
  if (!value) {
    throw new AppError(
      "MISSING_ENV_VAR",
      `Required environment variable "${name}" is not set.`,
      500
    );
  }
  return value;
}

// ---------------------------------------------------------------------------
// Client factories
// ---------------------------------------------------------------------------

/**
 * Creates a Supabase client that authenticates as the service role.
 *
 * The service-role key bypasses all Row Level Security policies.
 * Use this client only for operations that legitimately require elevated
 * privileges (e.g. writing usage_tracking, ai_route_cache, or handling
 * RevenueCat webhooks).
 *
 * Required environment variables:
 *   SUPABASE_URL          — e.g. https://xxxx.supabase.co
 *   SUPABASE_SERVICE_ROLE_KEY — service role secret
 *
 * @returns A SupabaseClient authenticated as service role.
 * @throws AppError(500) if the required env vars are not set.
 */
export function createServiceClient(): SupabaseClient {
  const supabaseUrl = requireEnv("SUPABASE_URL");
  const serviceRoleKey = requireEnv("SUPABASE_SERVICE_ROLE_KEY");

  return createClient(supabaseUrl, serviceRoleKey, {
    auth: {
      // Disable auto-refresh — Edge Functions are stateless.
      autoRefreshToken: false,
      // Do not persist the session between invocations.
      persistSession: false,
      // Service role does not need user detection.
      detectSessionInUrl: false,
    },
  });
}

/**
 * Creates a Supabase client that operates under the authenticated user's
 * JWT token so that Row Level Security policies are enforced normally.
 *
 * The Bearer token is forwarded from the incoming request's Authorization
 * header. If the header is absent the client is still created but all
 * RLS-protected queries will fail — call verifyAuth() before using this
 * client to ensure the token is valid.
 *
 * Required environment variables:
 *   SUPABASE_URL      — e.g. https://xxxx.supabase.co
 *   SUPABASE_ANON_KEY — public anon key (safe to expose to clients)
 *
 * @param req - The incoming Edge Function Request.
 * @returns A SupabaseClient that forwards the user's JWT.
 * @throws AppError(500) if the required env vars are not set.
 */
export function createUserClient(req: Request): SupabaseClient {
  const supabaseUrl = requireEnv("SUPABASE_URL");
  const anonKey = requireEnv("SUPABASE_ANON_KEY");

  // Forward the Authorization header so Supabase Auth validates the JWT and
  // RLS `auth.uid()` returns the correct user id for every query.
  const authHeader = req.headers.get("Authorization") ?? "";

  return createClient(supabaseUrl, anonKey, {
    global: {
      headers: {
        Authorization: authHeader,
      },
    },
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false,
    },
  });
}
