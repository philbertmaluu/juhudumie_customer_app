/// Rating data models for the rating system

/// Rating type enum
enum RatingType {
  driver,
  ride,
  shop,
  product,
  service,
}

/// Rating status enum
enum RatingStatus {
  pending,
  completed,
  cancelled,
}

/// Rating model
class Rating {
  final String id;
  final String userId;
  final String targetId; // ID of what's being rated (driver, shop, product, etc.)
  final RatingType type;
  final int stars;
  final String? comment;
  final List<String> tags; // e.g., ["clean", "friendly", "fast"]
  final DateTime createdAt;
  final DateTime? updatedAt;
  final RatingStatus status;
  final Map<String, dynamic> metadata; // Additional data like ride duration, order value, etc.

  const Rating({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.type,
    required this.stars,
    this.comment,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    required this.metadata,
  });

  /// Create a copy with updated values
  Rating copyWith({
    String? id,
    String? userId,
    String? targetId,
    RatingType? type,
    int? stars,
    String? comment,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    RatingStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return Rating(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get rating description
  String get ratingDescription {
    switch (stars) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Good';
      case 3:
        return 'Average';
      case 2:
        return 'Poor';
      case 1:
        return 'Very Poor';
      default:
        return 'Not Rated';
    }
  }
}

/// Rating summary model
class RatingSummary {
  final String targetId;
  final RatingType type;
  final double averageRating;
  final int totalRatings;
  final Map<int, int> ratingDistribution; // stars -> count
  final List<String> commonTags;
  final DateTime lastUpdated;

  const RatingSummary({
    required this.targetId,
    required this.type,
    required this.averageRating,
    required this.totalRatings,
    required this.ratingDistribution,
    required this.commonTags,
    required this.lastUpdated,
  });

  /// Get formatted average rating
  String get formattedAverageRating => averageRating.toStringAsFixed(1);

  /// Get rating percentage for a specific star count
  double getRatingPercentage(int stars) {
    if (totalRatings == 0) return 0.0;
    return (ratingDistribution[stars] ?? 0) / totalRatings * 100;
  }
}

/// Rating template model
class RatingTemplate {
  final RatingType type;
  final String title;
  final String subtitle;
  final List<String> suggestedTags;
  final List<String> placeholderComments;

  const RatingTemplate({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.suggestedTags,
    required this.placeholderComments,
  });
}

/// Rating feedback model
class RatingFeedback {
  final String ratingId;
  final String feedback;
  final List<String> selectedTags;
  final DateTime submittedAt;

  const RatingFeedback({
    required this.ratingId,
    required this.feedback,
    required this.selectedTags,
    required this.submittedAt,
  });
}
