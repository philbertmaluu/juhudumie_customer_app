import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../models/cart_data.dart';
import '../services/cart_service.dart';
import '../components/cart_item_card.dart';
import '../components/cart_summary_card.dart';

/// Cart screen for managing shopping cart
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final ScrollController _scrollController = ScrollController();

  List<CartItem> _cartItems = [];
  CartSummary _cartSummary = CartSummary.fromItems([]);
  CartState _state = CartState.loading;
  int _currentBottomNavIndex = 3; // Cart tab is selected

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load cart data
  void _loadCartData() {
    setState(() {
      _state = CartState.loading;
    });

    // Load sample data for demo
    _cartService.loadSampleData();

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _cartItems = _cartService.cartItems;
        _cartSummary = _cartService.cartSummary;
        _state = _cartService.state;
      });
    });
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
        // Scroll to top when tapping cart while already on cart
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

  /// Handle remove item
  void _onRemoveItem(String itemId) {
    _cartService.removeFromCart(itemId).then((success) {
      if (success) {
        setState(() {
          _cartItems = _cartService.cartItems;
          _cartSummary = _cartService.cartSummary;
          _state = _cartService.state;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }
    });
  }

  /// Handle quantity change
  void _onQuantityChanged(String itemId, int newQuantity) {
    _cartService.updateQuantity(itemId, newQuantity).then((success) {
      if (success) {
        setState(() {
          _cartItems = _cartService.cartItems;
          _cartSummary = _cartService.cartSummary;
          _state = _cartService.state;
        });
      }
    });
  }

  /// Handle clear cart
  void _onClearCart() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cartService.clearCart().then((success) {
                    if (success) {
                      setState(() {
                        _cartItems = _cartService.cartItems;
                        _cartSummary = _cartService.cartSummary;
                        _state = _cartService.state;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cart cleared successfully'),
                          backgroundColor: AppColors.primary,
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      );
                    }
                  });
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  /// Handle checkout
  void _onCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout feature coming soon! 🛒'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
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
        appBar: _buildAppBar(isDarkMode),
        body: _buildBody(isDarkMode),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? AppColors.darkPrimaryGradient
                  : AppColors.primaryGradient,
        ),
      ),
      title: Text(
        'Shopping Cart',
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (_cartItems.isNotEmpty)
          IconButton(
            onPressed: _onClearCart,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          ),
        Consumer<ThemeManager>(
          builder: (context, themeManager, child) {
            return IconButton(
              icon: Icon(
                themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                themeManager.toggleTheme();
              },
            );
          },
        ),
      ],
    );
  }

  /// Build body content
  Widget _buildBody(bool isDarkMode) {
    switch (_state) {
      case CartState.loading:
        return _buildLoadingState();
      case CartState.empty:
        return _buildEmptyState(isDarkMode);
      case CartState.error:
        return _buildErrorState(isDarkMode);
      case CartState.loaded:
        return _buildCartContent(isDarkMode);
    }
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.3)
                      : AppColors.onSurface.withOpacity(0.3),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              'Your cart is empty',
              style: AppTextStyles.headingMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Add some products to get started with your shopping',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            ElevatedButton(
              onPressed: () {
                BottomNavigationService.handleNavigationTap(context, 0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Shopping',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 120,
              color: Colors.red.withOpacity(0.5),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              'Something went wrong',
              style: AppTextStyles.headingMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Unable to load your cart. Please try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            ElevatedButton(
              onPressed: _loadCartData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build cart content
  Widget _buildCartContent(bool isDarkMode) {
    return Column(
      children: [
        // Cart items
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              bottom: AppSpacing.md + 120, // Space for summary card
            ),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return CartItemCard(
                item: item,
                onRemove: () => _onRemoveItem(item.id),
                onQuantityChanged:
                    (newQuantity) => _onQuantityChanged(item.id, newQuantity),
                onTap: () {
                  // Navigate to product details
                  Navigator.of(context).pushNamed(
                    '/product-details',
                    arguments: {'productId': item.productId},
                  );
                },
              );
            },
          ),
        ),

        // Cart summary (fixed at bottom)
        Container(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md + 100, // Space for bottom nav
          ),
          child: CartSummaryCard(
            summary: _cartSummary,
            onCheckout: _onCheckout,
          ),
        ),
      ],
    );
  }
}
