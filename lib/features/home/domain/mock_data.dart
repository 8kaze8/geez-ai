class MockRoute {
  const MockRoute({
    required this.title,
    required this.city,
    required this.stopCount,
    required this.completionPercent,
    required this.nextStop,
    required this.date,
  });

  final String title;
  final String city;
  final int stopCount;
  final double completionPercent;
  final String nextStop;
  final String date;
}

class MockSuggestion {
  const MockSuggestion({
    required this.city,
    required this.country,
    required this.flag,
    required this.reason,
  });

  final String city;
  final String country;
  final String flag;
  final String reason;
}

class MockDiscovery {
  const MockDiscovery({
    required this.placeName,
    required this.score,
    required this.icon,
    this.rating,
  });

  final String placeName;
  final String icon;
  final int score;
  final double? rating;
}

class MockDiscoveryScore {
  const MockDiscoveryScore({
    required this.score,
    required this.tier,
    required this.nextTier,
    required this.pointsToNext,
    required this.progress,
  });

  final int score;
  final String tier;
  final String nextTier;
  final int pointsToNext;
  final double progress;
}

// --- Sample Data ---

const sampleDiscoveryScore = MockDiscoveryScore(
  score: 847,
  tier: 'Explorer',
  nextTier: 'Local',
  pointsToNext: 153,
  progress: 0.7,
);

const sampleActiveRoute = MockRoute(
  title: 'Istanbul Tarihi Rota',
  city: 'Istanbul',
  stopCount: 6,
  completionPercent: 0.6,
  nextStop: 'Topkapi Sarayi',
  date: '13 Mar 2026',
);

const sampleSuggestions = [
  MockSuggestion(
    city: 'Roma',
    country: 'Italya',
    flag: '\u{1F1EE}\u{1F1F9}',
    reason: 'Tarih sever olarak kacirma',
  ),
  MockSuggestion(
    city: 'Atina',
    country: 'Yunanistan',
    flag: '\u{1F1EC}\u{1F1F7}',
    reason: 'Acik hava + antik ruins',
  ),
  MockSuggestion(
    city: 'Barselona',
    country: 'Ispanya',
    flag: '\u{1F1EA}\u{1F1F8}',
    reason: 'Gaudi + street food cenneti',
  ),
];

const sampleDiscoveries = [
  MockDiscovery(
    placeName: 'Suleymaniye Camii',
    icon: '\u{1F3DB}',
    score: 45,
    rating: 4.9,
  ),
  MockDiscovery(
    placeName: 'Balat Sokaklari',
    icon: '\u{1F355}',
    score: 25,
  ),
  MockDiscovery(
    placeName: 'Kapalicarsi',
    icon: '\u{1F4F8}',
    score: 30,
    rating: 4.2,
  ),
  MockDiscovery(
    placeName: 'Yerebatan Sarnici',
    icon: '\u{1F30A}',
    score: 35,
    rating: 4.7,
  ),
];
