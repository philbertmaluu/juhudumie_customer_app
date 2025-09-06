import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../models/promotion_data.dart';
import '../services/sliver_appbar_service.dart';

/// Custom sliver app bar with promotions and app branding
class CustomSliverAppBar extends StatelessWidget {
  final SliverAppBarConfig config;
  final Widget? title;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final double? collapsedHeight;

  const CustomSliverAppBar({
    super.key,
    required this.config,
    this.title,
    this.actions,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.expandedHeight,
    this.collapsedHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final featuredPromotion = config.featuredPromotion;

    return SliverAppBar(
      expandedHeight: expandedHeight ?? config.expandedHeight,
      collapsedHeight: collapsedHeight ?? config.collapsedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.surface,
      foregroundColor:
          isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient:
                isDarkMode
                    ? AppColors.darkPrimaryGradient
                    : AppColors.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top section with logo and actions
                _buildTopSection(context, isDarkMode),

                // Promotions section
                if (featuredPromotion != null)
                  _buildPromotionsSection(
                    context,
                    featuredPromotion,
                    isDarkMode,
                  ),

                // Category and search section
                _buildCategoryAndSearchSection(context, isDarkMode),
              ],
            ),
          ),
        ),
      ),
      title: title,
      actions: actions,
    );
  }

  /// Build top section with logo and action buttons
  Widget _buildTopSection(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // App logo and name

          // Action buttons
          Row(
            children: [
              // Theme toggle button
              Consumer<ThemeManager>(
                builder: (context, themeManager, child) {
                  return _buildActionButton(
                    context,
                    _getThemeIcon(themeManager),
                    () => _showThemeMenu(context, themeManager),
                    isDarkMode,
                  );
                },
              ),
              const SizedBox(width: 8),
              if (config.showNotifications)
                _buildActionButton(context, Icons.notifications_outlined, () {
                  // Handle notifications
                }, isDarkMode),
              const SizedBox(width: 8),
              if (config.showCart)
                _buildActionButton(context, Icons.shopping_cart_outlined, () {
                  // Handle cart
                }, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  /// Build promotions banner section
  Widget _buildPromotionsSection(
    BuildContext context,
    PromotionBanner promotion,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promotion type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.2)
                      : AppColors.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              SliverAppBarService.getPromotionTypeDisplayName(promotion.type),
              style: AppTextStyles.caption.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Promotion content
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promotion.title,
                      style: AppTextStyles.headingSmall.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface
                                : AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promotion.subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.8)
                                : AppColors.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Action button
              if (promotion.actionText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.1)
                            : AppColors.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface.withOpacity(0.3)
                              : AppColors.onPrimary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    promotion.actionText!,
                    style: AppTextStyles.buttonPrimary.copyWith(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface
                              : AppColors.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build category and search section (Alibaba style)
  Widget _buildCategoryAndSearchSection(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Professional search bar with modern design
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search for products',
                        style: TextStyle(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface
                                  : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Find anything you need',
                        style: TextStyle(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface.withOpacity(0.7)
                                  : Colors.grey[400],
                          fontSize: 11,
                        ),
                      ),
                    ],
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
                // QR Scanner button
                GestureDetector(
                  onTap: () {
                    // Handle scan action
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Categories horizontal scroll (Alibaba style - full width)
          SizedBox(
            height: 100, // Increased height for bigger cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _getCategories().length,
              itemBuilder: (context, index) {
                final category = _getCategories()[index];
                return GestureDetector(
                  onTap: () {
                    // Handle category tap
                  },
                  child: Container(
                    width: 85, // Increased width for bigger cards
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.1)
                                : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDarkMode
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            category['icon'],
                            size: 22,
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface
                                    : AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface
                                    : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

  /// Get categories list
  List<Map<String, dynamic>> _getCategories() {
    return [
      {'name': 'Home', 'icon': Icons.home},
      {'name': 'Electronics', 'icon': Icons.electrical_services},
      {'name': 'Fashion', 'icon': Icons.checkroom},
      {'name': 'Sports', 'icon': Icons.sports},
      {'name': 'Books', 'icon': Icons.book},
      {'name': 'Beauty', 'icon': Icons.face},
      {'name': 'Toys', 'icon': Icons.toys},
      {'name': 'Automotive', 'icon': Icons.directions_car},
    ];
  }

  /// Build action button
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.2)
                    : AppColors.onPrimary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isDarkMode ? AppColors.onDarkSurface : AppColors.onPrimary,
          size: 20,
        ),
      ),
    );
  }

  /// Get the appropriate theme icon based on current theme mode
  IconData _getThemeIcon(ThemeManager themeManager) {
    switch (themeManager.themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Show theme selection menu
  void _showThemeMenu(BuildContext context, ThemeManager themeManager) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: const Text('Light Mode'),
                  onTap: () {
                    themeManager.setLightTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  onTap: () {
                    themeManager.setDarkTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_auto),
                  title: const Text('System'),
                  onTap: () {
                    themeManager.setSystemTheme();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
