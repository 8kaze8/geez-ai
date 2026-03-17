/**
 * prompts.ts
 *
 * System and step-level prompts for the Geez AI chat Q&A flow.
 *
 * The chat agent uses a multi-step conversational approach to collect
 * route generation parameters: city, travel style, transport mode,
 * budget level, and trip duration.
 *
 * All prompts request structured JSON output so responses can be parsed
 * reliably. The language parameter controls the reply language.
 */

import type { ChatMessage } from "../_shared/types.ts";
import { sanitizeUserInput } from "../_shared/sanitize.ts";

// ---------------------------------------------------------------------------
// System prompt
// ---------------------------------------------------------------------------

/**
 * Builds the top-level system prompt for the chat assistant.
 *
 * The prompt establishes the AI's personality, constraints, and output
 * format. It is sent as the system message on every LLM call.
 *
 * @param language - BCP-47 language code (default "tr").
 * @returns The system prompt string.
 */
export function buildChatSystemPrompt(language = "tr"): string {
  const langInstruction =
    language === "tr"
      ? "Türkçe yanıt ver. Samimi, sıcak bir dil kullan (sen dili)."
      : language === "en"
        ? "Reply in English. Use a warm, friendly tone."
        : `Reply in the language identified by BCP-47 code "${language}". Use a warm, friendly tone.`;

  return `Sen Geez AI'in seyahat asistanısın. Adın Geez.

Görev: Kullanıcının seyahat rota parametrelerini sohbet yoluyla toplamak.
Toplanacak bilgiler: şehir, seyahat stili, ulaşım modu, bütçe seviyesi, süre (gün).

Kurallar:
- ${langInstruction}
- Kısa ve öz yanıtlar ver (maksimum 2-3 cümle).
- Her yanıtta sadece bir soru sor.
- Kullanıcının yanıtı belirsizse, kibarca tekrar sor.
- Emoji kullanabilirsin ama aşırı kullanma (maksimum 2 per mesaj).
- Kullanıcının seçimini her zaman onayla, sonra bir sonraki soruya geç.
- ASLA rota önerme, ASLA mekan adı söyleme — sadece parametreleri topla.

Yanıt formatı: Her zaman aşağıdaki JSON formatında yanıt ver:
{
  "message": "Kullanıcıya gösterilecek mesaj",
  "understood": true
}

"understood" alanı:
- true: Kullanıcının yanıtı anlaşıldı, bir sonraki adıma geçilecek.
- false: Yanıt belirsiz veya geçersiz, aynı soru tekrar sorulacak.`;
}

// ---------------------------------------------------------------------------
// Step prompts
// ---------------------------------------------------------------------------

/**
 * Builds the step-specific instruction prompt appended to the conversation.
 *
 * Each step tells the LLM what information was just provided by the user
 * and what to ask next. The prompt is injected as an additional user
 * message so the LLM has full context of the conversation plus the
 * current directive.
 *
 * @param step     - Current step index (0-4).
 * @param messages - Full conversation history for context.
 * @param language - BCP-47 language code (default "tr").
 * @returns The step-specific instruction string.
 */
export function buildStepPrompt(
  step: number,
  messages: ChatMessage[],
  language = "tr"
): string {
  // Extract and sanitize the last user message before interpolating into
  // the step prompt. Limits to 500 chars and strips injection patterns.
  const lastUserMsg = sanitizeUserInput(
    [...messages].reverse().find((m) => m.role === "user")?.content ?? "",
    500
  );

  const isTr = language === "tr";

  switch (step) {
    case 0:
      return isTr
        ? `Kullanıcı bir şehir/destinasyon belirtti: "${lastUserMsg}".

Görev:
1. Şehri onayla (harika seçim! vs.)
2. Seyahat stilini sor: Tarih & Kültür, Yeme & İçme, Macera, Doğa, Karışık gibi seçenekler sun.

JSON formatında yanıt ver: { "message": "...", "understood": true }`
        : `The user specified a city/destination: "${lastUserMsg}".

Task:
1. Confirm the city (great choice! etc.)
2. Ask about travel style: offer options like Historical, Food, Adventure, Nature, Mixed.

Reply in JSON: { "message": "...", "understood": true }`;

    case 1:
      return isTr
        ? `Kullanıcı seyahat stilini belirtti: "${lastUserMsg}".

Görev:
1. Stili onayla.
2. Ulaşım modunu sor: Yürüyerek, Toplu Taşıma, Araçla, Karışık.

JSON formatında yanıt ver: { "message": "...", "understood": true }`
        : `The user specified travel style: "${lastUserMsg}".

Task:
1. Confirm the style.
2. Ask about transport mode: Walking, Public Transit, Car, Mixed.

Reply in JSON: { "message": "...", "understood": true }`;

    case 2:
      return isTr
        ? `Kullanıcı ulaşım modunu belirtti: "${lastUserMsg}".

Görev:
1. Ulaşım modunu onayla.
2. Bütçe seviyesini sor: Ekonomik, Orta, Premium.

JSON formatında yanıt ver: { "message": "...", "understood": true }`
        : `The user specified transport mode: "${lastUserMsg}".

Task:
1. Confirm the transport mode.
2. Ask about budget level: Budget, Mid-range, Premium.

Reply in JSON: { "message": "...", "understood": true }`;

    case 3:
      return isTr
        ? `Kullanıcı bütçe seviyesini belirtti: "${lastUserMsg}".

Görev:
1. Bütçeyi onayla.
2. Gezi süresini sor: 1-7 gün arası seçenekler sun.

JSON formatında yanıt ver: { "message": "...", "understood": true }`
        : `The user specified budget level: "${lastUserMsg}".

Task:
1. Confirm the budget.
2. Ask about trip duration: offer options between 1-7 days.

Reply in JSON: { "message": "...", "understood": true }`;

    case 4:
      return isTr
        ? `Kullanıcı gezi süresini belirtti: "${lastUserMsg}".

Görev:
1. Süreyi onayla.
2. Tüm parametrelerin bir özetini yap (şehir, stil, ulaşım, bütçe, süre).
3. "Rotanı oluşturayım mı?" diye sor.

JSON formatında yanıt ver: { "message": "...", "understood": true }`
        : `The user specified trip duration: "${lastUserMsg}".

Task:
1. Confirm the duration.
2. Summarize all parameters (city, style, transport, budget, duration).
3. Ask "Shall I generate your route?"

Reply in JSON: { "message": "...", "understood": true }`;

    default:
      return isTr
        ? `Kullanıcının mesajını anla ve uygun şekilde yanıt ver.
JSON formatında yanıt ver: { "message": "...", "understood": false }`
        : `Understand the user's message and respond appropriately.
Reply in JSON: { "message": "...", "understood": false }`;
  }
}

// ---------------------------------------------------------------------------
// Extraction prompt
// ---------------------------------------------------------------------------

/**
 * Builds the prompt that extracts structured route parameters from the
 * full conversation history.
 *
 * Called once all five steps are complete. The LLM reads the entire
 * conversation and returns a JSON object with the normalized parameters
 * ready for the generate-route function.
 *
 * @param messages - Full conversation history.
 * @param language - BCP-47 language code (default "tr").
 * @returns The extraction instruction string.
 */
export function buildExtractionPrompt(
  messages: ChatMessage[],
  language = "tr"
): string {
  // Sanitize each message's content before embedding the conversation into
  // the extraction prompt. User content is capped at 500 chars; assistant
  // content (generated by the LLM) is capped at 1000 chars.
  const conversationText = messages
    .map((m) => {
      const cap = m.role === "user" ? 500 : 1000;
      return `${m.role}: ${sanitizeUserInput(m.content, cap)}`;
    })
    .join("\n");

  if (language === "en") {
    return `Extract route generation parameters from the conversation below.

Conversation:
${conversationText}

Return the parameters in the following JSON format:
{
  "city": "City name (e.g. Istanbul, Paris, Tokyo)",
  "country": "Country name or ISO code (e.g. Turkey, France, JP)",
  "travelStyle": "historical | food | adventure | nature | mixed",
  "transportMode": "walking | public | car | mixed",
  "budgetLevel": "budget | mid | premium",
  "durationDays": a number between 1 and 7
}

Rules:
- travelStyle values: historical, food, adventure, nature, mixed
  - "History", "Culture", "Historical" -> "historical"
  - "Food", "Food & Drink", "Eating" -> "food"
  - "Adventure" -> "adventure"
  - "Nature", "Outdoors" -> "nature"
  - "Mixed", "Surprise", "All" -> "mixed"
- transportMode values: walking, public, car, mixed
  - "Walking", "On foot" -> "walking"
  - "Public transit", "Metro", "Bus", "Public" -> "public"
  - "Car", "Drive" -> "car"
  - "Mixed", "Taxi", "Uber" -> "mixed"
- budgetLevel values: budget, mid, premium
  - "Budget", "Cheap", "Economy" -> "budget"
  - "Mid-range", "Mid", "Moderate" -> "mid"
  - "Premium", "Luxury", "No limit" -> "premium"
- durationDays: extract numeric value. "1 Day" -> 1, "One week" -> 7
- country: infer from the city when not stated (Istanbul -> Turkey, Paris -> France)

Return JSON only, no other text.`;
  }

  return `Aşağıdaki sohbetten rota oluşturma parametrelerini çıkar.

Sohbet:
${conversationText}

Parametreleri aşağıdaki JSON formatında dön:
{
  "city": "Şehir adı (örneğin İstanbul, Paris, Tokyo)",
  "country": "Ülke adı veya ISO kodu (örneğin Turkey, France, JP)",
  "travelStyle": "historical | food | adventure | nature | mixed",
  "transportMode": "walking | public | car | mixed",
  "budgetLevel": "budget | mid | premium",
  "durationDays": 1-7 arası bir sayı
}

Kurallar:
- travelStyle değerleri: historical, food, adventure, nature, mixed
  - "Tarih", "Kültür", "Tarih & Kültür", "Tarihi keşif" gibi yanıtlar -> "historical"
  - "Yemek", "Yeme & İçme", "Food" -> "food"
  - "Macera", "Adventure" -> "adventure"
  - "Doğa", "Nature" -> "nature"
  - "Karma", "Karışık", "Mixed", "Surprise" -> "mixed"
- transportMode değerleri: walking, public, car, mixed
  - "Yürüyerek", "Yaya", "Walking" -> "walking"
  - "Toplu Taşıma", "Metro", "Otobüs", "Public" -> "public"
  - "Araçla", "Araba", "Car" -> "car"
  - "Karışık", "Taksi", "Mixed" -> "mixed"
- budgetLevel değerleri: budget, mid, premium
  - "Ekonomik", "Ucuz", "Budget" -> "budget"
  - "Orta", "Mid" -> "mid"
  - "Premium", "Lüks", "Farketmez" -> "premium"
- durationDays: Sayısal değer çıkar. "1 Gün" -> 1, "Bir hafta" -> 7
- country: Şehre göre otomatik belirle (İstanbul -> Turkey, Paris -> France)

Sadece JSON dön, başka bir şey yazma.`;
}
