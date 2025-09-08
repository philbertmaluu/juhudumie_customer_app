import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../models/shop_data.dart';
import '../services/shop_service.dart';
import '../components/shop_card.dart';
import '../components/shop_filter_chip.dart';

/// Main shops screen displaying all enrolled vendors' shops
class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen>
    with TickerProviderStateMixin {
  final ShopService _shopService = ShopService.instance;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<Shop> _allShops = [];
  List<Shop> _filteredShops = [];
  String _searchQuery = '';
  ShopFilter _selectedFilter = ShopFilter.all;
  ShopSort _selectedSort = ShopSort.name;
  bool _isLoading = true;
  int _currentBottomNavIndex = 2; // Shops tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Load initial data
  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _allShops = _shopService.shops;
        _filteredShops = _allShops;
        _isLoading = false;
      });
    });
  }

  /// Handle search
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  /// Apply filters and search
  void _applyFilters() {
    _filteredShops = _shopService.getFilteredShops(
      query: _searchQuery,
      filter: _selectedFilter,
      sort: _selectedSort,
    );
  }

  /// Handle bottom navigation tap
  void _onBottomNavTap(int index) {
    final previousIndex = _currentBottomNavIndex;

    setState(() {
      _currentBottomNavIndex = index;
    });

    BottomNavigationService.handleNavigationTap(
      context,
      index,
      currentIndex: previousIndex,
      onSamePageTap: () {
        // Optional: Handle same page tap
      },
    );
  }

  /// Handle shop tap
  void _onShopTap(Shop shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${shop.name}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle view products
  void _onViewProducts(Shop shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing products from ${shop.name}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle view ads
  void _onViewAds(Shop shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ads from ${shop.name}'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle view videos
  void _onViewVideos(Shop shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing videos from ${shop.name}'),
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        body: _isLoading ? _buildLoadingState() : _buildBody(isDarkMode),
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
        'Shops',
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Shop count badge
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_allShops.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        tabs: const [
          Tab(text: 'All Shops'),
          Tab(text: 'Featured'),
          Tab(text: 'Nearby'),
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

  /// Build body content
  Widget _buildBody(bool isDarkMode) {
    return Column(
      children: [
        // Search bar
        _buildSearchSection(isDarkMode),

        // Filter chips
        _buildFilterChips(),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllShops(isDarkMode),
              _buildFeaturedShops(isDarkMode),
              _buildNearbyShops(isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  /// Build search section
  Widget _buildSearchSection(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search shops, categories, or locations...',
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.primary),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                  : null,
          filled: true,
          fillColor: isDarkMode ? AppColors.darkSurface : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.outlineVariant : AppColors.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.outlineVariant : AppColors.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  /// Build filter chips
  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ShopFilterChip(
            filter: ShopFilter.all,
            isSelected: _selectedFilter == ShopFilter.all,
            onTap: () => _onFilterChanged(ShopFilter.all),
            count: _shopService.getShopStatistics()['total'],
          ),
          const SizedBox(width: AppSpacing.sm),
          ShopFilterChip(
            filter: ShopFilter.fashion,
            isSelected: _selectedFilter == ShopFilter.fashion,
            onTap: () => _onFilterChanged(ShopFilter.fashion),
            count: _shopService.getShopStatistics()['fashion'],
          ),
          const SizedBox(width: AppSpacing.sm),
          ShopFilterChip(
            filter: ShopFilter.electronics,
            isSelected: _selectedFilter == ShopFilter.electronics,
            onTap: () => _onFilterChanged(ShopFilter.electronics),
            count: _shopService.getShopStatistics()['electronics'],
          ),
          const SizedBox(width: AppSpacing.sm),
          ShopFilterChip(
            filter: ShopFilter.food,
            isSelected: _selectedFilter == ShopFilter.food,
            onTap: () => _onFilterChanged(ShopFilter.food),
            count: _shopService.getShopStatistics()['food'],
          ),
          const SizedBox(width: AppSpacing.sm),
          ShopFilterChip(
            filter: ShopFilter.beauty,
            isSelected: _selectedFilter == ShopFilter.beauty,
            onTap: () => _onFilterChanged(ShopFilter.beauty),
            count: _shopService.getShopStatistics()['beauty'],
          ),
          const SizedBox(width: AppSpacing.sm),
          ShopFilterChip(
            filter: ShopFilter.verified,
            isSelected: _selectedFilter == ShopFilter.verified,
            onTap: () => _onFilterChanged(ShopFilter.verified),
          ),
          const SizedBox(width: AppSpacing.sm),
          ShopFilterChip(
            filter: ShopFilter.premium,
            isSelected: _selectedFilter == ShopFilter.premium,
            onTap: () => _onFilterChanged(ShopFilter.premium),
          ),
        ],
      ),
    );
  }

  /// Build all shops tab
  Widget _buildAllShops(bool isDarkMode) {
    if (_filteredShops.isEmpty) {
      return _buildEmptyState(
        'No shops found',
        'Try adjusting your search or filters to find shops',
        Icons.store_outlined,
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: _filteredShops.length,
      itemBuilder: (context, index) {
        final shop = _filteredShops[index];
        return ShopCard(
          shop: shop,
          onTap: () => _onShopTap(shop),
          onViewProducts: () => _onViewProducts(shop),
          onViewAds: () => _onViewAds(shop),
          onViewVideos: () => _onViewVideos(shop),
        );
      },
    );
  }

  /// Build featured shops tab
  Widget _buildFeaturedShops(bool isDarkMode) {
    final featuredShops =
        _allShops.where((shop) => shop.isPremium || shop.isVerified).toList();

    if (featuredShops.isEmpty) {
      return _buildEmptyState(
        'No featured shops',
        'Premium and verified shops will appear here',
        Icons.star_outline,
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: featuredShops.length,
      itemBuilder: (context, index) {
        final shop = featuredShops[index];
        return ShopCard(
          shop: shop,
          onTap: () => _onShopTap(shop),
          onViewProducts: () => _onViewProducts(shop),
          onViewAds: () => _onViewAds(shop),
          onViewVideos: () => _onViewVideos(shop),
        );
      },
    );
  }

  /// Build nearby shops tab
  Widget _buildNearbyShops(bool isDarkMode) {
    final nearbyShops =
        _allShops.where((shop) => shop.distanceFromUser <= 10.0).toList();

    if (nearbyShops.isEmpty) {
      return _buildEmptyState(
        'No nearby shops',
        'Shops within 10km will appear here',
        Icons.location_on_outlined,
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: nearbyShops.length,
      itemBuilder: (context, index) {
        final shop = nearbyShops[index];
        return ShopCard(
          shop: shop,
          onTap: () => _onShopTap(shop),
          onViewProducts: () => _onViewProducts(shop),
          onViewAds: () => _onViewAds(shop),
          onViewVideos: () => _onViewVideos(shop),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon,
    bool isDarkMode,
  ) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.3)
                      : AppColors.onSurface.withOpacity(0.3),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              title,
              style: AppTextStyles.headingSmall.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalSm,
            Text(
              subtitle,
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
      ),
    );
  }

  /// Handle filter change
  void _onFilterChanged(ShopFilter filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilters();
    });
  }
}
