import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'spacing.dart';

/// Button theme configurations for the application
class AppButtonTheme {
  // Private constructor to prevent instantiation
  AppButtonTheme._();

  /// Elevated button theme
  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationMedium,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        padding: AppSpacing.buttonPaddingMd,
        textStyle: AppTextStyles.buttonPrimary,
        minimumSize: const Size(0, AppSpacing.buttonHeightMd),
      ),
    );
  }

  /// Outlined button theme
  static OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        padding: AppSpacing.buttonPaddingMd,
        textStyle: AppTextStyles.buttonSecondary,
        minimumSize: const Size(0, AppSpacing.buttonHeightMd),
      ),
    );
  }

  /// Text button theme
  static TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        padding: AppSpacing.buttonPaddingSm,
        textStyle: AppTextStyles.buttonText,
        minimumSize: const Size(0, AppSpacing.buttonHeightSm),
      ),
    );
  }

  /// Floating action button theme
  static FloatingActionButtonThemeData get floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSpacing.elevationHigh,
    );
  }

  /// Icon button theme
  static IconButtonThemeData get iconButtonTheme {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
      ),
    );
  }

  /// Small elevated button style
  static ButtonStyle get elevatedButtonSmall {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      padding: AppSpacing.buttonPaddingSm,
      textStyle: AppTextStyles.buttonPrimary.copyWith(fontSize: 12),
      minimumSize: const Size(0, AppSpacing.buttonHeightSm),
    );
  }

  /// Large elevated button style
  static ButtonStyle get elevatedButtonLarge {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      padding: AppSpacing.buttonPaddingLg,
      textStyle: AppTextStyles.buttonPrimary.copyWith(fontSize: 18),
      minimumSize: const Size(0, AppSpacing.buttonHeightLg),
    );
  }

  /// Secondary elevated button style
  static ButtonStyle get elevatedButtonSecondary {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
      elevation: AppSpacing.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      padding: AppSpacing.buttonPaddingMd,
      textStyle: AppTextStyles.buttonPrimary,
      minimumSize: const Size(0, AppSpacing.buttonHeightMd),
    );
  }

  /// Success button style
  static ButtonStyle get elevatedButtonSuccess {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSpacing.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      padding: AppSpacing.buttonPaddingMd,
      textStyle: AppTextStyles.buttonPrimary,
      minimumSize: const Size(0, AppSpacing.buttonHeightMd),
    );
  }

  /// Error button style
  static ButtonStyle get elevatedButtonError {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSpacing.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      padding: AppSpacing.buttonPaddingMd,
      textStyle: AppTextStyles.buttonPrimary,
      minimumSize: const Size(0, AppSpacing.buttonHeightMd),
    );
  }
}
