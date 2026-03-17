/**
 * model-router.ts
 *
 * Intelligent model routing and fallback chain for Geez AI Edge Functions.
 *
 * Routes LLM requests to the optimal provider/model based on the task type,
 * then falls back through a tiered chain if the primary model fails. Tracks
 * latency and token usage for every call.
 *
 * Tiered strategy:
 *   route_generation   → Gemini 2.5 Flash → GPT-4.1-mini  → Claude Haiku
 *   content_enrichment → Gemini 2.5 Flash → GPT-4.1-mini  → Claude Haiku
 *   review_synthesis   → Gemini 2.5 Flash → GPT-4.1-mini  → Claude Haiku
 *   place_ranking      → Gemini 2.5 Flash → GPT-4.1-mini  → Claude Haiku
 *   qa_flow            → Gemini 2.5 Flash → GPT-4.1-nano  → GPT-4.1-mini
 *   memory_update      → Gemini 2.5 Flash → GPT-4.1-nano  → GPT-4.1-mini
 *
 * NOTE: Gemini is the primary for all chains because it is the only provider
 * with a configured API key in Supabase secrets. OpenAI and Anthropic steps
 * are present for future use but are skipped automatically at runtime when
 * their respective API key env vars are absent.
 *
 * Usage:
 *   import { routeToModel } from '../_shared/model-router.ts';
 *
 *   const response = await routeToModel({
 *     taskType: 'route_generation',
 *     systemPrompt: 'You are a travel route planner.',
 *     messages: [{ role: 'user', content: 'Plan a day in Istanbul.' }],
 *     jsonMode: true,
 *   });
 */

import type { ChatMessage } from "./types.ts";
import { AppError } from "./error-handler.ts";
import {
  geminiGenerateContent,
  type GeminiResponse,
} from "./llm-clients/gemini.ts";
import {
  openaiChatCompletion,
  type OpenAIModel,
  type OpenAIResponse,
} from "./llm-clients/openai.ts";
import {
  anthropicCreateMessage,
  type AnthropicResponse,
} from "./llm-clients/anthropic.ts";

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/** Task types that determine model selection and fallback chain. */
export type TaskType =
  | "route_generation"
  | "content_enrichment"
  | "review_synthesis"
  | "place_ranking"
  | "qa_flow"
  | "memory_update";

/** AI provider identifier. */
export type LLMProvider = "gemini" | "openai" | "anthropic";

/** Input for the model router. */
export interface LLMRequest {
  /** Determines which model is selected and the fallback chain. */
  taskType: TaskType;
  /** System-level instruction for the LLM. */
  systemPrompt: string;
  /** Conversation messages (user/assistant turns). */
  messages: ChatMessage[];
  /** When true, request structured JSON output from the model. */
  jsonMode?: boolean;
  /** Sampling temperature (0.0 - 2.0). Uses model default if omitted. */
  temperature?: number;
  /** Maximum tokens to generate. Uses model default if omitted. */
  maxTokens?: number;
  /** Request timeout in milliseconds per model attempt. */
  timeoutMs?: number;
}

/** Output from the model router. */
export interface LLMResponse {
  /** The generated text content. */
  content: string;
  /** The model identifier that produced the response. */
  model: string;
  /** Which provider served the response. */
  provider: LLMProvider;
  /** Token usage from the API. */
  usage: {
    inputTokens: number;
    outputTokens: number;
  };
  /** End-to-end latency including all fallback attempts, in milliseconds. */
  latencyMs: number;
  /** Number of fallback attempts before success (0 = primary succeeded). */
  fallbackAttempts: number;
}

// ---------------------------------------------------------------------------
// Model configuration
// ---------------------------------------------------------------------------

/**
 * A single step in a fallback chain — identifies the provider and model
 * to try at that step.
 */
interface ModelStep {
  provider: LLMProvider;
  model: string;
}

/** Gemini 2.5 Flash step. */
const GEMINI_FLASH: ModelStep = { provider: "gemini", model: "gemini-2.5-flash" };

/** OpenAI GPT-4.1-mini step. */
const GPT_41_MINI: ModelStep = { provider: "openai", model: "gpt-4.1-mini" };

/** OpenAI GPT-4.1-nano step. */
const GPT_41_NANO: ModelStep = { provider: "openai", model: "gpt-4.1-nano" };

/** Anthropic Claude Haiku step. */
const CLAUDE_HAIKU: ModelStep = {
  provider: "anthropic",
  model: "claude-haiku-4-5-20251001",
};

/**
 * Fallback chains per task type.
 *
 * The first entry is the primary model. Subsequent entries are tried
 * in order if previous models fail.
 */
const FALLBACK_CHAINS: Record<TaskType, ModelStep[]> = {
  route_generation: [GEMINI_FLASH, GPT_41_MINI, CLAUDE_HAIKU],
  content_enrichment: [GEMINI_FLASH, GPT_41_MINI, CLAUDE_HAIKU],
  review_synthesis: [GEMINI_FLASH, GPT_41_MINI, CLAUDE_HAIKU],
  place_ranking: [GEMINI_FLASH, GPT_41_MINI, CLAUDE_HAIKU],
  qa_flow: [GEMINI_FLASH, GPT_41_NANO, GPT_41_MINI],
  memory_update: [GEMINI_FLASH, GPT_41_NANO, GPT_41_MINI],
};

// ---------------------------------------------------------------------------
// Internal: per-provider call dispatchers
// ---------------------------------------------------------------------------

/**
 * Calls the Gemini API and returns a normalised response.
 */
async function callGemini(
  request: LLMRequest
): Promise<{ content: string; model: string; usage: { inputTokens: number; outputTokens: number } }> {
  const result: GeminiResponse = await geminiGenerateContent({
    systemInstruction: request.systemPrompt,
    messages: request.messages,
    jsonMode: request.jsonMode,
    temperature: request.temperature,
    maxOutputTokens: request.maxTokens,
    timeoutMs: request.timeoutMs,
  });
  return {
    content: result.content,
    model: result.model,
    usage: result.usage,
  };
}

/**
 * Calls the OpenAI API with the specified model and returns a normalised response.
 */
async function callOpenAI(
  request: LLMRequest,
  model: OpenAIModel
): Promise<{ content: string; model: string; usage: { inputTokens: number; outputTokens: number } }> {
  // Inject system prompt as a system message at the start of the messages array
  const messages: ChatMessage[] = [
    { role: "system", content: request.systemPrompt },
    ...request.messages.filter((m) => m.role !== "system"),
  ];

  const result: OpenAIResponse = await openaiChatCompletion({
    model,
    messages,
    jsonMode: request.jsonMode,
    temperature: request.temperature,
    maxTokens: request.maxTokens,
    timeoutMs: request.timeoutMs,
  });
  return {
    content: result.content,
    model: result.model,
    usage: result.usage,
  };
}

/**
 * Calls the Anthropic API and returns a normalised response.
 */
async function callAnthropic(
  request: LLMRequest
): Promise<{ content: string; model: string; usage: { inputTokens: number; outputTokens: number } }> {
  const result: AnthropicResponse = await anthropicCreateMessage({
    systemPrompt: request.systemPrompt,
    messages: request.messages,
    maxTokens: request.maxTokens,
    temperature: request.temperature,
    timeoutMs: request.timeoutMs,
  });
  return {
    content: result.content,
    model: result.model,
    usage: result.usage,
  };
}

/**
 * Maps each provider to the environment variable name that holds its API key.
 * Used to perform a fast availability check before attempting a call, so that
 * a missing key causes an immediate skip rather than a slow network timeout.
 */
const PROVIDER_KEY_ENV: Record<LLMProvider, string> = {
  gemini: "GEMINI_API_KEY",
  openai: "OPENAI_API_KEY",
  anthropic: "ANTHROPIC_API_KEY",
};

/**
 * Dispatches a request to the correct provider based on the ModelStep.
 *
 * Throws immediately with a descriptive error when the provider's API key
 * env var is not set, so the fallback chain skips it without a network round-trip.
 */
async function dispatchToProvider(
  step: ModelStep,
  request: LLMRequest
): Promise<{ content: string; model: string; usage: { inputTokens: number; outputTokens: number } }> {
  // Fast-fail if the required API key is absent — avoids a slow network timeout
  // and keeps the fallback chain latency low.
  const keyEnvVar = PROVIDER_KEY_ENV[step.provider];
  if (keyEnvVar && !Deno.env.get(keyEnvVar)) {
    throw new AppError(
      "MISSING_ENV_VAR",
      `Skipping ${step.provider}/${step.model}: env var "${keyEnvVar}" is not set.`,
      500
    );
  }

  switch (step.provider) {
    case "gemini":
      return callGemini(request);
    case "openai":
      return callOpenAI(request, step.model as OpenAIModel);
    case "anthropic":
      return callAnthropic(request);
    default:
      throw new AppError(
        "INVALID_PROVIDER",
        `Unknown LLM provider: ${step.provider}`,
        500
      );
  }
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * Routes an LLM request to the optimal model based on the task type,
 * with automatic fallback through a tiered provider chain.
 *
 * The function:
 *  1. Determines the primary model from the task type.
 *  2. Attempts generation with the primary model.
 *  3. On failure, falls back through the remaining chain.
 *  4. If all models fail, throws an AppError with aggregated details.
 *  5. Logs the final model used, latency, and token usage.
 *
 * @param request - The LLM request with task type, prompts, and options.
 * @returns An LLMResponse with content, model info, usage, and latency.
 * @throws AppError(502) if all models in the fallback chain fail.
 *
 * @example
 * const response = await routeToModel({
 *   taskType: 'review_synthesis',
 *   systemPrompt: 'Synthesise these reviews into a brief summary.',
 *   messages: [{ role: 'user', content: reviewsText }],
 *   jsonMode: true,
 *   maxTokens: 1024,
 * });
 */
export async function routeToModel(request: LLMRequest): Promise<LLMResponse> {
  const chain = FALLBACK_CHAINS[request.taskType];
  if (!chain || chain.length === 0) {
    throw new AppError(
      "INVALID_TASK_TYPE",
      `No fallback chain configured for task type: ${request.taskType}`,
      500
    );
  }

  const errors: Array<{ provider: string; model: string; error: string }> = [];
  const overallStartMs = Date.now();

  for (let i = 0; i < chain.length; i++) {
    const step = chain[i];
    const isLastStep = i === chain.length - 1;

    try {
      if (i > 0) {
        console.warn(
          `[model-router] Falling back to ${step.provider}/${step.model} ` +
            `for task=${request.taskType} (attempt ${i + 1}/${chain.length})`
        );
      }

      const result = await dispatchToProvider(step, request);
      const totalLatencyMs = Date.now() - overallStartMs;

      const response: LLMResponse = {
        content: result.content,
        model: result.model,
        provider: step.provider,
        usage: result.usage,
        latencyMs: totalLatencyMs,
        fallbackAttempts: i,
      };

      console.log(
        `[model-router] task=${request.taskType} provider=${step.provider} ` +
          `model=${result.model} fallbacks=${i} latency=${totalLatencyMs}ms ` +
          `tokens_in=${result.usage.inputTokens} tokens_out=${result.usage.outputTokens}`
      );

      return response;
    } catch (err: unknown) {
      const errorMsg =
        err instanceof Error ? err.message : String(err);
      errors.push({
        provider: step.provider,
        model: step.model,
        error: errorMsg,
      });

      console.error(
        `[model-router] ${step.provider}/${step.model} failed for task=${request.taskType}: ${errorMsg}`
      );

      // If this is the last step, throw with all accumulated errors
      if (isLastStep) {
        throw new AppError(
          "ALL_MODELS_FAILED",
          `All models failed for task "${request.taskType}". ` +
            `Tried: ${chain.map((s) => `${s.provider}/${s.model}`).join(" -> ")}`,
          502,
          { attempts: errors }
        );
      }
    }
  }

  // Unreachable, but TypeScript needs this
  throw new AppError(
    "ALL_MODELS_FAILED",
    `Model routing exhausted for task "${request.taskType}".`,
    502,
    { attempts: errors }
  );
}

/**
 * Returns the primary model information for a given task type
 * without making an API call. Useful for cost estimation and logging.
 *
 * @param taskType - The task type to look up.
 * @returns The primary model step (provider + model name).
 */
export function getPrimaryModel(taskType: TaskType): {
  provider: LLMProvider;
  model: string;
} {
  const chain = FALLBACK_CHAINS[taskType];
  if (!chain || chain.length === 0) {
    throw new AppError(
      "INVALID_TASK_TYPE",
      `No fallback chain configured for task type: ${taskType}`,
      500
    );
  }
  return { provider: chain[0].provider, model: chain[0].model };
}

/**
 * Returns the full fallback chain for a given task type.
 * Useful for debugging and observability dashboards.
 *
 * @param taskType - The task type to look up.
 * @returns An array of model steps in fallback order.
 */
export function getFallbackChain(taskType: TaskType): ModelStep[] {
  const chain = FALLBACK_CHAINS[taskType];
  if (!chain) {
    throw new AppError(
      "INVALID_TASK_TYPE",
      `No fallback chain configured for task type: ${taskType}`,
      500
    );
  }
  return [...chain];
}
