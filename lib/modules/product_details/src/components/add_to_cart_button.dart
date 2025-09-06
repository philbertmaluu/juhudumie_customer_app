import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/custom_button.dart';

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
              child: SecondaryButton(
                text: 'Add to Cart',
                icon: Icons.shopping_cart_outlined,
                onPressed: isInStock && !isLoading ? onAddToCart : null,
                isLoading: isLoading,
              ),
            ),

            AppSpacing.gapHorizontalMd,

            // Buy Now button
            Expanded(
              flex: 3,
              child: PrimaryButton(
                text: isInStock ? 'Buy Now' : 'Out of Stock',
                icon: Icons.flash_on,
                onPressed: isInStock && !isLoading ? onBuyNow : null,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
