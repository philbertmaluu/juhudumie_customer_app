import 'package:flutter/material.dart';
import 'map_service.dart';

/// Service for initializing Google Maps
class MapInitializationService {
  static const String _apiKey = 'AIzaSyC9SICPsvwmyhbNhBXS1tjD43kFhX5zh40';
  static bool _isInitialized = false;

  /// Initialize Google Maps service
  static Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    try {
      // Initialize the map service with API key
      MapService.instance.initialize(_apiKey);

      // Verify the service is working
      final testResult = await MapService.instance.geocodeAddress(
        'Dar es Salaam, Tanzania',
      );

      if (testResult.success) {
        _isInitialized = true;
        debugPrint('✅ Google Maps service initialized successfully');
        return true;
      } else {
        debugPrint(
          '❌ Google Maps service initialization failed: ${testResult.error}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ Google Maps service initialization error: $e');
      return false;
    }
  }

  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;

  /// Get API key
  static String get apiKey => _apiKey;

  /// Reset initialization status
  static void reset() {
    _isInitialized = false;
  }
}
