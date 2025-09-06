import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/category_data.dart';

/// Category card component for displaying category information
class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final bool isCompact;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child:
            isCompact
                ? _buildCompactCard(isDarkMode)
                : _buildFullCard(isDarkMode),
      ),
    );
  }

  /// Build full category card
  Widget _buildFullCard(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusLg),
              topRight: Radius.circular(AppSpacing.radiusLg),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withOpacity(0.8),
                category.color.withOpacity(0.6),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLg),
                  topRight: Radius.circular(AppSpacing.radiusLg),
                ),
                child: Image.network(
                  category.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: category.color.withOpacity(0.3),
                      child: Icon(
                        category.icon,
                        size: AppSpacing.iconXl,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),

              // Overlay with icon
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: Container(
                  padding: AppSpacing.cardPaddingSm,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(
                    category.icon,
                    size: AppSpacing.iconMd,
                    color: Colors.white,
                  ),
                ),
              ),

              // Popular/New badge
              if (category.isPopular || category.isNew)
                Positioned(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: category.isPopular ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      category.isPopular ? 'Popular' : 'New',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Content section
        Padding(
          padding: AppSpacing.cardPaddingSm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category name
              Text(
                category.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              AppSpacing.gapVerticalXs,

              // Description
              Text(
                category.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              AppSpacing.gapVerticalXs,

              // Product count and subcategories
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: AppSpacing.iconSm,
                    color: category.color,
                  ),
                  AppSpacing.gapHorizontalXs,
                  Text(
                    '${category.productCount} products',
                    style: AppTextStyles.caption.copyWith(
                      color: category.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppSpacing.iconSm,
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.5)
                            : AppColors.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build compact category card
  Widget _buildCompactCard(bool isDarkMode) {
    return Padding(
      padding: AppSpacing.cardPaddingMd,
      child: Row(
        children: [
          // Icon container
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              category.icon,
              size: AppSpacing.iconMd,
              color: category.color,
            ),
          ),

          AppSpacing.gapHorizontalMd,

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapVerticalXs,
                Text(
                  '${category.productCount} products',
                  style: AppTextStyles.caption.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.6)
                            : AppColors.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Arrow
          Icon(
            Icons.arrow_forward_ios,
            size: AppSpacing.iconSm,
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.5)
                    : AppColors.onSurface.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
