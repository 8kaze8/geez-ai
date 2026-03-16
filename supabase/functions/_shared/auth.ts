/**
 * auth.ts
 *
 * JWT verification and user identity helpers for Geez AI Edge Functions.
 *
 * Every function that operates on user data must call verifyAuth() first.
 * It validates the Bearer token present in the Authorization header against
 * Supabase Auth and returns the authenticated user's id and full User object.
 *
 * Usage:
 *   import { verifyAuth } from '../_shared/auth.ts';
 *
 *   const { userId, user } = await verifyAuth(req, supabaseClient);
 */

import type { SupabaseClient, User } from "https://esm.sh/@supabase/supabase-js@2";
import { AppError } from "./error-handler.ts";

/** Shape returned by a successful verifyAuth() call. */
export interface AuthResult {
  /** Supabase Auth UUID for the authenticated user. */
  userId: string;
  /** Full Supabase User object. */
  user: User;
}

/**
 * Extracts the Bearer token from the Authorization header.
 *
 * @param req - The incoming Request.
 * @returns The raw JWT string.
 * @throws AppError(401) if the header is missing or malformed.
 */
export function extractBearerToken(req: Request): string {
  const authHeader = req.headers.get("Authorization");

  if (!authHeader) {
    throw new AppError(
      "MISSING_AUTH_HEADER",
      "Authorization header is required.",
      401
    );
  }

  const parts = authHeader.split(" ");
  if (parts.length !== 2 || parts[0].toLowerCase() !== "bearer") {
    throw new AppError(
      "INVALID_AUTH_HEADER",
      "Authorization header must be in 'Bearer <token>' format.",
      401
    );
  }

  const token = parts[1].trim();
  if (!token) {
    throw new AppError(
      "EMPTY_AUTH_TOKEN",
      "Bearer token must not be empty.",
      401
    );
  }

  return token;
}

/**
 * Verifies the JWT token from the Authorization header using the provided
 * Supabase client (which should already be initialised with the token).
 *
 * The function calls supabase.auth.getUser() which validates the token
 * signature against Supabase Auth and returns the user record.
 *
 * @param req           - The incoming Request (used only to read the header).
 * @param supabaseClient - A SupabaseClient initialised with the user's token
 *                         so that auth.getUser() validates the correct JWT.
 * @returns An AuthResult containing the userId string and the User object.
 * @throws AppError(401) if the token is invalid, expired, or the user is not
 *         found.
 */
export async function verifyAuth(
  req: Request,
  supabaseClient: SupabaseClient
): Promise<AuthResult> {
  // Ensure the header is present and well-formed, then pass the token
  // directly to getUser(). The Edge Function client is stateless
  // (persistSession: false) so there is no internal session — getUser()
  // without a token argument will always fail.
  const token = extractBearerToken(req);

  const { data, error } = await supabaseClient.auth.getUser(token);

  if (error || !data.user) {
    console.error("[auth] Token verification failed");
    throw new AppError(
      "UNAUTHORIZED",
      error?.message ?? "Invalid or expired authentication token.",
      401
    );
  }

  return {
    userId: data.user.id,
    user: data.user,
  };
}

/**
 * Builds a 401 Unauthorized JSON Response.
 *
 * Use this as a last-resort fallback when you cannot throw (e.g. in a
 * top-level catch that runs before error-handler.ts is available).
 *
 * @param message - Human-readable explanation.
 * @param headers - Additional headers to include (e.g. CORS headers).
 * @returns A Response with status 401.
 */
export function unauthorizedResponse(
  message = "Unauthorized.",
  headers: Record<string, string> = {}
): Response {
  return new Response(
    JSON.stringify({
      error: {
        code: "UNAUTHORIZED",
        message,
      },
    }),
    {
      status: 401,
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
    }
  );
}
