# Geez AI — MVP Feature Specification

**Tarih:** 12 Mart 2026
**Durum:** Pre-launch / Idea Validation

---

## 1. Product Vision

> **Geez AI, her geziden öğrenen, insider-level öneriler veren, keşfi eğlenceli kılan AI gezi asistanı.**

Sadece rota planlama değil — seni tanıyan, hatırlayan, her seferinde daha iyi öneriler veren bir gezi zekası.

---

## 2. Core Architecture: Agentic AI System

Geez AI'ın kalbinde birden fazla AI agent'ın koordineli çalıştığı bir sistem var:

```
┌─────────────────────────────────────────────┐
│              GEEZ AI BRAIN                  │
│                                             │
│  ┌───────────┐  ┌───────────┐  ┌─────────┐ │
│  │ Research   │  │ Memory    │  │ Route   │ │
│  │ Agent      │  │ Agent     │  │ Agent   │ │
│  │            │  │           │  │         │ │
│  │ • Reviews  │  │ • Geçmiş  │  │ • Sıra  │ │
│  │ • Blogs    │  │   geziler │  │ • Zaman │ │
│  │ • Local    │  │ • Tercih  │  │ • Mesafe│ │
│  │   tips     │  │ • Feedback│  │ • Ulaşım│ │
│  │ • Fun      │  │ • Persona │  │         │ │
│  │   facts    │  │           │  │         │ │
│  └─────┬─────┘  └─────┬─────┘  └────┬────┘ │
│        │              │              │      │
│        └──────────┬───┘──────────────┘      │
│                   │                         │
│           ┌───────▼───────┐                 │
│           │  Orchestrator │                 │
│           │  (Ana Beyin)  │                 │
│           └───────┬───────┘                 │
│                   │                         │
└───────────────────┼─────────────────────────┘
                    │
            ┌───────▼───────┐
            │  User-Facing  │
            │  Chat + UI    │
            └───────────────┘
```

### Agent Rolleri

| Agent              | Görev                              | Input                               | Output                                                     |
| ------------------ | ---------------------------------- | ----------------------------------- | ---------------------------------------------------------- |
| **Research Agent** | Destinasyon hakkında deep research | Şehir + kullanıcı tercihleri        | Mekanlar, review sentezi, insider tips, fun facts          |
| **Memory Agent**   | Kullanıcıyı tanı, geçmişi hatırla  | Geçmiş geziler, feedback, tercihler | Kişiselleştirilmiş filtreler, "bunu da seversin" önerileri |
| **Route Agent**    | Optimal rota oluştur               | Mekanlar + zaman + ulaşım           | Sıralı rota, zamanlama, ulaşım bilgisi                     |
| **Orchestrator**   | Agent'ları koordine et             | Kullanıcı prompt'u                  | Final rota + sunum                                         |

---

## 3. User Journey (MVP)

### 3.1 Onboarding (İlk Açılış)

```
1. App aç → Güzel splash screen
2. "Merhaba! Ben Geez. Seni tanımak istiyorum."
3. Quick quiz (30 sn):
   - "Genelde nasıl gezmeyi seversin?" → [Tarihi | Yemek | Doğa | Macera | Karma]
   - "Bütçen?" → [Ekonomik | Orta | Premium]
   - "Kiminle?" → [Solo | Çift | Arkadaşlar | Aile]
4. İlk Travel Persona oluştur → "Sen bir Foodie Explorer'sın!"
5. Dijital Pasaport oluştur (boş, doldurulmayı bekliyor)
6. Ana ekrana yönlendir
```

### 3.2 Rota Oluşturma (Core Flow)

```
Kullanıcı: "İstanbul'a 3 gün gideceğim"

Geez: "Harika seçim! Birkaç soru sorayım sana özel bir rota çıkarayım."

→ Soru 1: "Ne tarz bir gezi istiyorsun?"
   [Tarihi keşif] [Yemek turu] [Hidden gems] [Karma] [Surprise me!]

→ Soru 2: "Nasıl gezeceksin?"
   [Yürüyerek] [Toplu taşıma] [Arabam var] [Taksi/Uber OK]

→ Soru 3: "Günlük bütçen?"
   [₺500 altı] [₺500-1000] [₺1000+] [Farketmez]

→ Soru 4: "Kaçta başlamak istiyorsun?"
   [Erken kuş (08:00)] [Normal (10:00)] [Geç başla (12:00)]

→ [Memory Agent check]: "Geçen seferkinde müze yorumundan sonra
   açık hava istediğini söylemiştin. Bunu da hesaba katayım mı?"

→ "Rotanı hazırlıyorum... ✨"
   [Research Agent → route araştırması başlar]
   [Animasyonlu loading: mekan kartları tek tek beliriyor]
```

### 3.3 Rota Sonucu (Wow Moment)

Her durak için zengin kart:

```
┌─────────────────────────────────────┐
│ 📍 Durak 1: Süleymaniye Camii       │
│ ⏰ 09:00 - 10:30 | 🚶 12 dk yürüyüş │
│                                     │
│ 💡 "Kubbesi Ayasofya'dan ilham      │
│     almış. Namaz dışı saatlerde     │
│     kubbe altında dur — akustiği    │
│     inanılmaz."                     │
│                                     │
│ ⭐ Google: 4.8 (12K yorum)          │
│ 📝 "Herkes manzarayı övmüş ama     │
│     asıl hazinesi bahçedeki         │
│     Kanuni türbesi"                 │
│                                     │
│ 🎯 Fun Fact: "Mimar Sinan bu camiyi│
│     'çıraklık eserim' diye          │
│     nitelendirmiş."                 │
│                                     │
│ 💰 Ücretsiz                         │
│ ⏱️ En iyi zaman: Sabah 9-10        │
│ ⚠️ Cuma namazı: 12:30-14:00 kapalı │
│                                     │
│ [Haritada Gör] [Detay] [Değiştir]  │
└─────────────────────────────────────┘
          │
          │ 🚶 12 dk yürüyüş ↓
          │
┌─────────────────────────────────────┐
│ 📍 Durak 2: Kapalıçarşı             │
│ ⏰ 10:45 - 12:30                     │
│ ...                                  │
└─────────────────────────────────────┘
```

### 3.4 Post-Trip Feedback Loop

```
[Gezi bittikten sonra - push notification]

Geez: "İstanbul gezin nasıldı? 🎉 2 dakika ayırırsan
       bir sonraki gezini çok daha iyi planlayabilirim!"

→ Soru 1: "Rotayı genel olarak nasıl buldun?"
   [⭐⭐⭐⭐⭐ puanlama]

→ Soru 2: "En çok hangi durak hoşuna gitti?"
   [Durak kartları - seçilebilir]

→ Soru 3: "Bir daha gitme dediğin yer var mı?"
   [Durak kartları - seçilebilir]

→ Soru 4: "Keşke rotada olsaydı dediğin bir şey?"
   [Serbest metin]

→ Soru 5: "Yemekler nasıldı?"
   [Muhteşem | İyi | Vasat | Kötü]

→ "Teşekkürler! Seni daha iyi tanıdım.
   Dijital pasaportuna İstanbul damgası eklendi! 🛂"

[Memory Agent güncellenir:
 - "Süleymaniye'yi çok beğendi, tarihi mimariden hoşlanıyor"
 - "Kapalıçarşı kalabalık gelmiş, off-peak öneri"
 - "Yemekleri orta bulmuş, street food daha iyi olabilir"
 - Travel Persona güncelleme: History Buff +2, Foodie -1]
```

---

## 4. MVP Feature Matrix

### Must Have (V1.0)

| #   | Feature                  | Açıklama                                                             | Öncelik |
| --- | ------------------------ | -------------------------------------------------------------------- | ------- |
| 1   | **AI Soru-Cevap Flow**   | 4-6 akıllı soru ile tercih toplama                                   | P0      |
| 2   | **Deep Research Rota**   | Review sentezi, insider tips, fun facts ile zengin rota              | P0      |
| 3   | **Zamanlama Zekası**     | En iyi ziyaret saatleri, kalabalık uyarıları                         | P0      |
| 4   | **Rota Optimizasyonu**   | Mesafe/zaman bazlı optimal sıralama                                  | P0      |
| 5   | **Harita Görünümü**      | Rotayı harita üzerinde görme                                         | P0      |
| 6   | **AI Memory**            | Geçmiş gezileri + tercihleri hatırlama                               | P0      |
| 7   | **Post-Trip Feedback**   | Gezi sonrası sorular + learning                                      | P0      |
| 8   | **Dijital Pasaport**     | Gidilen şehirlerin damga koleksiyonu                                 | P0      |
| 9   | **Discovery Score**      | Off-the-beaten-path puanlama                                         | P0      |
| 10  | **Travel Persona**       | Foodie Lv.3, History Buff Lv.5 gibi evrilen profil                   | P0      |
| 11  | **Fun Facts**            | Her durakta "biliyor muydun?"                                        | P0      |
| 12  | **Global Şehir Desteği** | AI on-demand research — tüm şehirler Day 1'de açık, şehir limiti yok | P0      |
| 13  | **Türkçe + İngilizce**   | Dual language                                                        | P0      |
| 14  | **Güzel Mobil UI**       | iOS + Android (cross-platform)                                       | P0      |

### Should Have (V1.1)

| #   | Feature                      | Açıklama                               | Öncelik |
| --- | ---------------------------- | -------------------------------------- | ------- |
| 15  | **Offline Rota**             | İndirilen rota + harita                | P1      |
| 16  | **Bütçe Optimizasyonu**      | Günlük harcama tahmini                 | P1      |
| 17  | **Hava Durumu Entegrasyonu** | Yağmurda müze, güneşte açık hava       | P1      |
| 18  | **Rota Paylaşımı**           | Sosyal medya + direkt paylaşım         | P1      |
| 19  | **Premium Subscription**     | Sınırsız rota, gelişmiş AI, reklamsız  | P1      |
| 20  | **Hidden Gem Discovery**     | Az bilinen ama yüksek puanlı yerler    | P1      |
| 21  | **Kültürel Context**         | Adetler, bahşiş, kıyafet, dil ipuçları | P1      |

### Nice to Have (V1.2+)

| #   | Feature                 | Açıklama                                                | Öncelik |
| --- | ----------------------- | ------------------------------------------------------- | ------- |
| 22  | **Affiliate Booking**   | Otel, tur, uçak, otobüs linkleri                        | P2      |
| 23  | **Social Feed**         | Arkadaş aktivitesi, popüler rotalar                     | P2      |
| 24  | **Leaderboard**         | Arkadaşlarla Discovery Score yarışı                     | P2      |
| 25  | **Route Challenges**    | "Ottoman Trail", "Mediterranean Food" tematik challenge | P2      |
| 26  | **Streak System**       | "3 hafta üst üste keşif!"                               | P2      |
| 27  | **Group Planning**      | Arkadaşlarla birlikte rota oluşturma                    | P2      |
| 28  | **Photo Integration**   | Gezi fotoğraflarını rotaya bağlama                      | P2      |
| 29  | **Notification System** | "47 kişi rotanı takip etti"                             | P2      |
| 30  | **B2B API**             | Otel/tur operatörleri için API                          | P3      |

---

## 5. AI Memory System (Detay)

### Memory Katmanları

```
┌──────────────────────────────────────┐
│          USER MEMORY                 │
│                                      │
│  Layer 1: Profile (statik)           │
│  ├── Dil tercihi                     │
│  ├── Yaş grubu                       │
│  ├── Genelde kiminle gezer           │
│  └── Bütçe aralığı                   │
│                                      │
│  Layer 2: Preferences (öğrenilen)    │
│  ├── Sevdiği aktivite türleri        │
│  ├── Yemek tercihleri                │
│  ├── Tempo (yoğun vs rahat)          │
│  ├── Sabahçı mı akşamcı mı          │
│  └── Kalabalık toleransı             │
│                                      │
│  Layer 3: History (birikimli)        │
│  ├── Gittiği şehirler               │
│  ├── Beğendiği mekanlar             │
│  ├── Beğenmediği mekanlar            │
│  ├── Feedback notları                │
│  └── Tamamlanan rotalar             │
│                                      │
│  Layer 4: Persona (evrilen)          │
│  ├── Foodie Level: 5                 │
│  ├── History Buff Level: 3           │
│  ├── Adventure Seeker Level: 7       │
│  ├── Culture Explorer Level: 4       │
│  └── Discovery Score: 847            │
│                                      │
└──────────────────────────────────────┘
```

### Memory Kullanım Senaryoları

| Senaryo                    | Memory Input                      | AI Output                                                 |
| -------------------------- | --------------------------------- | --------------------------------------------------------- |
| Yeni rota oluştururken     | Geçmiş beğeniler + persona        | "Tarih seviyorsun, Topkapı'yı mutlaka ekleyelim"          |
| Aynı şehre tekrar giderken | Gittiği yerler                    | "Bunları zaten gördün, bu sefer hidden gems'e bakalım"    |
| Yemek önerisi              | Yemek tercihleri + geçmiş puanlar | "Street food seviyorsun, Balık Ekmek yerine Kokoreç dene" |
| Tempo ayarı                | Geçmiş feedback                   | "Geçen sefer 'çok yoğundu' demiştin, bugün 4 durak yeter" |
| Mevsimsel                  | Geçmiş gezilerin zamanlaması      | "Yazın deniz, kışın müze tercih ediyorsun"                |

### Öğrenme Mekanizması

```
Trip 1: Kullanıcı İstanbul'a gidiyor
        → Başlangıç profili: Karma gezgin
        → Post-trip: "Tarihi yerler favori, yemek vasat"

Trip 2: Kullanıcı Roma'ya gidiyor
        → AI: "Tarih seviyorsun, Colosseum + Forum + Vatikan öncelik"
        → Post-trip: "Vatikan muhteşem, yürüyüş çok uzun"

Trip 3: Kullanıcı Paris'e gidiyor
        → AI: "Tarih + kısa yürüyüşler. Louvre → Musée d'Orsay yakın.
               Uzun yürüyüş sevmediğini biliyorum, metro rotası ekledim."
        → AI: "Roma'da antik tarih beğenmiştin, Paris'te de
               Catacombes'u ekledim — farklı ama aynı his."
```

---

## 6. Gamification System (MVP — 3 Feature)

### 6.1 Dijital Pasaport

```
┌─────────────────────────────────────┐
│        🛂 GEZ PASAPORTU              │
│                                     │
│  ┌─────┐  ┌─────┐  ┌─────┐        │
│  │ 🇹🇷  │  │ 🇮🇹  │  │ ❓  │        │
│  │ IST  │  │ ROM  │  │ ???  │        │
│  │ ✅   │  │ ✅   │  │     │        │
│  └─────┘  └─────┘  └─────┘        │
│                                     │
│  Ziyaret: 2 şehir | 3 ülke hedefi  │
│  ████████░░░░░░░░ 67%              │
│                                     │
│  [Pasaportumu Paylaş]              │
└─────────────────────────────────────┘
```

- Her gezide otomatik damga
- Ülke/kıta/tematik koleksiyonlar
- Paylaşılabilir (viral loop)
- Progress bar ile sonraki hedef

### 6.2 Discovery Score

```
┌─────────────────────────────────────┐
│  🧭 DISCOVERY SCORE: 847            │
│                                     │
│  Explorer Seviyesi: ⭐⭐⭐⭐☆          │
│                                     │
│  Tourist ←───────●──→ Explorer      │
│                                     │
│  Son geziden:                       │
│  + Süleymaniye Bahçesi (+15 hidden) │
│  + Balat Sokakları (+25 off-path)   │
│  - Kapalıçarşı (-5 tourist trap)   │
│                                     │
│  Üst seviye: 1000 puan → "Local"   │
└─────────────────────────────────────┘
```

- Turistik yer = az puan, hidden gem = çok puan
- Seviyeler: Tourist → Traveler → Explorer → Local → Legend
- Arkadaşlarla kıyaslanabilir (V1.2)

### 6.3 Travel Persona

```
┌─────────────────────────────────────┐
│  🎭 TRAVEL PERSONA                  │
│                                     │
│  🍕 Foodie ............. Lv.5       │
│  🏛️ History Buff ....... Lv.3       │
│  🌿 Nature Lover ....... Lv.1       │
│  🎒 Adventure Seeker ... Lv.7       │
│  🎨 Culture Explorer ... Lv.4       │
│                                     │
│  Dominant: "Adventurous Foodie"     │
│                                     │
│  [Personamı Paylaş]               │
└─────────────────────────────────────┘
```

- Her gezi + feedback sonrası otomatik güncelleme
- Level atladıkça o kategoride daha niş öneriler açılır
- Paylaşılabilir persona kartı (sosyal medya)

---

## 7. Deep Research Engine (Teknik Detay)

### Her Durak İçin Research Pipeline

```
Input: "Süleymaniye Camii, İstanbul"

Step 1: Google Maps API
├── Rating: 4.8/5
├── Konum: koordinatlar
├── Açılış saatleri
├── Fotoğraflar
└── Temel bilgi

Step 2: Review Sentezi
├── Google Reviews (top 100) → sentiment analysis
├── TripAdvisor reviews → key themes extract
├── "Herkes X'i övmüş ama Y'den şikayet etmiş"
└── "En iyi zaman: sabah erken"

Step 3: Blog/Forum Sentezi
├── Travel blog'lardan insider tips
├── Reddit r/travel, r/istanbul threads
├── Local blog/forum önerileri
└── "Çoğu turist X'i kaçırıyor"

Step 4: Historical/Cultural Context
├── Tarihçe özeti (kısa, engaging)
├── Mimari özellikler
├── Kültürel önemi
└── Bağlam: dönem, mimar, hikaye

Step 5: Fun Fact Generation
├── İlginç/şaşırtıcı bilgi
├── "Biliyor muydun?" formatı
└── Kaynak doğrulaması

Step 6: Practical Info
├── En iyi ziyaret saati (kalabalık data)
├── Bilet fiyatı
├── Ulaşım seçenekleri
├── Yakınındaki diğer duraklar
├── Fotoğraf noktaları
└── Uyarılar (kapalı günler, kıyafet kuralı vb.)

Output: Zengin durak kartı
```

### Bilgi Doğrulama Katmanı

| Bilgi Türü         | Doğrulama Yöntemi                  |
| ------------------ | ---------------------------------- |
| Açılış saatleri    | Google Maps API (real-time)        |
| Fiyatlar           | Google Maps + resmi site scrape    |
| Review sentezi     | Minimum 20+ review, son 6 ay       |
| Insider tips       | 3+ farklı kaynak doğrulaması       |
| Fun facts          | Wikipedia/resmi kaynak cross-check |
| Kalabalık saatleri | Google Maps "popular times" data   |

---

## 8. Teknik Mimari (Yüksek Seviye)

### Tech Stack Önerisi

| Katman        | Teknoloji                                | Neden                                   |
| ------------- | ---------------------------------------- | --------------------------------------- |
| **Mobile**    | React Native veya Flutter                | Cross-platform (iOS + Android)          |
| **Backend**   | Node.js + Supabase                       | Hızlı geliştirme, realtime, auth        |
| **AI/LLM**    | Claude API (ana) + GPT-4 mini (fallback) | Kalite + maliyet balance                |
| **Maps**      | Google Maps Platform                     | Places API, Directions, Popular Times   |
| **Search**    | Tavily + Exa (hybrid)                    | Ucuz genel arama + derin semantic arama |
| **Vector DB** | Supabase pgvector                        | Mekan embeddings, benzer yer önerileri  |
| **Storage**   | Supabase Storage                         | Kullanıcı data, offline cache           |
| **Analytics** | Mixpanel veya PostHog                    | Funnel, retention, feature usage        |
| **Push**      | Firebase Cloud Messaging                 | Post-trip feedback, re-engagement       |

### AI Maliyet Tahmini (Per Rota)

| İşlem                          | Token (est.) | Maliyet    |
| ------------------------------ | ------------ | ---------- |
| Kullanıcı soru-cevap           | ~2K          | ~$0.01     |
| Research (per durak × 8 durak) | ~40K         | ~$0.20     |
| Route optimization             | ~5K          | ~$0.03     |
| Fun facts + tips               | ~10K         | ~$0.05     |
| **Toplam per rota**            | **~57K**     | **~$0.29** |

Free tier: 3 rota/ay = ~$0.87/user/ay → 50K free user = $43.5K/ay
Premium'dan $6.99/ay × %5 conversion = offset

### Data Flow

```
User Input
    ↓
Orchestrator Agent
    ↓
┌───────────────────────────────────┐
│ Parallel Execution                │
│                                   │
│ Research Agent  Memory Agent      │
│ ├ Google Maps   ├ User profile    │
│ ├ Tavily/Exa    ├ Past trips      │
│ ├ Review APIs   └ Preferences     │
│ └ Fun facts                       │
└───────────┬───────────────────────┘
            ↓
      Route Agent
      ├ Optimal ordering
      ├ Time calculation
      ├ Transport modes
      └ Weather check
            ↓
      Presentation Layer
      ├ Rich cards
      ├ Map overlay
      └ Offline package
            ↓
        User Screen
```

---

## 9. MVP Scope & Timeline (Tahmini)

### Development Approach: Vibe Coding + AI Agent Team

Tek developer + AI development team (Claude Code, Cursor, vb.) ile build. Şehir bazlı kısıtlama yok — AI her destinasyonu on-demand araştırır. Tüm dünya Day 1'de açık.

### Phase 1: Core (0-8 hafta)

- [ ] AI soru-cevap flow
- [ ] Research Agent (Google Maps + LLM — herhangi bir şehir)
- [ ] Rota oluşturma + kart görünümü
- [ ] Harita entegrasyonu
- [ ] Temel UI (Flutter)
- [ ] Auth + user profile

### Phase 2: Intelligence (8-14 hafta)

- [ ] Deep Research (review sentezi, insider tips)
- [ ] Fun facts
- [ ] Zamanlama zekası
- [ ] AI Memory sistemi
- [ ] Post-trip feedback flow

### Phase 3: Gamification (14-18 hafta)

- [ ] Dijital Pasaport
- [ ] Discovery Score
- [ ] Travel Persona
- [ ] Paylaşım özellikleri

### Phase 4: Polish & Launch (18-22 hafta)

- [ ] Offline rota indirme
- [ ] Premium subscription (RevenueCat)
- [ ] App Store + Play Store submission
- [ ] Product Hunt launch hazırlığı
- [ ] Beta test (100 kullanıcı)

**Toplam tahmini: ~5-6 ay** (tek developer + AI agent team ile vibe coding)

---

## 10. Success Metrics (MVP)

### Launch Hedefleri (İlk 3 ay)

| Metrik                  | Hedef | Neden Önemli              |
| ----------------------- | ----- | ------------------------- |
| Downloads               | 10K   | Product Hunt + organic    |
| Oluşturulan rota        | 30K   | Core usage                |
| D7 retention            | %15+  | Industry avg %7.6         |
| D30 retention           | %8+   | Industry avg %2.8         |
| Post-trip feedback rate | %30+  | Learning loop             |
| App Store rating        | 4.5+  | Organic growth            |
| Premium conversion      | %3+   | Revenue validation        |
| NPS                     | 50+   | Product-market fit signal |

### North Star Metric

**"Haftalık aktif rota oluşturan kullanıcı sayısı"**

Bu metrik hem engagement'ı hem de core value delivery'yi ölçer.

---

## 11. Riskler & Mitigasyonlar

| Risk                              | Seviye | Mitigation                                                         |
| --------------------------------- | ------ | ------------------------------------------------------------------ |
| AI maliyeti yüksek                | Yüksek | Caching, cheaper models for simple tasks, rate limit free tier     |
| Hallucination (yanlış bilgi)      | Yüksek | Google Maps grounding, review-based validation, user report button |
| Review API erişim kısıtlaması     | Orta   | Multiple data sources, kendi review DB oluşturma zamanla           |
| Low retention (travel = seasonal) | Orta   | Gamification, domestic micro-trips, "weekend keşif" push           |
| App Store rejection               | Düşük  | Apple/Google guidelines'a uyum, beta test                          |
| Rakip kopyalama                   | Orta   | Hız + gamification data moat + community                           |

---

## Sonraki Adımlar

1. ✅ Market opportunity analysis
2. ✅ Competitive landscape analysis
3. ✅ MVP feature specification
4. ✅ Technical architecture (detaylı)
5. ✅ Financial projections (3-5 yıl detaylı)
6. ✅ Go-to-market strategy
7. ✅ UI/UX wireframes
8. ✅ Development kickoff

---

_Bu doküman Geez AI MVP'sinin kapsamını ve özelliklerini tanımlar. Development sürecinde iteratif olarak güncellenecektir._
