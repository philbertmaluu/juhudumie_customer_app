import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/rating_data.dart';
import '../services/rating_service.dart';
import '../components/rating_stars.dart';
import '../components/rating_tags.dart';
import '../components/rating_comment.dart';

/// Main rating screen with Bolt app-inspired design
class RatingScreen extends StatefulWidget {
  final String targetId;
  final RatingType type;
  final String targetName;
  final String? targetImage;
  final Map<String, dynamic>? metadata;

  const RatingScreen({
    super.key,
    required this.targetId,
    required this.type,
    required this.targetName,
    this.targetImage,
    this.metadata,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final RatingService _ratingService = RatingService.instance;
  final TextEditingController _commentController = TextEditingController();

  int _selectedStars = 0;
  List<String> _selectedTags = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ratingService.loadSampleData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onStarSelected(int stars) {
    setState(() {
      _selectedStars = stars;
    });
  }

  void _onTagToggled(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  Future<void> _submitRating() async {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final rating = Rating(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user', // In real app, get from auth service
      targetId: widget.targetId,
      type: widget.type,
      stars: _selectedStars,
      comment:
          _commentController.text.trim().isNotEmpty
              ? _commentController.text.trim()
              : null,
      tags: _selectedTags,
      createdAt: DateTime.now(),
      status: RatingStatus.completed,
      metadata: widget.metadata ?? {},
    );

    final success = await _ratingService.submitRating(rating);

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for your ${widget.type.name} rating!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit rating. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final template = _ratingService.getRatingTemplate(widget.type);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with shop banner
          _buildSliverAppBar(isDarkMode, template),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPaddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating stars section
                  _buildRatingSection(isDarkMode, template),

                  AppSpacing.gapVerticalLg,

                  // Tags section
                  if (_selectedStars > 0) ...[
                    _buildTagsSection(isDarkMode, template),
                    AppSpacing.gapVerticalLg,
                  ],

                  // Comment section
                  if (_selectedStars > 0) ...[
                    _buildCommentSection(isDarkMode, template),
                    AppSpacing.gapVerticalLg,
                  ],

                  // Submit button
                  if (_selectedStars > 0) ...[
                    _buildSubmitButton(isDarkMode),
                    AppSpacing.gapVerticalLg,
                  ],

                  // Recent reviews section
                  _buildRecentReviews(isDarkMode),

                  // Bottom padding
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isDarkMode, RatingTemplate template) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Full-width banner background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primary.withOpacity(0.6),
                    AppColors.primary.withOpacity(0.4),
                  ],
                ),
              ),
              child:
                  widget.targetImage != null
                      ? Image.network(
                        widget.targetImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Shop logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        child:
                            widget.targetImage != null
                                ? Image.network(
                                  widget.targetImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      _getTypeIcon(widget.type),
                                      color: AppColors.primary,
                                      size: 30,
                                    );
                                  },
                                )
                                : Icon(
                                  _getTypeIcon(widget.type),
                                  color: AppColors.primary,
                                  size: 30,
                                ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Shop name
                    Text(
                      widget.targetName,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    // Rating title
                    Text(
                      template.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(bool isDarkMode, RatingTemplate template) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Rating question
          Text(
            'How was your experience?',
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Your feedback helps us improve',
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.7)
                      : AppColors.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Star rating with responsive sizing
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate appropriate star size based on available width
              final availableWidth = constraints.maxWidth;
              final starSize = (availableWidth / 6).clamp(40.0, 45.0);

              return Center(
                child: RatingStars(
                  selectedStars: _selectedStars,
                  onStarSelected: _onStarSelected,
                  size: starSize,
                ),
              );
            },
          ),

          if (_selectedStars > 0) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                _getRatingDescription(_selectedStars),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTagsSection(bool isDarkMode, RatingTemplate template) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What stood out to you?',
            style: AppTextStyles.headingSmall.copyWith(
              color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Select all that apply',
            style: AppTextStyles.bodyMedium.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.7)
                      : AppColors.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          RatingTags(
            tags: template.suggestedTags,
            selectedTags: _selectedTags,
            onTagToggled: _onTagToggled,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(bool isDarkMode, RatingTemplate template) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: RatingComment(
        controller: _commentController,
        placeholder: template.placeholderComments.first,
        isDarkMode: isDarkMode,
      ),
    );
  }

  Widget _buildSubmitButton(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSubmitting ? null : _submitRating,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSubmitting) ...[
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ] else ...[
                  const Icon(Icons.star_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  _isSubmitting ? 'Submitting...' : 'Submit Rating',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReviews(bool isDarkMode) {
    final recentRatings = _ratingService.getRatingsForTarget(
      widget.targetId,
      widget.type,
    );

    if (recentRatings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.reviews_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Recent Reviews',
                style: AppTextStyles.headingSmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          ...recentRatings
              .take(3)
              .map((rating) => _buildReviewItem(rating, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Rating rating, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPaddingMd,
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkSurfaceVariant
                : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RatingStars(
                selectedStars: rating.stars,
                onStarSelected: null,
                size: 16,
              ),
              const Spacer(),
              Text(
                rating.formattedDate,
                style: AppTextStyles.caption.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.6)
                          : AppColors.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          if (rating.comment != null) ...[
            AppSpacing.gapVerticalSm,
            Text(
              rating.comment!,
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
          ],

          if (rating.tags.isNotEmpty) ...[
            AppSpacing.gapVerticalSm,
            Wrap(
              spacing: AppSpacing.xs,
              children:
                  rating.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTypeIcon(RatingType type) {
    switch (type) {
      case RatingType.driver:
        return Icons.person_rounded;
      case RatingType.ride:
        return Icons.directions_car_rounded;
      case RatingType.shop:
        return Icons.store_rounded;
      case RatingType.product:
        return Icons.shopping_bag_rounded;
      case RatingType.service:
        return Icons.support_agent_rounded;
    }
  }

  String _getRatingDescription(int stars) {
    switch (stars) {
      case 5:
        return 'Excellent!';
      case 4:
        return 'Good';
      case 3:
        return 'Average';
      case 2:
        return 'Poor';
      case 1:
        return 'Very Poor';
      default:
        return '';
    }
  }
}
