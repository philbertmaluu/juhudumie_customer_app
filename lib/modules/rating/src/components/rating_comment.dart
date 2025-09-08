import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Rating comment input component
class RatingComment extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isDarkMode;
  final int maxLength;
  final bool showCharacterCount;

  const RatingComment({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.isDarkMode,
    this.maxLength = 500,
    this.showCharacterCount = true,
  });

  @override
  State<RatingComment> createState() => _RatingCommentState();
}

class _RatingCommentState extends State<RatingComment> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a comment (optional)',
          style: AppTextStyles.bodyMedium.copyWith(
            color:
                widget.isDarkMode
                    ? AppColors.onDarkSurface
                    : AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Container(
          decoration: BoxDecoration(
            color:
                widget.isDarkMode
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color:
                  _isFocused
                      ? AppColors.primary
                      : widget.isDarkMode
                      ? AppColors.outline
                      : AppColors.outlineVariant,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: 4,
            maxLength: widget.maxLength,
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  widget.isDarkMode
                      ? AppColors.onDarkSurface
                      : AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color:
                    widget.isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.5)
                        : AppColors.onSurface.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
              counterText: widget.showCharacterCount ? null : '',
            ),
          ),
        ),

        if (widget.showCharacterCount) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${widget.controller.text.length}/${widget.maxLength}',
                style: AppTextStyles.caption.copyWith(
                  color:
                      widget.isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.6)
                          : AppColors.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Quick comment suggestions component
class CommentSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionSelected;
  final bool isDarkMode;

  const CommentSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick suggestions',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.7)
                    : AppColors.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children:
              suggestions
                  .map(
                    (suggestion) => GestureDetector(
                      onTap: () => onSuggestionSelected(suggestion),
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
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                          border: Border.all(
                            color:
                                isDarkMode
                                    ? AppColors.outline
                                    : AppColors.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface
                                    : AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
