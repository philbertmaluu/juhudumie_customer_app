import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'spacing.dart';

/// Input decoration theme configurations for the application
class AppInputTheme {
  // Private constructor to prevent instantiation
  AppInputTheme._();

  /// Main input decoration theme
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppSpacing.inputPaddingMd,
      labelStyle: AppTextStyles.labelMedium,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    );
  }

  /// Small input decoration theme
  static InputDecorationTheme get inputDecorationThemeSmall {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppSpacing.inputPaddingSm,
      labelStyle: AppTextStyles.labelSmall,
      hintStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
    );
  }

  /// Large input decoration theme
  static InputDecorationTheme get inputDecorationThemeLarge {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppSpacing.inputPaddingLg,
      labelStyle: AppTextStyles.labelLarge,
      hintStyle: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      errorStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
    );
  }

  /// Search input decoration theme
  static InputDecorationTheme get searchInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCircular),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCircular),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCircular),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  /// Underlined input decoration theme
  static InputDecorationTheme get underlinedInputDecorationTheme {
    return InputDecorationTheme(
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.outline),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.outline),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: AppSpacing.md,
      ),
      labelStyle: AppTextStyles.labelMedium,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    );
  }
}
