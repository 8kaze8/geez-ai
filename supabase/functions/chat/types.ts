/**
 * types.ts
 *
 * Type definitions for the Geez AI chat Edge Function.
 *
 * The chat flow collects route generation parameters through a step-by-step
 * conversational Q&A. Each request carries the full conversation history and
 * the current step index so the AI knows which question to ask next.
 */

import type {
  ChatMessage,
  RouteRequest,
} from "../_shared/types.ts";

// ---------------------------------------------------------------------------
// Chat step enumeration
// ---------------------------------------------------------------------------

/**
 * Chat flow steps.
 *
 * 0 = city/destination confirmed, asking for travel style
 * 1 = style confirmed, asking for transport
 * 2 = transport confirmed, asking for budget
 * 3 = budget confirmed, asking for duration
 * 4 = duration confirmed, presenting summary + "generate?" prompt
 * 5+ = all parameters collected, ready for route generation
 */
export type ChatStepIndex = 0 | 1 | 2 | 3 | 4;

// ---------------------------------------------------------------------------
// Request / Response
// ---------------------------------------------------------------------------

/**
 * Body of POST /functions/v1/chat.
 *
 * Sent by the Flutter app on every user message during the Q&A flow.
 */
export interface ChatRequest {
  /** Full conversation history (user + assistant turns). */
  messages: ChatMessage[];
  /**
   * Current step in the Q&A flow (0-4).
   * The Flutter client tracks this from the previous response's currentStep.
   */
  currentStep: number;
  /**
   * BCP-47 language code for AI responses.
   * Defaults to "tr" (Turkish) when omitted.
   */
  language?: string;
}

/**
 * Response body from POST /functions/v1/chat.
 *
 * The Flutter client uses this to:
 *  - Display the AI message in the chat bubble
 *  - Render quick-reply suggestion chips
 *  - Advance the step counter
 *  - Detect completion and trigger route generation
 */
export interface ChatResponse {
  /** AI assistant's reply text. */
  message: string;
  /** Updated step index after processing the user's message. */
  currentStep: number;
  /** Quick-reply suggestion chips for the next question. */
  suggestions: string[];
  /** True when all parameters have been collected. */
  isComplete: boolean;
  /**
   * Extracted route generation parameters.
   * Only populated when isComplete is true.
   */
  extractedParams?: Partial<RouteRequest>;
}

/**
 * Expected JSON structure the LLM returns for each step response.
 *
 * The LLM is instructed to respond with this exact shape in JSON mode.
 */
export interface LLMStepResponse {
  /** The conversational reply to show the user. */
  message: string;
  /**
   * Whether the user's answer for the current step was understood and valid.
   * When false the AI re-asks the same question with clarification.
   */
  understood: boolean;
}

/**
 * Expected JSON structure for parameter extraction.
 *
 * The LLM extracts all route parameters from the full conversation.
 */
export interface LLMExtractionResponse {
  city: string;
  country: string;
  travelStyle: string;
  transportMode: string;
  budgetLevel: string;
  durationDays: number;
}
