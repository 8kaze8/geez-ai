/**
 * anthropic.ts
 *
 * Claude API client for Geez AI Edge Functions (fallback provider).
 *
 * Uses Claude Haiku as the last-resort fallback in the model routing
 * chain. Communicates with the Anthropic Messages API using native
 * Deno fetch.
 *
 * Usage:
 *   import { anthropicCreateMessage } from '../llm-clients/anthropic.ts';
 *
 *   const result = await anthropicCreateMessage({
 *     model: 'claude-haiku-4-5-20251001',
 *     systemPrompt: 'You are a travel expert.',
 *     messages: [{ role: 'user', content: 'Top 3 hidden gems in Rome.' }],
 *     maxTokens: 2048,
 *   });
 */

import type { ChatMessage } from "../types.ts";
import { AppError } from "../error-handler.ts";

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const ANTHROPIC_API_URL = "https://api.anthropic.com/v1/messages";
const ANTHROPIC_VERSION = "2023-06-01";
// Claude Haiku is fast but still needs headroom for longer route prompts.
// Raised to 90 s to match the Gemini and OpenAI clients.
const DEFAULT_TIMEOUT_MS = 90_000;
const MAX_RETRIES = 1;
const RETRYABLE_STATUS_CODES = [429, 500, 503, 529];

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/** Supported Anthropic model identifiers. */
export type AnthropicModel =
  | "claude-haiku-4-5-20251001"
  | "claude-sonnet-4-5-20250514";

/** Options for an Anthropic Messages API call. */
export interface AnthropicOptions {
  /** Which Claude model to use. Default: claude-haiku-4-5-20251001. */
  model?: AnthropicModel;
  /** System prompt (passed as a top-level field, not a message). */
  systemPrompt?: string;
  /** Conversation messages (user/assistant turns only, no system). */
  messages: ChatMessage[];
  /** Maximum tokens to generate. Default: 4096. */
  maxTokens?: number;
  /** Sampling temperature (0.0 - 1.0). Default: 0.7. */
  temperature?: number;
  /** Request timeout in milliseconds. Default: 30000. */
  timeoutMs?: number;
}

/** Parsed response from an Anthropic API call. */
export interface AnthropicResponse {
  /** The generated text content. */
  content: string;
  /** The model identifier that produced the response. */
  model: string;
  /** Token usage reported by the API. */
  usage: {
    inputTokens: number;
    outputTokens: number;
  };
}

/** Shape of the Anthropic Messages API response body. */
interface AnthropicApiResponse {
  id?: string;
  type?: string;
  role?: string;
  model?: string;
  content?: Array<{
    type: string;
    text?: string;
  }>;
  stop_reason?: string;
  usage?: {
    input_tokens?: number;
    output_tokens?: number;
  };
  error?: {
    type?: string;
    message?: string;
  };
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/**
 * Retrieves the Anthropic API key from environment variables.
 * @throws AppError(500) if the key is not configured.
 */
function getApiKey(): string {
  const key = Deno.env.get("ANTHROPIC_API_KEY");
  if (!key) {
    throw new AppError(
      "MISSING_ENV_VAR",
      'Required environment variable "ANTHROPIC_API_KEY" is not set.',
      500
    );
  }
  return key;
}

/**
 * Converts ChatMessage[] into the Anthropic messages format.
 *
 * The Anthropic Messages API does not accept "system" role messages in
 * the messages array (system prompt is a separate top-level field).
 * System messages are filtered out here; pass them via systemPrompt instead.
 */
function toAnthropicMessages(
  messages: ChatMessage[]
): Array<{ role: "user" | "assistant"; content: string }> {
  return messages
    .filter((m) => m.role !== "system")
    .map((m) => ({
      role: m.role as "user" | "assistant",
      content: m.content,
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
 * Sends a Messages API request to the Anthropic Claude API.
 *
 * Used as the fallback provider in the Geez AI model routing chain.
 * Defaults to Claude Haiku for cost efficiency. Includes automatic
 * retry on transient errors (429, 500, 503, 529).
 *
 * @param options - Message options including model, system prompt, and messages.
 * @returns An AnthropicResponse with generated content, model name, and usage.
 * @throws AppError on API errors, timeouts, or missing configuration.
 *
 * @example
 * const res = await anthropicCreateMessage({
 *   systemPrompt: 'You are a travel expert. Respond in JSON.',
 *   messages: [{ role: 'user', content: 'Best restaurants in Tokyo?' }],
 *   maxTokens: 2048,
 * });
 * console.log(res.content);
 */
export async function anthropicCreateMessage(
  options: AnthropicOptions
): Promise<AnthropicResponse> {
  const apiKey = getApiKey();
  const model = options.model ?? "claude-haiku-4-5-20251001";
  const timeoutMs = options.timeoutMs ?? DEFAULT_TIMEOUT_MS;

  // Build the request body
  // deno-lint-ignore no-explicit-any
  const requestBody: Record<string, any> = {
    model,
    messages: toAnthropicMessages(options.messages),
    max_tokens: options.maxTokens ?? 4096,
    temperature: options.temperature ?? 0.7,
  };

  // System prompt is a top-level field in the Anthropic API
  if (options.systemPrompt) {
    requestBody.system = options.systemPrompt;
  }

  const fetchInit: RequestInit = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": apiKey,
      "anthropic-version": ANTHROPIC_VERSION,
    },
    body: JSON.stringify(requestBody),
  };

  // Retry loop: initial attempt + MAX_RETRIES
  let lastError: Error | null = null;

  for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
    try {
      const startMs = Date.now();
      const response = await fetchWithTimeout(
        ANTHROPIC_API_URL,
        fetchInit,
        timeoutMs
      );
      const latencyMs = Date.now() - startMs;

      if (!response.ok) {
        const errorBody = await response.text();

        if (isRetryable(response.status) && attempt < MAX_RETRIES) {
          console.warn(
            `[anthropic] Retryable error (${response.status}), attempt ${attempt + 1}/${MAX_RETRIES + 1}:`,
            errorBody.slice(0, 200)
          );
          await new Promise((r) => setTimeout(r, 1000 * (attempt + 1)));
          continue;
        }

        throw new AppError(
          "ANTHROPIC_API_ERROR",
          `Anthropic API returned ${response.status}: ${errorBody.slice(0, 300)}`,
          502
        );
      }

      const data: AnthropicApiResponse = await response.json();

      // Check for API-level error in the response body
      if (data.error) {
        throw new AppError(
          "ANTHROPIC_API_ERROR",
          `Anthropic error: ${data.error.message ?? "Unknown error"}`,
          502
        );
      }

      // Extract text from content blocks
      const textBlocks = (data.content ?? []).filter(
        (block) => block.type === "text"
      );
      const content = textBlocks.map((block) => block.text ?? "").join("");

      const usage = {
        inputTokens: data.usage?.input_tokens ?? 0,
        outputTokens: data.usage?.output_tokens ?? 0,
      };

      console.log(
        `[anthropic] model=${model} latency=${latencyMs}ms ` +
          `tokens_in=${usage.inputTokens} tokens_out=${usage.outputTokens}`
      );

      return {
        content,
        model: data.model ?? model,
        usage,
      };
    } catch (err: unknown) {
      if (err instanceof AppError) {
        if (attempt >= MAX_RETRIES) throw err;
        lastError = err;
        continue;
      }

      if (err instanceof DOMException && err.name === "AbortError") {
        lastError = new AppError(
          "ANTHROPIC_TIMEOUT",
          `Anthropic request timed out after ${timeoutMs}ms.`,
          504
        );
        if (attempt >= MAX_RETRIES) throw lastError;
        continue;
      }

      lastError = new AppError(
        "ANTHROPIC_NETWORK_ERROR",
        `Anthropic request failed: ${err instanceof Error ? err.message : String(err)}`,
        502
      );
      if (attempt >= MAX_RETRIES) throw lastError;
    }
  }

  throw (
    lastError ??
    new AppError("ANTHROPIC_UNKNOWN_ERROR", "Anthropic request failed.", 502)
  );
}
