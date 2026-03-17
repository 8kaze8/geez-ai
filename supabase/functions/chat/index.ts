/**
 * chat/index.ts
 *
 * Edge Function handler for the Geez AI conversational Q&A flow.
 *
 * The chat function powers a step-by-step conversation that collects the
 * parameters needed for AI route generation: city, travel style, transport
 * mode, budget level, and trip duration.
 *
 * Flow:
 *   Step 0 — User names a city      -> AI confirms, asks travel style
 *   Step 1 — User picks style       -> AI confirms, asks transport
 *   Step 2 — User picks transport   -> AI confirms, asks budget
 *   Step 3 — User picks budget      -> AI confirms, asks duration
 *   Step 4 — User picks duration    -> AI summarises, asks to generate
 *   Step 5+ — Complete              -> extractedParams returned
 *
 * Model: GPT-4.1-nano via routeToModel (qa_flow task type) — cheapest tier.
 *
 * POST /functions/v1/chat
 * Authorization: Bearer <supabase-jwt>
 * Body: { messages: ChatMessage[], currentStep: number, language?: string }
 */

import { withErrorHandler, AppError } from "../_shared/error-handler.ts";
import { handleCors, corsHeaders } from "../_shared/cors.ts";
import { createUserClient } from "../_shared/supabase-client.ts";
import { verifyAuth } from "../_shared/auth.ts";
import { routeToModel } from "../_shared/model-router.ts";
import {
  checkFrequencyLimit,
  frequencyLimitResponse,
} from "../_shared/rate-limit.ts";
import { sanitizeUserInput } from "../_shared/sanitize.ts";
import type { ChatMessage, RouteRequest } from "../_shared/types.ts";
import type {
  ChatRequest,
  ChatResponse,
  LLMStepResponse,
  LLMExtractionResponse,
} from "./types.ts";
import {
  buildChatSystemPrompt,
  buildStepPrompt,
  buildExtractionPrompt,
} from "./prompts.ts";

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/**
 * Maximum number of messages allowed per request.
 *
 * Chat messages use GPT-4.1-nano and are cheap, but we guard against
 * runaway session sizes. A single conversation collecting route params
 * should never exceed this; it is a safety ceiling, not a quota.
 */
const MAX_MESSAGES = 50;

/** Maximum step index (inclusive). */
const MAX_STEP = 4;

/** Token budget for Q&A step responses. */
const STEP_MAX_TOKENS = 500;

/** Token budget for parameter extraction. */
const EXTRACTION_MAX_TOKENS = 300;

// ---------------------------------------------------------------------------
// Validation
// ---------------------------------------------------------------------------

/**
 * Validates the incoming chat request body.
 *
 * @throws AppError(400) if the request is malformed.
 */
function validateChatRequest(body: unknown): ChatRequest {
  if (!body || typeof body !== "object") {
    throw new AppError(
      "INVALID_REQUEST_BODY",
      "Request body must be a JSON object.",
      400
    );
  }

  const { messages, currentStep, language } = body as Record<string, unknown>;

  // messages validation
  if (!Array.isArray(messages)) {
    throw new AppError(
      "INVALID_MESSAGES",
      "messages must be an array of ChatMessage objects.",
      400
    );
  }

  if (messages.length === 0) {
    throw new AppError(
      "EMPTY_MESSAGES",
      "messages array must contain at least one message.",
      400
    );
  }

  if (messages.length > MAX_MESSAGES) {
    throw new AppError(
      "TOO_MANY_MESSAGES",
      `messages array must not exceed ${MAX_MESSAGES} entries.`,
      400
    );
  }

  // Validate each message has role and content
  for (let i = 0; i < messages.length; i++) {
    const msg = messages[i];
    if (
      !msg ||
      typeof msg !== "object" ||
      typeof msg.role !== "string" ||
      typeof msg.content !== "string"
    ) {
      throw new AppError(
        "INVALID_MESSAGE_FORMAT",
        `messages[${i}] must have string "role" and "content" fields.`,
        400
      );
    }
    if (!["user", "assistant", "system"].includes(msg.role)) {
      throw new AppError(
        "INVALID_MESSAGE_ROLE",
        `messages[${i}].role must be "user", "assistant", or "system".`,
        400
      );
    }
    if (msg.content.length > 2000) {
      throw new AppError(
        "MESSAGE_TOO_LONG",
        `messages[${i}].content must not exceed 2000 characters.`,
        400
      );
    }
  }

  // currentStep validation
  if (typeof currentStep !== "number" || !Number.isInteger(currentStep)) {
    throw new AppError(
      "INVALID_STEP",
      "currentStep must be an integer.",
      400
    );
  }

  if (currentStep < 0 || currentStep > MAX_STEP) {
    throw new AppError(
      "STEP_OUT_OF_RANGE",
      `currentStep must be between 0 and ${MAX_STEP}.`,
      400
    );
  }

  // language validation (optional)
  if (language !== undefined && typeof language !== "string") {
    throw new AppError(
      "INVALID_LANGUAGE",
      "language must be a string (BCP-47 code).",
      400
    );
  }

  return {
    messages: messages as ChatMessage[],
    currentStep: currentStep as number,
    language: (language as string | undefined) ?? "tr",
  };
}

// ---------------------------------------------------------------------------
// Suggestion chips per step
// ---------------------------------------------------------------------------

/**
 * Returns quick-reply suggestion chips for the given step.
 *
 * These map to the chip options displayed in the Flutter UI. The labels
 * are returned in Turkish by default; the Flutter client can localise
 * them if needed.
 *
 * @param step - The upcoming step the user will answer.
 * @param language - BCP-47 language code.
 * @returns An array of suggestion strings.
 */
function getSuggestionsForStep(step: number, language = "tr"): string[] {
  const isTr = language === "tr";

  switch (step) {
    case 0:
      // Destination step — no suggestions, user types freely
      return [];

    case 1:
      // Travel style
      return isTr
        ? ["Tarih & Kültür", "Yeme & İçme", "Macera", "Doğa", "Karışık"]
        : ["Historical", "Food & Drink", "Adventure", "Nature", "Mixed"];

    case 2:
      // Transport mode
      return isTr
        ? ["Yürüyerek", "Toplu Taşıma", "Araçla", "Karışık"]
        : ["Walking", "Public Transit", "By Car", "Mixed"];

    case 3:
      // Budget level
      return isTr
        ? ["Ekonomik", "Orta", "Premium"]
        : ["Budget", "Mid-range", "Premium"];

    case 4:
      // Duration
      return isTr
        ? ["1 Gün", "2 Gün", "3 Gün", "5 Gün", "7 Gün"]
        : ["1 Day", "2 Days", "3 Days", "5 Days", "7 Days"];

    default:
      return [];
  }
}

// ---------------------------------------------------------------------------
// LLM response parsing
// ---------------------------------------------------------------------------

/**
 * Parses the LLM's JSON response for a Q&A step.
 *
 * The LLM is instructed to return { message, understood } but may
 * sometimes wrap it in markdown code fences or return malformed JSON.
 * This function handles common edge cases gracefully.
 *
 * @param raw - The raw string content from the LLM.
 * @returns A parsed LLMStepResponse.
 */
function parseStepResponse(raw: string): LLMStepResponse {
  // Strip markdown code fences if present
  let cleaned = raw.trim();
  if (cleaned.startsWith("```")) {
    cleaned = cleaned
      .replace(/^```(?:json)?\s*\n?/, "")
      .replace(/\n?```\s*$/, "");
  }

  try {
    const parsed = JSON.parse(cleaned);

    if (typeof parsed.message !== "string") {
      // LLM returned JSON but without the expected shape — use the whole
      // content as the message with understood = true as a fallback.
      return {
        message: parsed.message?.toString() ?? raw,
        understood: true,
      };
    }

    return {
      message: parsed.message,
      understood: parsed.understood !== false, // default to true
    };
  } catch {
    // JSON parse failed — use the raw text as the message.
    // This is a graceful degradation: the user still sees a reply.
    console.warn(
      "[chat] Failed to parse LLM step response as JSON, using raw text."
    );
    return {
      message: raw,
      understood: true,
    };
  }
}

/**
 * Parses the LLM's JSON response for parameter extraction.
 *
 * @param raw - The raw string content from the LLM.
 * @returns A partial RouteRequest with extracted parameters.
 */
function parseExtractionResponse(raw: string): Partial<RouteRequest> {
  let cleaned = raw.trim();
  if (cleaned.startsWith("```")) {
    cleaned = cleaned
      .replace(/^```(?:json)?\s*\n?/, "")
      .replace(/\n?```\s*$/, "");
  }

  try {
    const parsed: LLMExtractionResponse = JSON.parse(cleaned);

    // Normalize and validate extracted values
    const travelStyleMap: Record<string, string> = {
      historical: "historical",
      food: "food",
      adventure: "adventure",
      nature: "nature",
      mixed: "mixed",
    };

    const transportMap: Record<string, string> = {
      walking: "walking",
      public: "public",
      car: "car",
      mixed: "mixed",
    };

    const budgetMap: Record<string, string> = {
      budget: "budget",
      mid: "mid",
      premium: "premium",
    };

    const travelStyle = travelStyleMap[parsed.travelStyle] ?? "mixed";
    const transportMode = transportMap[parsed.transportMode] ?? "mixed";
    const budgetLevel = budgetMap[parsed.budgetLevel] ?? "mid";
    const durationDays = Math.min(
      7,
      Math.max(1, Math.round(parsed.durationDays ?? 1))
    );

    return {
      city: parsed.city || "Unknown",
      country: parsed.country || "Unknown",
      travelStyle: travelStyle as RouteRequest["travelStyle"],
      transportMode: transportMode as RouteRequest["transportMode"],
      budgetLevel: budgetLevel as RouteRequest["budgetLevel"],
      durationDays,
      startTime: "09:00",
    };
  } catch {
    console.error("[chat] Failed to parse extraction response:", raw);
    throw new AppError(
      "EXTRACTION_FAILED",
      "Failed to extract route parameters from conversation.",
      500
    );
  }
}

// ---------------------------------------------------------------------------
// Core logic
// ---------------------------------------------------------------------------

/**
 * Determines the next step based on the current step and LLM response.
 *
 * If the LLM understood the user's answer, advance to the next step.
 * Otherwise, stay on the same step (the AI will re-ask).
 *
 * @param currentStep - The step the user just answered.
 * @param parsed      - The parsed LLM response.
 * @returns The next step index.
 */
function determineNextStep(
  currentStep: number,
  parsed: LLMStepResponse
): number {
  if (parsed.understood) {
    return currentStep + 1;
  }
  // Stay on the same step — AI will clarify and re-ask
  return currentStep;
}

/**
 * Extracts route parameters from the full conversation by calling the LLM
 * with an extraction prompt.
 *
 * Uses the qa_flow task type (GPT-4.1-nano) for cost efficiency.
 *
 * @param messages - Full conversation history.
 * @param language - BCP-47 language code for extraction instructions.
 * @returns Extracted partial RouteRequest.
 */
async function extractRouteParams(
  messages: ChatMessage[],
  language: string
): Promise<Partial<RouteRequest>> {
  const extractionPrompt = buildExtractionPrompt(messages, language);

  const llmResponse = await routeToModel({
    taskType: "qa_flow",
    systemPrompt:
      "You are a parameter extraction engine. Extract travel route parameters from the conversation and return valid JSON only. No explanations.",
    messages: [{ role: "user", content: extractionPrompt }],
    jsonMode: true,
    temperature: 0.0, // deterministic extraction
    maxTokens: EXTRACTION_MAX_TOKENS,
    timeoutMs: 30_000,
  });

  return parseExtractionResponse(llmResponse.content);
}

/**
 * Generates a chat response for the current Q&A step.
 *
 * Calls the LLM with the conversation history plus the step-specific
 * instruction, parses the structured response, determines step
 * progression, and optionally extracts parameters when complete.
 *
 * @param messages    - Full conversation history.
 * @param currentStep - Current step index (0-4).
 * @param language    - BCP-47 language code.
 * @returns A ChatResponse with the AI message, updated step, and suggestions.
 */
async function generateChatResponse(
  messages: ChatMessage[],
  currentStep: number,
  language: string
): Promise<ChatResponse> {
  const systemPrompt = buildChatSystemPrompt(language);
  const stepPrompt = buildStepPrompt(currentStep, messages, language);

  // Build the message list for the LLM:
  // - All prior conversation messages (user + assistant turns only)
  // - The step instruction as the final user message
  const llmMessages: ChatMessage[] = [
    ...messages.filter((m) => m.role !== "system"),
    { role: "user", content: stepPrompt },
  ];

  const llmResponse = await routeToModel({
    taskType: "qa_flow",
    systemPrompt,
    messages: llmMessages,
    jsonMode: true,
    temperature: 0.8,
    maxTokens: STEP_MAX_TOKENS,
    timeoutMs: 30_000,
  });

  const parsed = parseStepResponse(llmResponse.content);
  const nextStep = determineNextStep(currentStep, parsed);

  // If all steps are complete (user answered step 4, advancing to step 5),
  // extract the route parameters from the conversation.
  let extractedParams: Partial<RouteRequest> | undefined;
  const isComplete = nextStep > MAX_STEP;

  if (isComplete) {
    try {
      extractedParams = await extractRouteParams(messages, language);
    } catch (err) {
      // If extraction fails, still return the message but flag as incomplete
      // so the Flutter client can retry or fall back.
      console.error("[chat] Parameter extraction failed:", err);
      return {
        message: parsed.message,
        currentStep: nextStep,
        suggestions: [],
        isComplete: false,
        extractedParams: undefined,
      };
    }
  }

  return {
    message: parsed.message,
    currentStep: nextStep,
    suggestions: isComplete ? [] : getSuggestionsForStep(nextStep, language),
    isComplete,
    extractedParams,
  };
}

// ---------------------------------------------------------------------------
// Edge Function handler
// ---------------------------------------------------------------------------

Deno.serve(
  withErrorHandler(async (req: Request): Promise<Response> => {
    // --- CORS preflight ---
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;

    const origin = req.headers.get("Origin") ?? undefined;

    // --- Method check ---
    if (req.method !== "POST") {
      throw new AppError(
        "METHOD_NOT_ALLOWED",
        `Method ${req.method} is not allowed. Use POST.`,
        405
      );
    }

    // --- Content-Type validation ---
    const ct = req.headers.get("content-type") ?? "";
    if (!ct.includes("application/json")) {
      return new Response(
        JSON.stringify({ error: "Content-Type must be application/json" }),
        {
          status: 415,
          headers: { ...corsHeaders(origin), "Content-Type": "application/json" },
        }
      );
    }

    // --- Authentication ---
    const userClient = createUserClient(req);
    const { userId } = await verifyAuth(req, userClient);

    // --- Frequency rate limit (30 req/min per user) ---
    if (!checkFrequencyLimit("chat", userId)) {
      console.warn(`[chat] Frequency limit exceeded for userId=${userId}`);
      return frequencyLimitResponse("chat", origin);
    }

    // --- Parse and validate body ---
    let body: unknown;
    try {
      body = await req.json();
    } catch {
      throw new AppError(
        "INVALID_JSON",
        "Request body is not valid JSON.",
        400
      );
    }
    const { messages, currentStep, language } = validateChatRequest(body);

    // --- Sanitize last user message before it enters LLM prompts ---
    const sanitizedMessages: ChatMessage[] = messages.map((msg, idx) => {
      // Only sanitize the last user message; earlier turns are already
      // validated and do not need re-processing.
      if (msg.role === "user" && idx === messages.length - 1) {
        return { ...msg, content: sanitizeUserInput(msg.content, 500) };
      }
      return msg;
    });

    console.log(
      `[chat] userId=${userId} step=${currentStep} messages=${messages.length} lang=${language}`
    );

    // --- Generate AI response ---
    const response = await generateChatResponse(
      sanitizedMessages,
      currentStep,
      language ?? "tr"
    );

    console.log(
      `[chat] userId=${userId} nextStep=${response.currentStep} isComplete=${response.isComplete}`
    );

    // --- Return response ---
    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        ...corsHeaders(origin),
        "Content-Type": "application/json",
      },
    });
  })
);
