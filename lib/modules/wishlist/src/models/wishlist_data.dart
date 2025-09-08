/// Wishlist data models
class WishlistItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double originalPrice;
  final String vendorName;
  final String vendorLogo;
  final String category;
  final bool isAvailable;
  final String? size;
  final String? color;
  final Map<String, dynamic>? specifications;
  final DateTime addedDate;
  final bool isOnSale;
  final double rating;
  final int reviewCount;

  const WishlistItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.originalPrice,
    required this.vendorName,
    required this.vendorLogo,
    required this.category,
    required this.isAvailable,
    this.size,
    this.color,
    this.specifications,
    required this.addedDate,
    this.isOnSale = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  /// Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= price) return 0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }

  /// Get formatted price
  String get formattedPrice => 'TSh ${price.toStringAsFixed(0)}';

  /// Get formatted original price
  String get formattedOriginalPrice =>
      'TSh ${originalPrice.toStringAsFixed(0)}';

  /// Get formatted rating
  String get formattedRating => rating.toStringAsFixed(1);

  /// Get formatted review count
  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}k reviews';
    }
    return '$reviewCount reviews';
  }

  /// Get formatted added date
  String get formattedAddedDate {
    final now = DateTime.now();
    final difference = now.difference(addedDate);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  /// Copy with method
  WishlistItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? originalPrice,
    String? vendorName,
    String? vendorLogo,
    String? category,
    bool? isAvailable,
    String? size,
    String? color,
    Map<String, dynamic>? specifications,
    DateTime? addedDate,
    bool? isOnSale,
    double? rating,
    int? reviewCount,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      vendorName: vendorName ?? this.vendorName,
      vendorLogo: vendorLogo ?? this.vendorLogo,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      size: size ?? this.size,
      color: color ?? this.color,
      specifications: specifications ?? this.specifications,
      addedDate: addedDate ?? this.addedDate,
      isOnSale: isOnSale ?? this.isOnSale,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}

/// Wishlist summary data
class WishlistSummary {
  final List<WishlistItem> items;
  final int totalItems;
  final double totalValue;
  final double totalSavings;
  final Map<String, int> categoryCounts;

  const WishlistSummary({
    required this.items,
    required this.totalItems,
    required this.totalValue,
    required this.totalSavings,
    required this.categoryCounts,
  });

  /// Calculate total items count
  static int calculateTotalItems(List<WishlistItem> items) {
    return items.length;
  }

  /// Calculate total value
  static double calculateTotalValue(List<WishlistItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }

  /// Calculate total savings
  static double calculateTotalSavings(List<WishlistItem> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.originalPrice - item.price),
    );
  }

  /// Calculate category counts
  static Map<String, int> calculateCategoryCounts(List<WishlistItem> items) {
    final Map<String, int> counts = {};
    for (final item in items) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Create summary from items
  static WishlistSummary fromItems(List<WishlistItem> items) {
    return WishlistSummary(
      items: items,
      totalItems: calculateTotalItems(items),
      totalValue: calculateTotalValue(items),
      totalSavings: calculateTotalSavings(items),
      categoryCounts: calculateCategoryCounts(items),
    );
  }
}

/// Wishlist filter options
enum WishlistFilter { all, available, onSale, recentlyAdded, byCategory }

/// Wishlist sort options
enum WishlistSort {
  recentlyAdded,
  priceLowToHigh,
  priceHighToLow,
  nameAZ,
  nameZA,
  rating,
}
