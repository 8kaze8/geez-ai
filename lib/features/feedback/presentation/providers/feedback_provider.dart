import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/feedback/data/feedback_repository.dart';
import 'package:geez_ai/features/feedback/domain/trip_feedback_model.dart';

// ---------------------------------------------------------------------------
// FeedbackFormState
// ---------------------------------------------------------------------------

class FeedbackFormState {
  const FeedbackFormState({
    this.overallRating = 0,
    this.accuracyRating = 0,
    this.highlights = const [],
    this.lowlights = const [],
    this.wouldRecommend,
    this.freeText = '',
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.error,
  });

  /// 1–5 star rating. 0 means no selection yet.
  final int overallRating;

  /// 1–5 star rating for AI route accuracy. 0 means no selection yet.
  final int accuracyRating;

  /// Selected highlight chip labels.
  final List<String> highlights;

  /// Selected lowlight chip labels.
  final List<String> lowlights;

  /// Nullable — user has not answered the recommend question yet.
  final bool? wouldRecommend;

  /// Optional free-text comment.
  final String freeText;

  final bool isSubmitting;
  final bool isSubmitted;

  /// Non-null when the last submit attempt failed.
  final String? error;

  /// Feedback is ready to submit when an overall rating has been chosen.
  bool get canSubmit => overallRating >= 1 && !isSubmitting && !isSubmitted;

  FeedbackFormState copyWith({
    int? overallRating,
    int? accuracyRating,
    List<String>? highlights,
    List<String>? lowlights,
    bool? Function()? wouldRecommend,
    String? freeText,
    bool? isSubmitting,
    bool? isSubmitted,
    String? Function()? error,
  }) {
    return FeedbackFormState(
      overallRating: overallRating ?? this.overallRating,
      accuracyRating: accuracyRating ?? this.accuracyRating,
      highlights: highlights ?? this.highlights,
      lowlights: lowlights ?? this.lowlights,
      wouldRecommend:
          wouldRecommend != null ? wouldRecommend() : this.wouldRecommend,
      freeText: freeText ?? this.freeText,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: error != null ? error() : this.error,
    );
  }
}

// ---------------------------------------------------------------------------
// FeedbackFormNotifier
// ---------------------------------------------------------------------------

class FeedbackFormNotifier extends StateNotifier<FeedbackFormState> {
  FeedbackFormNotifier(this._repo, this._ref)
      : super(const FeedbackFormState());

  final FeedbackRepository _repo;
  final Ref _ref;

  void setOverallRating(int rating) {
    if (rating < 1 || rating > 5) return;
    state = state.copyWith(
      overallRating: rating,
      error: () => null,
    );
  }

  void setAccuracyRating(int rating) {
    if (rating < 1 || rating > 5) return;
    state = state.copyWith(
      accuracyRating: rating,
      error: () => null,
    );
  }

  void toggleHighlight(String label) {
    final current = List<String>.from(state.highlights);
    if (current.contains(label)) {
      current.remove(label);
    } else {
      current.add(label);
    }
    state = state.copyWith(highlights: current);
  }

  void toggleLowlight(String label) {
    final current = List<String>.from(state.lowlights);
    if (current.contains(label)) {
      current.remove(label);
    } else {
      current.add(label);
    }
    state = state.copyWith(lowlights: current);
  }

  void setWouldRecommend(bool value) {
    state = state.copyWith(wouldRecommend: () => value);
  }

  void setFreeText(String text) {
    state = state.copyWith(freeText: text);
  }

  /// Validates and submits feedback to Supabase via [FeedbackRepository].
  ///
  /// Maps UI state to [TripFeedbackModel]:
  ///   - overallRating → overallRating
  ///   - highlights    → favoriteStops
  ///   - lowlights     → dislikedStops
  ///   - freeText      → freeText
  ///
  /// Note: accuracyRating and wouldRecommend are collected in the UI for
  /// forward-compatibility but are not yet part of TripFeedbackModel. They
  /// are stored in freeText as supplemental data until the model is extended.
  Future<void> submit(String routeId) async {
    if (!state.canSubmit) return;

    final authState = _ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) {
      state = state.copyWith(
        error: () => 'Geri bildirim göndermek için giriş yapmanız gerekiyor.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, error: () => null);

    try {
      // Build supplemental details that don't yet have dedicated columns.
      final supplemental = StringBuffer();
      if (state.freeText.isNotEmpty) {
        supplemental.write(state.freeText);
      }
      if (state.accuracyRating > 0) {
        if (supplemental.isNotEmpty) supplemental.write('\n');
        supplemental.write('[Doğruluk puanı: ${state.accuracyRating}/5]');
      }
      if (state.wouldRecommend != null) {
        if (supplemental.isNotEmpty) supplemental.write('\n');
        supplemental.write(
          '[Önerir mi: ${state.wouldRecommend! ? "Evet" : "Hayır"}]',
        );
      }

      final feedback = TripFeedbackModel(
        id: '', // Supabase gen_random_uuid() will fill this in.
        userId: authState.user!.id,
        routeId: routeId,
        overallRating: state.overallRating,
        favoriteStops: state.highlights,
        dislikedStops: state.lowlights,
        freeText: supplemental.isEmpty ? null : supplemental.toString(),
      );

      await _repo.submitFeedback(feedback);

      state = state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        error: () => null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: () =>
            'Geri bildirim gönderilemedi. Lütfen tekrar deneyin.',
      );
    }
  }

  void reset() {
    state = const FeedbackFormState();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final feedbackFormProvider =
    StateNotifierProvider.autoDispose<FeedbackFormNotifier, FeedbackFormState>(
  (ref) {
    final repo = ref.read(feedbackRepositoryProvider);
    return FeedbackFormNotifier(repo, ref);
  },
);
