import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Interactive star rating component
class RatingStars extends StatelessWidget {
  final int selectedStars;
  final Function(int)? onStarSelected;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showHalfStars;
  final int maxStars;

  const RatingStars({
    super.key,
    required this.selectedStars,
    this.onStarSelected,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.showHalfStars = false,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final active = activeColor ?? AppColors.primary;
    final inactive =
        inactiveColor ??
        (isDarkMode
            ? AppColors.onDarkSurface.withOpacity(0.3)
            : AppColors.onSurface.withOpacity(0.3));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxStars, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= selectedStars;

        return GestureDetector(
          onTap:
              onStarSelected != null ? () => onStarSelected!(starIndex) : null,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size * 0.05),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                color: isSelected ? active : inactive,
                size: size,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Static star rating display (read-only)
class StaticRatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final int maxStars;
  final bool showHalfStars;

  const StaticRatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
    this.maxStars = 5,
    this.showHalfStars = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final active = activeColor ?? Colors.amber;
    final inactive =
        inactiveColor ??
        (isDarkMode
            ? AppColors.onDarkSurface.withOpacity(0.3)
            : AppColors.onSurface.withOpacity(0.3));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starIndex = index + 1;
        final isFullStar = starIndex <= rating.floor();
        final isHalfStar =
            showHalfStars && starIndex == rating.ceil() && rating % 1 != 0;

        IconData icon;
        Color color;

        if (isFullStar) {
          icon = Icons.star_rounded;
          color = active;
        } else if (isHalfStar) {
          icon = Icons.star_half_rounded;
          color = active;
        } else {
          icon = Icons.star_border_rounded;
          color = inactive;
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: size * 0.05),
          child: Icon(icon, color: color, size: size),
        );
      }),
    );
  }
}

/// Rating summary with stars and count
class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final double starSize;
  final bool showCount;

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    this.starSize = 16,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StaticRatingStars(rating: averageRating, size: starSize),
        if (showCount) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            '($totalRatings)',
            style: AppTextStyles.caption.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.6)
                      : AppColors.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
