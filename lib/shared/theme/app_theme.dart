import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'button_theme.dart';
import 'input_theme.dart';
import 'navigation_theme.dart';
import 'spacing.dart';

/// Application theme configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onPrimary,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
      ),

      // Component themes
      appBarTheme: AppNavigationTheme.appBarTheme,
      bottomNavigationBarTheme: AppNavigationTheme.bottomNavigationBarTheme,
      drawerTheme: AppNavigationTheme.drawerTheme,
      tabBarTheme: AppNavigationTheme.tabBarTheme,
      navigationRailTheme: AppNavigationTheme.navigationRailTheme,

      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
      textButtonTheme: AppButtonTheme.textButtonTheme,
      floatingActionButtonTheme: AppButtonTheme.floatingActionButtonTheme,
      iconButtonTheme: AppButtonTheme.iconButtonTheme,

      inputDecorationTheme: AppInputTheme.inputDecorationTheme,

      // Basic themes
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.onSurface,
        size: AppSpacing.iconMd,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.onPrimary,
        size: AppSpacing.iconMd,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge,
        displayMedium: AppTextStyles.headingMedium,
        displaySmall: AppTextStyles.headingSmall,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        titleLarge: AppTextStyles.headingMedium,
        titleMedium: AppTextStyles.headingSmall,
        titleSmall: AppTextStyles.labelLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme for dark theme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.secondary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.primary,
        onSecondary: AppColors.onSecondary,
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFE0E0E0),
        error: AppColors.error,
        onError: AppColors.onPrimary,
        outline: Color(0xFF424242),
        outlineVariant: Color(0xFF616161),
        surfaceContainerHighest: Color(0xFF2C2C2C),
        onSurfaceVariant: Color(0xFFB0B0B0),
      ),

      // Component themes for dark mode
      appBarTheme: AppNavigationTheme.appBarThemeDark,
      bottomNavigationBarTheme: AppNavigationTheme.bottomNavigationBarThemeDark,
      drawerTheme: AppNavigationTheme.drawerThemeDark,
      tabBarTheme: AppNavigationTheme.tabBarThemeDark,
      navigationRailTheme: AppNavigationTheme.navigationRailThemeDark,

      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
      textButtonTheme: AppButtonTheme.textButtonTheme,
      floatingActionButtonTheme: AppButtonTheme.floatingActionButtonTheme,
      iconButtonTheme: AppButtonTheme.iconButtonTheme,

      inputDecorationTheme: AppInputTheme.inputDecorationTheme,

      // Basic themes for dark mode
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFE0E0E0),
        size: AppSpacing.iconMd,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.onPrimary,
        size: AppSpacing.iconMd,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge,
        displayMedium: AppTextStyles.headingMedium,
        displaySmall: AppTextStyles.headingSmall,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        titleLarge: AppTextStyles.headingMedium,
        titleMedium: AppTextStyles.headingSmall,
        titleSmall: AppTextStyles.labelLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
}
