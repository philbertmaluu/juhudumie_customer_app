import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../components/custom_sliver_appbar.dart';
import '../services/sliver_appbar_service.dart';

/// Demo screen showcasing the custom sliver app bar
class SliverAppBarDemo extends StatelessWidget {
  const SliverAppBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final config = SliverAppBarService.appBarConfig;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom sliver app bar
          CustomSliverAppBar(
            config: config,
            pinned: true,
            floating: false,
            snap: false,
          ),

          // Content section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    isDarkMode
                        ? AppColors.darkBackgroundGradient
                        : AppColors.backgroundGradient,
              ),
              child: Column(
                children: [
                  // Promotions grid
                  _buildPromotionsSection(context, isDarkMode),

                  // Sample content
                  _buildSampleContent(context, isDarkMode),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build promotions section
  Widget _buildPromotionsSection(BuildContext context, bool isDarkMode) {
    final promotions = SliverAppBarService.getActivePromotions();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Promotions',
            style: AppTextStyles.headingMedium.copyWith(
              color:
                  isDarkMode ? AppColors.onDarkSurface : AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Promotions grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promotion = promotions[index];
              return _buildPromotionCard(context, promotion, isDarkMode);
            },
          ),
        ],
      ),
    );
  }

  /// Build individual promotion card
  Widget _buildPromotionCard(
    BuildContext context,
    dynamic promotion,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onBackground.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppColors.darkShadow : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promotion type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                SliverAppBarService.getPromotionTypeDisplayName(promotion.type),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // Promotion title
            Text(
              promotion.title,
              style: AppTextStyles.bodyLarge.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Promotion subtitle
            Text(
              promotion.subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build sample content
  Widget _buildSampleContent(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Products',
            style: AppTextStyles.headingMedium.copyWith(
              color:
                  isDarkMode ? AppColors.onDarkSurface : AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Sample product cards
          ...List.generate(
            5,
            (index) => _buildSampleProductCard(context, index, isDarkMode),
          ),
        ],
      ),
    );
  }

  /// Build sample product card
  Widget _buildSampleProductCard(
    BuildContext context,
    int index,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onBackground.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.1)
                      : AppColors.onBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.6)
                      : AppColors.onBackground.withOpacity(0.6),
            ),
          ),

          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample Product ${index + 1}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'High-quality product description',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.7)
                            : AppColors.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(index + 1) * 25}.99',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
