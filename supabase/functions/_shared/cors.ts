/**
 * cors.ts
 *
 * CORS headers and preflight request handling for all Geez AI Edge Functions.
 *
 * In development, all origins are allowed. In production, the
 * ALLOWED_ORIGINS environment variable should be set to a
 * comma-separated list of permitted origins (e.g. the Flutter app
 * deep-link scheme + the Supabase dashboard origin).
 *
 * Usage:
 *   import { corsHeaders, handleCors } from '../_shared/cors.ts';
 *
 *   const preflight = handleCors(req);
 *   if (preflight) return preflight;
 *
 *   return new Response(body, { headers: { ...corsHeaders(), 'Content-Type': 'application/json' } });
 */

/** Default permissive headers used during development. */
const DEFAULT_CORS_HEADERS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-request-id",
  "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
  "Access-Control-Max-Age": "86400",
};

/**
 * Returns CORS response headers.
 *
 * When the ALLOWED_ORIGINS environment variable is set (production),
 * the Access-Control-Allow-Origin header is restricted to that list.
 * Only the first matching origin is echoed back; a wildcard is never
 * used when the env var is present so that credentials can be included.
 *
 * @param requestOrigin - Value of the incoming Origin header (optional).
 * @returns A plain object of CORS headers ready to spread into a Response.
 */
export function corsHeaders(requestOrigin?: string): Record<string, string> {
  const allowedOriginsEnv = Deno.env.get("ALLOWED_ORIGINS");

  if (!allowedOriginsEnv) {
    // Development: allow everything.
    return { ...DEFAULT_CORS_HEADERS };
  }

  const allowedOrigins = allowedOriginsEnv
    .split(",")
    .map((o) => o.trim())
    .filter(Boolean);

  // If the request origin is not in the allow-list, omit the
  // Access-Control-Allow-Origin header so the browser blocks the request.
  if (!requestOrigin || !allowedOrigins.includes(requestOrigin)) {
    const { "Access-Control-Allow-Origin": _, ...rest } = DEFAULT_CORS_HEADERS;
    return { ...rest, Vary: "Origin" };
  }

  return {
    ...DEFAULT_CORS_HEADERS,
    "Access-Control-Allow-Origin": requestOrigin,
    // Vary must be set when echoing the origin so caches don't serve the
    // wrong CORS header to a different origin.
    Vary: "Origin",
  };
}

/**
 * Handles an HTTP OPTIONS preflight request.
 *
 * Returns a 204 No Content Response with CORS headers if the request
 * method is OPTIONS, otherwise returns null so the caller can continue
 * with the actual handler.
 *
 * @param req - The incoming Request object.
 * @returns A Response for preflight requests, or null for all others.
 */
export function handleCors(req: Request): Response | null {
  if (req.method !== "OPTIONS") {
    return null;
  }

  const origin = req.headers.get("Origin") ?? undefined;

  return new Response(null, {
    status: 204,
    headers: corsHeaders(origin),
  });
}
