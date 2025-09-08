import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Advanced search bar for shops
class ShopSearchBar extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final bool showFilterButton;
  final bool showSortButton;

  const ShopSearchBar({
    super.key,
    this.initialQuery,
    required this.onQueryChanged,
    this.onFilterTap,
    this.onSortTap,
    this.showFilterButton = true,
    this.showSortButton = true,
  });

  @override
  State<ShopSearchBar> createState() => _ShopSearchBarState();
}

class _ShopSearchBarState extends State<ShopSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.outline : AppColors.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search input
          Container(
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color:
                    _focusNode.hasFocus
                        ? AppColors.primary
                        : isDarkMode
                        ? AppColors.outline
                        : AppColors.outlineVariant,
                width: _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Search shops, categories, or locations...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.6)
                          : AppColors.onSurface.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.6)
                          : AppColors.onSurface.withOpacity(0.6),
                ),
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface.withOpacity(0.6)
                                    : AppColors.onSurface.withOpacity(0.6),
                          ),
                          onPressed: () {
                            _controller.clear();
                            widget.onQueryChanged('');
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Action buttons
          Row(
            children: [
              if (widget.showFilterButton) ...[
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.tune_rounded,
                    label: 'Filters',
                    onTap: widget.onFilterTap,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              if (widget.showSortButton) ...[
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.sort_rounded,
                    label: 'Sort',
                    onTap: widget.onSortTap,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isDarkMode ? AppColors.outline : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
