import '../models/rating_data.dart';

/// Service for managing ratings and reviews
class RatingService {
  static final RatingService _instance = RatingService._internal();
  static RatingService get instance => _instance;
  RatingService._internal();

  final List<Rating> _ratings = [];
  final List<RatingSummary> _summaries = [];

  /// Initialize with sample data
  void loadSampleData() {
    _ratings.addAll(_generateSampleRatings());
    _summaries.addAll(_generateSampleSummaries());
  }

  /// Submit a new rating
  Future<bool> submitRating(Rating rating) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _ratings.add(rating);
      _updateRatingSummary(rating);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get ratings for a specific target
  List<Rating> getRatingsForTarget(String targetId, RatingType type) {
    return _ratings
        .where((rating) => rating.targetId == targetId && rating.type == type)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get rating summary for a target
  RatingSummary? getRatingSummary(String targetId, RatingType type) {
    try {
      return _summaries.firstWhere(
        (summary) => summary.targetId == targetId && summary.type == type,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get user's ratings
  List<Rating> getUserRatings(String userId) {
    return _ratings.where((rating) => rating.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get rating template for a type
  RatingTemplate getRatingTemplate(RatingType type) {
    switch (type) {
      case RatingType.driver:
        return const RatingTemplate(
          type: RatingType.driver,
          title: 'Rate your driver',
          subtitle: 'How was your ride experience?',
          suggestedTags: ['friendly', 'safe', 'clean', 'punctual', 'helpful'],
          placeholderComments: [
            'Great driver, very professional!',
            'Safe and comfortable ride.',
            'Driver was friendly and helpful.',
          ],
        );
      case RatingType.ride:
        return const RatingTemplate(
          type: RatingType.ride,
          title: 'Rate your ride',
          subtitle: 'How was your overall experience?',
          suggestedTags: [
            'comfortable',
            'fast',
            'smooth',
            'affordable',
            'convenient',
          ],
          placeholderComments: [
            'Smooth and comfortable ride!',
            'Great value for money.',
            'Very convenient service.',
          ],
        );
      case RatingType.shop:
        return const RatingTemplate(
          type: RatingType.shop,
          title: 'Rate this shop',
          subtitle: 'How was your shopping experience?',
          suggestedTags: ['clean', 'friendly', 'variety', 'prices', 'service'],
          placeholderComments: [
            'Great selection of products!',
            'Friendly staff and clean store.',
            'Good prices and quality.',
          ],
        );
      case RatingType.product:
        return const RatingTemplate(
          type: RatingType.product,
          title: 'Rate this product',
          subtitle: 'How satisfied are you with this product?',
          suggestedTags: ['quality', 'value', 'durable', 'useful', 'design'],
          placeholderComments: [
            'Great quality product!',
            'Good value for money.',
            'Exactly what I needed.',
          ],
        );
      case RatingType.service:
        return const RatingTemplate(
          type: RatingType.service,
          title: 'Rate this service',
          subtitle: 'How was your service experience?',
          suggestedTags: [
            'professional',
            'fast',
            'helpful',
            'reliable',
            'friendly',
          ],
          placeholderComments: [
            'Excellent service!',
            'Quick and professional.',
            'Very helpful staff.',
          ],
        );
    }
  }

  /// Update rating summary
  void _updateRatingSummary(Rating rating) {
    final existingIndex = _summaries.indexWhere(
      (summary) =>
          summary.targetId == rating.targetId && summary.type == rating.type,
    );

    if (existingIndex != -1) {
      // Update existing summary
      final targetRatings = getRatingsForTarget(rating.targetId, rating.type);

      final newAverage =
          targetRatings.map((r) => r.stars).reduce((a, b) => a + b) /
          targetRatings.length;
      final newDistribution = <int, int>{};

      for (int i = 1; i <= 5; i++) {
        newDistribution[i] = targetRatings.where((r) => r.stars == i).length;
      }

      final commonTags = <String, int>{};
      for (final rating in targetRatings) {
        for (final tag in rating.tags) {
          commonTags[tag] = (commonTags[tag] ?? 0) + 1;
        }
      }

      final sortedTags =
          commonTags.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      _summaries[existingIndex] = RatingSummary(
        targetId: rating.targetId,
        type: rating.type,
        averageRating: newAverage,
        totalRatings: targetRatings.length,
        ratingDistribution: newDistribution,
        commonTags: sortedTags.take(5).map((e) => e.key).toList(),
        lastUpdated: DateTime.now(),
      );
    } else {
      // Create new summary
      _summaries.add(
        RatingSummary(
          targetId: rating.targetId,
          type: rating.type,
          averageRating: rating.stars.toDouble(),
          totalRatings: 1,
          ratingDistribution: {rating.stars: 1},
          commonTags: rating.tags,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  /// Generate sample ratings
  List<Rating> _generateSampleRatings() {
    final now = DateTime.now();
    return [
      Rating(
        id: '1',
        userId: 'user1',
        targetId: 'shop1',
        type: RatingType.shop,
        stars: 5,
        comment: 'Great shop with excellent products and friendly staff!',
        tags: ['friendly', 'clean', 'variety'],
        createdAt: now.subtract(const Duration(days: 2)),
        status: RatingStatus.completed,
        metadata: {'orderValue': 150.0},
      ),
      Rating(
        id: '2',
        userId: 'user2',
        targetId: 'shop1',
        type: RatingType.shop,
        stars: 4,
        comment: 'Good selection and fair prices.',
        tags: ['prices', 'variety'],
        createdAt: now.subtract(const Duration(days: 5)),
        status: RatingStatus.completed,
        metadata: {'orderValue': 75.0},
      ),
      Rating(
        id: '3',
        userId: 'user3',
        targetId: 'driver1',
        type: RatingType.driver,
        stars: 5,
        comment: 'Excellent driver, very professional and safe!',
        tags: ['safe', 'professional', 'friendly'],
        createdAt: now.subtract(const Duration(hours: 3)),
        status: RatingStatus.completed,
        metadata: {'rideDuration': 25, 'distance': 8.5},
      ),
    ];
  }

  /// Generate sample summaries
  List<RatingSummary> _generateSampleSummaries() {
    return [
      RatingSummary(
        targetId: 'shop1',
        type: RatingType.shop,
        averageRating: 4.5,
        totalRatings: 2,
        ratingDistribution: const {5: 1, 4: 1, 3: 0, 2: 0, 1: 0},
        commonTags: const ['friendly', 'clean', 'variety', 'prices'],
        lastUpdated: DateTime.now(),
      ),
      RatingSummary(
        targetId: 'driver1',
        type: RatingType.driver,
        averageRating: 5.0,
        totalRatings: 1,
        ratingDistribution: const {5: 1, 4: 0, 3: 0, 2: 0, 1: 0},
        commonTags: const ['safe', 'professional', 'friendly'],
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}
