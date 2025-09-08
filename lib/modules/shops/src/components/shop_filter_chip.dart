import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/shop_data.dart';

/// Filter chip for shop categories and filters
class ShopFilterChip extends StatelessWidget {
  final ShopFilter filter;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const ShopFilterChip({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : isDarkMode
                    ? AppColors.outline
                    : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFilterIcon(filter),
              size: 16,
              color:
                  isSelected
                      ? AppColors.onPrimary
                      : isDarkMode
                      ? AppColors.onDarkSurface
                      : AppColors.onSurface,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _getFilterLabel(filter),
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isSelected
                        ? AppColors.onPrimary
                        : isDarkMode
                        ? AppColors.onDarkSurface
                        : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.onPrimary.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getFilterIcon(ShopFilter filter) {
    switch (filter) {
      case ShopFilter.all:
        return Icons.store_rounded;
      case ShopFilter.fashion:
        return Icons.checkroom_rounded;
      case ShopFilter.electronics:
        return Icons.devices_rounded;
      case ShopFilter.food:
        return Icons.restaurant_rounded;
      case ShopFilter.beauty:
        return Icons.face_rounded;
      case ShopFilter.home:
        return Icons.home_rounded;
      case ShopFilter.sports:
        return Icons.sports_rounded;
      case ShopFilter.books:
        return Icons.menu_book_rounded;
      case ShopFilter.automotive:
        return Icons.directions_car_rounded;
      case ShopFilter.health:
        return Icons.health_and_safety_rounded;
      case ShopFilter.other:
        return Icons.category_rounded;
      case ShopFilter.verified:
        return Icons.verified_rounded;
      case ShopFilter.premium:
        return Icons.diamond_rounded;
      case ShopFilter.nearby:
        return Icons.location_on_rounded;
    }
  }

  String _getFilterLabel(ShopFilter filter) {
    switch (filter) {
      case ShopFilter.all:
        return 'All Shops';
      case ShopFilter.fashion:
        return 'Fashion';
      case ShopFilter.electronics:
        return 'Electronics';
      case ShopFilter.food:
        return 'Food';
      case ShopFilter.beauty:
        return 'Beauty';
      case ShopFilter.home:
        return 'Home';
      case ShopFilter.sports:
        return 'Sports';
      case ShopFilter.books:
        return 'Books';
      case ShopFilter.automotive:
        return 'Automotive';
      case ShopFilter.health:
        return 'Health';
      case ShopFilter.other:
        return 'Other';
      case ShopFilter.verified:
        return 'Verified';
      case ShopFilter.premium:
        return 'Premium';
      case ShopFilter.nearby:
        return 'Nearby';
    }
  }
}
