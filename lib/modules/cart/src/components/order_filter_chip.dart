import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/order_data.dart';

/// Filter chip for order filtering
class OrderFilterChip extends StatelessWidget {
  final OrderFilter filter;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const OrderFilterChip({
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
              _getFilterText(),
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
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
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

  /// Get filter icon
  IconData? _getFilterIcon() {
    switch (filter) {
      case OrderFilter.all:
        return Icons.list_rounded;
      case OrderFilter.pending:
        return Icons.schedule_rounded;
      case OrderFilter.confirmed:
        return Icons.check_circle_outline_rounded;
      case OrderFilter.processing:
        return Icons.settings_rounded;
      case OrderFilter.shipped:
        return Icons.local_shipping_rounded;
      case OrderFilter.delivered:
        return Icons.check_circle_rounded;
      case OrderFilter.cancelled:
        return Icons.cancel_rounded;
      case OrderFilter.refunded:
        return Icons.undo_rounded;
    }
  }

  /// Get filter display text
  String _getFilterText() {
    switch (filter) {
      case OrderFilter.all:
        return 'All';
      case OrderFilter.pending:
        return 'Pending';
      case OrderFilter.confirmed:
        return 'Confirmed';
      case OrderFilter.processing:
        return 'Processing';
      case OrderFilter.shipped:
        return 'Shipped';
      case OrderFilter.delivered:
        return 'Delivered';
      case OrderFilter.cancelled:
        return 'Cancelled';
      case OrderFilter.refunded:
        return 'Refunded';
    }
  }
}
