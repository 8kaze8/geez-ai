# Geez AI — Competitive Landscape Analysis

**Tarih:** 12 Mart 2026
**Hazırlayan:** Startup Business Analyst Agent
**Durum:** Pre-launch / Idea Validation

---

## 1. Executive Summary

AI travel planner pazarında 5+ doğrudan rakip var ancak hiçbiri gamification, deep research-level öneriler ve Türkçe/MENA desteği sunmuyor. En büyük rakip Mindtrip ($22M fonlama) stabilite sorunları yaşıyor, en popüler Wanderlog (29K review) güven krizi ile boğuşuyor (Trustpilot 1.9/5). Pazar hızla büyüyor (%28.7 CAGR) ve henüz dominant bir oyuncu yok. **Google Gemini en büyük tehdit** — ücretsiz, güçlü, Maps entegrasyonu var. Geez AI'ın fırsatı: deep personalization + gamification + mobile-first UX ile ayrışmak.

---

## 2. Porter's Five Forces

### Scorecard

| Force                   | Intensity (1-5) | Impact | Key Factors                                                         |
| ----------------------- | --------------- | ------ | ------------------------------------------------------------------- |
| **New Entrants**        | 4               | Yüksek | Düşük giriş bariyeri, LLM API herkes erişebilir                     |
| **Supplier Power**      | 3               | Orta   | LLM sağlayıcıları (OpenAI, Anthropic, Google) fiyat belirler        |
| **Buyer Power**         | 4               | Yüksek | Kullanıcılar kolayca app değiştirebilir, ücretsiz alternatifler bol |
| **Substitutes**         | 4               | Yüksek | Google Gemini (ücretsiz), ChatGPT, manual planlama                  |
| **Competitive Rivalry** | 3               | Orta   | 5-8 direkt rakip, pazar hızla büyüyor, henüz dominant yok           |

**Genel Değerlendirme:** Pazar çekici (hızlı büyüme) ama giriş bariyeri düşük ve ikame tehditler güçlü. **Ayrışma kritik** — generic AI planner yapan herkes Google'a yenilir.

### Force 1: Threat of New Entrants — YÜKSEK (4/5)

- LLM API'leri herkese açık → hızla travel planner yapılabilir
- Google Maps API erişilebilir
- Mobil app geliştirme maliyeti düşük (React Native, Flutter)
- **Savunma:** Network effects (paylaşılan rotalar), gamification data, personalization engine

### Force 2: Supplier Power — ORTA (3/5)

- LLM sağlayıcıları: OpenAI, Anthropic, Google (3 büyük)
- Fiyatlar düşüyor ama bağımlılık var
- Google Maps API zorunlu — Google fiyat artırabilir
- **Mitigation:** Multi-LLM strategy, caching, kendi embedding DB

### Force 3: Buyer Power — YÜKSEK (4/5)

- Switching cost neredeyse sıfır
- Ücretsiz alternatifler bol (Wonderplan, TripGenie, Google Gemini)
- Kullanıcılar fiyata duyarlı
- **Savunma:** Gamification lock-in (dijital pasaport, persona data), personalization history

### Force 4: Threat of Substitutes — YÜKSEK (4/5)

- Google Gemini + Maps = ücretsiz, güçlü
- ChatGPT'ye "plan my trip" demek
- TripAdvisor + Booking.com combo
- Blog/YouTube/TikTok'dan manual planlama
- **Savunma:** AI travel planner'lar substitute'lardan 10x daha hızlı ve organize

### Force 5: Competitive Rivalry — ORTA (3/5)

- 5-8 direkt rakip ama henüz market leader yok
- Pazar %28.7 CAGR ile büyüyor → herkes için yer var
- Rakipler farklılaşmış: Wanderlog (collab), Mindtrip (design), Layla (fiyat karşılaştırma)
- **Fırsat:** Gamification + deep research hiçbir rakipte yok

---

## 3. Competitor Profiles

### 3.1 Mindtrip — "En İyi Fonlanan"

|                  |                                                                         |
| ---------------- | ----------------------------------------------------------------------- |
| **Kuruluş**      | 2023, San Francisco                                                     |
| **Fonlama**      | $22M (Seed $7M + Series A $12M)                                         |
| **Yatırımcılar** | Costanoa, Capital One Ventures, United Airlines Ventures, AMEX Ventures |
| **Ekip**         | 12+ kişi                                                                |
| **Fiyat**        | Ücretsiz (affiliate geliri)                                             |
| **iOS Rating**   | 4.8/5 (385 review)                                                      |
| **Android**      | Yok                                                                     |

**Güçlü Yönler:**

- En iyi UI/UX — Fast Company "Most Innovative 2025"
- Magic Camera (fotoğraftan mekan tanıma + çeviri)
- Expert guides by locals
- Güçlü yatırımcı desteği (havayolu + fintech)
- Creator program (bookinglerden kazanç)

**Zayıf Yönler:**

- ❌ App crash'leri — düzenleme sırasında random refresh, saatlerce çalışma kaybı
- ❌ Budget ayarları resetleniyor
- ❌ Android yok — pazarın %72'sini kaçırıyor
- ❌ Düşük review sayısı (385) — adoption zayıf olabilir
- ❌ Offline fonksiyon sınırlı

**Geez AI'a Karşı:** Güçlü tasarım ama stabilite sorunları ciddi. Android eksikliği büyük fırsat. Deep research yok — öneriler yüzeysel.

---

### 3.2 Wanderlog — "En Popüler"

|                |                                            |
| -------------- | ------------------------------------------ |
| **Kuruluş**    | 2019, San Francisco (Y Combinator)         |
| **Fonlama**    | $1.65M (YC + General Catalyst)             |
| **Ekip**       | 5 kişi (Peter & Harry Yu kardeşler)        |
| **Fiyat**      | Ücretsiz / Pro $39.99/yıl                  |
| **iOS Rating** | 4.9/5 (29,910 review)                      |
| **Trustpilot** | 1.9/5 ⚠️                                   |
| **Revenue**    | ~$2.4M/yıl (Haziran 2024'te $1M milestone) |

**Güçlü Yönler:**

- En çok review (29.9K) — güçlü organic adoption
- Google Maps entegrasyonu
- Offline erişim
- Collaboration + izin yönetimi
- Email import (uçuş/otel onayları)
- Budget tracking + gider paylaşımı
- 5 kişiyle $2.4M/yıl — verimli operasyon

**Zayıf Yönler:**

- ❌ Trustpilot 1.9/5 — "subscription deception" suçlamaları
- ❌ AI özellikleri zayıf — "terrible AI" yorumları
- ❌ Hallucination — yapay bilgi üretiyor
- ❌ İş saatleri/müze kapalı günleri yanlış
- ❌ Pro özellikleri gruba paylaşılamıyor
- ❌ Connection hataları

**Geez AI'a Karşı:** Popüler ama güven krizi. AI kalitesi düşük. Deep research ile Geez AI 10x daha doğru bilgi verebilir. Gamification ile retention avantajı.

---

### 3.3 Layla AI — "Fiyat Karşılaştırıcı"

|                    |                                      |
| ------------------ | ------------------------------------ |
| **Kuruluş**        | 2023, Berlin (eski adı: Roam Around) |
| **Ekip**           | 11-50 kişi                           |
| **Fiyat**          | Ücretsiz / Premium $49/yıl           |
| **iOS Rating**     | 4.8/5 (1,200+ review)                |
| **Android Rating** | 3.6/5 (296 review)                   |
| **Kullanıcı**      | 1.1M+                                |

**Güçlü Yönler:**

- Canlı fiyat karşılaştırma (uçak, otel, tren, aktivite)
- Multi-destinasyon desteği
- Interactive Video Map
- Aile odaklı trip planner
- 24/7 erişilebilirlik
- İnsan travel agent bağlantısı

**Zayıf Yönler:**

- ❌ Multi-şehir planları kullanılamaz — "almost useless"
- ❌ Aynı aktiviteyi farklı günlerde öneriyor
- ❌ Link vermiyor — "check the website" diyor
- ❌ 90+ dakika harcayıp kullanılabilir plan çıkaramayan kullanıcılar
- ❌ Otel marka tercihi (IHG, Marriott) dinlenmiyor
- ❌ Yavaş performans
- ❌ Beklenmedik faturalandırma şikayetleri

**Geez AI'a Karşı:** Fiyat karşılaştırma güçlü ama rota kalitesi düşük. Layla'nın booking entegrasyonu ilham alınabilir. Deep research ile Geez AI daha doğru ve detaylı.

---

### 3.4 Wonderplan — "Ücretsiz Deneysel"

|               |                                       |
| ------------- | ------------------------------------- |
| **Kuruluş**   | 2024 (çok yeni)                       |
| **Fiyat**     | Tamamen ücretsiz ("at least for now") |
| **Rating**    | Product Hunt 4.6/5 (11 review)        |
| **Mobil App** | Yok                                   |

**Güçlü Yönler:**

- Tamamen ücretsiz
- Sürükle-bırak aktivite planlama
- PDF export
- Real-time collaboration
- İnteraktif deals bölümü

**Zayıf Yönler:**

- ❌ Çok yeni (2024) — küçük kullanıcı tabanı
- ❌ AI hallucination — uydurma açıklamalar
- ❌ Uçuş/araç kiralama entegrasyonu yok
- ❌ Aktivite linkleri çalışmıyor
- ❌ Yavaş performans
- ❌ Mobil app yok

**Geez AI'a Karşı:** Düşük tehdit. Fonlama yok, mobil app yok. Wonderplan'ın ücretsiz modeli fiyat baskısı yaratabilir ama sürdürülebilir değil.

---

### 3.5 TripGenie (Trip.com) — "Kurumsal Güç"

|             |                                     |
| ----------- | ----------------------------------- |
| **Kuruluş** | 2024 (Trip.com Group, NASDAQ: TCOM) |
| **Fiyat**   | Ücretsiz (Trip.com içinde)          |
| **Rating**  | Trip.com 3.9/5 (3,413 review)       |

**Güçlü Yönler:**

- Enterprise altyapı — 180+ ülke, 1M+ attraction
- Ses + görüntü input desteği
- Menu Assistant (menü çevirisi + kültürel context)
- Doğrudan booking entegrasyonu
- 2024'te conversion 2x, engagement +20 dk, trafik %200 artış

**Zayıf Yönler:**

- ❌ Trip.com ekosistemine bağımlı — standalone değil
- ❌ Booking değişikliği/iptali zor
- ❌ Kullanıcılar TripGenie'yi ayrı değerlendirmiyor
- ❌ Kişiselleştirme sınırlı

**Geez AI'a Karşı:** Trip.com'un booking gücü rakip edilemez ama TripGenie bağımsız bir deneyim değil. Geez AI'ın avantajı: dedicated app, deep personalization, gamification.

---

## 4. Büyük Tehditler: Google & TripAdvisor

### Google Gemini + Maps — EN BÜYÜK TEHDİT ⚠️

|           |                                                  |
| --------- | ------------------------------------------------ |
| **Fiyat** | Tamamen ücretsiz                                 |
| **Güç**   | Real-time data, Maps entegrasyonu, Deep Research |

**Neler yapabiliyor:**

- Gems ile özel trip planner oluşturma
- Canvas ile visual itinerary
- Uçuş fiyat takibi + fiyat düşünce email
- Otel fiyat izleme
- Ekran görüntüsünden plan çıkarma
- Deep Research ile detaylı raporlar

**Neden TEHDİT:**

- Ücretsiz + herkesin Google hesabı var
- Maps + Search + Flights + Hotels tek ekosistem
- AI kapasitesi sınırsız bütçeyle geliştiriliyor

**Neden Geez AI hala kazanabilir:**

- Google **dedicated travel app DEĞİL** — genel araç
- Gamification yok, engagement mechanics yok
- Kişiselleştirme yüzeysel — "neden geziyorsun?" bilmiyor
- Sosyal özellikler yok (rota paylaşımı, arkadaş aktivitesi)
- Offline rota deneyimi yok (Maps offline var ama itinerary yok)
- Türkçe insider bilgi zayıf

### TripAdvisor AI

|           |                                                                |
| --------- | -------------------------------------------------------------- |
| **Güç**   | 300M+ review database, Perplexity entegrasyonu, Viator booking |
| **Durum** | Erken aşama rollout                                            |

- AI arayüzünden 2-3x daha fazla gelir
- Conversational deneyim
- Viator ile 300K+ aktivite booking

**Neden Geez AI hala kazanabilir:**

- TripAdvisor booking odaklı, deneyim planlamada zayıf
- Gamification yok
- Mobil deneyim eski ve hantal
- Rota optimizasyonu yok

---

## 5. Blue Ocean Strategy — Four Actions Framework

### Eliminate (Kaldır)

- ❌ Generic 3-5 soruluk planlama süreci
- ❌ Web-first yaklaşım (mobil ikincil)
- ❌ Statik PDF itinerary export

### Reduce (Azalt)

- 📉 Booking karmaşıklığı (MVP'de sadece affiliate link)
- 📉 Collaboration özelliklerinin kapsamı (MVP'de basit paylaşım)
- 📉 Manuel düzenleme ihtiyacı (AI daha akıllı → daha az düzeltme)

### Raise (Yükselt)

- 📈 AI kişiselleştirme derinliği (review sentezi, zamanlama, insider tips)
- 📈 Bilgi doğruluğu (Google Maps grounding, real-time verification)
- 📈 Mobil UX kalitesi (beautiful, native, hızlı)
- 📈 Offline deneyim (tam rota + harita indirme)

### Create (Yarat)

- ✨ **Gamification sistemi** — Dijital Pasaport, Discovery Score, Travel Persona
- ✨ **Deep Research Engine** — Her rota için derinlemesine araştırma
- ✨ **Fun Facts** — Her durak noktasında "biliyor muydun?"
- ✨ **Zamanlama Zekası** — "Ayasofya'ya sabah 9'da git"
- ✨ **Hidden Gem Discovery** — Turistler bilmiyor, locals gidiyor
- ✨ **Social Loop** — "47 kişi senin rotanı takip etti"

### Strategy Canvas

```
Yüksek │                                    ★ Geez AI
       │         ● Mindtrip
       │                        ● Wanderlog
       │  ● Google
       │              ● Layla
       │                                ● TripAdvisor
Düşük  │_____________________________________________
       Kişisel-   Gamifi-   Deep    Offline   Mobil
       leştirme   cation   Research          UX
```

---

## 6. Competitive Pricing Analysis

### Pazar Fiyatlandırma Haritası

| Tier                   | App                                            | Fiyat                     | Model                |
| ---------------------- | ---------------------------------------------- | ------------------------- | -------------------- |
| **Ücretsiz**           | Google Gemini, Wonderplan, TripGenie, Mindtrip | $0                        | Affiliate / Platform |
| **Düşük**              | Wanderlog Pro                                  | $39.99/yıl ($3.33/ay)     | Freemium             |
| **Orta**               | Layla Premium                                  | $49/yıl ($4.08/ay)        | Freemium             |
| **Geez AI (Önerilen)** | Premium                                        | **$49.99/yıl ($6.99/ay)** | Freemium + Affiliate |

### Geez AI Fiyatlandırma Stratejisi

| Tier              | Fiyat                    | İçerik                                         |
| ----------------- | ------------------------ | ---------------------------------------------- |
| **Free**          | $0                       | 3 rota/ay, temel AI, reklamlı                  |
| **Premium**       | $6.99/ay veya $49.99/yıl | Sınırsız rota, offline, gelişmiş AI, reklamsız |
| **Pro** (gelecek) | $14.99/ay                | API erişimi, ticari kullanım, ekip hesapları   |

**Neden bu fiyat:**

- Wanderlog ($40/yr) ve Layla ($49/yr) arasında konumlanma
- $6.99/ay psychologically önemli — $7'nin altında, impuls alım
- Yıllık indirim (%40) ile lock-in teşviki
- Free tier yeterince iyi → viral growth, premium yeterince farklı → conversion

---

## 7. Geez AI Competitive Advantages

### Sürdürülebilir Avantajlar

| Avantaj                    | Sürdürülebilirlik | Neden                                                                |
| -------------------------- | ----------------- | -------------------------------------------------------------------- |
| **Gamification Data**      | ✅ Yüksek         | Kullanıcının pasaport/persona verileri birikir, başka yere taşınamaz |
| **Personalization Engine** | ✅ Yüksek         | Ne kadar çok kullanılırsa o kadar iyi öğrenir                        |
| **Community/Social**       | ✅ Orta-Yüksek    | Paylaşılan rotalar network effect yaratır                            |
| **Deep Research Quality**  | ⚠️ Orta           | Rakipler kopyalayabilir ama execution matters                        |
| **Turkish/MENA Focus**     | ⚠️ Orta           | İlk hareket avantajı ama kopyalanabilir                              |
| **Beautiful Mobile UX**    | ⚠️ Orta           | Kopyalanabilir ama sürekli yatırım gerektirir                        |

### Switching Cost Yaratma

1. **Dijital Pasaport** — Tüm seyahat geçmişi app'te → başka yere taşıyamaz
2. **Travel Persona** — AI seni tanıyor, yeniden eğitmek istemezsin
3. **Rota Koleksiyonu** — Oluşturduğun/kaydettiğin rotalar
4. **Social Graph** — Arkadaşların da buradaysa gitmezsin
5. **Gamification Progress** — Level, badge, streak kaybetmek istemezsin

---

## 8. Positioning Statement

```
Seyahat planlamak isteyen deneyim odaklı gezginler için
Ki generic itinerary'lerden ve saatlerce araştırmadan bıkmış olanlar için
Geez AI bir AI gezi asistanıdır
Ki her gezi için deep research yaparak insider-level kişisel rotalar üretir
Wanderlog, Mindtrip ve Layla'nın aksine
Geez AI gamification ile keşfi eğlenceli kılar, review sentezi ile
gerçek insider bilgi verir ve beautiful mobile-first UX sunar.
```

### Tagline Önerileri

1. **"Geez, that was perfect!"** — Ana slogan (İngilizce)
2. **"Gez. Keşfet. Kazan."** — Türkçe slogan (gamification vurgusu)
3. **"Your AI travel researcher"** — Fonksiyonel slogan
4. **"Not just a plan. An experience."** — Premium positioning

---

## 9. Go-to-Market Strategy

### Beachhead Market

**İlk hedef segment:** Türkiye'ye gelen İngilizce konuşan turistler (62M/yıl inbound)

**Neden bu segment:**

- Büyük hacim (62M turist/yıl)
- İngilizce content üretmek kolay
- Türkiye bilgisi → competitive advantage (yerel bilgi)
- Dual language test (EN + TR)
- Hiçbir rakip burayı hedeflemiyor

### Market Entry Strategy: Niche → Expand

```
Phase 1 (0-6 ay):  Türkiye destinasyonları (İstanbul, Kapadokya, Antalya, İzmir)
Phase 2 (6-12 ay): Avrupa popüler şehirler (Paris, Barcelona, Roma, Amsterdam)
Phase 3 (12-18 ay): Global expansion (Asya, Amerika)
Phase 4 (18+ ay):  B2B (otel zincirleri, tur operatörleri)
```

### Acquisition Channels

| Kanal                      | Öncelik   | Neden                                             |
| -------------------------- | --------- | ------------------------------------------------- |
| **TikTok/Instagram Reels** | 🔴 Kritik | Travel content viral olur, UGC rotalar paylaşılır |
| **Product Hunt Launch**    | 🔴 Kritik | Early adopter community, press coverage           |
| **SEO/Blog**               | 🟡 Yüksek | "Best things to do in Istanbul" tipi content      |
| **Referral Program**       | 🟡 Yüksek | "Arkadaşını davet et, premium 1 ay hediye"        |
| **Micro-influencerlar**    | 🟡 Yüksek | Travel creators (10K-100K follower)               |
| **App Store Optimization** | 🟡 Yüksek | "AI travel planner" keyword                       |
| **Reddit/Twitter**         | 🟢 Orta   | r/travel, r/solotravel community'ler              |

---

## 10. Competitive Monitoring Plan

### Haftalık

- Rakip app update notları
- Twitter/X mentions
- App Store new reviews

### Aylık

- Rakip fiyat değişiklikleri
- Yeni özellik lansmanları
- Download/rating trendleri

### Çeyreklik

- Derin rekabet analizi güncelleme
- Google Gemini travel özellik takibi
- TripAdvisor AI rollout durumu
- Pazar payı tahmin güncelleme

---

## 11. Key Takeaways

### Top 3 Fırsat

1. **Gamification boşluğu** — Hiçbir rakip yapmıyor, retention 3x artırabilir
2. **AI kalite boşluğu** — Wanderlog "terrible AI", Layla "unusable" — deep research ile ayrış
3. **Türkiye/MENA boşluğu** — 62M turist, 0 yerli AI planner

### Top 3 Tehdit

1. **Google Gemini** — Ücretsiz, güçlü, Maps entegrasyonu
2. **Düşük giriş bariyeri** — Herkes AI travel app yapabilir
3. **Retention zorluğu** — Travel apps D30 retention %2.8 (düşük)

### Stratejik Öneriler

1. **Deep research kalitesini #1 öncelik yap** — Google'dan ayrışmanın tek yolu
2. **Gamification'ı MVP'den çıkarma** — Retention farkını yaratacak olan bu
3. **Türkiye ile başla** — Competitive advantage, test market, hızlı iterasyon
4. **Android-first veya cross-platform** — Mindtrip'in en büyük hatası Android yok
5. **Trustpilot/review yönetimi** — Wanderlog'un düşüşünden ders al

---

## Sonraki Adımlar

1. ✅ Market opportunity analysis
2. ✅ Competitive landscape analysis
3. ⬜ MVP feature specification
4. ⬜ Technical architecture
5. ⬜ Financial projections (3-5 yıl detaylı)
6. ⬜ Go-to-market strategy
7. ⬜ MVP development

---

## Kaynaklar

| Kaynak                          | Veri                       |
| ------------------------------- | -------------------------- |
| Mindtrip App Store              | Rating, review, features   |
| Tracxn Mindtrip Profile         | Funding, team, investors   |
| Skift Mindtrip Funding          | Series A details           |
| Wanderlog App Store             | Rating, 29.9K reviews      |
| GetLatka Wanderlog              | Revenue data               |
| Trustpilot Wanderlog            | 1.9/5 trust score          |
| Layla.ai Official               | Features, pricing          |
| Wonderplan.ai Official          | Features, pricing          |
| Trip.com TripGenie Newsroom     | Features, performance data |
| TechCrunch Google Gemini Travel | New travel features        |
| Tripadvisor Newsroom            | AI assistant launch        |
| Skift TripAdvisor Perplexity    | Partnership details        |
| PA Turkey Tourism 2024          | 62M inbound tourists       |

---

_Bu rapor Geez AI için rakip analizi olup, stratejik karar alma sürecinde kullanılmak üzere hazırlanmıştır. Veriler Mart 2026 itibarıyla günceldir._
