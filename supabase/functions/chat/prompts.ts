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
      ? "Turkce yanit ver. Samimi, sicak bir dil kullan (sen dili)."
      : language === "en"
        ? "Reply in English. Use a warm, friendly tone."
        : `Reply in the language identified by BCP-47 code "${language}". Use a warm, friendly tone.`;

  return `Sen Geez AI'in seyahat asistanisin. Adin Geez.

Gorev: Kullanicinin seyahat rota parametrelerini sohbet yoluyla toplamak.
Toplanacak bilgiler: sehir, seyahat stili, ulasim modu, butce seviyesi, sure (gun).

Kurallar:
- ${langInstruction}
- Kisa ve oz yanitlar ver (maksimum 2-3 cumle).
- Her yanitte sadece bir soru sor.
- Kullanicinin yaniti belirsizse, kibar bir sekilde tekrar sor.
- Emoji kullanabilirsin ama asiri kullanma (maksimum 2 per mesaj).
- Kullanicinin secimini her zaman olumla, sonra bir sonraki soruya gec.
- ASLA rota onerme, ASLA mekan adi soyleme — sadece parametreleri topla.

Yanit formati: Her zaman asagidaki JSON formatinda yanit ver:
{
  "message": "Kullaniciya gosterilecek mesaj",
  "understood": true
}

"understood" alani:
- true: Kullanicinin yaniti anlasildi, bir sonraki adima gecilecek.
- false: Yanet belirsiz veya gecersiz, ayni soru tekrar sorulacak.`;
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
  // Extract the last user message for context
  const lastUserMsg = [...messages]
    .reverse()
    .find((m) => m.role === "user")?.content ?? "";

  const isTr = language === "tr";

  switch (step) {
    case 0:
      return isTr
        ? `Kullanici bir sehir/destinasyon belirtti: "${lastUserMsg}".

Gorev:
1. Sehri onayla (harika secim! vs.)
2. Seyahat stili sor: Tarih & Kultur, Yeme & Icme, Macera, Doga, Karisik gibi secenekler sun.

JSON formatinda yanit ver: { "message": "...", "understood": true }`
        : `The user specified a city/destination: "${lastUserMsg}".

Task:
1. Confirm the city (great choice! etc.)
2. Ask about travel style: offer options like Historical, Food, Adventure, Nature, Mixed.

Reply in JSON: { "message": "...", "understood": true }`;

    case 1:
      return isTr
        ? `Kullanici seyahat stilini belirtti: "${lastUserMsg}".

Gorev:
1. Stili onayla.
2. Ulasim modunu sor: Yuruyerek, Toplu Tasima, Aracla, Karisik.

JSON formatinda yanit ver: { "message": "...", "understood": true }`
        : `The user specified travel style: "${lastUserMsg}".

Task:
1. Confirm the style.
2. Ask about transport mode: Walking, Public Transit, Car, Mixed.

Reply in JSON: { "message": "...", "understood": true }`;

    case 2:
      return isTr
        ? `Kullanici ulasim modunu belirtti: "${lastUserMsg}".

Gorev:
1. Ulasim modunu onayla.
2. Butce seviyesini sor: Ekonomik, Orta, Premium.

JSON formatinda yanit ver: { "message": "...", "understood": true }`
        : `The user specified transport mode: "${lastUserMsg}".

Task:
1. Confirm the transport mode.
2. Ask about budget level: Budget, Mid-range, Premium.

Reply in JSON: { "message": "...", "understood": true }`;

    case 3:
      return isTr
        ? `Kullanici butce seviyesini belirtti: "${lastUserMsg}".

Gorev:
1. Butceyi onayla.
2. Gezi suresini sor: 1-7 gun arasi secenekler sun.

JSON formatinda yanit ver: { "message": "...", "understood": true }`
        : `The user specified budget level: "${lastUserMsg}".

Task:
1. Confirm the budget.
2. Ask about trip duration: offer options between 1-7 days.

Reply in JSON: { "message": "...", "understood": true }`;

    case 4:
      return isTr
        ? `Kullanici gezi suresini belirtti: "${lastUserMsg}".

Gorev:
1. Sureyi onayla.
2. Tum parametrelerin bir ozetini yap (sehir, stil, ulasim, butce, sure).
3. "Rotani olusturayim mi?" diye sor.

JSON formatinda yanit ver: { "message": "...", "understood": true }`
        : `The user specified trip duration: "${lastUserMsg}".

Task:
1. Confirm the duration.
2. Summarize all parameters (city, style, transport, budget, duration).
3. Ask "Shall I generate your route?"

Reply in JSON: { "message": "...", "understood": true }`;

    default:
      return isTr
        ? `Kullanicinin mesajini anla ve uygun sekilde yanit ver.
JSON formatinda yanit ver: { "message": "...", "understood": false }`
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
 * @returns The extraction instruction string.
 */
export function buildExtractionPrompt(messages: ChatMessage[]): string {
  const conversationText = messages
    .map((m) => `${m.role}: ${m.content}`)
    .join("\n");

  return `Asagidaki sohbetten rota olusturma parametrelerini cikar.

Sohbet:
${conversationText}

Parametreleri asagidaki JSON formatinda don:
{
  "city": "Sehir adi (ornegin Istanbul, Paris, Tokyo)",
  "country": "Ulke adi veya ISO kodu (ornegin Turkey, France, JP)",
  "travelStyle": "historical | food | adventure | nature | mixed",
  "transportMode": "walking | public | car | mixed",
  "budgetLevel": "budget | mid | premium",
  "durationDays": 1-7 arasi bir sayi
}

Kurallar:
- travelStyle degerleri: historical, food, adventure, nature, mixed
  - "Tarih", "Kultur", "Tarihi kesif" gibi yanitlar -> "historical"
  - "Yemek", "Yeme & Icme", "Food" -> "food"
  - "Macera", "Adventure" -> "adventure"
  - "Doga", "Nature" -> "nature"
  - "Karma", "Karisik", "Mixed", "Surprise" -> "mixed"
- transportMode degerleri: walking, public, car, mixed
  - "Yuruyerek", "Yaya", "Walking" -> "walking"
  - "Toplu tasima", "Metro", "Otobus", "Public" -> "public"
  - "Araba", "Arac", "Car" -> "car"
  - "Karisik", "Taksi", "Mixed" -> "mixed"
- budgetLevel degerleri: budget, mid, premium
  - "Ekonomik", "Ucuz", "Budget", "500 alti" -> "budget"
  - "Orta", "Mid", "500-1000" -> "mid"
  - "Premium", "Luks", "1000+", "Farketmez" -> "premium"
- durationDays: Sayisal deger cikar. "1 Gun" -> 1, "Bir hafta" -> 7
- country: Sehre gore otomatik belirle (Istanbul -> Turkey, Paris -> France)

Sadece JSON don, baska bir sey yazma.`;
}
