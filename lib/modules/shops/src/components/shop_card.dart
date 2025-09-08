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
          bottom: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow:
              isDarkMode
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner section
            _buildBannerSection(isDarkMode),

            // Content section
            Padding(
              padding: AppSpacing.cardPaddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop header
                  _buildShopHeader(isDarkMode),

                  AppSpacing.gapVerticalSm,

                  // Tagline
                  if (shop.tagline.isNotEmpty)
                    Text(
                      shop.tagline,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.8)
                                : AppColors.onSurface.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  AppSpacing.gapVerticalMd,

                  // Stats row
                  _buildStatsRow(isDarkMode),

                  AppSpacing.gapVerticalMd,

                  // Action buttons with icons
                  _buildActionButtons(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection(bool isDarkMode) {
    return Stack(
      children: [
        // Banner image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.secondary.withOpacity(0.6),
                ],
              ),
            ),
            child:
                shop.bannerUrl.isNotEmpty
                    ? Image.network(
                      shop.bannerUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.store_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    )
                    : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.store_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
          ),
        ),

        // Overlay gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
            ),
          ),
        ),

        // Shop logo positioned on banner
        Positioned(
          bottom: -30,
          left: AppSpacing.md,
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: ClipRRect(
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
                        : Icon(
                          Icons.store_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
              ),
            ),
          ),
        ),

        // Premium badge
        if (shop.isPremium)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.diamond_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Premium',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShopHeader(bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop logo
        _buildShopLogoHeader(isDarkMode),

        const SizedBox(width: AppSpacing.md),

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
                      style: AppTextStyles.headingSmall.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface
                                : AppColors.onSurface,
                        fontWeight: FontWeight.bold,
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
                      size: 20,
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
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Text(
                      shop.categoryText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${shop.distanceFromUser.toStringAsFixed(1)} km',
                    style: AppTextStyles.bodySmall.copyWith(
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
    );
  }

  Widget _buildRating(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkSurfaceVariant
                : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildStatsRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCompactStat(
          icon: Icons.inventory_2_outlined,
          value: '${shop.totalProducts}',
          label: 'Products',
          isDarkMode: isDarkMode,
        ),
        _buildCompactStat(
          icon: Icons.shopping_bag_outlined,
          value: '${shop.totalOrders}',
          label: 'Orders',
          isDarkMode: isDarkMode,
        ),
        _buildCompactStat(
          icon: Icons.campaign_outlined,
          value: '${shop.advertisements.length}',
          label: 'Ads',
          isDarkMode: isDarkMode,
        ),
        _buildCompactStat(
          icon: Icons.play_circle_outline,
          value: '${shop.videos.length}',
          label: 'Videos',
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildCompactStat({
    required IconData icon,
    required String value,
    required String label,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.6)
                    : AppColors.onSurface.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Welcome to Shop',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopLogoHeader(bool isDarkMode) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child:
            shop.logoUrl.isNotEmpty
                ? Image.network(
                  shop.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                      ),
                      child: Icon(
                        Icons.store_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    );
                  },
                )
                : Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Icon(
                    Icons.store_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
      ),
    );
  }
}
