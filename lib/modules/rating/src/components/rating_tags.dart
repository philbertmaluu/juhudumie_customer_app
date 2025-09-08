import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Interactive rating tags component
class RatingTags extends StatelessWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final Function(String) onTagToggled;
  final int maxSelectedTags;
  final bool allowMultipleSelection;

  const RatingTags({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagToggled,
    this.maxSelectedTags = 5,
    this.allowMultipleSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: tags.map((tag) => _buildTag(tag, isDarkMode)).toList(),
    );
  }

  Widget _buildTag(String tag, bool isDarkMode) {
    final isSelected = selectedTags.contains(tag);
    final canSelect =
        allowMultipleSelection || selectedTags.isEmpty || isSelected;

    return GestureDetector(
      onTap: canSelect ? () => onTagToggled(tag) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check_rounded, color: Colors.white, size: 16),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              tag,
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
}

/// Static rating tags display (read-only)
class StaticRatingTags extends StatelessWidget {
  final List<String> tags;
  final int maxDisplayTags;
  final double fontSize;

  const StaticRatingTags({
    super.key,
    required this.tags,
    this.maxDisplayTags = 3,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final displayTags = tags.take(maxDisplayTags).toList();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children:
          displayTags
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
