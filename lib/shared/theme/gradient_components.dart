import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'spacing.dart';

/// Gradient-based components for the application
/// Since Flutter's theme system doesn't directly support gradients for primary colors,
/// we provide custom gradient components that can be used throughout the app
class AppGradientComponents {
  // Private constructor to prevent instantiation
  AppGradientComponents._();

  /// Gradient elevated button widget
  static Widget gradientElevatedButton({
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null ? AppColors.primaryGradient : null,
        color: onPressed == null ? AppColors.outline : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow:
            onPressed != null
                ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: AppSpacing.elevationMedium,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Container(
            padding: AppSpacing.buttonPaddingMd,
            constraints: const BoxConstraints(
              minHeight: AppSpacing.buttonHeightMd,
            ),
            child: Center(
              child: DefaultTextStyle(
                style: AppTextStyles.buttonPrimary,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gradient floating action button widget
  static Widget gradientFloatingActionButton({
    required VoidCallback? onPressed,
    required Widget child,
    String? tooltip,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null ? AppColors.primaryGradient : null,
        color: onPressed == null ? AppColors.outline : null,
        shape: BoxShape.circle,
        boxShadow:
            onPressed != null
                ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: AppSpacing.elevationHigh,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Container(width: 56, height: 56, child: Center(child: child)),
        ),
      ),
    );
  }

  /// Gradient app bar widget
  static PreferredSizeWidget gradientAppBar({
    Widget? title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    PreferredSizeWidget? bottom,
    double? elevation,
    Color? shadowColor,
    ShapeBorder? shape,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool primary = true,
    bool centerTitle = true,
    double? titleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
    Size? preferredSize,
    bool excludeHeaderSemantics = false,
    double? leadingWidth,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) {
    return PreferredSize(
      preferredSize:
          preferredSize ?? const Size.fromHeight(AppSpacing.buttonHeightXl),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: AppBar(
          title: title,
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          bottom: bottom,
          elevation: elevation ?? 0,
          shadowColor: shadowColor,
          shape: shape,
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? AppColors.onPrimary,
          iconTheme:
              iconTheme ?? const IconThemeData(color: AppColors.onPrimary),
          actionsIconTheme:
              actionsIconTheme ??
              const IconThemeData(color: AppColors.onPrimary),
          primary: primary,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          excludeHeaderSemantics: excludeHeaderSemantics,
          leadingWidth: leadingWidth,
          titleTextStyle:
              titleTextStyle ??
              AppTextStyles.headingMedium.copyWith(color: AppColors.onPrimary),
          systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
        ),
      ),
    );
  }

  /// Gradient container widget
  static Widget gradientContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    Color? color,
    Decoration? decoration,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      decoration:
          decoration ??
          BoxDecoration(
            gradient: gradient ?? AppColors.primaryGradient,
            color: color,
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: boxShadow,
          ),
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Gradient text widget
  static Widget gradientText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Gradient? gradient,
  }) {
    return ShaderMask(
      shaderCallback:
          (bounds) =>
              (gradient ?? AppColors.primaryGradient).createShader(bounds),
      child: Text(
        text,
        style:
            style?.copyWith(color: Colors.white) ??
            AppTextStyles.bodyLarge.copyWith(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  /// Gradient icon widget
  static Widget gradientIcon(
    IconData icon, {
    double? size,
    Gradient? gradient,
  }) {
    return ShaderMask(
      shaderCallback:
          (bounds) =>
              (gradient ?? AppColors.primaryGradient).createShader(bounds),
      child: Icon(icon, size: size ?? AppSpacing.iconMd, color: Colors.white),
    );
  }
}
