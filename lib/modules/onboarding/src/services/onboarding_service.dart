import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_data.dart';

/// Service for managing onboarding state and data
class OnboardingService {
  // Private constructor to prevent instantiation
  OnboardingService._();

  static const String _onboardingKey = 'onboarding_completed';
  static const String _onboardingSkippedKey = 'onboarding_skipped';

  /// Get onboarding data for all steps
  static List<OnboardingData> get onboardingSteps => [
    const OnboardingData(
      title: 'Welcome to Jihudumie',
      description:
          'Your one-stop shop for everything you need. Discover amazing products and enjoy seamless shopping experience.',
      imagePath: 'assets/onboarding/welcome.png',
      buttonText: 'Get Started',
    ),
    const OnboardingData(
      title: 'Amazing Features',
      description:
          'Browse thousands of products, compare prices, read reviews, and get the best deals delivered to your doorstep.',
      imagePath: 'assets/onboarding/amaizing.png',
      buttonText: 'Continue',
    ),
    const OnboardingData(
      title: 'Ready to Shop?',
      description:
          'You\'re all set! Start exploring our amazing collection and find exactly what you\'re looking for.',
      imagePath: 'assets/onboarding/ready.png',
      buttonText: 'Start Shopping',
      isLastStep: true,
    ),
  ];

  /// Check if onboarding has been completed
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      return false;
    }
  }

  /// Check if onboarding has been skipped
  static Future<bool> isOnboardingSkipped() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingSkippedKey) ?? false;
    } catch (e) {
      debugPrint('Error checking onboarding skip status: $e');
      return false;
    }
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      await prefs.setBool(_onboardingSkippedKey, false);
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
    }
  }

  /// Mark onboarding as skipped
  static Future<void> skipOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingSkippedKey, true);
      await prefs.setBool(_onboardingKey, false);
    } catch (e) {
      debugPrint('Error skipping onboarding: $e');
    }
  }

  /// Reset onboarding status (for testing or re-onboarding)
  static Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingKey);
      await prefs.remove(_onboardingSkippedKey);
    } catch (e) {
      debugPrint('Error resetting onboarding: $e');
    }
  }

  /// Check if user should see onboarding
  static Future<bool> shouldShowOnboarding() async {
    final isCompleted = await isOnboardingCompleted();
    final isSkipped = await isOnboardingSkipped();
    return !isCompleted && !isSkipped;
  }

  /// Get onboarding step data by index
  static OnboardingData getStepData(int index) {
    final steps = onboardingSteps;
    if (index >= 0 && index < steps.length) {
      return steps[index];
    }
    return steps.first;
  }

  /// Get total number of onboarding steps
  static int get totalSteps => onboardingSteps.length;

  /// Get current step progress (0.0 to 1.0)
  static double getStepProgress(int currentStep) {
    return (currentStep + 1) / totalSteps;
  }
}
