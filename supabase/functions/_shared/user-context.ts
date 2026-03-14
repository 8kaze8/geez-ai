/**
 * user-context.ts
 *
 * Shared helper that assembles a full UserContext from the database.
 *
 * This module is consumed by:
 *   - user-context/index.ts  (standalone Edge Function for the Flutter client)
 *   - generate-route/index.ts (inline enrichment before LLM calls)
 *
 * It reads across five tables using a service-role client (bypasses RLS) so
 * that cross-table joins work regardless of per-table policies:
 *   1. public.users          -> subscription_tier, language
 *   2. public.user_profiles  -> preferences, pace, food, crowd tolerance
 *   3. public.travel_personas -> persona levels, discovery score, tier
 *   4. public.visited_places -> recent places (limit 100)
 *   5. public.trip_feedback  -> recent feedback (limit 10)
 *
 * Derived fields:
 *   - pacePreference: majority vote from trip_feedback.pace_feedback history,
 *     falling back to user_profiles.pace_preference, then "normal".
 *   - strongPreferences: categories with 3+ highly-rated (>=4) visited places.
 *
 * All functions are pure data access -- no HTTP handling, no CORS, no auth
 * verification.  The caller is responsible for authentication.
 *
 * Usage:
 *   import { fetchUserContext } from '../_shared/user-context.ts';
 *
 *   const ctx = await fetchUserContext(serviceClient, userId);
 */

import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";
import type {
  UserContext,
  UserProfileSnapshot,
  TravelPersonaSnapshot,
  VisitedPlaceSnapshot,
  TripFeedbackSnapshot,
  PacePreference,
} from "./types.ts";

// ---------------------------------------------------------------------------
// Internal row types (match DB column names)
// ---------------------------------------------------------------------------

/** Raw row shape from public.user_profiles. */
interface UserProfileRow {
  age_group: string | null;
  travel_companion: string | null;
  default_budget: string | null;
  preferred_activities: string[];
  food_preferences: Record<string, boolean>;
  pace_preference: string;
  morning_person: boolean;
  crowd_tolerance: string;
}

/** Raw row shape from public.travel_personas. */
interface TravelPersonaRow {
  foodie_level: number;
  history_buff_level: number;
  nature_lover_level: number;
  adventure_seeker_level: number;
  culture_explorer_level: number;
  discovery_score: number;
  explorer_tier: string;
}

/** Raw row shape from public.visited_places (selected columns). */
interface VisitedPlaceRow {
  place_id: string | null;
  place_name: string;
  city: string;
  country: string;
  category: string | null;
  user_rating: number | null;
  visited_at: string | null;
}

/** Raw row shape from public.trip_feedback (selected columns). */
interface TripFeedbackRow {
  route_id: string;
  overall_rating: number | null;
  pace_feedback: string | null;
  created_at: string;
}

// ---------------------------------------------------------------------------
// Data fetchers (parallel)
// ---------------------------------------------------------------------------

/**
 * Fetches the user_profiles row for the given user.
 *
 * @param client - Service-role Supabase client.
 * @param userId - The authenticated user's UUID.
 * @returns The profile row or null if not found.
 */
async function fetchProfile(
  client: SupabaseClient,
  userId: string
): Promise<UserProfileSnapshot | null> {
  const { data, error } = await client
    .from("user_profiles")
    .select(
      "age_group, travel_companion, default_budget, preferred_activities, " +
        "food_preferences, pace_preference, morning_person, crowd_tolerance"
    )
    .eq("user_id", userId)
    .maybeSingle();

  if (error) {
    console.error("[user-context] Failed to fetch user_profiles:", error);
    return null;
  }
  if (!data) return null;

  const row = data as UserProfileRow;

  return {
    ageGroup: row.age_group ?? undefined,
    travelCompanion: row.travel_companion ?? undefined,
    defaultBudget: (row.default_budget as UserProfileSnapshot["defaultBudget"]) ?? undefined,
    preferredActivities: Array.isArray(row.preferred_activities)
      ? row.preferred_activities
      : [],
    foodPreferences:
      row.food_preferences && typeof row.food_preferences === "object"
        ? row.food_preferences
        : {},
    pacePreference: (row.pace_preference as PacePreference) ?? "normal",
    morningPerson: row.morning_person ?? true,
    crowdTolerance:
      (row.crowd_tolerance as UserProfileSnapshot["crowdTolerance"]) ?? "medium",
  };
}

/**
 * Fetches the travel_personas row for the given user.
 *
 * @param client - Service-role Supabase client.
 * @param userId - The authenticated user's UUID.
 * @returns The persona snapshot or null if not found.
 */
async function fetchPersona(
  client: SupabaseClient,
  userId: string
): Promise<TravelPersonaSnapshot | null> {
  const { data, error } = await client
    .from("travel_personas")
    .select(
      "foodie_level, history_buff_level, nature_lover_level, " +
        "adventure_seeker_level, culture_explorer_level, " +
        "discovery_score, explorer_tier"
    )
    .eq("user_id", userId)
    .maybeSingle();

  if (error) {
    console.error("[user-context] Failed to fetch travel_personas:", error);
    return null;
  }
  if (!data) return null;

  const row = data as TravelPersonaRow;

  return {
    foodieLevel: row.foodie_level,
    historyBuffLevel: row.history_buff_level,
    natureLoverLevel: row.nature_lover_level,
    adventureSeekerLevel: row.adventure_seeker_level,
    cultureExplorerLevel: row.culture_explorer_level,
    discoveryScore: row.discovery_score,
    explorerTier: row.explorer_tier,
  };
}

/**
 * Fetches the most recent visited places for the given user.
 *
 * @param client - Service-role Supabase client.
 * @param userId - The authenticated user's UUID.
 * @param limit  - Maximum number of rows to return (default 100).
 * @returns An array of visited place snapshots, ordered by visited_at DESC.
 */
async function fetchVisitedPlaces(
  client: SupabaseClient,
  userId: string,
  limit = 100
): Promise<VisitedPlaceSnapshot[]> {
  const { data, error } = await client
    .from("visited_places")
    .select("place_id, place_name, city, country, category, user_rating, visited_at")
    .eq("user_id", userId)
    .order("visited_at", { ascending: false, nullsFirst: false })
    .limit(limit);

  if (error) {
    console.error("[user-context] Failed to fetch visited_places:", error);
    return [];
  }
  if (!data) return [];

  return (data as VisitedPlaceRow[]).map((row) => ({
    placeId: row.place_id ?? undefined,
    placeName: row.place_name,
    city: row.city,
    country: row.country,
    category: row.category ?? undefined,
    userRating: row.user_rating ?? undefined,
    visitedAt: row.visited_at ?? undefined,
  }));
}

/**
 * Fetches the most recent trip feedback entries for the given user.
 *
 * @param client - Service-role Supabase client.
 * @param userId - The authenticated user's UUID.
 * @param limit  - Maximum number of rows to return (default 10).
 * @returns An array of feedback snapshots, ordered by created_at DESC.
 */
async function fetchRecentFeedback(
  client: SupabaseClient,
  userId: string,
  limit = 10
): Promise<TripFeedbackSnapshot[]> {
  const { data, error } = await client
    .from("trip_feedback")
    .select("route_id, overall_rating, pace_feedback, created_at")
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) {
    console.error("[user-context] Failed to fetch trip_feedback:", error);
    return [];
  }
  if (!data) return [];

  return (data as TripFeedbackRow[]).map((row) => ({
    routeId: row.route_id,
    overallRating: row.overall_rating ?? undefined,
    paceFeedback:
      (row.pace_feedback as TripFeedbackSnapshot["paceFeedback"]) ?? undefined,
    createdAt: row.created_at,
  }));
}

// ---------------------------------------------------------------------------
// Derived field computation
// ---------------------------------------------------------------------------

/**
 * Derives the user's pace preference from feedback history via majority vote.
 *
 * Counts occurrences of each pace_feedback value across all feedback entries.
 * If no feedback exists, falls back to the profile's pace_preference.
 * If no profile exists, defaults to "normal".
 *
 * @param feedback - Recent trip feedback entries.
 * @param profile  - User profile snapshot (may be null).
 * @returns The inferred PacePreference.
 */
export function derivePacePreference(
  feedback: TripFeedbackSnapshot[],
  profile: UserProfileSnapshot | null
): PacePreference {
  const counts: Record<string, number> = {
    too_intense: 0,
    just_right: 0,
    too_slow: 0,
  };

  for (const entry of feedback) {
    if (entry.paceFeedback && entry.paceFeedback in counts) {
      counts[entry.paceFeedback]++;
    }
  }

  const totalVotes = counts.too_intense + counts.just_right + counts.too_slow;

  if (totalVotes === 0) {
    // No feedback with pace data -- fall back to profile, then default.
    return profile?.pacePreference ?? "normal";
  }

  // Majority vote mapping:
  //   too_intense wins  -> user prefers "relaxed" (they found routes too intense)
  //   just_right wins   -> user prefers "normal"  (current pace is fine)
  //   too_slow wins     -> user prefers "intense"  (they want more stops/faster pace)
  if (counts.too_intense >= counts.just_right && counts.too_intense >= counts.too_slow) {
    return "relaxed";
  }
  if (counts.too_slow >= counts.just_right && counts.too_slow >= counts.too_intense) {
    return "intense";
  }
  return "normal";
}

/**
 * Derives strongly preferred activity categories from visited places history.
 *
 * A category is considered a "strong preference" when the user has visited
 * 3 or more places in that category with a rating of 4 or higher.
 *
 * @param visitedPlaces - Array of visited place snapshots.
 * @returns An array of category strings that the user strongly prefers.
 */
export function deriveStrongPreferences(
  visitedPlaces: VisitedPlaceSnapshot[]
): string[] {
  const categoryCounts: Record<string, number> = {};

  for (const place of visitedPlaces) {
    if (
      place.category &&
      place.userRating !== undefined &&
      place.userRating >= 4
    ) {
      categoryCounts[place.category] = (categoryCounts[place.category] ?? 0) + 1;
    }
  }

  const STRONG_THRESHOLD = 3;

  return Object.entries(categoryCounts)
    .filter(([_, count]) => count >= STRONG_THRESHOLD)
    .map(([category]) => category)
    .sort();
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * Assembles a full UserContext by reading from all relevant database tables
 * in parallel and computing derived fields.
 *
 * This is the primary entry point for both the user-context Edge Function
 * and inline usage from generate-route.
 *
 * @param serviceClient - A Supabase client with service-role privileges
 *                        (bypasses RLS for cross-table reads).
 * @param userId        - The authenticated user's UUID.
 * @returns A complete UserContext object ready for prompt injection.
 */
export async function fetchUserContext(
  serviceClient: SupabaseClient,
  userId: string
): Promise<UserContext> {
  // Fetch all data sources in parallel for minimum latency.
  const [profile, persona, visitedPlaces, recentFeedback] = await Promise.all([
    fetchProfile(serviceClient, userId),
    fetchPersona(serviceClient, userId),
    fetchVisitedPlaces(serviceClient, userId, 100),
    fetchRecentFeedback(serviceClient, userId, 10),
  ]);

  // Derive fields from the raw data.
  const pacePreference = derivePacePreference(recentFeedback, profile);
  const strongPreferences = deriveStrongPreferences(visitedPlaces);

  return {
    userId,
    profile,
    persona,
    visitedPlaces,
    recentFeedback,
    pacePreference,
    strongPreferences,
  };
}
