import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/shop_data.dart';

/// Shop card component for displaying shop information
class ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback? onTap;
  final VoidCallback? onViewProducts;
  final VoidCallback? onViewAds;
  final VoidCallback? onViewVideos;

  const ShopCard({
    super.key,
    required this.shop,
    this.onTap,
    this.onViewProducts,
    this.onViewAds,
    this.onViewVideos,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.sm,
        ),
        padding: AppSpacing.cardPaddingMd,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Shop logo
                _buildShopLogo(),

                AppSpacing.gapHorizontalMd,

                // Shop info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop name and verification
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              shop.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color:
                                    isDarkMode
                                        ? AppColors.onDarkSurface
                                        : AppColors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (shop.isVerified) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.verified_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ],
                      ),

                      AppSpacing.gapVerticalXs,

                      // Category and distance
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                            child: Text(
                              shop.categoryText,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.location_on_rounded,
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface.withOpacity(0.6)
                                    : AppColors.onSurface.withOpacity(0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${shop.distanceFromUser.toStringAsFixed(1)} km',
                            style: AppTextStyles.caption.copyWith(
                              color:
                                  isDarkMode
                                      ? AppColors.onDarkSurface.withOpacity(0.6)
                                      : AppColors.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rating
                _buildRating(isDarkMode),
              ],
            ),

            AppSpacing.gapVerticalSm,

            // Tagline
            if (shop.tagline.isNotEmpty)
              Text(
                shop.tagline,
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            AppSpacing.gapVerticalSm,

            // Stats row
            Row(
              children: [
                _buildStatItem(
                  icon: Icons.inventory_2_outlined,
                  label: '${shop.totalProducts} products',
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(width: AppSpacing.md),
                _buildStatItem(
                  icon: Icons.shopping_bag_outlined,
                  label: '${shop.totalOrders} orders',
                  isDarkMode: isDarkMode,
                ),
                const Spacer(),
                if (shop.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.diamond_rounded,
                          color: AppColors.warning,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Premium',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            AppSpacing.gapVerticalSm,

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.inventory_2_outlined,
                    label: 'Products',
                    onTap: onViewProducts,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.campaign_outlined,
                    label: 'Ads',
                    onTap: onViewAds,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.play_circle_outline,
                    label: 'Videos',
                    onTap: onViewVideos,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: AppColors.surfaceVariant),
        child:
            shop.logoUrl.isNotEmpty
                ? Image.network(
                  shop.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.store_rounded,
                      color: AppColors.primary,
                      size: 24,
                    );
                  },
                )
                : Icon(Icons.store_rounded, color: AppColors.primary, size: 24),
      ),
    );
  }

  Widget _buildRating(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
            const SizedBox(width: 4),
            Text(
              shop.rating.averageRating.toStringAsFixed(1),
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          '(${shop.rating.totalReviews})',
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.6)
                    : AppColors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required bool isDarkMode,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.6)
                  : AppColors.onSurface.withOpacity(0.6),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.6)
                    : AppColors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isDarkMode ? AppColors.outline : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
