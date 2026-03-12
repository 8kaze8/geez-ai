class RouteStop {
  final int number;
  final String name;
  final String timeStart;
  final String timeEnd;
  final double rating;
  final int reviewCount;
  final String price;
  final String description;
  final String insiderTip;
  final String funFact;
  final String reviewSummary;
  final String bestTime;
  final List<String> warnings;
  final String? photoTip;
  final String? dresscode;

  const RouteStop({
    required this.number,
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.description,
    required this.insiderTip,
    required this.funFact,
    required this.reviewSummary,
    required this.bestTime,
    this.warnings = const [],
    this.photoTip,
    this.dresscode,
  });
}

class TravelSegment {
  final String mode; // walking, transit, car
  final String icon;
  final int durationMinutes;
  final String description;

  const TravelSegment({
    required this.mode,
    required this.icon,
    required this.durationMinutes,
    required this.description,
  });
}

class RouteDay {
  final int dayNumber;
  final String title;
  final String subtitle;
  final List<RouteStop> stops;
  final List<TravelSegment> travelSegments;

  const RouteDay({
    required this.dayNumber,
    required this.title,
    required this.subtitle,
    required this.stops,
    required this.travelSegments,
  });
}

class MockRoute {
  final String title;
  final int totalDays;
  final int totalStops;
  final String transportMode;
  final String estimatedBudget;
  final List<RouteDay> days;

  const MockRoute({
    required this.title,
    required this.totalDays,
    required this.totalStops,
    required this.transportMode,
    required this.estimatedBudget,
    required this.days,
  });
}

final mockIstanbulRoute = MockRoute(
  title: 'İstanbul Tarihi Keşif',
  totalDays: 3,
  totalStops: 6,
  transportMode: 'Yürüyüş',
  estimatedBudget: '~₺3,200',
  days: [
    RouteDay(
      dayNumber: 1,
      title: 'Sultanahmet & Tarihi Yarımada',
      subtitle: 'Tarihin kalbine yolculuk',
      stops: [
        const RouteStop(
          number: 1,
          name: 'Süleymaniye Camii',
          timeStart: '09:00',
          timeEnd: '10:30',
          rating: 4.8,
          reviewCount: 12400,
          price: 'Ücretsiz',
          description:
              'Mimar Sinan\'ın İstanbul silüetine armağanı. Boğaz manzarası eşliğinde '
              'mimari bir şölene hazır ol.',
          insiderTip:
              'Kubbe altında tam ortada dur ve yukarı bak — akustiği inanılmaz. '
              'Fısıltın karşı taraftan duyulur. Ayrıca bahçedeki Kanuni türbesini '
              'çoğu turist atlar, kaçırma.',
          funFact:
              'Mimar Sinan bu camiyi "çıraklık eserim" demiş. Ustalık eseri olarak '
              'Edirne Selimiye\'yi gösterir. Çıraklık eseri bu kadar muhteşemse, '
              'ustalığı hayal et!',
          reviewSummary:
              '12K yorumda herkes manzarayı ve huzuru övmüş. En çok tekrarlanan tavsiye: '
              '"Sabah erken gidin, kalabalık olmadan caminin ihtişamını hissedin."',
          bestTime: 'Sabah 09:00-10:00, namaz saatleri dışı',
          warnings: ['Cuma namazı: 12:30-14:00 arası ziyaretçilere kapalı'],
          photoTip: 'Bahçeden Haliç manzarası',
          dresscode: 'Omuz ve diz kapalı olmalı',
        ),
        const RouteStop(
          number: 2,
          name: 'Kapalıçarşı',
          timeStart: '10:45',
          timeEnd: '12:30',
          rating: 4.5,
          reviewCount: 28900,
          price: 'Ücretsiz',
          description:
              '1461\'den beri ayakta! 4.000+ dükkanıyla dünyanın en eski ve en büyük '
              'kapalı çarşılarından biri. Kaybolmaya hazır ol — çünkü herkes kaybolur.',
          insiderTip:
              'Ana caddelerden sap, iç sokaklarda gerçek zanaatkarlar var. Kuyumcular '
              'Caddesi\'nden sonra sola dön — orada 5. kuşak bir bakırcı dükkanı var, '
              'fiyatlar yarı yarıya.',
          funFact:
              'Kapalıçarşı\'nın kendi posta kodu, camisi, hamamı ve çeşmesi var. '
              'Aslında bir şehir içinde şehir!',
          reviewSummary:
              '29K yorumda en çok uyarılan konu: "Pazarlık yapın!" İkinci en çok '
              'söylenen: "İç sokaklara dalın, ana cadde tourist trap."',
          bestTime: 'Sabah 10:00-11:00, hafta içi daha sakin',
          warnings: [
            'Pazar günü kapalı',
            'Çantanıza dikkat edin — kalabalık olabiliyor',
          ],
          photoTip: 'Tavan mozaiklerini yukarı bakarak çekin',
        ),
        const RouteStop(
          number: 3,
          name: 'Yerebatan Sarnıcı',
          timeStart: '12:45',
          timeEnd: '13:30',
          rating: 4.7,
          reviewCount: 18200,
          price: '₺450',
          description:
              '532 yılında inşa edilen, 336 sütunlu yeraltı su deposu. '
              'Atmosfer olarak İstanbul\'un en büyüleyici mekanlarından biri.',
          insiderTip:
              'Medusa başlarını mutlaka bul — sarnıcın en dibinde, sol köşe. '
              'Biri ters, biri yan duruyor. Neden böyle yerleştirildiği hâlâ tartışılıyor.',
          funFact:
              'James Bond "Rusya\'dan Sevgilerle" filminde burada çekilmiş. '
              'Ayrıca sarnıç, Osmanlı döneminde unutulmuş ve evlerin altında '
              'yüzyıllarca gizli kalmış!',
          reviewSummary:
              '18K yorumda en çok bahsedilen: "Atmosfer inanılmaz, ışıklandırma '
              'mükemmel." Uyarı: "Yoğun saatlerde çok kalabalık, sabah erken gidin."',
          bestTime: 'Öğle 12:00-13:00 veya kapanışa yakın',
          warnings: ['Merdivenler kaygan olabiliyor — rahat ayakkabı şart'],
          photoTip: 'Sütun yansımalarını su üzerinde yakalayın',
        ),
        const RouteStop(
          number: 4,
          name: 'Ayasofya',
          timeStart: '14:00',
          timeEnd: '15:30',
          rating: 4.9,
          reviewCount: 42100,
          price: '₺600',
          description:
              '537\'den beri ayakta. Bazilika, cami, müze, yeniden cami. '
              '1.500 yılda birçok kimlik değiştirmiş ama ihtişamı hiç azalmamış.',
          insiderTip:
              'Üst galeriye çıkmayı unutma — mozaikler orada ve çoğu kişi atlar. '
              'Ayrıca "Ter Damlası Sütunu"na parmağını koy ve 360° çevir — '
              'efsaneye göre dileğin gerçekleşir.',
          funFact:
              'Ayasofya\'nın kubbesi yapıldığında dünyanın en büyüğüydü ve bu '
              'rekoru 1.000 yıl korudu. Kubbe, depremlerle 2 kez çöküp '
              'yeniden yapıldı.',
          reviewSummary:
              '42K yorumda tartışmasız 1 numara: "Hayatımda gördüğüm en etkileyici '
              'yapı." Pratik not: "Kuyruk uzun, online bilet alın."',
          bestTime: 'Öğleden sonra 14:00-15:00',
          warnings: [
            'Namaz saatlerinde turistlere kapalı bölümler olabiliyor',
            'Online bilet şart — kuyruk çok uzun',
          ],
          dresscode: 'Omuz ve diz kapalı olmalı',
          photoTip: 'İç mekanda geniş açı lens şart',
        ),
        const RouteStop(
          number: 5,
          name: 'Sultanahmet Camii',
          timeStart: '15:45',
          timeEnd: '16:30',
          rating: 4.8,
          reviewCount: 35600,
          price: 'Ücretsiz',
          description:
              '"Mavi Cami" — 20.000+ İznik çinisiyle bezeli iç mekan seni '
              'mavinin tonlarında kaybolmaya davet ediyor.',
          insiderTip:
              'Dışarıdan fotoğraf çekmek için en iyi spot: Ayasofya tarafındaki '
              'park. İçeride ise mihrap tarafına yönel — çiniler orada en yoğun.',
          funFact:
              'Sultanahmet\'in 6 minaresi var. Rivayete göre mimar, Sultan\'ın '
              '"altın" (altın minare) isteğini "altı" (6 minare) diye yanlış '
              'anlamış. Kazara dünya rekoru!',
          reviewSummary:
              '36K yorumda en çok: "Çiniler nefes kesici." İkinci en çok: '
              '"Ayasofya\'dan sonra gidin, karşılaştırma harika."',
          bestTime: 'Namaz dışı saatler, öğleden sonra 15:30-16:30',
          warnings: [
            'Namaz saatlerinde ziyaretçilere kapalı',
            'Giriş sırası uzun olabiliyor',
          ],
          dresscode: 'Omuz ve diz kapalı, başörtüsü (girişte veriliyor)',
          photoTip: 'Avludan minare çekimleri',
        ),
        const RouteStop(
          number: 6,
          name: 'Balat',
          timeStart: '17:00',
          timeEnd: '19:00',
          rating: 4.6,
          reviewCount: 8700,
          price: 'Ücretsiz',
          description:
              'İstanbul\'un en renkli mahallesi. Tarihi evler, sokak sanatı, '
              'bağımsız kafeler ve yerel hayatın en otantik hali.',
          insiderTip:
              'Merdivenli Yokuş\'u (Kiremit Sokak) kaçırma — rengarenk merdivenler '
              'Instagram\'ın en çok çekilen noktası. Ama asıl güzellik arka '
              'sokaklardaki eski Rum evlerinde.',
          funFact:
              'Balat, Osmanlı döneminde Yahudi, Rum ve Ermeni toplulukların bir '
              'arada yaşadığı kozmopolit bir mahalleydi. Sokaklarda hâlâ farklı '
              'kültürlerin izlerini görebilirsin.',
          reviewSummary:
              '8.7K yorumda en çok: "Turist tuzaklarından uzak, gerçek İstanbul '
              'burada." İkinci: "Kafeler harika, fiyatlar makul."',
          bestTime: 'Öğleden sonra 16:00-19:00, golden hour ışığı muhteşem',
          warnings: [
            'Yokuşları ve arnavut kaldırımları var — rahat ayakkabı',
          ],
          photoTip: 'Golden hour\'da renkli evler önünde',
        ),
      ],
      travelSegments: [
        const TravelSegment(
          mode: 'walking',
          icon: '🚶',
          durationMinutes: 12,
          description: '12 dk yürüyüş',
        ),
        const TravelSegment(
          mode: 'walking',
          icon: '🚶',
          durationMinutes: 8,
          description: '8 dk yürüyüş',
        ),
        const TravelSegment(
          mode: 'walking',
          icon: '🚶',
          durationMinutes: 15,
          description: '15 dk yürüyüş',
        ),
        const TravelSegment(
          mode: 'walking',
          icon: '🚶',
          durationMinutes: 10,
          description: '10 dk yürüyüş',
        ),
        const TravelSegment(
          mode: 'walking',
          icon: '🚌',
          durationMinutes: 25,
          description: '25 dk (otobüs + yürüyüş)',
        ),
      ],
    ),
    RouteDay(
      dayNumber: 2,
      title: 'Boğaz & Beşiktaş',
      subtitle: 'Denizin iki yakası',
      stops: const [],
      travelSegments: const [],
    ),
    RouteDay(
      dayNumber: 3,
      title: 'Kadıköy & Moda',
      subtitle: 'Anadolu yakası keşfi',
      stops: const [],
      travelSegments: const [],
    ),
  ],
);
