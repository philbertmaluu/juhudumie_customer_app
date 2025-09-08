import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/wishlist_data.dart';

/// Wishlist item card component
class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final VoidCallback onViewProduct;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onAddToCart,
    required this.onViewProduct,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardPaddingSm,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Product image
              _buildProductImage(isDarkMode),

              AppSpacing.gapHorizontalSm,

              // Product info
              Expanded(child: _buildProductInfo(isDarkMode)),

              // Remove button
              _buildRemoveButton(isDarkMode),
            ],
          ),

          AppSpacing.gapVerticalSm,

          // Price and rating row
          _buildPriceAndRating(isDarkMode),

          AppSpacing.gapVerticalSm,

          // Action buttons
          _buildActionButtons(isDarkMode),
        ],
      ),
    );
  }

  /// Build product image
  Widget _buildProductImage(bool isDarkMode) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color:
            isDarkMode
                ? AppColors.onDarkSurface.withOpacity(0.1)
                : AppColors.onSurface.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Image.network(
          item.productImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image_not_supported_rounded,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.3)
                      : AppColors.onSurface.withOpacity(0.3),
              size: 24,
            );
          },
        ),
      ),
    );
  }

  /// Build product info
  Widget _buildProductInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Text(
          item.productName,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        AppSpacing.gapVerticalXs,

        // Vendor info
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.vendorLogo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.store,
                      size: 10,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
            ),

            AppSpacing.gapHorizontalXs,

            Expanded(
              child: Text(
                item.vendorName,
                style: AppTextStyles.caption.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        AppSpacing.gapVerticalXs,

        // Added date
        Text(
          'Added ${item.formattedAddedDate}',
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.5)
                    : AppColors.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  /// Build remove button
  Widget _buildRemoveButton(bool isDarkMode) {
    return IconButton(
      onPressed: onRemove,
      icon: Icon(Icons.favorite_rounded, color: AppColors.primary, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        minimumSize: const Size(36, 36),
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Build price and rating
  Widget _buildPriceAndRating(bool isDarkMode) {
    return Row(
      children: [
        // Price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.formattedPrice,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface
                              : AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item.isOnSale) ...[
                    AppSpacing.gapHorizontalXs,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${item.discountPercentage.toInt()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (item.isOnSale)
                Text(
                  item.formattedOriginalPrice,
                  style: AppTextStyles.bodySmall.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.5)
                            : AppColors.onSurface.withOpacity(0.5),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),

        // Rating
        if (item.rating > 0)
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              AppSpacing.gapHorizontalXs,
              Text(
                item.formattedRating,
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapHorizontalXs,
              Text(
                '(${item.reviewCount})',
                style: AppTextStyles.caption.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.5)
                          : AppColors.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        // Add to cart button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: item.isAvailable ? onAddToCart : null,
            icon: const Icon(Icons.shopping_cart_outlined, size: 16),
            label: const Text('Add to Cart'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),

        AppSpacing.gapHorizontalSm,

        // View product button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onViewProduct,
            icon: const Icon(Icons.visibility_outlined, size: 16),
            label: const Text('View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
