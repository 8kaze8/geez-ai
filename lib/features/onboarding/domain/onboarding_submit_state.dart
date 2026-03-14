/// Tracks the async status of the final onboarding submission.
enum OnboardingSubmitStatus {
  /// No submission in progress.
  idle,

  /// Writing to Supabase.
  loading,

  /// Write succeeded.
  success,

  /// Write failed — [errorMessage] is set.
  error,
}

class OnboardingSubmitState {
  const OnboardingSubmitState({
    this.status = OnboardingSubmitStatus.idle,
    this.errorMessage,
  });

  final OnboardingSubmitStatus status;
  final String? errorMessage;

  bool get isLoading => status == OnboardingSubmitStatus.loading;
  bool get isSuccess => status == OnboardingSubmitStatus.success;
  bool get isError => status == OnboardingSubmitStatus.error;

  OnboardingSubmitState copyWith({
    OnboardingSubmitStatus? status,
    String? errorMessage,
  }) {
    return OnboardingSubmitState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
