import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Text styles for consistent typography across the application
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // --- HEADING STYLES ---
  /// Large heading style for main titles
  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    height: 1.2,
  );

  /// Medium heading style for section titles
  static TextStyle get headingMedium => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
    height: 1.3,
  );

  /// Small heading style for subsection titles
  static TextStyle get headingSmall => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
    height: 1.3,
  );

  // --- BODY TEXT STYLES ---
  /// Large body text for important content
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    height: 1.5,
  );

  /// Medium body text for regular content
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    height: 1.4,
  );

  /// Small body text for secondary content
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurfaceVariant,
    height: 1.4,
  );

  // --- LABEL STYLES ---
  /// Large label for important labels
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
    height: 1.4,
  );

  /// Medium label for regular labels
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
    height: 1.3,
  );

  /// Small label for secondary labels
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
    height: 1.3,
  );

  // --- BUTTON STYLES ---
  /// Primary button text style
  static TextStyle get buttonPrimary => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    height: 1.2,
  );

  /// Secondary button text style
  static TextStyle get buttonSecondary => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.2,
  );

  /// Text button style
  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.2,
  );

  // --- SPECIAL STYLES ---
  /// Caption style for small text
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurfaceVariant,
    height: 1.3,
  );

  /// Overline style for very small text
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
    height: 1.2,
    letterSpacing: 1.5,
  );

  /// Price text style for e-commerce
  static TextStyle get price => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );

  /// Discount price text style
  static TextStyle get priceDiscount => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.2,
    decoration: TextDecoration.lineThrough,
  );

  /// Product title style
  static TextStyle get productTitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
    height: 1.3,
  );

  /// Product description style
  static TextStyle get productDescription => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurfaceVariant,
    height: 1.4,
  );
}
