import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/splash_service.dart';

/// Splash module for handling app initialization and splash screen
class SplashModule {
  // Private constructor to prevent instantiation
  SplashModule._();

  /// Get the splash screen widget
  static Widget get splashScreen => const SplashScreen();

  /// Initialize the splash service
  static Future<void> initialize() async {
    await SplashService.initialize();
  }

  /// Navigate to home screen after splash
  static void navigateToHome(BuildContext context) {
    // This will be called after splash animation completes
    // For now, we'll just navigate to the home screen
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
