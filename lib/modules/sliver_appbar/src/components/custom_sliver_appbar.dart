import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../models/promotion_data.dart';
import '../../../shops/src/services/shop_service.dart';

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

                // Simple promotion banner
                _buildSimplePromotionBanner(context, isDarkMode),

                // Category and search section
                _buildCategoryAndSearchSection(context, isDarkMode),
                // Promotion banner section
                // _buildPromotionBannerSection(context, isDarkMode),
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

  /// Build simple promotion banner
  Widget _buildSimplePromotionBanner(BuildContext context, bool isDarkMode) {
    final featuredShop = ShopService.instance.getRandomFeaturedShop();

    return GestureDetector(
      onTap: () {
        // Handle promotion banner tap
        if (featuredShop != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exploring ${featuredShop.name}!'),
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Constellation deals explored!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors:
                isDarkMode
                    ? [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.primary.withOpacity(0.08),
                      AppColors.primary.withOpacity(0.12),
                    ]
                    : [
                      AppColors.primary.withOpacity(0.12),
                      AppColors.primary.withOpacity(0.06),
                      AppColors.primary.withOpacity(0.10),
                    ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color:
                isDarkMode
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.primary.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Vendor logo with constellation styling - positioned to deviate from banner
            Positioned(
              top: -12,
              left: 4,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Constellation dots
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 10,
                      child: Container(
                        width: 3.5,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 14,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 2.5,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Center vendor logo - rounded and bigger
                    Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                            featuredShop != null &&
                                    featuredShop.logoUrl.isNotEmpty
                                ? ClipOval(
                                  child: Image.network(
                                    featuredShop.logoUrl,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.store_rounded,
                                        size: 20,
                                        color: AppColors.primary,
                                      );
                                    },
                                  ),
                                )
                                : Icon(
                                  Icons.store_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Promotion content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    featuredShop != null
                        ? featuredShop.name
                        : 'Constellation Deals',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    featuredShop != null
                        ? featuredShop.tagline.isNotEmpty
                            ? featuredShop.tagline
                            : 'Premium ${featuredShop.categoryText.toLowerCase()} store'
                        : 'Premium vendors, stellar prices',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // Action button
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build category and search section (Alibaba style)
  Widget _buildCategoryAndSearchSection(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Professional search bar with modern design
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
        ],
      ),
    );
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
