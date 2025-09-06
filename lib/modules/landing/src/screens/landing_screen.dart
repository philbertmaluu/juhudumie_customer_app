import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../../../game/src/game_module.dart';
import '../components/product_card.dart';
import '../models/product_data.dart';
import '../services/product_service.dart';

/// Landing page with product grid
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();

  List<Product> _products = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  int _currentBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load products based on selected category
  void _loadProducts() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (_selectedCategory == 'All') {
          _products = _productService.getFeaturedProducts();
        } else {
          _products = _productService.getProductsByCategory(_selectedCategory);
        }
        _isLoading = false;
      });
    });
  }

  /// Handle category selection
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadProducts();
  }

  /// Handle product tap
  void _onProductTap(Product product) {
    Navigator.of(
      context,
    ).pushNamed('/product-details', arguments: {'productId': product.id});
  }

  /// Handle favorite toggle
  void _onFavoriteToggle(Product product) {
    // TODO: Implement favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${product.name} to favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Handle bottom navigation tap
  void _onBottomNavTap(int index) {
    // Store the previous index before updating
    final previousIndex = _currentBottomNavIndex;

    setState(() {
      _currentBottomNavIndex = index;
    });

    // Use the bottom navigation service for consistent navigation logic
    BottomNavigationService.handleNavigationTap(
      context,
      index,
      currentIndex: previousIndex,
      onSamePageTap: () {
        // Scroll to top when tapping home while already on home
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBarModule.getFloatingBottomNavBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _onBottomNavTap,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Custom sliver app bar
                _buildSliverAppBar(),

                // Category filter
                _buildCategoryFilter(),

                // Products grid
                _buildProductsGrid(),
              ],
            ),

            // Floating game button
            FloatingGameButton(
              onTap: () {
                Navigator.of(context).pushNamed('/game');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build custom sliver app bar
  Widget _buildSliverAppBar() {
    return SliverAppBarModule.getCustomSliverAppBar();
  }

  /// Build category filter
  Widget _buildCategoryFilter() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final productCategories = _productService.getCategories();
    final categories = ['All', ...productCategories.map((cat) => cat.name)];

    // Fallback categories if none are loaded
    final displayCategories =
        categories.length > 1
            ? categories
            : [
              'All',
              'Electronics',
              'Fashion',
              'Home & Garden',
              'Sports',
              'Books',
              'Beauty',
            ];

    return SliverToBoxAdapter(
      child: Container(
        height: 70,
        margin: AppSpacing.marginSm,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: AppSpacing.screenPaddingMd,
          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final category = displayCategories[index];
            final isSelected = category == _selectedCategory;

            return Container(
              margin: EdgeInsets.only(right: AppSpacing.sm),
              child: FilterChip(
                label: Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isSelected
                            ? Colors.white
                            : isDarkMode
                            ? Colors.white
                            : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  _onCategorySelected(category);
                },
                backgroundColor:
                    isDarkMode ? AppColors.darkSurface : Colors.white,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color:
                      isSelected
                          ? AppColors.primary
                          : isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
                elevation: isSelected ? 2 : 0,
                shadowColor:
                    isDarkMode
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build products grid
  Widget _buildProductsGrid() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 400,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.5)
                          : Colors.grey[400],
                ),
                AppSpacing.gapVerticalLg,
                Text(
                  'No products found',
                  style: AppTextStyles.headingSmall.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.7)
                            : AppColors.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.gapVerticalSm,
                Text(
                  'Try selecting a different category',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.5)
                            : AppColors.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.md + 100, // Extra padding for floating nav bar
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = _products[index];
          return ProductCard(
            product: product,
            onTap: () => _onProductTap(product),
            onFavorite: () => _onFavoriteToggle(product),
          );
        }, childCount: _products.length),
      ),
    );
  }
}
