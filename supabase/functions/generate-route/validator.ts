/**
 * validator.ts
 *
 * Request validation for the generate-route Edge Function.
 *
 * Uses TypeScript assertion functions so the validated body is automatically
 * narrowed to RouteRequest after the call returns.  Every invalid field
 * throws an AppError(400) with a descriptive message and the field name
 * in `details`.
 */

import { AppError } from "../_shared/error-handler.ts";
import type { RouteRequest, TravelStyle, TransportMode, BudgetLevel } from "../_shared/types.ts";

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const VALID_TRAVEL_STYLES: TravelStyle[] = [
  "historical",
  "food",
  "adventure",
  "nature",
  "mixed",
];

const VALID_TRANSPORT_MODES: TransportMode[] = [
  "walking",
  "public",
  "car",
  "mixed",
];

const VALID_BUDGET_LEVELS: BudgetLevel[] = ["budget", "mid", "premium"];

const VALID_LANGUAGES = ["tr", "en"];

/** HH:MM 24-hour format. */
const TIME_REGEX = /^\d{2}:\d{2}$/;

const MIN_DURATION_DAYS = 1;
const MAX_DURATION_DAYS = 14;

/** Maximum allowed length for free-text fields (city, country). */
const MAX_TEXT_LENGTH = 100;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/**
 * Throws a 400 AppError for a specific field.
 */
function fieldError(field: string, message: string): never {
  throw new AppError("VALIDATION_ERROR", message, 400, { field });
}

/**
 * Asserts a value is a non-empty string.
 */
function requireString(value: unknown, field: string): asserts value is string {
  if (typeof value !== "string" || value.trim().length === 0) {
    fieldError(field, `"${field}" must be a non-empty string.`);
  }
}

/**
 * Asserts a value is one of the allowed enum values.
 */
function requireEnum<T extends string>(
  value: unknown,
  allowed: readonly T[],
  field: string
): asserts value is T {
  if (typeof value !== "string" || !allowed.includes(value as T)) {
    fieldError(
      field,
      `"${field}" must be one of: ${allowed.join(", ")}. Received: "${String(value)}".`
    );
  }
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * Validates and narrows an unknown request body to RouteRequest.
 *
 * @param body - The raw parsed JSON body.
 * @throws AppError(400) with field-level details for every validation failure.
 */
export function validateRouteRequest(
  body: unknown
): asserts body is RouteRequest {
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    throw new AppError(
      "VALIDATION_ERROR",
      "Request body must be a JSON object.",
      400
    );
  }

  const obj = body as Record<string, unknown>;

  // -- city (required, non-empty string, max length) --
  requireString(obj.city, "city");
  if ((obj.city as string).length > MAX_TEXT_LENGTH) {
    fieldError("city", `"city" must not exceed ${MAX_TEXT_LENGTH} characters.`);
  }

  // -- country (required, non-empty string, max length) --
  requireString(obj.country, "country");
  if ((obj.country as string).length > MAX_TEXT_LENGTH) {
    fieldError("country", `"country" must not exceed ${MAX_TEXT_LENGTH} characters.`);
  }

  // -- durationDays (required, integer 1-14) --
  if (
    typeof obj.durationDays !== "number" ||
    !Number.isInteger(obj.durationDays) ||
    obj.durationDays < MIN_DURATION_DAYS ||
    obj.durationDays > MAX_DURATION_DAYS
  ) {
    fieldError(
      "durationDays",
      `"durationDays" must be an integer between ${MIN_DURATION_DAYS} and ${MAX_DURATION_DAYS}.`
    );
  }

  // -- travelStyle (required, enum) --
  requireEnum(obj.travelStyle, VALID_TRAVEL_STYLES, "travelStyle");

  // -- transportMode (required, enum) --
  requireEnum(obj.transportMode, VALID_TRANSPORT_MODES, "transportMode");

  // -- budgetLevel (required, enum) --
  requireEnum(obj.budgetLevel, VALID_BUDGET_LEVELS, "budgetLevel");

  // -- startTime (required, HH:MM format) --
  requireString(obj.startTime, "startTime");
  if (!TIME_REGEX.test(obj.startTime as string)) {
    fieldError(
      "startTime",
      '"startTime" must be in HH:MM format (24-hour), e.g. "09:00".'
    );
  }
  // Validate hour/minute ranges
  const [hours, minutes] = (obj.startTime as string).split(":").map(Number);
  if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
    fieldError(
      "startTime",
      '"startTime" contains invalid hour or minute values.'
    );
  }

  // -- language (optional, default 'tr') --
  if (obj.language !== undefined && obj.language !== null) {
    requireEnum(obj.language, VALID_LANGUAGES, "language");
  }

  // -- preferences (optional, string array, max 10 items, 200 chars each) --
  if (obj.preferences !== undefined && obj.preferences !== null) {
    if (!Array.isArray(obj.preferences)) {
      fieldError("preferences", '"preferences" must be an array of strings.');
    }
    if (obj.preferences.length > 10) {
      fieldError(
        "preferences",
        '"preferences" must not contain more than 10 items.'
      );
    }
    for (let i = 0; i < obj.preferences.length; i++) {
      if (typeof obj.preferences[i] !== "string") {
        fieldError(
          "preferences",
          `"preferences[${i}]" must be a string.`
        );
      }
      if ((obj.preferences[i] as string).length > 200) {
        fieldError(
          "preferences",
          `"preferences[${i}]" must not exceed 200 characters.`
        );
      }
    }
  }
}
