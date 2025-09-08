import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/order_data.dart';

/// Order card component for displaying order information
class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onTrack;
  final VoidCallback? onReorder;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
    this.onTrack,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: AppSpacing.cardPaddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with order number and status
              _buildHeader(isDarkMode),

              AppSpacing.gapVerticalMd,

              // Order items preview
              _buildItemsPreview(),

              AppSpacing.gapVerticalMd,

              // Order details
              _buildOrderDetails(isDarkMode),

              AppSpacing.gapVerticalMd,

              // Action buttons
              _buildActionButtons(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.orderNumber,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapVerticalSm,
              Text(
                _formatDate(order.orderDate),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: _getStatusColor().withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            order.statusText,
            style: AppTextStyles.labelSmall.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Build items preview
  Widget _buildItemsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items (${order.totalItems})',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapVerticalSm,
        ...order.items.take(2).map((item) => _buildItemPreview(item)),
        if (order.items.length > 2)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              '+${order.items.length - 2} more items',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  /// Build individual item preview
  Widget _buildItemPreview(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.outline),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Image.network(
                item.productImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  );
                },
              ),
            ),
          ),
          AppSpacing.gapHorizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variant != null)
                  Text(
                    item.variant!,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            '×${item.quantity}',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build order details
  Widget _buildOrderDetails(bool isDarkMode) {
    return Container(
      padding: AppSpacing.cardPaddingSm,
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkSurface.withOpacity(0.5)
                : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: AppTextStyles.labelSmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                'TSh ${order.total.toStringAsFixed(0)}',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (order.estimatedDelivery != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Est. Delivery',
                  style: AppTextStyles.labelSmall.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.7)
                            : AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  _formatDate(order.estimatedDelivery!),
                  style: AppTextStyles.bodySmall.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        if (order.canCancel)
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Cancel'),
            ),
          ),
        if (order.canCancel && order.status == OrderStatus.shipped)
          const SizedBox(width: AppSpacing.sm),
        if (order.status == OrderStatus.shipped)
          Expanded(
            child: ElevatedButton(
              onPressed: onTrack,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Track'),
            ),
          ),
        if (order.status == OrderStatus.shipped)
          const SizedBox(width: AppSpacing.sm),
        if (order.status == OrderStatus.delivered)
          Expanded(
            child: ElevatedButton(
              onPressed: onReorder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Reorder'),
            ),
          ),
      ],
    );
  }

  /// Get status color
  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.confirmed:
        return AppColors.info;
      case OrderStatus.processing:
        return AppColors.primary;
      case OrderStatus.shipped:
        return AppColors.success;
      case OrderStatus.delivered:
        return AppColors.onSurfaceVariant;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.refunded:
        return const Color(0xFF6F42C1);
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
