/**
 * error-handler.ts
 *
 * Global error wrapper and structured error response helpers for Geez AI
 * Edge Functions.
 *
 * All Edge Function handlers should be wrapped with withErrorHandler() so
 * that any thrown error — whether an AppError or an unexpected runtime
 * exception — is serialised into the canonical JSON error envelope:
 *
 *   { "error": { "code": string, "message": string, "details"?: unknown } }
 *
 * Usage:
 *   import { withErrorHandler, AppError } from '../_shared/error-handler.ts';
 *
 *   serve(withErrorHandler(async (req) => {
 *     // handler logic — throw AppError for expected failures
 *     throw new AppError('NOT_FOUND', 'Route not found.', 404);
 *   }));
 */

import { corsHeaders } from "./cors.ts";

// ---------------------------------------------------------------------------
// AppError — typed, structured application errors
// ---------------------------------------------------------------------------

/**
 * Structured application error.
 *
 * Use this class when you want to control the HTTP status code and the
 * error code string that reaches the client. Generic Error instances are
 * caught by withErrorHandler() and mapped to 500 Internal Server Error.
 */
export class AppError extends Error {
  /** Machine-readable error code for the client (e.g. 'RATE_LIMIT_EXCEEDED'). */
  public readonly code: string;
  /** HTTP status code to send in the response. */
  public readonly statusCode: number;
  /** Optional extra detail (e.g. validation errors, field names). */
  public readonly details?: unknown;

  constructor(
    code: string,
    message: string,
    statusCode = 400,
    details?: unknown
  ) {
    super(message);
    this.name = "AppError";
    this.code = code;
    this.statusCode = statusCode;
    this.details = details;
  }
}

// ---------------------------------------------------------------------------
// HTTP status code mapping for generic errors
// ---------------------------------------------------------------------------

/**
 * Maps well-known error message substrings / names to HTTP status codes.
 * Used when a non-AppError is caught so we can return a reasonable status
 * instead of always 500.
 */
const GENERIC_STATUS_MAP: Array<[RegExp, number]> = [
  [/unauthorized|unauthenticated|invalid.*token|jwt/i, 401],
  [/forbidden|not allowed/i, 403],
  [/not found/i, 404],
  [/timeout|timed out/i, 504],
  [/too many requests|rate limit/i, 429],
  [/bad request|invalid input|validation/i, 400],
];

function statusCodeForError(err: Error): number {
  const text = `${err.name} ${err.message}`;
  for (const [pattern, code] of GENERIC_STATUS_MAP) {
    if (pattern.test(text)) return code;
  }
  return 500;
}

// ---------------------------------------------------------------------------
// Error response builder
// ---------------------------------------------------------------------------

/** Canonical JSON error envelope shape. */
export interface ErrorEnvelope {
  error: {
    code: string;
    message: string;
    details?: unknown;
  };
}

/**
 * Serialises an error into a JSON Response with the correct HTTP status and
 * CORS headers.
 *
 * @param err     - The error to serialise.
 * @param origin  - Optional incoming Origin header value for CORS echoing.
 * @returns A Response with Content-Type application/json.
 */
export function errorResponse(err: unknown, origin?: string): Response {
  let code = "INTERNAL_ERROR";
  let message = "An unexpected error occurred.";
  let statusCode = 500;
  let details: unknown;

  if (err instanceof AppError) {
    code = err.code;
    message = err.message;
    statusCode = err.statusCode;
    details = err.details;
  } else if (err instanceof Error) {
    code = err.name.toUpperCase().replace(/\s+/g, "_") || "INTERNAL_ERROR";
    message = err.message || "An unexpected error occurred.";
    statusCode = statusCodeForError(err);
  }

  const envelope: ErrorEnvelope = {
    error: {
      code,
      message,
      ...(details !== undefined ? { details } : {}),
    },
  };

  return new Response(JSON.stringify(envelope), {
    status: statusCode,
    headers: {
      ...corsHeaders(origin),
      "Content-Type": "application/json",
    },
  });
}

// ---------------------------------------------------------------------------
// withErrorHandler — handler wrapper
// ---------------------------------------------------------------------------

/**
 * Wraps an Edge Function handler with global error handling.
 *
 * The wrapper:
 *  1. Passes the request to the inner handler.
 *  2. If the handler throws, serialises the error with errorResponse().
 *  3. Always attaches CORS headers even on error paths so that the Flutter
 *     client receives a parseable response rather than a CORS failure.
 *
 * @param handler - The async Edge Function handler to wrap.
 * @returns A new async function with the same signature.
 *
 * @example
 * serve(withErrorHandler(async (req) => {
 *   const { userId } = await verifyAuth(req, client);
 *   return new Response(JSON.stringify({ userId }), { status: 200 });
 * }));
 */
export function withErrorHandler(
  handler: (req: Request) => Promise<Response>
): (req: Request) => Promise<Response> {
  return async (req: Request): Promise<Response> => {
    const origin = req.headers.get("Origin") ?? undefined;
    try {
      return await handler(req);
    } catch (err: unknown) {
      // Log to Supabase Edge Function logs for observability.
      console.error("[geez-ai] Unhandled error:", err);
      return errorResponse(err, origin);
    }
  };
}
