/**
 * gemini.ts
 *
 * Gemini 2.5 Flash API client for Geez AI Edge Functions.
 *
 * Used as the primary model for route generation and content enrichment
 * tasks. Communicates with the Google Generative Language API using
 * native Deno fetch (no external HTTP libraries).
 *
 * Usage:
 *   import { geminiGenerateContent } from '../llm-clients/gemini.ts';
 *
 *   const result = await geminiGenerateContent({
 *     systemInstruction: 'You are a travel expert.',
 *     messages: [{ role: 'user', content: 'Plan a day in Istanbul.' }],
 *     jsonMode: true,
 *     temperature: 0.7,
 *     maxOutputTokens: 4096,
 *   });
 */

import type { ChatMessage } from "../types.ts";
import { AppError } from "../error-handler.ts";

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const GEMINI_MODEL = "gemini-2.5-flash";
const GEMINI_BASE_URL =
  "https://generativelanguage.googleapis.com/v1beta/models";
// Gemini 2.5 Flash can take 60–90 s for complex multi-day route generation.
// 90 s gives one full retry attempt within the Supabase Edge Function 300 s
// wall-clock limit while still protecting against hung connections.
const DEFAULT_TIMEOUT_MS = 90_000;
const MAX_RETRIES = 1;
const RETRYABLE_STATUS_CODES = [429, 500, 503];

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/** Options for a Gemini generateContent call. */
export interface GeminiOptions {
  /** System-level instruction prepended to the conversation. */
  systemInstruction?: string;
  /** Conversation messages (user/assistant turns). */
  messages: ChatMessage[];
  /** When true, instructs the model to respond with valid JSON only. */
  jsonMode?: boolean;
  /** Sampling temperature (0.0 - 2.0). Default: 0.7. */
  temperature?: number;
  /** Maximum tokens to generate. Default: 4096. */
  maxOutputTokens?: number;
  /** Nucleus sampling parameter. Default: 0.95. */
  topP?: number;
  /** Request timeout in milliseconds. Default: 30000. */
  timeoutMs?: number;
}

/** Parsed response from a Gemini API call. */
export interface GeminiResponse {
  /** Raw text content from the model. */
  content: string;
  /** The model identifier that produced the response. */
  model: string;
  /** Token usage reported by the API. */
  usage: {
    inputTokens: number;
    outputTokens: number;
  };
}

/** Shape of the Gemini REST API response body. */
interface GeminiApiResponse {
  candidates?: Array<{
    content?: {
      parts?: Array<{ text?: string }>;
    };
    finishReason?: string;
  }>;
  usageMetadata?: {
    promptTokenCount?: number;
    candidatesTokenCount?: number;
    totalTokenCount?: number;
  };
  error?: {
    code?: number;
    message?: string;
    status?: string;
  };
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/**
 * Retrieves the Gemini API key from environment variables.
 * @throws AppError(500) if the key is not configured.
 */
function getApiKey(): string {
  const key = Deno.env.get("GEMINI_API_KEY");
  if (!key) {
    throw new AppError(
      "MISSING_ENV_VAR",
      'Required environment variable "GEMINI_API_KEY" is not set.',
      500
    );
  }
  return key;
}

/**
 * Converts ChatMessage[] into the Gemini contents format.
 *
 * Gemini uses "user" and "model" roles (not "assistant"), and system
 * messages are passed separately via systemInstruction.
 */
function toGeminiContents(
  messages: ChatMessage[]
): Array<{ role: string; parts: Array<{ text: string }> }> {
  return messages
    .filter((m) => m.role !== "system")
    .map((m) => ({
      role: m.role === "assistant" ? "model" : "user",
      parts: [{ text: m.content }],
    }));
}

/**
 * Executes a fetch request with an AbortController-based timeout.
 */
async function fetchWithTimeout(
  url: string,
  init: RequestInit,
  timeoutMs: number
): Promise<Response> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  try {
    return await fetch(url, { ...init, signal: controller.signal });
  } finally {
    clearTimeout(timer);
  }
}

/**
 * Determines if a failed request should be retried based on status code.
 */
function isRetryable(status: number): boolean {
  return RETRYABLE_STATUS_CODES.includes(status);
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * Sends a generateContent request to the Gemini 2.5 Flash API.
 *
 * Supports system instructions, multi-turn conversations, JSON mode,
 * and configurable generation parameters. Includes automatic retry on
 * transient errors (429, 500, 503) with a single retry attempt.
 *
 * @param options - Generation options including messages and parameters.
 * @returns A GeminiResponse with the generated content, model name, and usage.
 * @throws AppError on API errors, timeouts, or missing configuration.
 *
 * @example
 * const res = await geminiGenerateContent({
 *   systemInstruction: 'You are a travel planner.',
 *   messages: [{ role: 'user', content: 'Best cafes in Istanbul?' }],
 *   jsonMode: true,
 * });
 * console.log(res.content);
 */
export async function geminiGenerateContent(
  options: GeminiOptions
): Promise<GeminiResponse> {
  const apiKey = getApiKey();
  const timeoutMs = options.timeoutMs ?? DEFAULT_TIMEOUT_MS;
  const url = `${GEMINI_BASE_URL}/${GEMINI_MODEL}:generateContent`;

  // Build the request body
  // deno-lint-ignore no-explicit-any
  const requestBody: Record<string, any> = {
    contents: toGeminiContents(options.messages),
    generationConfig: {
      temperature: options.temperature ?? 0.7,
      maxOutputTokens: options.maxOutputTokens ?? 4096,
      topP: options.topP ?? 0.95,
    },
  };

  // System instruction (Gemini-specific field)
  if (options.systemInstruction) {
    requestBody.systemInstruction = {
      parts: [{ text: options.systemInstruction }],
    };
  }

  // JSON mode — use responseMimeType
  if (options.jsonMode) {
    requestBody.generationConfig.responseMimeType = "application/json";
  }

  const fetchInit: RequestInit = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
    },
    body: JSON.stringify(requestBody),
  };

  // Retry loop: initial attempt + MAX_RETRIES
  let lastError: Error | null = null;

  for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
    try {
      const startMs = Date.now();
      const response = await fetchWithTimeout(url, fetchInit, timeoutMs);
      const latencyMs = Date.now() - startMs;

      if (!response.ok) {
        const errorBody = await response.text();

        if (isRetryable(response.status) && attempt < MAX_RETRIES) {
          console.warn(
            `[gemini] Retryable error (${response.status}), attempt ${attempt + 1}/${MAX_RETRIES + 1}:`,
            errorBody.slice(0, 200)
          );
          // Brief backoff before retry
          await new Promise((r) => setTimeout(r, 1000 * (attempt + 1)));
          continue;
        }

        throw new AppError(
          "GEMINI_API_ERROR",
          `Gemini API returned ${response.status}: ${errorBody.slice(0, 300)}`,
          502
        );
      }

      const data: GeminiApiResponse = await response.json();

      // Check for API-level error in the response body
      if (data.error) {
        throw new AppError(
          "GEMINI_API_ERROR",
          `Gemini error: ${data.error.message ?? "Unknown error"}`,
          502
        );
      }

      // Extract text from the first candidate
      const text =
        data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";

      if (!text && data.candidates?.[0]?.finishReason === "SAFETY") {
        throw new AppError(
          "GEMINI_SAFETY_FILTER",
          "Gemini blocked the response due to safety filters.",
          422
        );
      }

      const usage = {
        inputTokens: data.usageMetadata?.promptTokenCount ?? 0,
        outputTokens: data.usageMetadata?.candidatesTokenCount ?? 0,
      };

      console.log(
        `[gemini] model=${GEMINI_MODEL} latency=${latencyMs}ms ` +
          `tokens_in=${usage.inputTokens} tokens_out=${usage.outputTokens}`
      );

      return {
        content: text,
        model: GEMINI_MODEL,
        usage,
      };
    } catch (err: unknown) {
      if (err instanceof AppError) {
        // If it is already an AppError and we are out of retries, rethrow
        if (attempt >= MAX_RETRIES) throw err;
        lastError = err;
        continue;
      }

      // Handle AbortController timeout
      if (err instanceof DOMException && err.name === "AbortError") {
        lastError = new AppError(
          "GEMINI_TIMEOUT",
          `Gemini request timed out after ${timeoutMs}ms.`,
          504
        );
        if (attempt >= MAX_RETRIES) throw lastError;
        continue;
      }

      // Network or unexpected error
      lastError = new AppError(
        "GEMINI_NETWORK_ERROR",
        `Gemini request failed: ${err instanceof Error ? err.message : String(err)}`,
        502
      );
      if (attempt >= MAX_RETRIES) throw lastError;
    }
  }

  // Should not reach here, but safety net
  throw (
    lastError ??
    new AppError("GEMINI_UNKNOWN_ERROR", "Gemini request failed.", 502)
  );
}
