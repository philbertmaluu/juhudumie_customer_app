import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/custom_button.dart';
import '../../../landing/src/components/product_card.dart';
import '../../../landing/src/models/product_data.dart';
import '../../../landing/src/services/product_service.dart';
import '../models/category_data.dart';

/// Professional bottom sheet for displaying products in a category
class CategoryProductsBottomSheet extends StatefulWidget {
  final Category category;
  final VoidCallback? onClose;

  const CategoryProductsBottomSheet({
    super.key,
    required this.category,
    this.onClose,
  });

  @override
  State<CategoryProductsBottomSheet> createState() =>
      _CategoryProductsBottomSheetState();
}

class _CategoryProductsBottomSheetState
    extends State<CategoryProductsBottomSheet>
    with TickerProviderStateMixin {
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Product> _products = [];
  bool _isLoading = true;
  String _sortBy = 'popular';
  String _filterBy = 'all';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Setup entrance animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  /// Load products for the category
  void _loadProducts() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _products = _productService.getProductsByCategory(widget.category.name);
        _isLoading = false;
      });
    });
  }

  /// Handle product tap
  void _onProductTap(Product product) {
    Navigator.of(
      context,
    ).pushNamed('/product-details', arguments: {'productId': product.id});
  }

  /// Handle favorite toggle
  void _onFavoriteToggle(Product product) {
    // For now, just show a message since the Product model doesn't have isFavorite
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to favorites! ❤️'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle sort change
  void _onSortChanged(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      _sortProducts();
    });
  }

  /// Handle filter change
  void _onFilterChanged(String filterBy) {
    setState(() {
      _filterBy = filterBy;
      _filterProducts();
    });
  }

  /// Sort products based on selected criteria
  void _sortProducts() {
    switch (_sortBy) {
      case 'popular':
        _products.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case 'price_low':
        _products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        _products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        _products.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
  }

  /// Filter products based on selected criteria
  void _filterProducts() {
    // For now, we'll just reload all products
    // In a real app, you'd filter based on price range, rating, etc.
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              height: screenHeight * 0.9, // 90% of screen height
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.darkBackground
                        : AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  _buildHandleBar(isDarkMode),

                  // Header section
                  _buildHeader(isDarkMode),

                  // Filter and sort section
                  _buildFilterSortSection(isDarkMode),

                  // Products section
                  Expanded(
                    child:
                        _isLoading
                            ? _buildLoadingState()
                            : _buildProductsSection(isDarkMode),
                  ),

                  // Bottom action bar
                  _buildBottomActionBar(isDarkMode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build handle bar
  Widget _buildHandleBar(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.onDarkSurface.withOpacity(0.3)
                : AppColors.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: Row(
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.category_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          AppSpacing.gapHorizontalMd,

          // Category info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category.name,
                  style: AppTextStyles.headingMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapVerticalXs,
                Text(
                  '${_products.length} products available',
                  style: AppTextStyles.bodyMedium.copyWith(
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
              _animationController.reverse().then((_) {
                Navigator.of(context).pop();
                widget.onClose?.call();
              });
            },
            icon: Icon(
              Icons.close_rounded,
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Build filter and sort section
  Widget _buildFilterSortSection(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Sort dropdown
          Expanded(child: _buildSortDropdown(isDarkMode)),

          AppSpacing.gapHorizontalMd,

          // Filter dropdown
          Expanded(child: _buildFilterDropdown(isDarkMode)),
        ],
      ),
    );
  }

  /// Build sort dropdown
  Widget _buildSortDropdown(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
          ),
          items: const [
            DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
            DropdownMenuItem(
              value: 'price_low',
              child: Text('Price: Low to High'),
            ),
            DropdownMenuItem(
              value: 'price_high',
              child: Text('Price: High to Low'),
            ),
            DropdownMenuItem(value: 'rating', child: Text('Highest Rated')),
            DropdownMenuItem(value: 'newest', child: Text('Newest First')),
          ],
          onChanged: (value) {
            if (value != null) _onSortChanged(value);
          },
        ),
      ),
    );
  }

  /// Build filter dropdown
  Widget _buildFilterDropdown(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _filterBy,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
          ),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Products')),
            DropdownMenuItem(
              value: 'under_100k',
              child: Text('Under TSh 100K'),
            ),
            DropdownMenuItem(
              value: '100k_500k',
              child: Text('TSh 100K - 500K'),
            ),
            DropdownMenuItem(value: 'over_500k', child: Text('Over TSh 500K')),
            DropdownMenuItem(value: 'high_rated', child: Text('4+ Stars')),
          ],
          onChanged: (value) {
            if (value != null) _onFilterChanged(value);
          },
        ),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build products section
  Widget _buildProductsSection(bool isDarkMode) {
    if (_products.isEmpty) {
      return _buildEmptyState(isDarkMode);
    }

    return GridView.builder(
      controller: _scrollController,
      padding: AppSpacing.screenPaddingMd,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductCard(
          product: product,
          onTap: () => _onProductTap(product),
          onFavorite: () => _onFavoriteToggle(product),
        );
      },
    );
  }

  /// Build empty state
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
          AppSpacing.gapVerticalLg,
          Text(
            'No products found',
            style: AppTextStyles.headingMedium.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
          ),
          AppSpacing.gapVerticalSm,
          Text(
            'Try adjusting your filters or check back later',
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

  /// Build bottom action bar
  Widget _buildBottomActionBar(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // View all button
          Expanded(
            child: SecondaryButton(
              text: 'View All Products',
              onPressed: () {
                // TODO: Navigate to full category page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View all products feature coming soon!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),

          AppSpacing.gapHorizontalMd,

          // Start shopping button
          Expanded(
            child: PrimaryButton(
              text: 'Start Shopping',
              onPressed: () {
                // Scroll to top and show a welcome message
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Welcome to ${widget.category.name}! Happy shopping! 🛍️',
                    ),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
