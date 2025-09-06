import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/profile_data.dart' as models;
import 'profile_menu_item.dart';

/// Profile menu section component
class ProfileMenuSection extends StatelessWidget {
  final models.ProfileSection section;
  final Function(models.ProfileMenuItem)? onItemTap;

  const ProfileMenuSection({super.key, required this.section, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            section.title,
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.8)
                      : AppColors.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Menu items
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children:
                section.items.map((item) {
                  return ProfileMenuItemWidget(
                    item: item,
                    onTap: () => onItemTap?.call(item),
                  );
                }).toList(),
          ),
        ),

        // Divider
        if (section.showDivider) ...[
          AppSpacing.gapVerticalLg,
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.1)
                    : AppColors.onSurface.withOpacity(0.1),
          ),
          AppSpacing.gapVerticalLg,
        ],
      ],
    );
  }
}
