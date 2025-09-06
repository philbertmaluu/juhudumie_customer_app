import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Quantity selector component for product details
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final Function(int) onQuantityChanged;
  final bool isEnabled;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppSpacing.buttonHeightMd,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          _buildButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
            isEnabled: isEnabled && quantity > 1,
            isDarkMode: isDarkMode,
          ),

          // Quantity display
          Container(
            width: 40,
            padding: AppSpacing.inputPaddingSm,
            child: Center(
              child: Text(
                quantity.toString(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Increase button
          _buildButton(
            icon: Icons.add,
            onTap:
                quantity < maxQuantity
                    ? () => onQuantityChanged(quantity + 1)
                    : null,
            isEnabled: isEnabled && quantity < maxQuantity,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  /// Build individual button
  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isEnabled,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          icon,
          size: AppSpacing.iconSm,
          color:
              isEnabled
                  ? AppColors.primary
                  : isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
