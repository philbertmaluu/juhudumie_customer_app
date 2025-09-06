import '../../../landing/src/models/product_data.dart';

/// Product details model extending the base Product model
class ProductDetails extends Product {
  final List<String> imageUrls;
  final String detailedDescription;
  final List<String> detailedSpecifications;
  final List<String> features;
  final String warranty;
  final String shippingInfo;
  final int stockQuantity;
  final bool isInStock;
  final double averageRating;
  final int totalReviews;
  final List<ProductReview> reviews;
  final List<Product> relatedProducts;

  const ProductDetails({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.originalPrice,
    required super.imageUrl,
    required super.vendorName,
    required super.vendorLogo,
    required super.rating,
    required super.reviewCount,
    required super.soldCount,
    required super.tags,
    required super.isOnSale,
    required super.isNew,
    required super.isVerified,
    required super.category,
    required super.brand,
    required super.images,
    required super.specifications,
    required this.imageUrls,
    required this.detailedDescription,
    required this.detailedSpecifications,
    required this.features,
    required this.warranty,
    required this.shippingInfo,
    required this.stockQuantity,
    required this.isInStock,
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
    required this.relatedProducts,
  });

  /// Get formatted stock status
  String get stockStatus {
    if (!isInStock) return 'Out of Stock';
    if (stockQuantity <= 5) return 'Only $stockQuantity left';
    return 'In Stock';
  }

  /// Get stock status color
  String get stockStatusColor {
    if (!isInStock) return 'red';
    if (stockQuantity <= 5) return 'orange';
    return 'green';
  }
}

/// Product review model
class ProductReview {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String> images;
  final bool isVerified;

  ProductReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    required this.images,
    required this.isVerified,
  });

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}

/// Cart item model
class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String vendorName;
  final bool isInStock;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.vendorName,
    required this.isInStock,
  });

  /// Get total price for this cart item
  double get totalPrice => price * quantity;

  /// Get formatted total price
  String get formattedTotalPrice => 'TSh ${totalPrice.toStringAsFixed(0)}';
}
