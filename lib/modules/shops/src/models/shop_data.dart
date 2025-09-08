/// Shop data models for managing vendor shops

/// Shop category enum
enum ShopCategory {
  fashion,
  electronics,
  food,
  beauty,
  home,
  sports,
  books,
  automotive,
  health,
  other,
}

/// Shop status enum
enum ShopStatus { active, inactive, pending, suspended }

/// Shop rating model
class ShopRating {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count

  const ShopRating({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  /// Create a copy with updated values
  ShopRating copyWith({
    double? averageRating,
    int? totalReviews,
    Map<int, int>? ratingDistribution,
  }) {
    return ShopRating(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingDistribution: ratingDistribution ?? this.ratingDistribution,
    );
  }
}

/// Shop product model
class ShopProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String currency;
  final int stock;
  final bool isAvailable;

  const ShopProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.stock,
    required this.isAvailable,
  });

  /// Create a copy with updated values
  ShopProduct copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? currency,
    int? stock,
    bool? isAvailable,
  }) {
    return ShopProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

/// Shop advertisement model
class ShopAdvertisement {
  final String id;
  final String title;
  final String imageUrl;
  final String? videoUrl;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const ShopAdvertisement({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.videoUrl,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  /// Create a copy with updated values
  ShopAdvertisement copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? videoUrl,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return ShopAdvertisement(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Shop video model
class ShopVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;
  final Duration duration;
  final DateTime uploadDate;
  final int views;
  final bool isFeatured;

  const ShopVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
    required this.duration,
    required this.uploadDate,
    required this.views,
    required this.isFeatured,
  });

  /// Create a copy with updated values
  ShopVideo copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    String? videoUrl,
    String? description,
    Duration? duration,
    DateTime? uploadDate,
    int? views,
    bool? isFeatured,
  }) {
    return ShopVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      uploadDate: uploadDate ?? this.uploadDate,
      views: views ?? this.views,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}

/// Main shop model
class Shop {
  final String id;
  final String name;
  final String description;
  final String tagline;
  final String logoUrl;
  final String bannerUrl;
  final ShopCategory category;
  final ShopStatus status;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime joinedDate;
  final DateTime lastActive;
  final ShopRating rating;
  final List<ShopProduct> featuredProducts;
  final List<ShopAdvertisement> advertisements;
  final List<ShopVideo> videos;
  final int totalProducts;
  final int totalOrders;
  final bool isVerified;
  final bool isPremium;
  final Map<String, dynamic> metadata;

  const Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.tagline,
    required this.logoUrl,
    required this.bannerUrl,
    required this.category,
    required this.status,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.joinedDate,
    required this.lastActive,
    required this.rating,
    required this.featuredProducts,
    required this.advertisements,
    required this.videos,
    required this.totalProducts,
    required this.totalOrders,
    required this.isVerified,
    required this.isPremium,
    required this.metadata,
  });

  /// Get category display text
  String get categoryText {
    switch (category) {
      case ShopCategory.fashion:
        return 'Fashion';
      case ShopCategory.electronics:
        return 'Electronics';
      case ShopCategory.food:
        return 'Food & Beverages';
      case ShopCategory.beauty:
        return 'Beauty & Health';
      case ShopCategory.home:
        return 'Home & Garden';
      case ShopCategory.sports:
        return 'Sports & Fitness';
      case ShopCategory.books:
        return 'Books & Media';
      case ShopCategory.automotive:
        return 'Automotive';
      case ShopCategory.health:
        return 'Health & Wellness';
      case ShopCategory.other:
        return 'Other';
    }
  }

  /// Get status display text
  String get statusText {
    switch (status) {
      case ShopStatus.active:
        return 'Active';
      case ShopStatus.inactive:
        return 'Inactive';
      case ShopStatus.pending:
        return 'Pending';
      case ShopStatus.suspended:
        return 'Suspended';
    }
  }

  /// Check if shop is open (simplified logic)
  bool get isOpen {
    final now = DateTime.now();
    final hour = now.hour;
    // Assume shops are open from 8 AM to 10 PM
    return hour >= 8 && hour < 22;
  }

  /// Get distance from user (placeholder)
  double get distanceFromUser => 2.5; // km

  /// Create a copy with updated values
  Shop copyWith({
    String? id,
    String? name,
    String? description,
    String? tagline,
    String? logoUrl,
    String? bannerUrl,
    ShopCategory? category,
    ShopStatus? status,
    String? ownerName,
    String? ownerEmail,
    String? ownerPhone,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    DateTime? joinedDate,
    DateTime? lastActive,
    ShopRating? rating,
    List<ShopProduct>? featuredProducts,
    List<ShopAdvertisement>? advertisements,
    List<ShopVideo>? videos,
    int? totalProducts,
    int? totalOrders,
    bool? isVerified,
    bool? isPremium,
    Map<String, dynamic>? metadata,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tagline: tagline ?? this.tagline,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      category: category ?? this.category,
      status: status ?? this.status,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      joinedDate: joinedDate ?? this.joinedDate,
      lastActive: lastActive ?? this.lastActive,
      rating: rating ?? this.rating,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      advertisements: advertisements ?? this.advertisements,
      videos: videos ?? this.videos,
      totalProducts: totalProducts ?? this.totalProducts,
      totalOrders: totalOrders ?? this.totalOrders,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Shop filter enum
enum ShopFilter {
  all,
  fashion,
  electronics,
  food,
  beauty,
  home,
  sports,
  books,
  automotive,
  health,
  other,
  verified,
  premium,
  nearby,
}

/// Shop sort enum
enum ShopSort {
  name,
  rating,
  distance,
  newest,
  oldest,
  mostProducts,
  mostOrders,
}

/// Shop search filters
class ShopSearchFilters {
  final String query;
  final ShopFilter category;
  final ShopSort sortBy;
  final bool verifiedOnly;
  final bool premiumOnly;
  final bool nearbyOnly;
  final double maxDistance;
  final double minRating;

  const ShopSearchFilters({
    this.query = '',
    this.category = ShopFilter.all,
    this.sortBy = ShopSort.rating,
    this.verifiedOnly = false,
    this.premiumOnly = false,
    this.nearbyOnly = false,
    this.maxDistance = 10.0,
    this.minRating = 0.0,
  });

  /// Create a copy with updated values
  ShopSearchFilters copyWith({
    String? query,
    ShopFilter? category,
    ShopSort? sortBy,
    bool? verifiedOnly,
    bool? premiumOnly,
    bool? nearbyOnly,
    double? maxDistance,
    double? minRating,
  }) {
    return ShopSearchFilters(
      query: query ?? this.query,
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      premiumOnly: premiumOnly ?? this.premiumOnly,
      nearbyOnly: nearbyOnly ?? this.nearbyOnly,
      maxDistance: maxDistance ?? this.maxDistance,
      minRating: minRating ?? this.minRating,
    );
  }
}
