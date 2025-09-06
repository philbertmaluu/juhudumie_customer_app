import 'package:flutter/material.dart';

/// Consistent spacing and sizing constants for the application
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // --- SPACING CONSTANTS ---
  /// Extra small spacing (4px)
  static const double xs = 4.0;

  /// Small spacing (8px)
  static const double sm = 8.0;

  /// Medium spacing (12px)
  static const double md = 12.0;

  /// Large spacing (16px)
  static const double lg = 16.0;

  /// Extra large spacing (20px)
  static const double xl = 20.0;

  /// Double extra large spacing (24px)
  static const double xxl = 24.0;

  /// Triple extra large spacing (32px)
  static const double xxxl = 32.0;

  /// Quadruple extra large spacing (48px)
  static const double xxxxl = 48.0;

  // --- BORDER RADIUS CONSTANTS ---
  /// Small border radius (4px)
  static const double radiusSm = 4.0;

  /// Medium border radius (8px)
  static const double radiusMd = 8.0;

  /// Large border radius (12px)
  static const double radiusLg = 12.0;

  /// Extra large border radius (16px)
  static const double radiusXl = 16.0;

  /// Circular border radius (50%)
  static const double radiusCircular = 50.0;

  // --- ELEVATION CONSTANTS ---
  /// Low elevation (1px)
  static const double elevationLow = 1.0;

  /// Medium elevation (2px)
  static const double elevationMedium = 2.0;

  /// High elevation (4px)
  static const double elevationHigh = 4.0;

  /// Very high elevation (8px)
  static const double elevationVeryHigh = 8.0;

  // --- ICON SIZES ---
  /// Small icon size (16px)
  static const double iconSm = 16.0;

  /// Medium icon size (24px)
  static const double iconMd = 24.0;

  /// Large icon size (32px)
  static const double iconLg = 32.0;

  /// Extra large icon size (48px)
  static const double iconXl = 48.0;

  // --- BUTTON SIZES ---
  /// Small button height (32px)
  static const double buttonHeightSm = 32.0;

  /// Medium button height (40px)
  static const double buttonHeightMd = 40.0;

  /// Large button height (48px)
  static const double buttonHeightLg = 48.0;

  /// Extra large button height (56px)
  static const double buttonHeightXl = 56.0;

  // --- INPUT FIELD SIZES ---
  /// Small input height (40px)
  static const double inputHeightSm = 40.0;

  /// Medium input height (48px)
  static const double inputHeightMd = 48.0;

  /// Large input height (56px)
  static const double inputHeightLg = 56.0;

  // --- CARD SIZES ---
  /// Small card padding
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(sm);

  /// Medium card padding
  static const EdgeInsets cardPaddingMd = EdgeInsets.all(md);

  /// Large card padding
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(lg);

  // --- BUTTON PADDING ---
  /// Small button padding
  static const EdgeInsets buttonPaddingSm = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );

  /// Medium button padding
  static const EdgeInsets buttonPaddingMd = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Large button padding
  static const EdgeInsets buttonPaddingLg = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: md,
  );

  // --- INPUT PADDING ---
  /// Small input padding
  static const EdgeInsets inputPaddingSm = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );

  /// Medium input padding
  static const EdgeInsets inputPaddingMd = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Large input padding
  static const EdgeInsets inputPaddingLg = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );

  // --- SCREEN PADDING ---
  /// Small screen padding
  static const EdgeInsets screenPaddingSm = EdgeInsets.all(sm);

  /// Medium screen padding
  static const EdgeInsets screenPaddingMd = EdgeInsets.all(lg);

  /// Large screen padding
  static const EdgeInsets screenPaddingLg = EdgeInsets.all(xl);

  // --- MARGIN CONSTANTS ---
  /// Small margin
  static const EdgeInsets marginSm = EdgeInsets.all(sm);

  /// Medium margin
  static const EdgeInsets marginMd = EdgeInsets.all(md);

  /// Large margin
  static const EdgeInsets marginLg = EdgeInsets.all(lg);

  // --- GAP CONSTANTS ---
  /// Extra small gap
  static const SizedBox gapXs = SizedBox(height: xs, width: xs);

  /// Small gap
  static const SizedBox gapSm = SizedBox(height: sm, width: sm);

  /// Medium gap
  static const SizedBox gapMd = SizedBox(height: md, width: md);

  /// Large gap
  static const SizedBox gapLg = SizedBox(height: lg, width: lg);

  /// Extra large gap
  static const SizedBox gapXl = SizedBox(height: xl, width: xl);

  /// Double extra large gap
  static const SizedBox gapXxl = SizedBox(height: xxl, width: xxl);

  // --- VERTICAL GAPS ---
  /// Extra small vertical gap
  static const SizedBox gapVerticalXs = SizedBox(height: xs);

  /// Small vertical gap
  static const SizedBox gapVerticalSm = SizedBox(height: sm);

  /// Medium vertical gap
  static const SizedBox gapVerticalMd = SizedBox(height: md);

  /// Large vertical gap
  static const SizedBox gapVerticalLg = SizedBox(height: lg);

  /// Extra large vertical gap
  static const SizedBox gapVerticalXl = SizedBox(height: xl);

  /// Double extra large vertical gap
  static const SizedBox gapVerticalXxl = SizedBox(height: xxl);

  // --- HORIZONTAL GAPS ---
  /// Extra small horizontal gap
  static const SizedBox gapHorizontalXs = SizedBox(width: xs);

  /// Small horizontal gap
  static const SizedBox gapHorizontalSm = SizedBox(width: sm);

  /// Medium horizontal gap
  static const SizedBox gapHorizontalMd = SizedBox(width: md);

  /// Large horizontal gap
  static const SizedBox gapHorizontalLg = SizedBox(width: lg);

  /// Extra large horizontal gap
  static const SizedBox gapHorizontalXl = SizedBox(width: xl);

  /// Double extra large horizontal gap
  static const SizedBox gapHorizontalXxl = SizedBox(width: xxl);
}
