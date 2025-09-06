import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'services/onboarding_service.dart';
import 'models/onboarding_data.dart';

/// Onboarding module for handling app introduction and setup
class OnboardingModule {
  // Private constructor to prevent instantiation
  OnboardingModule._();

  /// Get the onboarding screen widget
  static Widget get onboardingScreen => const OnboardingScreen();

  /// Check if user should see onboarding
  static Future<bool> shouldShowOnboarding() async {
    return await OnboardingService.shouldShowOnboarding();
  }

  /// Complete onboarding process
  static Future<void> completeOnboarding() async {
    await OnboardingService.completeOnboarding();
  }

  /// Skip onboarding process
  static Future<void> skipOnboarding() async {
    await OnboardingService.skipOnboarding();
  }

  /// Reset onboarding status (for testing)
  static Future<void> resetOnboarding() async {
    await OnboardingService.resetOnboarding();
  }

  /// Get onboarding data
  static List<OnboardingData> get onboardingData =>
      OnboardingService.onboardingSteps;

  /// Get total number of onboarding steps
  static int get totalSteps => OnboardingService.totalSteps;
}
