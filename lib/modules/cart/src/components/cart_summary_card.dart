import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/cart_data.dart';

/// Cart summary card component
class CartSummaryCard extends StatelessWidget {
  final CartSummary summary;
  final VoidCallback? onCheckout;

  const CartSummaryCard({super.key, required this.summary, this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardPaddingMd,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.gapHorizontalXs,
              Text(
                'Order Summary',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalMd,

          // Summary items
          _buildSummaryItem(
            'Subtotal (${summary.totalItems} items)',
            'TSh ${summary.subtotal.toStringAsFixed(0)}',
            isDarkMode,
          ),

          if (summary.totalSavings > 0) ...[
            AppSpacing.gapVerticalXs,
            _buildSummaryItem(
              'Savings',
              '-TSh ${summary.totalSavings.toStringAsFixed(0)}',
              isDarkMode,
              isSavings: true,
            ),
          ],

          AppSpacing.gapVerticalXs,
          _buildSummaryItem(
            'Shipping',
            summary.shippingFee == 0
                ? 'FREE'
                : 'TSh ${summary.shippingFee.toStringAsFixed(0)}',
            isDarkMode,
            isShipping: true,
          ),

          AppSpacing.gapVerticalXs,
          _buildSummaryItem(
            'Tax (18% VAT)',
            'TSh ${summary.tax.toStringAsFixed(0)}',
            isDarkMode,
          ),

          AppSpacing.gapVerticalMd,

          // Divider
          Container(
            height: 1,
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.1)
                    : AppColors.onSurface.withOpacity(0.1),
          ),

          AppSpacing.gapVerticalMd,

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.bodyLarge.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'TSh ${summary.total.toStringAsFixed(0)}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalMd,

          // Free shipping notice
          if (summary.shippingFee == 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.green,
                    size: 16,
                  ),
                  AppSpacing.gapHorizontalXs,
                  Expanded(
                    child: Text(
                      'You qualify for FREE shipping!',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Checkout button
          AppSpacing.gapVerticalMd,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Proceed to Checkout',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build summary item row
  Widget _buildSummaryItem(
    String label,
    String value,
    bool isDarkMode, {
    bool isSavings = false,
    bool isShipping = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.8)
                    : AppColors.onSurface.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isSavings
                    ? Colors.green
                    : isShipping && value == 'FREE'
                    ? Colors.green
                    : isDarkMode
                    ? AppColors.onDarkSurface
                    : AppColors.onSurface,
            fontWeight:
                isSavings || (isShipping && value == 'FREE')
                    ? FontWeight.w600
                    : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
