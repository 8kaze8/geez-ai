class OnboardingState {
  const OnboardingState({
    this.selectedStyles = const [],
    this.budget = '',
    this.companion = '',
  });

  final List<String> selectedStyles;
  final String budget;
  final String companion;

  /// Helper to check if a style label (with emoji prefix) is selected.
  bool _hasStyle(String keyword) {
    return selectedStyles.any((s) => s.contains(keyword));
  }

  String get personaName {
    if (selectedStyles.isEmpty) return 'Explorer';

    // Map style selections to persona traits
    final traits = <String>[];

    if (_hasStyle('Macera')) traits.add('Adventurous');
    if (_hasStyle('Yemek Turu')) traits.add('Foodie');
    if (_hasStyle('Tarihi Keşif')) traits.add('History Buff');
    if (_hasStyle('Doğa')) traits.add('Nature Lover');
    if (_hasStyle('Karma')) traits.add('Spontaneous');

    if (traits.isEmpty) return 'Explorer';
    if (traits.length == 1) return traits.first;

    // Build a compound persona name from top 2 traits
    return '${traits[0]} ${traits[1]}';
  }

  /// Returns dominant persona categories derived from style selections.
  List<PersonaTrait> get personaTraits {
    return [
      PersonaTrait(
        name: 'Foodie',
        emoji: '🍕',
        level: 1,
        isActive: _hasStyle('Yemek Turu') || _hasStyle('Karma'),
      ),
      PersonaTrait(
        name: 'History',
        emoji: '🏛️',
        level: 1,
        isActive: _hasStyle('Tarihi Keşif') || _hasStyle('Karma'),
      ),
      PersonaTrait(
        name: 'Adventure',
        emoji: '🎒',
        level: 1,
        isActive: _hasStyle('Macera') || _hasStyle('Karma'),
      ),
      PersonaTrait(
        name: 'Culture',
        emoji: '🎨',
        level: 1,
        isActive: _hasStyle('Tarihi Keşif') || _hasStyle('Karma'),
      ),
      PersonaTrait(
        name: 'Nature',
        emoji: '🌿',
        level: 1,
        isActive: _hasStyle('Doğa') || _hasStyle('Karma'),
      ),
    ];
  }

  OnboardingState copyWith({
    List<String>? selectedStyles,
    String? budget,
    String? companion,
  }) {
    return OnboardingState(
      selectedStyles: selectedStyles ?? this.selectedStyles,
      budget: budget ?? this.budget,
      companion: companion ?? this.companion,
    );
  }
}

class PersonaTrait {
  const PersonaTrait({
    required this.name,
    required this.emoji,
    required this.level,
    required this.isActive,
  });

  final String name;
  final String emoji;
  final int level;
  final bool isActive;
}
