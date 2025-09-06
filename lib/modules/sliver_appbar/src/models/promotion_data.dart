/// Model representing a promotion banner
class PromotionBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? actionText;
  final String? actionUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final PromotionType type;

  const PromotionBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.actionText,
    this.actionUrl,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.type = PromotionType.banner,
  });

  /// Create a copy with updated values
  PromotionBanner copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? actionText,
    String? actionUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    PromotionType? type,
  }) {
    return PromotionBanner(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      actionText: actionText ?? this.actionText,
      actionUrl: actionUrl ?? this.actionUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
    );
  }

  /// Check if promotion is currently valid
  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  @override
  String toString() {
    return 'PromotionBanner(id: $id, title: $title, subtitle: $subtitle, type: $type, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PromotionBanner &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.imageUrl == imageUrl &&
        other.actionText == actionText &&
        other.actionUrl == actionUrl &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.isActive == isActive &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        imageUrl.hashCode ^
        actionText.hashCode ^
        actionUrl.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        isActive.hashCode ^
        type.hashCode;
  }
}

/// Types of promotions
enum PromotionType { banner, flashSale, newArrival, seasonal, clearance }

/// Sliver app bar configuration
class SliverAppBarConfig {
  final String appLogo;
  final String appName;
  final List<PromotionBanner> promotions;
  final bool showSearchBar;
  final bool showNotifications;
  final bool showCart;
  final double expandedHeight;
  final double collapsedHeight;

  const SliverAppBarConfig({
    required this.appLogo,
    required this.appName,
    required this.promotions,
    this.showSearchBar = true,
    this.showNotifications = true,
    this.showCart = true,
    this.expandedHeight = 350.0,
    this.collapsedHeight = 80.0,
  });

  /// Get active promotions only
  List<PromotionBanner> get activePromotions {
    return promotions.where((promo) => promo.isValid).toList();
  }

  /// Get featured promotion (first active promotion)
  PromotionBanner? get featuredPromotion {
    final active = activePromotions;
    return active.isNotEmpty ? active.first : null;
  }
}
