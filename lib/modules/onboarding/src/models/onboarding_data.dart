/// Model representing onboarding step data
class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final String? buttonText;
  final bool isLastStep;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.buttonText,
    this.isLastStep = false,
  });
}

/// Onboarding step enumeration
enum OnboardingStep { welcome, features, ready }

/// Onboarding state model
class OnboardingState {
  final int currentStep;
  final bool isCompleted;
  final bool isSkipped;

  const OnboardingState({
    this.currentStep = 0,
    this.isCompleted = false,
    this.isSkipped = false,
  });

  /// Create a copy with updated values
  OnboardingState copyWith({
    int? currentStep,
    bool? isCompleted,
    bool? isSkipped,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isCompleted: isCompleted ?? this.isCompleted,
      isSkipped: isSkipped ?? this.isSkipped,
    );
  }

  /// Check if onboarding is finished (completed or skipped)
  bool get isFinished => isCompleted || isSkipped;

  /// Get current step as enum
  OnboardingStep get currentStepEnum {
    switch (currentStep) {
      case 0:
        return OnboardingStep.welcome;
      case 1:
        return OnboardingStep.features;
      case 2:
        return OnboardingStep.ready;
      default:
        return OnboardingStep.welcome;
    }
  }

  @override
  String toString() {
    return 'OnboardingState(currentStep: $currentStep, isCompleted: $isCompleted, isSkipped: $isSkipped)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingState &&
        other.currentStep == currentStep &&
        other.isCompleted == isCompleted &&
        other.isSkipped == isSkipped;
  }

  @override
  int get hashCode {
    return currentStep.hashCode ^ isCompleted.hashCode ^ isSkipped.hashCode;
  }
}
