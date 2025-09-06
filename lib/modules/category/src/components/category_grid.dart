import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/category_data.dart';
import 'category_card.dart';

/// Category grid component for displaying categories in a grid layout
class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final Function(Category)? onCategoryTap;
  final bool isCompact;
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.isCompact = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          category: category,
          isCompact: isCompact,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }

  /// Build empty state when no categories are available
  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.screenPaddingLg,
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
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
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
        ],
      ),
    );
  }
}

/// Category list component for displaying categories in a list layout
class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(Category)? onCategoryTap;
  final bool showDividers;

  const CategoryList({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.showDividers = true,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder:
          showDividers
              ? (context, index) => const Divider(height: 1)
              : (context, index) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          category: category,
          isCompact: true,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }

  /// Build empty state when no categories are available
  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.screenPaddingLg,
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
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
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
        ],
      ),
    );
  }
}
