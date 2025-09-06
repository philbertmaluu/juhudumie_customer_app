import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'spacing.dart';

/// Navigation theme configurations for the application
class AppNavigationTheme {
  // Private constructor to prevent instantiation
  AppNavigationTheme._();

  /// App bar theme for light mode
  static AppBarTheme get appBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headingMedium,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: AppSpacing.buttonHeightXl,
    );
  }

  /// App bar theme for dark mode
  static AppBarTheme get appBarThemeDark {
    return AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: const Color(0xFFE0E0E0),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headingMedium,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: AppSpacing.buttonHeightXl,
    );
  }

  /// Bottom navigation bar theme
  static BottomNavigationBarThemeData get bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: AppSpacing.elevationVeryHigh,
      selectedLabelStyle: AppTextStyles.labelSmall,
      unselectedLabelStyle: AppTextStyles.labelSmall,
    );
  }

  /// Bottom navigation bar theme for dark mode
  static BottomNavigationBarThemeData get bottomNavigationBarThemeDark {
    return BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: const Color(0xFFB0B0B0),
      type: BottomNavigationBarType.fixed,
      elevation: AppSpacing.elevationVeryHigh,
      selectedLabelStyle: AppTextStyles.labelSmall,
      unselectedLabelStyle: AppTextStyles.labelSmall,
    );
  }

  /// Drawer theme
  static DrawerThemeData get drawerTheme {
    return const DrawerThemeData(
      backgroundColor: AppColors.surface,
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSpacing.radiusLg),
          bottomRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }

  /// Drawer theme for dark mode
  static DrawerThemeData get drawerThemeDark {
    return const DrawerThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSpacing.radiusLg),
          bottomRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }

  /// Tab bar theme
  static TabBarTheme get tabBarTheme {
    return TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.onSurfaceVariant,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: AppTextStyles.labelLarge,
      unselectedLabelStyle: AppTextStyles.labelMedium,
    );
  }

  /// Tab bar theme for dark mode
  static TabBarTheme get tabBarThemeDark {
    return TabBarTheme(
      labelColor: AppColors.secondary,
      unselectedLabelColor: const Color(0xFFB0B0B0),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.secondary, width: 2),
      ),
      labelStyle: AppTextStyles.labelLarge,
      unselectedLabelStyle: AppTextStyles.labelMedium,
    );
  }

  /// Navigation rail theme
  static NavigationRailThemeData get navigationRailTheme {
    return NavigationRailThemeData(
      backgroundColor: AppColors.surface,
      selectedIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: AppSpacing.iconMd,
      ),
      unselectedIconTheme: const IconThemeData(
        color: AppColors.onSurfaceVariant,
        size: AppSpacing.iconMd,
      ),
      selectedLabelTextStyle: AppTextStyles.labelMedium,
      unselectedLabelTextStyle: AppTextStyles.labelSmall,
      elevation: AppSpacing.elevationMedium,
    );
  }

  /// Navigation rail theme for dark mode
  static NavigationRailThemeData get navigationRailThemeDark {
    return NavigationRailThemeData(
      backgroundColor: const Color(0xFF2C2C2C),
      selectedIconTheme: const IconThemeData(
        color: AppColors.secondary,
        size: AppSpacing.iconMd,
      ),
      unselectedIconTheme: const IconThemeData(
        color: Color(0xFFB0B0B0),
        size: AppSpacing.iconMd,
      ),
      selectedLabelTextStyle: AppTextStyles.labelMedium,
      unselectedLabelTextStyle: AppTextStyles.labelSmall,
      elevation: AppSpacing.elevationMedium,
    );
  }
}
