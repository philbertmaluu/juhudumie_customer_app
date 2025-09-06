import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/custom_button.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../models/category_data.dart';
import '../services/category_service.dart';
import '../components/category_grid.dart';
import '../components/category_card.dart';

/// Category screen for browsing and searching categories
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  final CategoryService _categoryService = CategoryService();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  String _searchQuery = '';
  bool _isGridView = true;
  bool _isLoading = true;
  int _currentBottomNavIndex = 1; // Categories tab is selected

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Load categories from service
  void _loadCategories() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _allCategories = _categoryService.getAllCategories();
        _filteredCategories = _allCategories;
        _isLoading = false;
      });
    });
  }

  /// Handle search query change
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _categoryService.searchCategories(query);
      }
    });
  }

  /// Handle category tap
  void _onCategoryTap(Category category) {
    // TODO: Navigate to category products screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${category.name}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handle view toggle
  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  /// Handle bottom navigation tap
  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    // Handle navigation based on selected tab
    switch (index) {
      case 0: // Home
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
        break;
      case 1: // Categories - already on category page
        break;
      case 2: // Messages
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Messages feature coming soon!'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
      case 3: // Cart
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cart feature coming soon!'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
      case 4: // Profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile feature coming soon!'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
    }
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
        body: Column(
          children: [
            // Search and filter section
            _buildSearchSection(isDarkMode),

            // Tab bar
            _buildTabBar(isDarkMode),

            // Content with bottom padding for floating nav bar
            Expanded(
              child:
                  _isLoading ? _buildLoadingState() : _buildContent(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Categories',
        style: AppTextStyles.headingMedium.copyWith(
          color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isGridView ? Icons.list : Icons.grid_view,
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
          ),
          onPressed: _toggleView,
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
          ),
          onPressed: () {
            // TODO: Show filter options
          },
        ),
      ],
    );
  }

  /// Build search section
  Widget _buildSearchSection(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: Column(
        children: [
          // Search bar
          Container(
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
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.5)
                          : AppColors.onSurface.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.5)
                          : AppColors.onSurface.withOpacity(0.5),
                ),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface.withOpacity(0.5)
                                    : AppColors.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: AppSpacing.inputPaddingMd,
              ),
            ),
          ),

          AppSpacing.gapVerticalMd,

          // Stats row
          Row(
            children: [
              Text(
                '${_filteredCategories.length} categories',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              Text(
                '${_categoryService.getTotalProducts()} total products',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
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
        tabs: const [Tab(text: 'All'), Tab(text: 'Popular'), Tab(text: 'New')],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build content based on selected tab
  Widget _buildContent(bool isDarkMode) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCategoryList(_filteredCategories),
        _buildCategoryList(_categoryService.getPopularCategories()),
        _buildCategoryList(_categoryService.getNewCategories()),
      ],
    );
  }

  /// Build category list/grid
  Widget _buildCategoryList(List<Category> categories) {
    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom:
            AppSpacing.md +
            110, // Extra padding for floating nav bar + overflow fix
      ),
      child:
          _isGridView
              ? CategoryGrid(
                categories: categories,
                onCategoryTap: _onCategoryTap,
              )
              : CategoryList(
                categories: categories,
                onCategoryTap: _onCategoryTap,
              ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom:
            AppSpacing.md +
            110, // Extra padding for floating nav bar + overflow fix
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: AppSpacing.iconXl * 2,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.3)
                      : AppColors.onSurface.withOpacity(0.3),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              'No categories found',
              style: AppTextStyles.headingMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Try adjusting your search or filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            PrimaryButton(
              text: 'Clear Search',
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          ],
        ),
      ),
    );
  }
}
