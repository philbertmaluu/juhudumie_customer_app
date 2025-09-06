import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Add to cart button component
class AddToCartButton extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool isInStock;
  final bool isLoading;

  const AddToCartButton({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.isInStock,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.screenPaddingMd,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Add to Cart button
            Expanded(
              flex: 2,
              child: _buildButton(
                text: 'Add to Cart',
                icon: Icons.shopping_cart_outlined,
                onTap: isInStock && !isLoading ? onAddToCart : null,
                isPrimary: false,
                isDarkMode: isDarkMode,
              ),
            ),

            AppSpacing.gapHorizontalMd,

            // Buy Now button
            Expanded(
              flex: 3,
              child: _buildButton(
                text: isInStock ? 'Buy Now' : 'Out of Stock',
                icon: Icons.flash_on,
                onTap: isInStock && !isLoading ? onBuyNow : null,
                isPrimary: true,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual button
  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isPrimary,
    required bool isDarkMode,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          gradient:
              isEnabled && isPrimary
                  ? LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : null,
          color:
              isEnabled && !isPrimary
                  ? isDarkMode
                      ? AppColors.darkSurface
                      : Colors.white
                  : isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border:
              isEnabled && !isPrimary
                  ? Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  )
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
          children: [
            if (isLoading && isPrimary)
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
            else
              Icon(
                icon,
                size: AppSpacing.iconSm,
                color:
                    isEnabled
                        ? (isPrimary ? Colors.white : AppColors.primary)
                        : isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.5),
              ),

            AppSpacing.gapHorizontalSm,

            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isEnabled
                        ? (isPrimary ? Colors.white : AppColors.primary)
                        : isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
