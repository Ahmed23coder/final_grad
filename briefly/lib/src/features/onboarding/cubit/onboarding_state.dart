class OnboardingState {
  final int currentPage;
  final bool isLastPage;

  OnboardingState({required this.currentPage, required this.isLastPage});

  factory OnboardingState.initial() {
    return OnboardingState(currentPage: 0, isLastPage: false);
  }

  OnboardingState copyWith({int? currentPage, bool? isLastPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}
