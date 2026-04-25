import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/onboarding_repository.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository _repository;
  final PageController pageController;

  static const List<Map<String, String>> onboardingOverlays = [
    {
      'title': 'Intelligence,\nReimagined.',
      'subtitle':
          'Your personalized news experience powered by insight and clarity.',
      'buttonText': 'Next',
    },
    {
      'title': 'Curated For You.',
      'subtitle':
          'AI-driven editorial picks tailored to your interests and worldview.',
      'buttonText': 'Continue',
    },
    {
      'title': 'Stay Ahead.\nStay Informed.',
      'subtitle':
          'Breaking stories, deep analysis, and perspectives that matter.',
      'buttonText': 'Get Started',
    },
  ];

  OnboardingCubit({required OnboardingRepository repository})
    : _repository = repository,
      pageController = PageController(initialPage: 0),
      super(OnboardingState.initial());

  void onPageChanged(int page) {
    emit(
      state.copyWith(
        currentPage: page,
        isLastPage: page == onboardingOverlays.length - 1,
      ),
    );
  }

  void nextPage() {
    if (state.isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingComplete();
    // In actual app, navigation is handled in the UI listener since completeOnboarding doesn't emit a distinct state here if we rely on UI to navigate, wait, the reference code navigates via router.
    // So the UI can just call completeOnboarding() and then context.go(AppRouter.home).
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
