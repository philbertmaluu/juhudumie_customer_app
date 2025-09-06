import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/message_data.dart';

/// Order tracking card widget
class OrderTrackingCard extends StatelessWidget {
  final OrderTracking tracking;
  final bool isLatest;
  final VoidCallback? onCallDeliveryMan;
  final VoidCallback? onMessageDeliveryMan;

  const OrderTrackingCard({
    super.key,
    required this.tracking,
    this.isLatest = false,
    this.onCallDeliveryMan,
    this.onMessageDeliveryMan,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      padding: AppSpacing.cardPaddingMd,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border:
            isLatest ? Border.all(color: AppColors.primary, width: 2) : null,
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
              // Status icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStatusColor().withOpacity(0.1),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 20,
                ),
              ),

              AppSpacing.gapHorizontalMd,

              // Status info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tracking.status,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface
                                : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      tracking.description,
                      style: AppTextStyles.caption.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.7)
                                : AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Time
              Text(
                tracking.formattedTime,
                style: AppTextStyles.caption.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.6)
                          : AppColors.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          // Location info
          if (tracking.location != null) ...[
            AppSpacing.gapVerticalSm,
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                AppSpacing.gapHorizontalXs,
                Expanded(
                  child: Text(
                    tracking.location!,
                    style: AppTextStyles.caption.copyWith(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface.withOpacity(0.8)
                              : AppColors.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Delivery man info and actions
          if (tracking.deliveryManName != null && isLatest) ...[
            AppSpacing.gapVerticalMd,
            Container(
              padding: AppSpacing.cardPaddingSm,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                children: [
                  // Delivery man info
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                      AppSpacing.gapHorizontalSm,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tracking.deliveryManName!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color:
                                    isDarkMode
                                        ? AppColors.onDarkSurface
                                        : AppColors.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (tracking.deliveryManPhone != null)
                              Text(
                                tracking.deliveryManPhone!,
                                style: AppTextStyles.caption.copyWith(
                                  color:
                                      isDarkMode
                                          ? AppColors.onDarkSurface.withOpacity(
                                            0.7,
                                          )
                                          : AppColors.onSurface.withOpacity(
                                            0.7,
                                          ),
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
                      // Call button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onCallDeliveryMan,
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      AppSpacing.gapHorizontalSm,

                      // Message button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onMessageDeliveryMan,
                          icon: const Icon(Icons.message, size: 16),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Estimated delivery
          if (tracking.estimatedDelivery != null) ...[
            AppSpacing.gapVerticalSm,
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.orange),
                AppSpacing.gapHorizontalXs,
                Text(
                  'Estimated delivery: ${tracking.estimatedDelivery}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Get status color
  Color _getStatusColor() {
    switch (tracking.status.toLowerCase()) {
      case 'order confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.purple;
      case 'out for delivery':
        return Colors.indigo;
      case 'in transit':
        return AppColors.primary;
      case 'delivered':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  /// Get status icon
  IconData _getStatusIcon() {
    switch (tracking.status.toLowerCase()) {
      case 'order confirmed':
        return Icons.check_circle_outline;
      case 'processing':
        return Icons.build_outlined;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'out for delivery':
        return Icons.delivery_dining_outlined;
      case 'in transit':
        return Icons.directions_car_outlined;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.info_outline;
    }
  }
}
