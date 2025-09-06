import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/profile_data.dart' as models;

/// Profile menu item component
class ProfileMenuItemWidget extends StatelessWidget {
  final models.ProfileMenuItem item;
  final VoidCallback? onTap;

  const ProfileMenuItemWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? item.onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: AppSpacing.cardPaddingMd,
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),

                AppSpacing.gapHorizontalMd,

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface
                                  : AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        AppSpacing.gapVerticalXs,
                        Text(
                          item.subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface.withOpacity(0.7)
                                    : AppColors.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Badge and arrow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge
                    if (item.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.badge!,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),

                    if (item.badge != null) AppSpacing.gapHorizontalSm,

                    // Arrow
                    if (item.hasArrow)
                      Icon(
                        Icons.chevron_right_rounded,
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.5)
                                : AppColors.onSurface.withOpacity(0.5),
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
