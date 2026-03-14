import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/onboarding/data/onboarding_repository.dart';
import 'package:geez_ai/features/onboarding/domain/onboarding_state.dart';
import 'package:geez_ai/features/onboarding/domain/onboarding_submit_state.dart';

/// SharedPreferences key used to persist quiz answers for unauthenticated users.
///
/// The value is a JSON-encoded map with the same field names used in
/// [OnboardingState] so that it can be decoded back without ambiguity.
const _kPendingOnboardingKey = 'onboarding_pending';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class OnboardingNotifier
    extends StateNotifier<(OnboardingState, OnboardingSubmitState)> {
  OnboardingNotifier(this._ref)
      : super((const OnboardingState(), const OnboardingSubmitState()));

  final Ref _ref;

  // ---- quiz state mutators --------------------------------------------------

  OnboardingState get quizState => state.$1;
  OnboardingSubmitState get submitState => state.$2;

  void updateState(OnboardingState newQuizState) {
    state = (newQuizState, state.$2);
  }

  // ---- submit --------------------------------------------------------------

  /// Persist quiz results.
  ///
  /// If the user is authenticated the data goes straight to Supabase.
  /// If not, it is serialised to [SharedPreferences] under
  /// [_kPendingOnboardingKey] so [flushPendingOnboarding] can write it
  /// after the user signs up.
  Future<void> submitOnboarding() async {
    _setSubmit(const OnboardingSubmitState(
      status: OnboardingSubmitStatus.loading,
    ));

    try {
      final auth = _ref.read(authStateProvider);

      if (auth.isAuthenticated && auth.user != null) {
        await _writeToSupabase(auth.user!.id);
      } else {
        await _writeToPendingPrefs();
      }

      _setSubmit(const OnboardingSubmitState(
        status: OnboardingSubmitStatus.success,
      ));
    } catch (e) {
      _setSubmit(OnboardingSubmitState(
        status: OnboardingSubmitStatus.error,
        errorMessage: 'Bir sorun oluştu, lütfen tekrar deneyin.',
      ));
    }
  }

  /// Called from [SignupScreen] after a successful sign-up to drain the
  /// pending quiz answers from SharedPreferences and write them to Supabase.
  ///
  /// Returns `true` if pending data was found and written, `false` otherwise.
  static Future<bool> flushPendingOnboarding(
    Ref ref,
    String userId,
  ) async {
    final repo = ref.read(onboardingRepositoryProvider);
    return flushPendingOnboardingWith(repo, userId);
  }

  /// Same as [flushPendingOnboarding] but accepts an [OnboardingRepository]
  /// directly — useful when called from a WidgetRef context.
  static Future<bool> flushPendingOnboardingWith(
    OnboardingRepository repo,
    String userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPendingOnboardingKey);
    if (raw == null) return false;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final quizState = OnboardingState(
        selectedStyles: List<String>.from(
          (map['selectedStyles'] as List<dynamic>? ?? []),
        ),
        budget: (map['budget'] as String?) ?? '',
        companion: (map['companion'] as String?) ?? '',
      );

      await _persist(repo, userId, quizState);
      await prefs.remove(_kPendingOnboardingKey);
      return true;
    } catch (_) {
      // Best-effort: don't crash signup if flush fails.
      return false;
    }
  }

  // ---- private helpers -----------------------------------------------------

  Future<void> _writeToSupabase(String userId) async {
    final repo = _ref.read(onboardingRepositoryProvider);
    await _persist(repo, userId, quizState);
  }

  Future<void> _writeToPendingPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'selectedStyles': quizState.selectedStyles,
      'budget': quizState.budget,
      'companion': quizState.companion,
    };
    await prefs.setString(_kPendingOnboardingKey, jsonEncode(map));
  }

  void _setSubmit(OnboardingSubmitState s) {
    state = (state.$1, s);
  }
}

/// Shared helper used both by the notifier and the static flush method.
Future<void> _persist(
  OnboardingRepository repo,
  String userId,
  OnboardingState quiz,
) async {
  // Map quiz labels to DB column values.
  final budget = _budgetMap[quiz.budget] ?? quiz.budget;
  final companion = _companionMap[quiz.companion] ?? quiz.companion;

  // Compute initial persona levels from selected styles.
  final levels = _computePersonaLevels(quiz.selectedStyles);

  await Future.wait([
    repo.saveQuizResults(
      userId,
      budget: budget.isNotEmpty ? budget : null,
      travelCompanion: companion.isNotEmpty ? companion : null,
      activities: quiz.selectedStyles.isNotEmpty ? quiz.selectedStyles : null,
    ),
    repo.saveInitialPersona(
      userId,
      foodieLevel: levels['foodie'],
      historyBuffLevel: levels['history'],
      natureLoverLevel: levels['nature'],
      adventureSeekerLevel: levels['adventure'],
      cultureExplorerLevel: levels['culture'],
    ),
  ]);
}

// ---------------------------------------------------------------------------
// Mapping helpers
// ---------------------------------------------------------------------------

/// Maps quiz budget labels (with emoji) to DB snake_case values.
const _budgetMap = <String, String>{
  '💰 Ekonomik': 'budget',
  '💳 Orta': 'mid',
  '💎 Premium': 'premium',
};

/// Maps quiz companion labels (with emoji) to DB snake_case values.
const _companionMap = <String, String>{
  '🧑 Solo': 'solo',
  '💑 Çift': 'couple',
  '👫 Arkadaşlar': 'friends',
  '👨‍👩‍👧‍👦 Aile': 'family',
};

/// Derives initial persona level (1 or 2) for each category.
///
/// Active styles start at level 2 so users feel immediate progress.
Map<String, int> _computePersonaLevels(List<String> styles) {
  bool has(String keyword) => styles.any((s) => s.contains(keyword));

  final isKarma = has('Karma');

  return {
    'foodie': (has('Yemek Turu') || isKarma) ? 2 : 1,
    'history': (has('Tarihi Keşif') || isKarma) ? 2 : 1,
    'nature': (has('Doğa') || isKarma) ? 2 : 1,
    'adventure': (has('Macera') || isKarma) ? 2 : 1,
    'culture': (has('Tarihi Keşif') || isKarma) ? 2 : 1,
  };
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final onboardingProvider = StateNotifierProvider<OnboardingNotifier,
    (OnboardingState, OnboardingSubmitState)>(
  (ref) => OnboardingNotifier(ref),
);
