import 'package:flutter/material.dart';
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

                // Search bar section
                if (config.showSearchBar)
                  _buildSearchSection(context, isDarkMode),
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

  /// Build search section
  Widget _buildSearchSection(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.2)
                    : AppColors.onPrimary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.6)
                      : AppColors.onPrimary.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search products, brands, and more...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.6)
                          : AppColors.onPrimary.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
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
}
