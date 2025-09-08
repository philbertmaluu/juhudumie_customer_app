import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/wishlist_data.dart';
import '../services/wishlist_service.dart';
import 'wishlist_item_card.dart';
import 'wishlist_filter_chip.dart';

/// Professional wishlist modal bottom sheet
class WishlistModal extends StatefulWidget {
  const WishlistModal({super.key});

  @override
  State<WishlistModal> createState() => _WishlistModalState();
}

class _WishlistModalState extends State<WishlistModal>
    with TickerProviderStateMixin {
  final WishlistService _wishlistService = WishlistService();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  List<WishlistItem> _wishlistItems = [];
  WishlistSummary _summary = WishlistSummary.fromItems([]);
  WishlistFilter _currentFilter = WishlistFilter.all;
  WishlistSort _currentSort = WishlistSort.recentlyAdded;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWishlistData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Load wishlist data
  void _loadWishlistData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _wishlistService.loadSampleData();
      _updateWishlistData();
    });
  }

  /// Update wishlist data
  void _updateWishlistData() {
    setState(() {
      _wishlistItems = _wishlistService.getFilteredItems(_currentFilter);
      _wishlistItems = _wishlistService.getSortedItems(
        _wishlistItems,
        _currentSort,
      );
      _summary = _wishlistService.summary;
      _isLoading = false;
    });
  }

  /// Handle filter change
  void _onFilterChanged(WishlistFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    _updateWishlistData();
  }

  /// Handle sort change
  void _onSortChanged(WishlistSort sort) {
    setState(() {
      _currentSort = sort;
    });
    _updateWishlistData();
  }

  /// Handle remove item
  void _onRemoveItem(String productId) {
    _wishlistService.removeFromWishlist(productId);
    _updateWishlistData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from wishlist'),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
      ),
    );
  }

  /// Handle add to cart
  void _onAddToCart(WishlistItem item) {
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.productName} added to cart'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle view product
  void _onViewProduct(WishlistItem item) {
    // TODO: Navigate to product details
    Navigator.of(context).pop();
  }

  /// Handle clear wishlist
  void _onClearWishlist() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Wishlist'),
            content: const Text(
              'Are you sure you want to remove all items from your wishlist?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _wishlistService.clearWishlist();
                  _updateWishlistData();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.9,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          _buildHandleBar(isDarkMode),

          // Header
          _buildHeader(isDarkMode),

          // Tab bar
          _buildTabBar(isDarkMode),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWishlistTab(isDarkMode),
                _buildStatisticsTab(isDarkMode),
              ],
            ),
          ),
        ],
      ),
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

  /// Build header
  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: AppSpacing.screenPaddingMd,
      child: Row(
        children: [
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Wishlist',
                  style: AppTextStyles.headingLarge.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapVerticalXs,
                Text(
                  '${_summary.totalItems} items • TSh ${_summary.totalValue.toStringAsFixed(0)}',
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

          // Actions
          Row(
            children: [
              // Sort button
              IconButton(
                onPressed: _showSortOptions,
                icon: Icon(
                  Icons.sort_rounded,
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                ),
              ),

              // Clear button
              if (_summary.totalItems > 0)
                IconButton(
                  onPressed: _onClearWishlist,
                  icon: Icon(Icons.clear_all_rounded, color: AppColors.error),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build tab bar
  Widget _buildTabBar(bool isDarkMode) {
    return Container(
      margin: AppSpacing.screenPaddingMd,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor:
            isDarkMode
                ? AppColors.onDarkSurface.withOpacity(0.6)
                : AppColors.onSurface.withOpacity(0.6),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [Tab(text: 'Items'), Tab(text: 'Statistics')],
      ),
    );
  }

  /// Build wishlist tab
  Widget _buildWishlistTab(bool isDarkMode) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_wishlistItems.isEmpty) {
      return _buildEmptyState(isDarkMode);
    }

    return Column(
      children: [
        // Filter chips
        _buildFilterChips(isDarkMode),

        // Items list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: AppSpacing.screenPaddingMd,
            itemCount: _wishlistItems.length,
            itemBuilder: (context, index) {
              final item = _wishlistItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: WishlistItemCard(
                  item: item,
                  onRemove: () => _onRemoveItem(item.productId),
                  onAddToCart: () => _onAddToCart(item),
                  onViewProduct: () => _onViewProduct(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build statistics tab
  Widget _buildStatisticsTab(bool isDarkMode) {
    final stats = _wishlistService.getStatistics();

    return SingleChildScrollView(
      padding: AppSpacing.screenPaddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview cards
          _buildStatsOverview(isDarkMode, stats),

          AppSpacing.gapVerticalLg,

          // Category breakdown
          _buildCategoryBreakdown(isDarkMode),

          AppSpacing.gapVerticalLg,

          // Price analysis
          _buildPriceAnalysis(isDarkMode, stats),
        ],
      ),
    );
  }

  /// Build filter chips
  Widget _buildFilterChips(bool isDarkMode) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          WishlistFilterChip(
            filter: WishlistFilter.all,
            isSelected: _currentFilter == WishlistFilter.all,
            onTap: () => _onFilterChanged(WishlistFilter.all),
          ),
          const SizedBox(width: AppSpacing.sm),
          WishlistFilterChip(
            filter: WishlistFilter.available,
            isSelected: _currentFilter == WishlistFilter.available,
            onTap: () => _onFilterChanged(WishlistFilter.available),
          ),
          const SizedBox(width: AppSpacing.sm),
          WishlistFilterChip(
            filter: WishlistFilter.onSale,
            isSelected: _currentFilter == WishlistFilter.onSale,
            onTap: () => _onFilterChanged(WishlistFilter.onSale),
          ),
          const SizedBox(width: AppSpacing.sm),
          WishlistFilterChip(
            filter: WishlistFilter.recentlyAdded,
            isSelected: _currentFilter == WishlistFilter.recentlyAdded,
            onTap: () => _onFilterChanged(WishlistFilter.recentlyAdded),
          ),
        ],
      ),
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
              Icons.favorite_border_rounded,
              size: 120,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.3)
                      : AppColors.onSurface.withOpacity(0.3),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              'Your wishlist is empty',
              style: AppTextStyles.headingMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Start adding items you love to your wishlist',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Start Shopping'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build stats overview
  Widget _buildStatsOverview(bool isDarkMode, Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Items',
            '${stats['totalItems']}',
            Icons.favorite_rounded,
            AppColors.primary,
            isDarkMode,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Total Value',
            'TSh ${stats['totalValue'].toStringAsFixed(0)}',
            Icons.attach_money_rounded,
            Colors.green,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  /// Build stat card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: AppSpacing.cardPaddingMd,
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
        children: [
          Icon(icon, color: color, size: 32),
          AppSpacing.gapVerticalSm,
          Text(
            value,
            style: AppTextStyles.headingMedium.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.7)
                      : AppColors.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Build category breakdown
  Widget _buildCategoryBreakdown(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.headingSmall.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapVerticalMd,
        ..._summary.categoryCounts.entries.map((entry) {
          final percentage =
              _summary.totalItems > 0
                  ? (entry.value / _summary.totalItems * 100).round()
                  : 0;
          return _buildCategoryItem(
            entry.key,
            entry.value,
            percentage,
            isDarkMode,
          );
        }).toList(),
      ],
    );
  }

  /// Build category item
  Widget _buildCategoryItem(
    String category,
    int count,
    int percentage,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                  ),
                ),
                AppSpacing.gapVerticalXs,
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.1)
                          : AppColors.onSurface.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '$count ($percentage%)',
            style: AppTextStyles.bodySmall.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.7)
                      : AppColors.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Build price analysis
  Widget _buildPriceAnalysis(bool isDarkMode, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Analysis',
          style: AppTextStyles.headingSmall.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapVerticalMd,
        _buildPriceItem(
          'Total Value',
          'TSh ${stats['totalValue'].toStringAsFixed(0)}',
          isDarkMode,
        ),
        _buildPriceItem(
          'Total Savings',
          'TSh ${stats['totalSavings'].toStringAsFixed(0)}',
          isDarkMode,
        ),
        _buildPriceItem(
          'Average Rating',
          '${stats['averageRating'].toStringAsFixed(1)} ⭐',
          isDarkMode,
        ),
      ],
    );
  }

  /// Build price item
  Widget _buildPriceItem(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Show sort options
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: AppSpacing.screenPaddingMd,
                  child: Text(
                    'Sort by',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...WishlistSort.values.map((sort) {
                  return ListTile(
                    title: Text(_getSortTitle(sort)),
                    trailing:
                        _currentSort == sort
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                    onTap: () {
                      _onSortChanged(sort);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
    );
  }

  /// Get sort title
  String _getSortTitle(WishlistSort sort) {
    switch (sort) {
      case WishlistSort.recentlyAdded:
        return 'Recently Added';
      case WishlistSort.priceLowToHigh:
        return 'Price: Low to High';
      case WishlistSort.priceHighToLow:
        return 'Price: High to Low';
      case WishlistSort.nameAZ:
        return 'Name: A to Z';
      case WishlistSort.nameZA:
        return 'Name: Z to A';
      case WishlistSort.rating:
        return 'Rating';
    }
  }
}
