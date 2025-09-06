import 'package:flutter/material.dart';

/// App color scheme for consistent theming across the application
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // --- PRIMARY COLORS ---
  /// Primary blue color for main UI elements
  static const Color primary = Color(0xFF0D47A1);

  /// Secondary blue color for accents and highlights
  static const Color secondary = Color(0xFF42A5F5);

  /// Primary variant for different shades of primary color
  static const Color primaryVariant = Color(0xFF1565C0);

  // --- SURFACE COLORS ---
  /// Main background color
  static const Color background = Color(0xFFFFFFFF);

  /// Surface color for cards and containers
  static const Color surface = Color(0xFFF5F7FA);

  /// Surface variant for different surface shades
  static const Color surfaceVariant = Color(0xFFE8EAF6);

  // --- TEXT COLORS ---
  /// Primary text color (dark)
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Secondary text color
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// Text color on background
  static const Color onBackground = Color(0xFF212121);

  /// Text color on surface
  static const Color onSurface = Color(0xFF212121);

  /// Text color for secondary content
  static const Color onSurfaceVariant = Color(0xFF757575);

  // --- NEUTRAL COLORS ---
  /// Light gray for borders and dividers
  static const Color outline = Color(0xFFE0E0E0);

  /// Medium gray for secondary elements
  static const Color outlineVariant = Color(0xFF9E9E9E);

  /// Dark gray for headings
  static const Color darkGray = Color(0xFF424242);

  /// Light gray for subtle backgrounds
  static const Color lightGray = Color(0xFFF5F5F5);

  // --- SEMANTIC COLORS ---
  /// Success color for positive actions
  static const Color success = Color(0xFF4CAF50);

  /// Error color for negative actions
  static const Color error = Color(0xFFF44336);

  /// Warning color for caution states
  static const Color warning = Color(0xFFFFC107);

  /// Info color for informational content
  static const Color info = Color(0xFF2196F3);

  // --- GRADIENTS ---
  /// Primary gradient for headers and banners
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Background gradient for subtle depth
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark gradient for dark-themed sections
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkGray, Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark mode primary gradient (blue to blackish gray)
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1A1A1A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Dark mode background gradient
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // --- DARK MODE COLORS ---
  /// Dark background color
  static const Color darkBackground = Color(0xFF121212);

  /// Dark surface color
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Dark surface variant
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);

  /// Text color on dark background
  static const Color onDarkBackground = Color(0xFFE0E0E0);

  /// Text color on dark surface
  static const Color onDarkSurface = Color(0xFFE0E0E0);

  /// Secondary text color on dark surface
  static const Color onDarkSurfaceVariant = Color(0xFFB0B0B0);

  /// Dark outline color
  static const Color darkOutline = Color(0xFF424242);

  /// Dark outline variant
  static const Color darkOutlineVariant = Color(0xFF616161);

  // --- SHADOWS ---
  /// Light shadow for subtle elevation
  static const Color shadow = Color(0x1A000000);

  /// Medium shadow for moderate elevation
  static const Color shadowMedium = Color(0x33000000);

  /// Dark shadow for high elevation
  static const Color shadowDark = Color(0x4D000000);

  /// Dark mode shadow
  static const Color darkShadow = Color(0x1AFFFFFF);
}
