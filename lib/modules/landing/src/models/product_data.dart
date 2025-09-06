/// Product data models for the landing page
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String vendorName;
  final String vendorLogo;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final List<String> tags;
  final bool isOnSale;
  final bool isNew;
  final bool isVerified;
  final String category;
  final String brand;
  final List<String> images;
  final Map<String, dynamic> specifications;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.vendorName,
    required this.vendorLogo,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.tags,
    this.isOnSale = false,
    this.isNew = false,
    this.isVerified = false,
    required this.category,
    required this.brand,
    required this.images,
    required this.specifications,
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

  /// Get formatted sold count
  String get formattedSoldCount {
    if (soldCount >= 1000) {
      return '${(soldCount / 1000).toStringAsFixed(1)}k+ sold';
    }
    return '$soldCount+ sold';
  }

  /// Get formatted review count
  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}k reviews';
    }
    return '$reviewCount reviews';
  }
}

/// Product category model
class ProductCategory {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;
  final int productCount;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.productCount,
  });
}

/// Vendor model
class Vendor {
  final String id;
  final String name;
  final String logo;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String location;
  final int yearsInBusiness;

  const Vendor({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.reviewCount,
    this.isVerified = false,
    required this.location,
    required this.yearsInBusiness,
  });

  /// Get formatted rating
  String get formattedRating => rating.toStringAsFixed(1);

  /// Get formatted review count
  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}k reviews';
    }
    return '$reviewCount reviews';
  }
}
