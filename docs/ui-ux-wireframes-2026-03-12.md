# Geez AI — UI/UX Wireframes & Design System

**Tarih:** 12 Mart 2026
**Platform:** Flutter (iOS + Android)
**Durum:** Pre-development wireframes

---

## 1. Design Principles

| Prensip                           | Açıklama                                                                |
| --------------------------------- | ----------------------------------------------------------------------- |
| **Keşif Hissi**                   | Her ekran bir "gezi keşfi" gibi hissettirmeli — sürpriz, merak, heyecan |
| **Minimal Input, Maximum Output** | Kullanıcı az yazsın, AI çok üretsin                                     |
| **Card-First**                    | Tüm içerik kart bazlı — scroll, swipe, tap                              |
| **Dark/Light Mode**               | İkisi de desteklenmeli (gece uçak modu)                                 |
| **Micro-animations**              | Her etkileşimde küçük, tatmin edici animasyonlar                        |
| **AI Transparency**               | AI ne yaptığını göster (araştırıyor, review okuyor, rota çiziyor)       |

---

## 2. Color Palette & Typography

### Renkler

```
Primary:     #1A73E8 (Geez Blue — güven, keşif)
Secondary:   #FF6D00 (Sunset Orange — enerji, macera)
Accent:      #00C853 (Discovery Green — doğa, yeni keşif)
Background:  #FAFAFA (Light) / #121212 (Dark)
Surface:     #FFFFFF (Light) / #1E1E1E (Dark)
Text:        #212121 (Light) / #E0E0E0 (Dark)
Muted:       #757575
Error:       #D32F2F
Success:     #388E3C
```

### Gamification Renkleri

```
Foodie:      #FF5722 (Deep Orange)
History:     #795548 (Brown)
Adventure:   #4CAF50 (Green)
Culture:     #9C27B0 (Purple)
Nature:      #009688 (Teal)
Discovery:   #FFC107 (Amber)
```

### Typography

```
Heading:     Inter Bold / 24-32px
Subheading:  Inter SemiBold / 18-20px
Body:        Inter Regular / 14-16px
Caption:     Inter Regular / 12px
AI Chat:     Inter Regular / 15px (biraz daha rounded feel)
Fun Fact:    Inter Medium Italic / 14px
```

---

## 3. Screen Flow Overview

```
┌─────────┐     ┌──────────┐     ┌──────────┐
│ Splash   │ ──→ │ Onboard  │ ──→ │  Home    │
│ Screen   │     │ Quiz     │     │  Screen  │
└─────────┘     └──────────┘     └────┬─────┘
                                      │
                    ┌─────────────────┼──────────────────┐
                    │                 │                   │
              ┌─────▼─────┐   ┌──────▼──────┐   ┌──────▼──────┐
              │  AI Chat   │   │  Passport   │   │  Profile    │
              │  + Route   │   │  + Score    │   │  + Persona  │
              │  Creation  │   │  + History  │   │  + Settings │
              └─────┬─────┘   └─────────────┘   └─────────────┘
                    │
              ┌─────▼─────┐
              │  Route     │
              │  Detail    │
              │  + Map     │
              └─────┬─────┘
                    │
              ┌─────▼─────┐
              │  Active    │
              │  Trip      │
              │  Mode      │
              └─────┬─────┘
                    │
              ┌─────▼─────┐
              │  Post-Trip │
              │  Feedback  │
              └───────────┘
```

---

## 4. Bottom Navigation

```
┌─────────────────────────────────────────────────┐
│                                                 │
│   [Home]     [Keşfet]    [+]     [Passport]  [Profil] │
│    🏠          🧭        ✈️        🛂         👤    │
│                        (FAB)                    │
└─────────────────────────────────────────────────┘

[+] = Floating Action Button — "Yeni Rota" — her zaman erişilebilir
```

| Tab      | Ekran             | İçerik                                         |
| -------- | ----------------- | ---------------------------------------------- |
| Home     | Ana Sayfa         | Mevcut/yaklaşan rota, öneriler, discovery feed |
| Keşfet   | Explore           | Popüler rotalar, ilham, trend destinasyonlar   |
| +        | Yeni Rota         | FAB — AI chat flow başlatır                    |
| Passport | Dijital Pasaport  | Damga koleksiyonu, Discovery Score, stats      |
| Profil   | Kullanıcı Profili | Travel Persona, geçmiş, ayarlar                |

---

## 5. Splash & Onboarding

### 5.1 Splash Screen

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│                                 │
│          ✈️                      │
│                                 │
│        G E E Z   A I            │
│     "Her gezi bir keşif"        │
│                                 │
│                                 │
│        ●●●○ (loading)           │
│                                 │
│                                 │
└─────────────────────────────────┘

- Logo animasyonu: uçak emoji spiral path izler
- Tagline fade-in
- 2 saniye sonra onboarding'e geçiş
```

### 5.2 Onboarding (3 Ekranlı Swipe)

**Ekran 1: Welcome**

```
┌─────────────────────────────────┐
│                                 │
│     [Illustration: AI + Map]    │
│                                 │
│    "Merhaba, ben Geez!"        │
│                                 │
│    "Seni tanımak ve mükemmel   │
│     geziler planlamak           │
│     istiyorum."                │
│                                 │
│         ● ○ ○                   │
│                                 │
│     [Devam Et →]               │
│                                 │
└─────────────────────────────────┘
```

**Ekran 2: Quick Quiz**

```
┌─────────────────────────────────┐
│                                 │
│  "Genelde nasıl gezmeyi        │
│   seversin?"                   │
│                                 │
│  ┌─────────┐  ┌─────────┐     │
│  │ 🏛️       │  │ 🍕       │     │
│  │ Tarihi   │  │ Yemek    │     │
│  │ Keşif    │  │ Turu     │     │
│  └─────────┘  └─────────┘     │
│  ┌─────────┐  ┌─────────┐     │
│  │ 🌿       │  │ 🎒       │     │
│  │ Doğa     │  │ Macera   │     │
│  └─────────┘  └─────────┘     │
│  ┌─────────────────────┐      │
│  │ 🎲 Karma — Surprise me! │   │
│  └─────────────────────┘      │
│                                 │
│  (Birden fazla seçilebilir)    │
│         ○ ● ○                   │
│     [Devam Et →]               │
└─────────────────────────────────┘
```

**Ekran 3: Persona Reveal**

```
┌─────────────────────────────────┐
│                                 │
│    ✨ Confetti animation ✨      │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │   🎭 SENİN TRAVEL         │ │
│  │      PERSONAN:            │ │
│  │                           │ │
│  │   "Adventurous Foodie"    │ │
│  │                           │ │
│  │   🍕 Foodie ........ Lv.1 │ │
│  │   🎒 Adventure ..... Lv.1 │ │
│  │                           │ │
│  │   Discovery Score: 0      │ │
│  │   ░░░░░░░░░░░░░░░ 0%     │ │
│  │                           │ │
│  └───────────────────────────┘ │
│                                 │
│  "Gezine başladıkça            │
│   seviyelerin yükselecek!"     │
│                                 │
│     [İlk Rotamı Planla! →]    │
└─────────────────────────────────┘
```

---

## 6. Home Screen

```
┌─────────────────────────────────┐
│ 👤 Merhaba, Kaze!    🔔 ⚙️     │
│                                 │
│ ┌───────────────────────────┐  │
│ │ 🧭 Discovery Score: 847   │  │
│ │ ████████████░░░ Explorer  │  │
│ │ 153 puan → Local seviye   │  │
│ └───────────────────────────┘  │
│                                 │
│ ── Aktif Rota ──────────────── │
│ ┌───────────────────────────┐  │
│ │ 📍 İstanbul Tarihi Rota   │  │
│ │ 13 Mar 2026 | 6 durak     │  │
│ │ ████████░░ %60 tamamlandı │  │
│ │                           │  │
│ │ Sonraki: Topkapı Sarayı  │  │
│ │ [Devam Et →]              │  │
│ └───────────────────────────┘  │
│                                 │
│ ── Sana Özel ──────────────── │
│ ┌──────────┐  ┌──────────┐    │
│ │ 🇮🇹 Roma   │  │ 🇬🇷 Atina  │    │
│ │ "Tarih    │  │ "Açık hava│    │
│ │  sever    │  │  + antik  │    │
│ │  olarak   │  │  ruins"   │    │
│ │  kaçırma" │  │           │    │
│ │ [Planla]  │  │ [Planla]  │    │
│ └──────────┘  └──────────┘    │
│                                 │
│ ── Son Keşifler ──────────── │
│ ┌───────────────────────────┐  │
│ │ 🏛️ Süleymaniye → ⭐4.9     │  │
│ │ 🍕 Balat Sokakları → +25   │  │
│ │ 📸 Kapalıçarşı → ⭐4.2     │  │
│ └───────────────────────────┘  │
│                                 │
│  [Home]  [Keşfet] [+] [🛂] [👤] │
└─────────────────────────────────┘
```

### Home Screen Bileşenleri

| Bileşen            | Açıklama                                    | Dinamik mi?                      |
| ------------------ | ------------------------------------------- | -------------------------------- |
| **Discovery Bar**  | Kompakt skor göstergesi + seviye progress   | Her gezi sonrası güncellenir     |
| **Aktif Rota**     | En son/aktif rota kartı, devam butonu       | Aktif trip varsa göster          |
| **Sana Özel**      | AI Memory'den kişiselleştirilmiş öneri      | Persona + history bazlı          |
| **Son Keşifler**   | Geçmiş trip'lerden highlights               | Trip tamamlandığında güncellenir |
| **Yeni Kullanıcı** | Aktif rota yoksa: "İlk rotanı oluştur!" CTA | Sadece yeni kullanıcılarda       |

---

## 7. AI Chat & Route Creation (Core Flow)

### 7.1 Chat Başlangıcı

```
┌─────────────────────────────────┐
│ ← Yeni Rota                    │
│                                 │
│  ┌──────────────────────────┐  │
│  │ ✈️ "Nereye gitmek          │  │
│  │    istiyorsun?"            │  │
│  └──────────────────────────┘  │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 📍 Şehir veya ülke yaz...│   │
│  │                    [→]  │   │
│  └─────────────────────────┘   │
│                                 │
│ Popüler:                       │
│ [İstanbul] [Paris] [Roma]      │
│ [Tokyo] [Barcelona] [Londra]   │
└─────────────────────────────────┘
```

### 7.2 Akıllı Sorular (Chip-based UI)

```
┌─────────────────────────────────┐
│ ← İstanbul Rotası              │
│                                 │
│  👤 "İstanbul'a 3 gün          │
│      gideceğim"                │
│                                 │
│  ┌──────────────────────────┐  │
│  │ ✈️ "Harika seçim!          │  │
│  │    Ne tarz bir gezi       │  │
│  │    istiyorsun?"           │  │
│  └──────────────────────────┘  │
│                                 │
│  ┌────────────┐ ┌───────────┐  │
│  │ 🏛️ Tarihi   │ │ 🍕 Yemek   │  │
│  │    keşif    │ │    turu   │  │
│  └────────────┘ └───────────┘  │
│  ┌────────────┐ ┌───────────┐  │
│  │ 💎 Hidden   │ │ 🎲 Karma   │  │
│  │    gems    │ │           │  │
│  └────────────┘ └───────────┘  │
│  ┌─────────────────────────┐   │
│  │ 🎁 Surprise me!          │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### 7.3 Memory Agent Interjection

```
┌─────────────────────────────────┐
│                                 │
│  ... (önceki sorular) ...      │
│                                 │
│  ┌──────────────────────────┐  │
│  │ 🧠 MEMORY INSIGHT         │  │
│  │                          │  │
│  │ "Geçen İstanbul gezinde  │  │
│  │  müze sonrası 'çok kapalı│  │
│  │  alan' demiştin. Açık    │  │
│  │  hava ağırlıklı           │  │
│  │  planlayım mı?"          │  │
│  │                          │  │
│  │  [Evet, hatırlıyorum!]   │  │
│  │  [Bu sefer farklı]       │  │
│  └──────────────────────────┘  │
│                                 │
└─────────────────────────────────┘

- Memory kartı farklı renkte (soft purple/blue gradient)
- 🧠 ikonu ile AI memory olduğu belli
- Sadece 2+ trip sonrası aktif
```

### 7.4 Route Generation Loading

```
┌─────────────────────────────────┐
│ ← İstanbul Rotası              │
│                                 │
│                                 │
│                                 │
│     ┌────────────────────┐     │
│     │  ✈️ ─ ─ ─ ─ → 📍    │     │
│     │   (uçak animasyonu)  │     │
│     └────────────────────┘     │
│                                 │
│  "Rotanı hazırlıyorum..."     │
│                                 │
│  ┌──────────────────────────┐  │
│  │ ✅ Google Maps verileri    │  │
│  │ ✅ 847 review okundu       │  │
│  │ 🔄 Insider tips aranıyor  │  │
│  │ ○ Fun facts hazırlanıyor  │  │
│  │ ○ Rota optimize ediliyor  │  │
│  └──────────────────────────┘  │
│                                 │
│  "Süleymaniye'nin gizli       │
│   bahçesi hakkında ilginç     │
│   bir şey buldum..."          │
│                                 │
└─────────────────────────────────┘

- Gerçek zamanlı progress (hangi agent ne yapıyor)
- Her adım tamamlandığında check + micro-animation
- AI'ın bulduğu ilginç şeyleri snippet olarak göster
- Kullanıcı sabırsızlanmasın — merakını artır
- Tahmini 15-30 saniye
```

---

## 8. Route Detail Screen

### 8.1 Route Overview

```
┌─────────────────────────────────┐
│ ← İstanbul Tarihi Rota   [📤]  │
│                                 │
│ ┌───────────────────────────┐  │
│ │    [HARITA GÖRÜNÜMÜ]      │  │
│ │                           │  │
│ │   📍1 ── 📍2 ── 📍3       │  │
│ │           \              │  │
│ │            📍4 ── 📍5     │  │
│ │                    \     │  │
│ │                     📍6   │  │
│ │                           │  │
│ │  [Haritayı Büyüt]       │  │
│ └───────────────────────────┘  │
│                                 │
│  İstanbul Tarihi Keşif         │
│  📅 3 gün | 📍 18 durak         │
│  🚶 Yürüyüş + toplu taşıma     │
│  💰 ~₺3,200 tahmini bütçe      │
│                                 │
│  [Gün 1 ▼] [Gün 2] [Gün 3]   │
│                                 │
│  ── Gün 1: Sultanahmet ──     │
│  "Tarihin kalbine yolculuk"    │
│                                 │
│  (Durak kartları aşağıda...)   │
│                                 │
└─────────────────────────────────┘
```

### 8.2 Stop Card (Durak Kartı)

```
┌─────────────────────────────────┐
│                                 │
│  ┌───────────────────────────┐ │
│  │ [Mekan Fotoğrafı — full]  │ │
│  │                           │ │
│  │              ⭐ 4.8 (12K) │ │
│  └───────────────────────────┘ │
│                                 │
│  📍 1  Süleymaniye Camii        │
│  ⏰ 09:00 - 10:30               │
│                                 │
│  💡 AI Insight                  │
│  "Kubbe altında dur ve yukarı  │
│   bak — akustiği inanılmaz.    │
│   Fısıltın karşı taraftan      │
│   duyulur."                    │
│                                 │
│  📝 Review Özeti                │
│  "12K yorumda herkes manzarayı │
│   övmüş. Asıl gizli hazine:   │
│   Kanuni türbesi bahçede."     │
│                                 │
│  🎯 Fun Fact                    │
│  "Mimar Sinan bu camiyi        │
│   'çıraklık eserim' demiş.    │
│   Ustalık eseri: Selimiye."   │
│                                 │
│  ── Detaylar ──                │
│  ⏱️ En iyi: Sabah 09:00-10:00  │
│  💰 Ücretsiz giriş             │
│  ⚠️ Cuma 12:30-14:00 kapalı    │
│  📸 Fotoğraf noktası: Bahçe    │
│  👗 Kıyafet: Omuz/diz kapalı   │
│                                 │
│  [Haritada Gör] [Değiştir] [×] │
│                                 │
│  └───────── 🚶 12 dk ──────────┘
│                                 │
│  ┌───────────────────────────┐ │
│  │ 📍 2  Kapalıçarşı          │ │
│  │ ...                        │ │
│  └───────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

### 8.3 Stop Card States

| State         | Görünüm                                | Tetikleyici                  |
| ------------- | -------------------------------------- | ---------------------------- |
| **Upcoming**  | Normal kart, beyaz/gri arka plan       | Default                      |
| **Current**   | Blue highlight border, pulse animasyon | Aktif trip modunda           |
| **Completed** | Soft green tint, check mark overlay    | Kullanıcı "Gezdim" dediğinde |
| **Skipped**   | Muted, strikethrough                   | Kullanıcı "Atla" dediğinde   |
| **Expanded**  | Full card (yukarıdaki gibi)            | Tap to expand                |
| **Collapsed** | Sadece isim + saat + rating            | Default list görünümü        |

### 8.4 Collapsed Card (List View)

```
┌─────────────────────────────────┐
│ 1  📍 Süleymaniye Camii          │
│    09:00-10:30 | ⭐4.8 | Ücretsiz│
│                                  │
│    🚶 12 dk ↓                    │
│                                  │
│ 2  📍 Kapalıçarşı                │
│    10:45-12:30 | ⭐4.5 | Ücretsiz│
│                                  │
│    🚶 8 dk ↓                     │
│                                  │
│ 3  📍 Yerebatan Sarnıcı          │
│    12:45-13:30 | ⭐4.7 | ₺450    │
│                                  │
│    🍽️ Öğle molası önerisi ↓      │
│                                  │
│ ☕ AI Önerisi: Divanyolu Lokantası│
│    "Yerel favori, turist tuzağı │
│     değil" | ⭐4.6 | ~₺200      │
└─────────────────────────────────┘
```

---

## 9. Active Trip Mode

### 9.1 Trip Mode Banner

Rota başlatıldığında alt tab bar'ın üstüne yapışan banner:

```
┌─────────────────────────────────┐
│ ┌───────────────────────────┐  │
│ │ 📍 Sonraki: Topkapı Sarayı │  │
│ │ 🚶 8 dk yürüyüş | 10:30   │  │
│ │ [Navigate] [Gezdim ✓]     │  │
│ └───────────────────────────┘  │
│  [Home]  [Keşfet] [+] [🛂] [👤] │
└─────────────────────────────────┘
```

### 9.2 Active Trip Full Screen

```
┌─────────────────────────────────┐
│ ── Aktif Gezi: İstanbul ──    │
│ Gün 1 / 3  |  Durak 3 / 6     │
│ ████████████░░░░░░ %50          │
│                                 │
│ ┌───────────────────────────┐  │
│ │ MEVCUT DURAK              │  │
│ │                           │  │
│ │ 📍 Yerebatan Sarnıcı       │  │
│ │ ⏰ 12:45 - 13:30            │  │
│ │                           │  │
│ │ 💡 "Medusa başlarını       │  │
│ │    mutlaka bul — sarnıcın │  │
│ │    en dibinde, sol köşe"  │  │
│ │                           │  │
│ │ [Navigate] [Detay]        │  │
│ └───────────────────────────┘  │
│                                 │
│  [Gezdim ✓]    [Atla →]       │
│                                 │
│ ── Sıradaki ──                 │
│ ┌───────────────────────────┐  │
│ │ 📍 4. Ayasofya — 14:00      │  │
│ │ 🚶 5 dk yürüyüş             │  │
│ └───────────────────────────┘  │
│ ┌───────────────────────────┐  │
│ │ 📍 5. Sultanahmet — 15:30   │  │
│ └───────────────────────────┘  │
│                                 │
│ [Geziyi Bitir]                 │
└─────────────────────────────────┘

"Gezdim" butonuna basınca:
→ Hafif confetti + Discovery Score +X animasyonu
→ Kart yeşile döner
→ Bir sonraki durak öne çıkar
```

---

## 10. Digital Passport Screen

```
┌─────────────────────────────────┐
│           🛂 GEZ PASAPORTU       │
│                                 │
│  ┌───────────────────────────┐ │
│  │ [Pasaport kapağı — deri   │ │
│  │  texture, Geez AI logosu, │ │
│  │  kullanıcı adı emboss]   │ │
│  └───────────────────────────┘ │
│                                 │
│  Tap to open ↓                 │
│                                 │
│  ── Damgalarım ──              │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ │
│  │🇹🇷  │ │🇮🇹  │ │🇬🇷  │ │❓  │ │
│  │IST │ │ROM │ │ATH │ │??? │ │
│  │✅  │ │✅  │ │✅  │ │🔒  │ │
│  │3/26│ │2/26│ │1/26│ │    │ │
│  └────┘ └────┘ └────┘ └────┘ │
│                                 │
│  📊 İstatistikler               │
│  ┌───────────────────────────┐ │
│  │ Şehir: 3  | Ülke: 3      │ │
│  │ Kıta: 1   | Durak: 24    │ │
│  │ Toplam km: 1,247         │ │
│  │                           │ │
│  │ Hedef: 5 ülke             │ │
│  │ ██████████░░░░ 60%       │ │
│  └───────────────────────────┘ │
│                                 │
│  ── Koleksiyonlar ──           │
│  [🏛️ Antik Dünya 2/7]          │
│  [🍕 Food Capital 1/5]         │
│  [🏖️ Akdeniz 2/8]              │
│                                 │
│  [Pasaportumu Paylaş 📤]       │
│                                 │
└─────────────────────────────────┘
```

### Damga Detay (Tap on stamp)

```
┌─────────────────────────────────┐
│ ← Damgalarım                   │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │    🇹🇷 İSTANBUL            │ │
│  │                           │ │
│  │    [Vintage damga          │ │
│  │     stili illüstrasyon:    │ │
│  │     Ayasofya silüeti]      │ │
│  │                           │ │
│  │    12 Mart 2026           │ │
│  │    3 gün | 18 durak       │ │
│  │                           │ │
│  └───────────────────────────┘ │
│                                 │
│  En Sevdiğin: Süleymaniye      │
│  Discovery: +127 puan          │
│  Hidden Gems: 4 keşfedildi     │
│                                 │
│  [Rotayı Tekrar Gör]          │
│  [Paylaş]                      │
│                                 │
└─────────────────────────────────┘
```

---

## 11. Profile & Travel Persona

```
┌─────────────────────────────────┐
│ ← Profil                       │
│                                 │
│  ┌───────────────────────────┐ │
│  │     [Avatar / Fotoğraf]   │ │
│  │      Kaze                 │ │
│  │  "Adventurous Foodie"     │ │
│  │                           │ │
│  │  🧭 847 Discovery Score   │ │
│  │  ⭐⭐⭐⭐☆ Explorer         │ │
│  └───────────────────────────┘ │
│                                 │
│  ── Travel Persona ──          │
│  ┌───────────────────────────┐ │
│  │ 🍕 Foodie ........... Lv.5│ │
│  │ █████████░░░░░░ 67%      │ │
│  │                           │ │
│  │ 🏛️ History Buff ..... Lv.3│ │
│  │ ██████░░░░░░░░░ 45%      │ │
│  │                           │ │
│  │ 🎒 Adventure ....... Lv.7│ │
│  │ ████████████░░░ 82%      │ │
│  │                           │ │
│  │ 🎨 Culture ......... Lv.4│ │
│  │ ███████░░░░░░░░ 53%      │ │
│  │                           │ │
│  │ 🌿 Nature .......... Lv.1│ │
│  │ ██░░░░░░░░░░░░░ 12%      │ │
│  └───────────────────────────┘ │
│                                 │
│  [Personamı Paylaş 📤]         │
│                                 │
│  ── Geçmiş Geziler ──          │
│  📍 İstanbul — Mar 2026        │
│  📍 Roma — Feb 2026             │
│  📍 Atina — Jan 2026            │
│                                 │
│  ── Ayarlar ──                  │
│  [Dil: Türkçe]                 │
│  [Tema: Light/Dark]            │
│  [Bildirimler]                 │
│  [Premium ⭐]                   │
│  [Hesap]                       │
│                                 │
└─────────────────────────────────┘
```

---

## 12. Post-Trip Feedback

### 12.1 Feedback Trigger

Push notification (gezi bitiş + 2 saat sonra):

```
"İstanbul gezin nasıldı? 2 dk ayır, bir sonraki gezini 10x iyi planlayayım!"
```

### 12.2 Feedback Flow (Bottom Sheet + Swipe Cards)

**Ekran 1: Genel Puan**

```
┌─────────────────────────────────┐
│                                 │
│  "İstanbul gezini nasıl        │
│   buldun?"                     │
│                                 │
│    ☆  ☆  ☆  ☆  ☆              │
│   (tap to rate, 1-5)           │
│                                 │
│         [Devam →]              │
│                                 │
└─────────────────────────────────┘
```

**Ekran 2: Favori Durak**

```
┌─────────────────────────────────┐
│                                 │
│  "En çok hangisi hoşuna gitti?"│
│                                 │
│  ┌──────┐ ┌──────┐ ┌──────┐  │
│  │📍1    │ │📍2    │ │📍3    │  │
│  │Süley- │ │Kapalı │ │Yereba│  │
│  │maniye │ │çarşı  │ │tan   │  │
│  │  ○    │ │  ○    │ │  ○   │  │
│  └──────┘ └──────┘ └──────┘  │
│  ┌──────┐ ┌──────┐ ┌──────┐  │
│  │📍4    │ │📍5    │ │📍6    │  │
│  │Ayasof │ │Sultan │ │Balat │  │
│  │ya     │ │ahmet  │ │      │  │
│  │  ○    │ │  ○    │ │  ○   │  │
│  └──────┘ └──────┘ └──────┘  │
│                                 │
│  (Birden fazla seçilebilir)    │
│         [Devam →]              │
└─────────────────────────────────┘
```

**Ekran 3: Beğenmediğin**

```
┌─────────────────────────────────┐
│                                 │
│  "Bir daha gitme dediğin       │
│   var mı?"                     │
│                                 │
│  (Aynı kart seçim UI'ı)       │
│                                 │
│  [Hepsi güzeldi 👍] [Devam →]  │
└─────────────────────────────────┘
```

**Ekran 4: Serbest Feedback**

```
┌─────────────────────────────────┐
│                                 │
│  "Keşke rotada olsaydı         │
│   dediğin bir şey var mı?"    │
│                                 │
│  ┌──────────────────────────┐  │
│  │                          │  │
│  │  (serbest metin alanı)   │  │
│  │                          │  │
│  └──────────────────────────┘  │
│                                 │
│  [Atla]           [Devam →]    │
└─────────────────────────────────┘
```

**Ekran 5: Reward!**

```
┌─────────────────────────────────┐
│                                 │
│     ✨ Confetti + Haptic ✨      │
│                                 │
│  "Teşekkürler! Seni daha iyi  │
│   tanıdım."                   │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │  🛂 İstanbul damgası       │ │
│  │     eklendi!              │ │
│  │                           │ │
│  │  🧭 +127 Discovery Score   │ │
│  │  🍕 Foodie Lv.5 → Lv.6!   │ │
│  │                           │ │
│  └───────────────────────────┘ │
│                                 │
│  [Pasaportuma Bak]             │
│  [Ana Sayfaya Dön]             │
│                                 │
└─────────────────────────────────┘
```

---

## 13. Explore / Keşfet Screen

```
┌─────────────────────────────────┐
│ 🧭 Keşfet                       │
│                                 │
│ ┌───────────────────────────┐  │
│ │ 🔍 Şehir, ülke veya tema...│  │
│ └───────────────────────────┘  │
│                                 │
│ ── Senin İçin Öneriler ──     │
│ (Memory Agent bazlı)           │
│                                 │
│ ┌──────────┐  ┌──────────┐    │
│ │ [Foto]   │  │ [Foto]   │    │
│ │ Barselona│  │ Marakeş  │    │
│ │ "Foodie  │  │ "Macera  │    │
│ │  cenneti"│  │  + tarih"│    │
│ │ ⭐4.7    │  │ ⭐4.5    │    │
│ └──────────┘  └──────────┘    │
│                                 │
│ ── Trend Rotalar ──            │
│ ┌───────────────────────────┐  │
│ │ 🔥 "48 Saat Paris" — 2.3K  │  │
│ │    kez planlandı           │  │
│ │ 🔥 "İstanbul Street Food"  │  │
│ │    — 1.8K kez planlandı    │  │
│ │ 🔥 "Roma Antik Rota"       │  │
│ │    — 1.5K kez planlandı    │  │
│ └───────────────────────────┘  │
│                                 │
│ ── Tematik Koleksiyonlar ──   │
│ [🍕 Yemek Başkentleri]         │
│ [🏛️ Antik Dünya Turu]          │
│ [🏖️ Akdeniz Rotaları]          │
│ [💎 Hidden Gem Şehirler]       │
│                                 │
└─────────────────────────────────┘
```

---

## 14. Premium Upgrade Screen

```
┌─────────────────────────────────┐
│ ← Premium                      │
│                                 │
│         ⭐ GEEZ PRO              │
│                                 │
│  "Daha derin keşifler,         │
│   sınırsız macera"             │
│                                 │
│  ── Neler Dahil? ──            │
│                                 │
│  ✅ Sınırsız rota oluşturma    │
│     (Free: 3/ay)               │
│                                 │
│  ✅ Deep Research (detailed)    │
│     Insider tips, review sentez│
│                                 │
│  ✅ Offline rota indirme        │
│                                 │
│  ✅ Gelişmiş AI Memory          │
│     Daha akıllı öneriler       │
│                                 │
│  ✅ Reklamsız deneyim           │
│                                 │
│  ✅ Öncelikli destek            │
│                                 │
│  ┌───────────────────────────┐ │
│  │ AYLIK        │ YILLIK     │ │
│  │ ₺229/ay      │ ₺1,599/yıl│ │
│  │              │ ₺133/ay    │ │
│  │              │ %42 TASARRUF│ │
│  │  [Başla]     │ [Başla ⭐] │ │
│  └───────────────────────────┘ │
│                                 │
│  7 gün ücretsiz deneme         │
│  İstediğin zaman iptal et      │
│                                 │
└─────────────────────────────────┘
```

---

## 15. Key Micro-interactions & Animations

| Etkileşim            | Animasyon                                   | Platform                |
| -------------------- | ------------------------------------------- | ----------------------- |
| **Route Generation** | Uçak emoji spiral path + progress bar       | Lottie                  |
| **Stop Complete**    | Mini confetti burst + score popup (+15)     | Rive                    |
| **New Stamp**        | Damga "vurulma" animasyonu (stamp press)    | Lottie                  |
| **Level Up**         | Glow effect + particle burst + haptic       | Rive                    |
| **Discovery Score**  | Counter odometer animation (847 → 862)      | Flutter built-in        |
| **Persona Level**    | Progress bar smooth fill + sparkle          | Flutter AnimatedBuilder |
| **Memory Insight**   | Soft fade-in + subtle glow border           | CSS/Flutter             |
| **Chip Selection**   | Scale bounce (1.0 → 1.1 → 1.0) + color fill | Spring animation        |
| **Card Expand**      | Hero animation + blur background            | Flutter Hero            |
| **Pull to Refresh**  | Custom Geez mascot animation                | Lottie                  |
| **Swipe Feedback**   | Card slides out + next card slides in       | PageView                |
| **Trip Complete**    | Full-screen confetti + stamp animation      | Lottie overlay          |

---

## 16. Design Tokens (Flutter)

```dart
// colors.dart
class GeezColors {
  static const primary = Color(0xFF1A73E8);
  static const secondary = Color(0xFFFF6D00);
  static const accent = Color(0xFF00C853);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const background = Color(0xFFFAFAFA);
  static const backgroundDark = Color(0xFF121212);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);

  // Persona colors
  static const foodie = Color(0xFFFF5722);
  static const history = Color(0xFF795548);
  static const adventure = Color(0xFF4CAF50);
  static const culture = Color(0xFF9C27B0);
  static const nature = Color(0xFF009688);
  static const discovery = Color(0xFFC107);
}

// spacing.dart
class GeezSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

// radius.dart
class GeezRadius {
  static const card = 16.0;
  static const chip = 24.0;
  static const button = 12.0;
  static const avatar = 40.0;
  static const stamp = 8.0;
}

// typography.dart (Inter font)
class GeezTypography {
  static const h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  static const h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const bodySmall = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
  static const funFact = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic);
}
```

---

## 17. Responsive Considerations

| Platform              | Yaklaşım                                         |
| --------------------- | ------------------------------------------------ |
| **iPhone SE**         | Compact mode — kartlar daha küçük, single column |
| **iPhone 15**         | Default reference design (bu wireframe)          |
| **iPhone 15 Pro Max** | Wider cards, harita daha büyük                   |
| **Android (varied)**  | Material Design 3 uyumu, edge-to-edge            |
| **Tablet**            | 2 kolon layout (ileride, MVP değil)              |

---

## 18. Accessibility

| Gereksinim          | Çözüm                                          |
| ------------------- | ---------------------------------------------- |
| **Renk kontrastı**  | WCAG AA minimum (4.5:1 text, 3:1 UI)           |
| **Font boyutu**     | System font scaling destekle                   |
| **Screen reader**   | Semantik labels tüm interaktif elemanlar       |
| **Haptic feedback** | Stamp, level up, complete — vibration patterns |
| **Reduced motion**  | Animasyonları kapat seçeneği                   |
| **Dark mode**       | Tam dark theme desteği                         |

---

## 19. Ekran Envanteri (Development Checklist)

### Phase 1: Core (8 ekran)

- [ ] Splash Screen
- [ ] Onboarding (3 sayfa swipe)
- [ ] Home Screen
- [ ] AI Chat / Route Creation
- [ ] Route Generation Loading
- [ ] Route Detail (Overview + Map)
- [ ] Stop Card (Expanded + Collapsed)
- [ ] Settings

### Phase 2: Intelligence (4 ekran)

- [ ] Memory Insight Cards (chat içinde)
- [ ] Post-Trip Feedback Flow (5 sayfa)
- [ ] Enhanced Stop Card (reviews, tips, fun facts)
- [ ] Trip History

### Phase 3: Gamification (5 ekran)

- [ ] Digital Passport (main + stamp detail)
- [ ] Discovery Score (home widget + detail)
- [ ] Travel Persona (profile section + share card)
- [ ] Active Trip Mode (banner + full screen)
- [ ] Level Up / Reward Overlays

### Phase 4: Polish (3 ekran)

- [ ] Explore / Keşfet
- [ ] Premium Upgrade
- [ ] Share Cards (passport, persona, route)

**Toplam: ~20 unique ekran**

---

_Bu wireframe dokümanı development öncesi referans olarak kullanılacaktır. High-fidelity mockup'lar Figma'da oluşturulabilir veya doğrudan Flutter'da prototype yapılabilir (vibe coding yaklaşımı)._
