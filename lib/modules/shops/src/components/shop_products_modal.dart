import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/shop_data.dart';
import '../../../cart/src/models/cart_data.dart';
import '../../../cart/src/services/cart_service.dart';
import '../../../landing/src/components/product_card.dart';
import '../../../landing/src/models/product_data.dart';

/// Modal bottom sheet for displaying shop products with add to cart functionality
class ShopProductsModal extends StatefulWidget {
  final Shop shop;
  final VoidCallback? onClose;

  const ShopProductsModal({super.key, required this.shop, this.onClose});

  @override
  State<ShopProductsModal> createState() => _ShopProductsModalState();
}

class _ShopProductsModalState extends State<ShopProductsModal> {
  final CartService _cartService = CartService();
  List<ShopProduct> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading products
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _products = widget.shop.featuredProducts;
        _isLoading = false;
      });
    });
  }

  /// Convert ShopProduct to Product for use with ProductCard
  Product _convertToProduct(ShopProduct shopProduct) {
    return Product(
      id: shopProduct.id,
      name: shopProduct.name,
      description: 'Available from ${widget.shop.name}',
      price: shopProduct.price,
      originalPrice: shopProduct.price * 1.2, // Simulate original price
      imageUrl: shopProduct.imageUrl,
      vendorName: widget.shop.name,
      vendorLogo: widget.shop.logoUrl,
      rating: 4.5, // Default rating
      reviewCount: 25, // Default review count
      soldCount:
          shopProduct.stock > 0
              ? (shopProduct.stock * 2)
              : 0, // Simulate sold count
      tags: [widget.shop.category.name],
      isOnSale: shopProduct.price < (shopProduct.price * 1.2),
      isNew: true, // Assume new products
      isVerified: widget.shop.isVerified,
      category: widget.shop.category.name,
      brand: widget.shop.name,
      images: [shopProduct.imageUrl],
      specifications: {},
    );
  }

  void _addToCart(ShopProduct product) {
    final cartItem = CartItem(
      id: '${widget.shop.id}_${product.id}',
      productId: product.id,
      productName: product.name,
      productImage: product.imageUrl,
      price: product.price,
      originalPrice: product.price,
      quantity: 1,
      vendorName: widget.shop.name,
      vendorLogo: widget.shop.logoUrl,
      category: widget.shop.category.name,
      isAvailable: product.isAvailable,
    );

    _cartService.addToCart(cartItem).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });
  }

  void _proceedToCheckout() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/cart');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.3)
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: AppSpacing.cardPaddingMd,
                child: Row(
                  children: [
                    // Shop logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        child:
                            widget.shop.logoUrl.isNotEmpty
                                ? Image.network(
                                  widget.shop.logoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.store_rounded,
                                      color: AppColors.primary,
                                      size: 24,
                                    );
                                  },
                                )
                                : Icon(
                                  Icons.store_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.sm),

                    // Shop info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop.name,
                            style: AppTextStyles.headingSmall.copyWith(
                              color:
                                  isDarkMode
                                      ? AppColors.onDarkSurface
                                      : AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_products.length} products available',
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  isDarkMode
                                      ? AppColors.onDarkSurface.withOpacity(0.7)
                                      : AppColors.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close button
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onClose?.call();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface
                                : AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Products grid
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : _products.isEmpty
                        ? _buildEmptyState(isDarkMode)
                        : GridView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.all(AppSpacing.md),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: AppSpacing.sm,
                                mainAxisSpacing: AppSpacing.sm,
                              ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final shopProduct = _products[index];
                            final product = _convertToProduct(shopProduct);
                            return ProductCard(
                              product: product,
                              onTap: () {
                                _addToCart(shopProduct);
                              },
                              onFavorite: () {
                                // Handle favorite toggle
                              },
                              isFavorite: false,
                            );
                          },
                        ),
              ),

              // Checkout button
              if (!_isLoading && _products.isNotEmpty)
                Container(
                  padding: AppSpacing.cardPaddingLg,

                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _proceedToCheckout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart_rounded, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Proceed to Checkout',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.3)
                    : AppColors.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No products available',
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This shop doesn\'t have any products yet',
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.7)
                      : AppColors.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
