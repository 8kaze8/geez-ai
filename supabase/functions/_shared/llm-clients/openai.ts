/**
 * openai.ts
 *
 * OpenAI API client for Geez AI Edge Functions.
 *
 * Supports GPT-4.1-mini (review synthesis, place ranking) and
 * GPT-4.1-nano (Q&A flow, memory updates). Communicates with the
 * OpenAI Chat Completions API using native Deno fetch.
 *
 * Usage:
 *   import { openaiChatCompletion } from '../llm-clients/openai.ts';
 *
 *   const result = await openaiChatCompletion({
 *     model: 'gpt-4.1-mini',
 *     messages: [
 *       { role: 'system', content: 'You are a travel expert.' },
 *       { role: 'user', content: 'Summarise reviews for Hagia Sophia.' },
 *     ],
 *     jsonMode: true,
 *   });
 */

import type { ChatMessage } from "../types.ts";
import { AppError } from "../error-handler.ts";

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";
// GPT-4.1-mini can take 30–60 s for longer route-generation prompts.
// Raised to 90 s to match the Gemini client and prevent false timeouts
// when OpenAI is under load.
const DEFAULT_TIMEOUT_MS = 90_000;
const MAX_RETRIES = 1;
const RETRYABLE_STATUS_CODES = [429, 500, 503];

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/** Supported OpenAI model identifiers. */
export type OpenAIModel = "gpt-4.1-mini" | "gpt-4.1-nano";

/** Options for an OpenAI Chat Completion call. */
export interface OpenAIOptions {
  /** Which model to use. */
  model: OpenAIModel;
  /** Conversation messages (system, user, assistant). */
  messages: ChatMessage[];
  /** When true, adds response_format: { type: "json_object" }. */
  jsonMode?: boolean;
  /** Sampling temperature (0.0 - 2.0). Default: 0.7. */
  temperature?: number;
  /** Maximum tokens to generate. Default: 4096. */
  maxTokens?: number;
  /** Request timeout in milliseconds. Default: 30000. */
  timeoutMs?: number;
}

/** Parsed response from an OpenAI API call. */
export interface OpenAIResponse {
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

/** Shape of the OpenAI Chat Completions response body. */
interface OpenAIApiResponse {
  id?: string;
  object?: string;
  model?: string;
  choices?: Array<{
    index?: number;
    message?: {
      role?: string;
      content?: string;
    };
    finish_reason?: string;
  }>;
  usage?: {
    prompt_tokens?: number;
    completion_tokens?: number;
    total_tokens?: number;
  };
  error?: {
    message?: string;
    type?: string;
    code?: string;
  };
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/**
 * Retrieves the OpenAI API key from environment variables.
 * @throws AppError(500) if the key is not configured.
 */
function getApiKey(): string {
  const key = Deno.env.get("OPENAI_API_KEY");
  if (!key) {
    throw new AppError(
      "MISSING_ENV_VAR",
      'Required environment variable "OPENAI_API_KEY" is not set.',
      500
    );
  }
  return key;
}

/**
 * Converts ChatMessage[] into OpenAI messages format.
 * OpenAI natively supports system/user/assistant roles, so this is
 * a straightforward mapping.
 */
function toOpenAIMessages(
  messages: ChatMessage[]
): Array<{ role: string; content: string }> {
  return messages.map((m) => ({
    role: m.role,
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
 * Sends a Chat Completion request to the OpenAI API.
 *
 * Supports both GPT-4.1-mini and GPT-4.1-nano models with optional JSON
 * mode, configurable temperature and token limits. Includes automatic
 * retry on transient errors (429, 500, 503).
 *
 * @param options - Completion options including model, messages, and parameters.
 * @returns An OpenAIResponse with generated content, model name, and usage.
 * @throws AppError on API errors, timeouts, or missing configuration.
 *
 * @example
 * const res = await openaiChatCompletion({
 *   model: 'gpt-4.1-nano',
 *   messages: [
 *     { role: 'system', content: 'Answer briefly.' },
 *     { role: 'user', content: 'What is the capital of Turkey?' },
 *   ],
 * });
 * console.log(res.content);
 */
export async function openaiChatCompletion(
  options: OpenAIOptions
): Promise<OpenAIResponse> {
  const apiKey = getApiKey();
  const timeoutMs = options.timeoutMs ?? DEFAULT_TIMEOUT_MS;

  // Build the request body
  // deno-lint-ignore no-explicit-any
  const requestBody: Record<string, any> = {
    model: options.model,
    messages: toOpenAIMessages(options.messages),
    temperature: options.temperature ?? 0.7,
    max_tokens: options.maxTokens ?? 4096,
  };

  // JSON mode
  if (options.jsonMode) {
    requestBody.response_format = { type: "json_object" };
  }

  const fetchInit: RequestInit = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify(requestBody),
  };

  // Retry loop: initial attempt + MAX_RETRIES
  let lastError: Error | null = null;

  for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
    try {
      const startMs = Date.now();
      const response = await fetchWithTimeout(
        OPENAI_API_URL,
        fetchInit,
        timeoutMs
      );
      const latencyMs = Date.now() - startMs;

      if (!response.ok) {
        const errorBody = await response.text();

        if (isRetryable(response.status) && attempt < MAX_RETRIES) {
          console.warn(
            `[openai] Retryable error (${response.status}), attempt ${attempt + 1}/${MAX_RETRIES + 1}:`,
            errorBody.slice(0, 200)
          );
          await new Promise((r) => setTimeout(r, 1000 * (attempt + 1)));
          continue;
        }

        throw new AppError(
          "OPENAI_API_ERROR",
          `OpenAI API returned ${response.status}: ${errorBody.slice(0, 300)}`,
          502
        );
      }

      const data: OpenAIApiResponse = await response.json();

      // Check for API-level error in the response body
      if (data.error) {
        throw new AppError(
          "OPENAI_API_ERROR",
          `OpenAI error: ${data.error.message ?? "Unknown error"}`,
          502
        );
      }

      // Extract content from the first choice
      const content = data.choices?.[0]?.message?.content ?? "";

      if (!content && data.choices?.[0]?.finish_reason === "content_filter") {
        throw new AppError(
          "OPENAI_CONTENT_FILTER",
          "OpenAI blocked the response due to content filters.",
          422
        );
      }

      const usage = {
        inputTokens: data.usage?.prompt_tokens ?? 0,
        outputTokens: data.usage?.completion_tokens ?? 0,
      };

      console.log(
        `[openai] model=${options.model} latency=${latencyMs}ms ` +
          `tokens_in=${usage.inputTokens} tokens_out=${usage.outputTokens}`
      );

      return {
        content,
        model: data.model ?? options.model,
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
          "OPENAI_TIMEOUT",
          `OpenAI request timed out after ${timeoutMs}ms.`,
          504
        );
        if (attempt >= MAX_RETRIES) throw lastError;
        continue;
      }

      lastError = new AppError(
        "OPENAI_NETWORK_ERROR",
        `OpenAI request failed: ${err instanceof Error ? err.message : String(err)}`,
        502
      );
      if (attempt >= MAX_RETRIES) throw lastError;
    }
  }

  throw (
    lastError ??
    new AppError("OPENAI_UNKNOWN_ERROR", "OpenAI request failed.", 502)
  );
}
