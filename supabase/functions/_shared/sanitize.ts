/**
 * sanitize.ts
 *
 * Input sanitization utilities for Geez AI Edge Functions.
 *
 * All user-supplied strings that are interpolated into LLM prompts MUST be
 * passed through sanitizeUserInput() before use. This prevents:
 *
 *   - Prompt injection via separator sequences (---, <|...|>, {{...}})
 *   - Role-spoofing via XML-style chat tags (<system>, <user>, <assistant>)
 *   - Payload bloat / token exhaustion via overly long inputs
 *   - C0 control characters that can confuse tokenizers
 *
 * Usage:
 *   import { sanitizeUserInput } from "../_shared/sanitize.ts";
 *
 *   const safeCity = sanitizeUserInput(rawCity, 100);
 *   const safeMessage = sanitizeUserInput(rawMessage, 500);
 */

/**
 * Sanitizes a user-supplied string before it is interpolated into an LLM
 * prompt.
 *
 * Steps applied in order:
 *  1. Truncate to maxLength characters (hard cap before any processing).
 *  2. Strip horizontal-rule / separator sequences (--- or longer).
 *  3. Strip model-control tokens of the form <|...|>.
 *  4. Strip template injection patterns of the form {{...}}.
 *  5. Strip common XML-style role tags used in prompt injection attacks.
 *  6. Remove C0 control characters except \n (LF, U+000A) and \t (HT, U+0009).
 *  7. Trim surrounding whitespace.
 *
 * @param input     - The raw user-supplied string.
 * @param maxLength - Maximum character length to keep (default 500).
 * @returns The sanitized string, safe for LLM prompt interpolation.
 */
export function sanitizeUserInput(input: string, maxLength = 500): string {
  // 1. Truncate
  let clean = input.slice(0, maxLength);

  // 2. Strip separator sequences (three or more dashes, equals, or underscores)
  clean = clean.replace(/---+/g, "");
  clean = clean.replace(/===+/g, "");
  clean = clean.replace(/___+/g, "");

  // 3. Strip model-control tokens: <|...|>
  clean = clean.replace(/<\|.*?\|>/g, "");

  // 4. Strip template injection: {{...}}
  clean = clean.replace(/\{\{.*?\}\}/g, "");

  // 5. Strip XML-style role/control tags used in prompt injection
  clean = clean.replace(
    /<\/?(?:system|user|assistant|human|ai|prompt|context|instruction)>/gi,
    ""
  );

  // 6. Remove C0 control characters except LF (\x0A) and HT (\x09)
  //    Range covers NUL–HT minus tab (\x09), then LF–CR range, then SO–US
  clean = clean.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F]/g, "");

  // 7. Trim
  return clean.trim();
}

/**
 * Sanitizes a short identifier field (city name, country, style, etc.).
 *
 * More aggressive than sanitizeUserInput: collapses consecutive whitespace
 * and limits to 100 characters. Suitable for fields that should be a
 * single word or short phrase with no special formatting.
 *
 * @param input     - The raw user-supplied identifier string.
 * @param maxLength - Maximum character length (default 100).
 * @returns The sanitized identifier string.
 */
export function sanitizeIdentifier(input: string, maxLength = 100): string {
  let clean = sanitizeUserInput(input, maxLength);
  // Collapse runs of whitespace to a single space
  clean = clean.replace(/\s+/g, " ");
  return clean;
}
