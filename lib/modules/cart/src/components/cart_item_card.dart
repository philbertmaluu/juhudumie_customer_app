import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/cart_data.dart';

/// Cart item card component
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;
  final VoidCallback? onTap;

  const CartItemCard({
    super.key,
    required this.item,
    this.onRemove,
    this.onQuantityChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: AppSpacing.cardPaddingMd,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            _buildProductImage(isDarkMode),

            AppSpacing.gapHorizontalMd,

            // Product details
            Expanded(child: _buildProductDetails(isDarkMode)),

            // Quantity and actions
            _buildQuantityAndActions(isDarkMode),
          ],
        ),
      ),
    );
  }

  /// Build product image
  Widget _buildProductImage(bool isDarkMode) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Image.network(
          item.productImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: isDarkMode ? AppColors.darkSurface : Colors.grey[100],
              child: Icon(
                Icons.image_not_supported_outlined,
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.3)
                        : AppColors.onSurface.withOpacity(0.3),
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build product details
  Widget _buildProductDetails(bool isDarkMode) {
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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

            Text(
              item.vendorName,
              style: AppTextStyles.caption.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),

        AppSpacing.gapVerticalXs,

        // Size and color info
        if (item.size != null || item.color != null) ...[
          Row(
            children: [
              if (item.size != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Size: ${item.size}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                ),
                if (item.color != null) AppSpacing.gapHorizontalXs,
              ],
              if (item.color != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Color: ${item.color}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          AppSpacing.gapVerticalXs,
        ],

        // Price info
        Row(
          children: [
            Text(
              'TSh ${item.price.toStringAsFixed(0)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // Availability status
        if (!item.isAvailable)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Out of Stock',
              style: AppTextStyles.caption.copyWith(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  /// Build quantity and actions
  Widget _buildQuantityAndActions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Remove button
        IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.close_rounded,
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.5)
                    : AppColors.onSurface.withOpacity(0.5),
            size: 20,
          ),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
        ),

        AppSpacing.gapVerticalSm,

        // Quantity selector
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkBackground : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrease button
              GestureDetector(
                onTap: () {
                  if (item.quantity > 1) {
                    onQuantityChanged?.call(item.quantity - 1);
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        item.quantity > 1
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    size: 16,
                    color:
                        item.quantity > 1
                            ? AppColors.primary
                            : isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.3)
                            : AppColors.onSurface.withOpacity(0.3),
                  ),
                ),
              ),

              // Quantity display
              Container(
                width: 40,
                height: 32,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkSurface : Colors.white,
                ),
                child: Center(
                  child: Text(
                    '${item.quantity}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface
                              : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Increase button
              GestureDetector(
                onTap: () {
                  onQuantityChanged?.call(item.quantity + 1);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        AppSpacing.gapVerticalXs,

        // Total price
        Text(
          'TSh ${item.totalPrice.toStringAsFixed(0)}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
