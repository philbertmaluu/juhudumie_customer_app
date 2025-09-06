import 'package:flutter/material.dart';
import '../theme/index.dart';

/// Custom button widget for consistent styling across the app
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isPrimary;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isPrimary = true,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height ?? AppSpacing.buttonHeightLg,
        padding: padding ?? AppSpacing.buttonPaddingMd,
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? (isPrimary ? AppColors.primary : Colors.transparent)
                  : (isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(borderRadius),
          border:
              isEnabled && !isPrimary
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
          boxShadow:
              isEnabled && isPrimary
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? Colors.white : AppColors.primary,
                  ),
                ),
              )
            else if (icon != null) ...[
              Icon(
                icon,
                size: AppSpacing.iconSm,
                color:
                    isEnabled
                        ? (isPrimary ? Colors.white : AppColors.primary)
                        : (isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.5)),
              ),
              AppSpacing.gapHorizontalSm,
            ],
            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isEnabled
                        ? (isPrimary ? Colors.white : AppColors.primary)
                        : (isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.5)),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary button variant
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isPrimary: true,
      width: width,
      height: height,
      padding: padding,
    );
  }
}

/// Secondary button variant
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isPrimary: false,
      width: width,
      height: height,
      padding: padding,
    );
  }
}
