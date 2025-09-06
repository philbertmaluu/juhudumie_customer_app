import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/custom_button.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../models/category_data.dart';
import '../services/category_service.dart';
import '../components/category_grid.dart';
import '../components/category_products_bottom_sheet.dart';

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
    // Show the professional bottom sheet with products
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CategoryProductsBottomSheet(
            category: category,
            onClose: () {
              // Optional: Handle close callback
            },
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
        // Optional: Handle same page tap (e.g., scroll to top)
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
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? AppColors.darkPrimaryGradient
                  : AppColors.primaryGradient,
        ),
      ),
      title: Text(
        'Categories',
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isGridView ? Icons.list : Icons.grid_view,
            color: Colors.white,
          ),
          onPressed: _toggleView,
        ),
        //theme toggle button
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

  /// Build search section
  Widget _buildSearchSection(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: Column(
        children: [
          // Professional search bar with modern design (matching sliver app bar style)
          Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDarkMode
                        ? [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ]
                        : [Colors.white, Colors.grey[50]!],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                // Search icon with background
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                // Search input area
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Focus on search field
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search categories',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface
                                    : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Find your favorite categories',
                          style: AppTextStyles.caption.copyWith(
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface.withOpacity(0.7)
                                    : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Voice search button
                Container(
                  width: 1,
                  height: 24,
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.3)
                          : Colors.grey[300],
                ),
                GestureDetector(
                  onTap: () {
                    // Handle voice search
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice search coming soon!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.mic_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Clear search button (when there's text)
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.clear_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
              ],
            ),
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
