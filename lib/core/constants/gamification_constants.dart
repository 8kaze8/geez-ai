// Authoritative thresholds for the Geez AI discovery score tier system.
// Both the home and profile providers must derive all tier logic from here.
// The DB column `explorer_tier` is set by a Supabase trigger using the same
// thresholds — keep them in sync when changing values.
class GamificationConstants {
  GamificationConstants._();

  static const Map<String, int> tierThresholds = {
    'tourist': 0,
    'traveler': 200,
    'explorer': 500,
    'local': 1000,
    'legend': 2500, // DB authoritative value
  };

  static const Map<String, String> tierLabels = {
    'tourist': 'Turist',
    'traveler': 'Gezgin',
    'explorer': 'Ka\u015fif',
    'local': 'Yerli',
    'legend': 'Efsane',
  };

  static String tierForScore(int score) {
    if (score >= 2500) return 'legend';
    if (score >= 1000) return 'local';
    if (score >= 500) return 'explorer';
    if (score >= 200) return 'traveler';
    return 'tourist';
  }

  static int starsForScore(int score) {
    if (score >= 2500) return 5;
    if (score >= 1000) return 4;
    if (score >= 500) return 3;
    if (score >= 200) return 2;
    return 1;
  }

  static double progressForScore(int score) {
    const thresholds = [0, 200, 500, 1000, 2500];
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (score >= thresholds[i]) {
        if (i == thresholds.length - 1) return 1.0;
        final current = thresholds[i];
        final next = thresholds[i + 1];
        return (score - current) / (next - current);
      }
    }
    return 0.0;
  }
}
