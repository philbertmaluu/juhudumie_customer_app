import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../../../messages/src/components/delivery_map_modal.dart';
import '../../../messages/src/models/message_data.dart';
import '../models/cart_data.dart';
import '../models/order_data.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../components/cart_item_card.dart';
import '../components/cart_summary_card.dart';
import '../components/order_card.dart';
import '../components/order_filter_chip.dart';

/// Cart screen for managing shopping cart
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  List<CartItem> _cartItems = [];
  CartSummary _cartSummary = CartSummary.fromItems([]);
  CartState _state = CartState.loading;
  int _currentBottomNavIndex = 3; // Cart tab is selected

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Check for initial tab argument
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['initialTab'] != null) {
        final initialTab = args['initialTab'] as int;
        if (initialTab >= 0 && initialTab < 2) {
          _tabController?.animateTo(initialTab);
        }
      }
    });

    _loadCartData();
    _loadOrderData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController?.dispose();
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

  /// Load order data
  void _loadOrderData() {
    _orderService.loadSampleData();
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
        'Cart & Orders',
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (_tabController?.index == 0 && _cartItems.isNotEmpty)
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
      bottom:
          _tabController != null
              ? TabBar(
                controller: _tabController!,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text('Cart (${_cartItems.length})')],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Orders (${_orderService.orders.length})'),
                      ],
                    ),
                  ),
                ],
              )
              : null,
    );
  }

  /// Build body content
  Widget _buildBody(bool isDarkMode) {
    if (_tabController == null) {
      return _buildCartTab(isDarkMode); // Show cart by default while loading
    }

    return TabBarView(
      controller: _tabController!,
      children: [
        // Cart tab
        _buildCartTab(isDarkMode),
        // Orders tab
        _buildOrdersTab(isDarkMode),
      ],
    );
  }

  /// Build cart tab content
  Widget _buildCartTab(bool isDarkMode) {
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

  /// Build orders tab content
  Widget _buildOrdersTab(bool isDarkMode) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        // Filter chips
        _buildOrderFilters(),
        const SizedBox(height: AppSpacing.sm),

        // Orders list
        Expanded(child: _buildOrdersList(isDarkMode)),
      ],
    );
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

  /// Build order filters
  Widget _buildOrderFilters() {
    final orderStats = _orderService.orderStatistics;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          OrderFilterChip(
            filter: OrderFilter.all,
            isSelected: _orderService.currentFilter == OrderFilter.all,
            onTap: () {
              setState(() {
                _orderService.setFilter(OrderFilter.all);
              });
            },
            count: _orderService.orders.length,
          ),
          const SizedBox(width: AppSpacing.sm),
          OrderFilterChip(
            filter: OrderFilter.pending,
            isSelected: _orderService.currentFilter == OrderFilter.pending,
            onTap: () {
              setState(() {
                _orderService.setFilter(OrderFilter.pending);
              });
            },
            count: orderStats['pending'] ?? 0,
          ),
          const SizedBox(width: AppSpacing.sm),
          OrderFilterChip(
            filter: OrderFilter.processing,
            isSelected: _orderService.currentFilter == OrderFilter.processing,
            onTap: () {
              setState(() {
                _orderService.setFilter(OrderFilter.processing);
              });
            },
            count: orderStats['processing'] ?? 0,
          ),
          const SizedBox(width: AppSpacing.sm),
          OrderFilterChip(
            filter: OrderFilter.shipped,
            isSelected: _orderService.currentFilter == OrderFilter.shipped,
            onTap: () {
              setState(() {
                _orderService.setFilter(OrderFilter.shipped);
              });
            },
            count: orderStats['shipped'] ?? 0,
          ),
          const SizedBox(width: AppSpacing.sm),
          OrderFilterChip(
            filter: OrderFilter.delivered,
            isSelected: _orderService.currentFilter == OrderFilter.delivered,
            onTap: () {
              setState(() {
                _orderService.setFilter(OrderFilter.delivered);
              });
            },
            count: orderStats['delivered'] ?? 0,
          ),
        ],
      ),
    );
  }

  /// Build orders list
  Widget _buildOrdersList(bool isDarkMode) {
    final filteredOrders = _orderService.filteredOrders;

    if (filteredOrders.isEmpty) {
      return _buildEmptyOrdersState(isDarkMode);
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return OrderCard(
          order: order,
          onTap: () => _onOrderTap(order),
          onCancel: () => _onCancelOrder(order),
          onTrack: () => _onTrackOrder(order),
          onReorder: () => _onReorder(order),
        );
      },
    );
  }

  /// Build empty orders state
  Widget _buildEmptyOrdersState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.onSurfaceVariant,
          ),
          AppSpacing.gapVerticalXxl,
          Text(
            'No Orders Found',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapVerticalLg,
          Text(
            'You haven\'t placed any orders yet.\nStart shopping to see your orders here!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVerticalXxl,
          ElevatedButton(
            onPressed: () {
              // Switch to cart tab
              _tabController?.animateTo(0);
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  /// Handle order tap
  void _onOrderTap(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing order ${order.orderNumber}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle cancel order
  void _onCancelOrder(Order order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Order'),
            content: Text(
              'Are you sure you want to cancel order ${order.orderNumber}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (_orderService.cancelOrder(order.id)) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order ${order.orderNumber} cancelled'),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );
  }

  /// Handle track order
  void _onTrackOrder(Order order) {
    // Create OrderTracking object from Order
    final tracking = OrderTracking(
      orderId: order.id,
      status: order.status.name,
      description: _getOrderStatusDescription(order.status),
      timestamp: order.orderDate,
      location: 'Dar es Salaam, Tanzania',
      deliveryManId: 'delivery_${order.id}',
      deliveryManName: 'John Mwalimu',
      deliveryManPhone: '+255 123 456 789',
      estimatedDelivery:
          order.estimatedDelivery != null
              ? '${DateTime.now().difference(order.estimatedDelivery!).inHours} hours'
              : '2-3 hours',
    );

    _showDeliveryMapModal(tracking);
  }

  /// Show delivery map modal
  void _showDeliveryMapModal(OrderTracking tracking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DeliveryMapModal(
            tracking: tracking,
            onCallDeliveryMan:
                tracking.deliveryManPhone != null
                    ? () {
                      Navigator.of(context).pop();
                      _onCallDeliveryMan(tracking.deliveryManPhone!);
                    }
                    : null,
            onMessageDeliveryMan:
                tracking.deliveryManId != null
                    ? () {
                      Navigator.of(context).pop();
                      _onMessageDeliveryMan(tracking.deliveryManId!);
                    }
                    : null,
          ),
    );
  }

  /// Handle call delivery man
  void _onCallDeliveryMan(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling delivery partner: $phoneNumber'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle message delivery man
  void _onMessageDeliveryMan(String deliveryManId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening chat with delivery partner'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Get order status description
  String _getOrderStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Your order is pending confirmation';
      case OrderStatus.confirmed:
        return 'Your order has been confirmed';
      case OrderStatus.processing:
        return 'Your order is being prepared';
      case OrderStatus.shipped:
        return 'Your order is on the way to you';
      case OrderStatus.delivered:
        return 'Your order has been delivered';
      case OrderStatus.cancelled:
        return 'Your order has been cancelled';
      case OrderStatus.refunded:
        return 'Your order has been refunded';
    }
  }

  /// Handle reorder
  void _onReorder(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding items from ${order.orderNumber} to cart'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
