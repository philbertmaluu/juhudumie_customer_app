import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/product_details_data.dart';
import '../services/product_details_service.dart';
import '../components/quantity_selector.dart';
import '../components/add_to_cart_button.dart';

/// Product details screen
class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  final ProductDetailsService _productService = ProductDetailsService();
  late TabController _tabController;
  late PageController _pageController;

  ProductDetails? _product;
  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isLoading = true;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _loadProduct();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Load product details
  void _loadProduct() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _product = _productService.getProductDetails(widget.productId);
        _isLoading = false;
      });
    });
  }

  /// Handle add to cart
  void _addToCart() async {
    if (_product == null) return;

    setState(() {
      _isAddingToCart = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    _productService.addToCart(_product!, _quantity);

    setState(() {
      _isAddingToCart = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${_product!.name} to cart'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Handle buy now
  void _buyNow() async {
    if (_product == null) return;

    setState(() {
      _isAddingToCart = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    _productService.addToCart(_product!, _quantity);

    setState(() {
      _isAddingToCart = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proceeding to checkout with ${_product!.name}'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.5)
                        : Colors.grey[400],
              ),
              AppSpacing.gapVerticalLg,
              Text(
                'Product not found',
                style: AppTextStyles.headingMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.background,
      body: Column(
        children: [
          // Full width image gallery with overlay buttons
          _buildFullWidthImageGallery(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product info
                  _buildProductInfo(),

                  // Quantity selector
                  _buildQuantitySelector(),

                  // Tabs
                  _buildTabs(),

                  // Tab content
                  _buildTabContent(),
                ],
              ),
            ),
          ),

          // Add to cart button
          AddToCartButton(
            onAddToCart: _addToCart,
            onBuyNow: _buyNow,
            isInStock: _product!.isInStock,
            isLoading: _isAddingToCart,
          ),
        ],
      ),
    );
  }

  /// Build full width image gallery with overlay buttons
  Widget _buildFullWidthImageGallery() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 400,
      child: Stack(
        children: [
          // Full width page view for images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedImageIndex = index;
              });
            },
            itemCount: _product!.imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                _product!.imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  );
                },
              );
            },
          ),

          // Overlay action buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // Right side buttons
                Row(
                  children: [
                    // Favorite button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // TODO: Toggle favorite
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Share button
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // TODO: Share product
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Image indicators
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _product!.imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _selectedImageIndex == index
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build product info
  Widget _buildProductInfo() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.screenPaddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            _product!.name,
            style: AppTextStyles.headingLarge.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          AppSpacing.gapVerticalSm,

          // Rating and reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < _product!.rating.floor()
                        ? Icons.star
                        : index < _product!.rating
                        ? Icons.star_half
                        : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  );
                }),
              ),
              AppSpacing.gapHorizontalSm,
              Text(
                '${_product!.rating} (${_product!.reviewCount} reviews)',
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalSm,

          // Price
          Row(
            children: [
              Text(
                _product!.formattedPrice,
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapHorizontalSm,
              if (_product!.originalPrice > _product!.price)
                Text(
                  _product!.formattedOriginalPrice,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.5)
                            : Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              AppSpacing.gapHorizontalSm,
              if (_product!.discountPercentage > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-${_product!.discountPercentage.toInt()}%',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          AppSpacing.gapVerticalSm,

          // Stock status
          Row(
            children: [
              Icon(
                _product!.isInStock ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: _product!.isInStock ? Colors.green : Colors.red,
              ),
              AppSpacing.gapHorizontalXs,
              Text(
                _product!.stockStatus,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _product!.isInStock ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalSm,

          // Vendor info
          Row(
            children: [
              Text(
                'Sold by ',
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                _product!.vendorName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapHorizontalXs,
              Icon(Icons.verified, size: 14, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  /// Build quantity selector
  Widget _buildQuantitySelector() {
    return Padding(
      padding: AppSpacing.screenPaddingMd,
      child: Row(
        children: [
          Text(
            'Quantity:',
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.onDarkSurface
                      : AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapHorizontalMd,
          QuantitySelector(
            quantity: _quantity,
            maxQuantity: _product!.stockQuantity,
            onQuantityChanged: (quantity) {
              setState(() {
                _quantity = quantity;
              });
            },
            isEnabled: _product!.isInStock,
          ),
        ],
      ),
    );
  }

  /// Build tabs
  Widget _buildTabs() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: AppSpacing.screenPaddingMd,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: const BoxDecoration(),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.primary,
        unselectedLabelColor:
            isDarkMode
                ? AppColors.onDarkSurface.withOpacity(0.6)
                : AppColors.onSurface.withOpacity(0.6),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Description'),
          Tab(text: 'Specifications'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  /// Build tab content
  Widget _buildTabContent() {
    return Container(
      height: 300,
      margin: AppSpacing.screenPaddingMd,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(),
          _buildSpecificationsTab(),
          _buildReviewsTab(),
        ],
      ),
    );
  }

  /// Build description tab
  Widget _buildDescriptionTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapVerticalMd,
          Text(
            _product!.detailedDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.8)
                      : AppColors.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          AppSpacing.gapVerticalLg,
          Text(
            'Features',
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapVerticalMd,
          ..._product!.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                  AppSpacing.gapHorizontalSm,
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.8)
                                : AppColors.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build specifications tab
  Widget _buildSpecificationsTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapVerticalMd,
          ..._product!.detailedSpecifications.map((spec) {
            final parts = spec.split(':');
            final key = parts.isNotEmpty ? parts[0].trim() : spec;
            final value = parts.length > 1 ? parts[1].trim() : '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: AppSpacing.cardPaddingMd,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkBackground : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      key,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.7)
                                : AppColors.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (value.isNotEmpty)
                    Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface
                                : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Build reviews tab
  Widget _buildReviewsTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reviews',
                style: AppTextStyles.headingSmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapHorizontalSm,
              Text(
                '(${_product!.totalReviews})',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMd,
          ..._product!.reviews.map(
            (review) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: AppSpacing.cardPaddingMd,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Colors.black.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(review.userAvatar),
                      ),
                      AppSpacing.gapHorizontalMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  review.userName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color:
                                        isDarkMode
                                            ? AppColors.onDarkSurface
                                            : AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (review.isVerified) ...[
                                  AppSpacing.gapHorizontalXs,
                                  Icon(
                                    Icons.verified,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < review.rating.floor()
                                          ? Icons.star
                                          : index < review.rating
                                          ? Icons.star_half
                                          : Icons.star_border,
                                      size: 14,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                AppSpacing.gapHorizontalXs,
                                Text(
                                  review.formattedDate,
                                  style: AppTextStyles.caption.copyWith(
                                    color:
                                        isDarkMode
                                            ? AppColors.onDarkSurface
                                                .withOpacity(0.5)
                                            : AppColors.onSurface.withOpacity(
                                              0.5,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapVerticalSm,
                  Text(
                    review.comment,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface.withOpacity(0.8)
                              : AppColors.onSurface.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
