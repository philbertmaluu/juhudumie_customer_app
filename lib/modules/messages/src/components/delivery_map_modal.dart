import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/message_data.dart';

/// Delivery map modal bottom sheet for order tracking
class DeliveryMapModal extends StatelessWidget {
  final OrderTracking tracking;
  final VoidCallback? onCallDeliveryMan;
  final VoidCallback? onMessageDeliveryMan;

  const DeliveryMapModal({
    super.key,
    required this.tracking,
    this.onCallDeliveryMan,
    this.onMessageDeliveryMan,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 550,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Map section (covers whole modal)
          _buildMapSection(isDarkMode),

          // Handle bar (floating on top)
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: _buildHandleBar(isDarkMode),
          ),

          // Action buttons (floating on top of map)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildActionButtons(isDarkMode),
          ),
        ],
      ),
    );
  }

  /// Build handle bar
  Widget _buildHandleBar(bool isDarkMode) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.3)
                  : AppColors.onSurface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Build map section
  Widget _buildMapSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Map placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 48, color: AppColors.primary),
                AppSpacing.gapVerticalSm,
                Text(
                  'Live Delivery Map',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Real-time location tracking',
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

          // Delivery man location indicator
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Live',
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
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Call button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onCallDeliveryMan,
              icon: const Icon(Icons.phone, size: 18),
              label: const Text('Call'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Message button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onMessageDeliveryMan,
              icon: const Icon(Icons.message, size: 18),
              label: const Text('Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
