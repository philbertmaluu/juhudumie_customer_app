import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/product_data.dart';

/// Professional product card component
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.08),
              blurRadius: AppSpacing.elevationVeryHigh,
              offset: const Offset(0, AppSpacing.elevationMedium),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with badges
            _buildProductImage(context, isDarkMode),

            // Product details
            Padding(
              padding: AppSpacing.cardPaddingSm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor info
                  _buildVendorInfo(isDarkMode),

                  AppSpacing.gapVerticalXs,

                  // Product name
                  _buildProductName(isDarkMode),

                  AppSpacing.gapVerticalXs,

                  // Rating and reviews
                  _buildRatingSection(isDarkMode),

                  AppSpacing.gapVerticalXs,

                  // Price section
                  _buildPriceSection(isDarkMode),

                  AppSpacing.gapVerticalXs,

                  // Sold count
                  _buildSoldCount(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build product image with badges
  Widget _buildProductImage(BuildContext context, bool isDarkMode) {
    return Stack(
      children: [
        // Product image
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
            image: DecorationImage(
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Badges
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: Row(
            children: [
              if (product.isOnSale)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '-${product.discountPercentage.toInt()}%',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (product.isNew) ...[
                AppSpacing.gapHorizontalSm,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    'NEW',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Favorite button
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: GestureDetector(
            onTap: onFavorite,
            child: Container(
              width: AppSpacing.iconLg,
              height: AppSpacing.iconLg,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: AppSpacing.elevationHigh,
                    offset: const Offset(0, AppSpacing.elevationMedium),
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey[600],
                size: AppSpacing.iconSm,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build vendor info
  Widget _buildVendorInfo(bool isDarkMode) {
    return Row(
      children: [
        // Vendor logo
        Container(
          width: AppSpacing.lg,
          height: AppSpacing.lg,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCircular),
            image: DecorationImage(
              image: NetworkImage(product.vendorLogo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AppSpacing.gapHorizontalSm,

        // Vendor name
        Expanded(
          child: Text(
            product.vendorName,
            style: AppTextStyles.caption.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.7)
                      : AppColors.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Verified badge
        if (product.isVerified)
          Icon(Icons.verified, color: AppColors.primary, size: 14),
      ],
    );
  }

  /// Build product name
  Widget _buildProductName(bool isDarkMode) {
    return Text(
      product.name,
      style: AppTextStyles.bodySmall.copyWith(
        color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build rating section
  Widget _buildRatingSection(bool isDarkMode) {
    return Row(
      children: [
        // Star rating
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < product.rating.floor()
                  ? Icons.star
                  : index < product.rating
                  ? Icons.star_half
                  : Icons.star_border,
              color: Colors.amber,
              size: AppSpacing.iconSm,
            );
          }),
        ),
        AppSpacing.gapHorizontalSm,

        // Rating number
        Text(
          product.formattedRating,
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.8)
                    : AppColors.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapHorizontalSm,

        // Review count
        Text(
          '(${product.reviewCount})',
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.6)
                    : AppColors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  /// Build price section
  Widget _buildPriceSection(bool isDarkMode) {
    return Row(
      children: [
        // Current price
        Text(
          product.formattedPrice,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Original price (if on sale)
        if (product.isOnSale) ...[
          AppSpacing.gapHorizontalSm,
          Text(
            product.formattedOriginalPrice,
            style: AppTextStyles.bodySmall.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.5)
                      : AppColors.onSurface.withOpacity(0.5),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  /// Build sold count
  Widget _buildSoldCount(bool isDarkMode) {
    return Text(
      product.formattedSoldCount,
      style: AppTextStyles.caption.copyWith(
        color:
            isDarkMode
                ? AppColors.onDarkSurface.withOpacity(0.6)
                : AppColors.onSurface.withOpacity(0.6),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
