import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/wishlist_data.dart';

/// Wishlist filter chip component
class WishlistFilterChip extends StatelessWidget {
  final WishlistFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const WishlistFilterChip({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : isDarkMode
                  ? AppColors.darkSurface
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.2)
                    : AppColors.onSurface.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_getFilterIcon() != null) ...[
              Icon(
                _getFilterIcon(),
                size: 16,
                color:
                    isSelected
                        ? Colors.white
                        : isDarkMode
                        ? AppColors.onDarkSurface
                        : AppColors.onSurface,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              _getFilterTitle(),
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isSelected
                        ? Colors.white
                        : isDarkMode
                        ? AppColors.onDarkSurface
                        : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get filter icon
  IconData? _getFilterIcon() {
    switch (filter) {
      case WishlistFilter.all:
        return Icons.list_rounded;
      case WishlistFilter.available:
        return Icons.check_circle_outline_rounded;
      case WishlistFilter.onSale:
        return Icons.local_offer_rounded;
      case WishlistFilter.recentlyAdded:
        return Icons.schedule_rounded;
      case WishlistFilter.byCategory:
        return Icons.category_rounded;
    }
  }

  /// Get filter title
  String _getFilterTitle() {
    switch (filter) {
      case WishlistFilter.all:
        return 'All';
      case WishlistFilter.available:
        return 'Available';
      case WishlistFilter.onSale:
        return 'On Sale';
      case WishlistFilter.recentlyAdded:
        return 'Recent';
      case WishlistFilter.byCategory:
        return 'Category';
    }
  }
}
