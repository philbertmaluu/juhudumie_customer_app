/// Cart data models
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double originalPrice;
  final int quantity;
  final String vendorName;
  final String vendorLogo;
  final String category;
  final bool isAvailable;
  final String? size;
  final String? color;
  final Map<String, dynamic>? specifications;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.vendorName,
    required this.vendorLogo,
    required this.category,
    this.isAvailable = true,
    this.size,
    this.color,
    this.specifications,
  });

  /// Calculate total price for this item
  double get totalPrice => price * quantity;

  /// Calculate total savings for this item
  double get totalSavings => (originalPrice - price) * quantity;

  /// Check if item is on sale
  bool get isOnSale => originalPrice > price;

  /// Get discount percentage
  double get discountPercentage {
    if (originalPrice <= price) return 0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }

  /// Create a copy with updated quantity
  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? originalPrice,
    int? quantity,
    String? vendorName,
    String? vendorLogo,
    String? category,
    bool? isAvailable,
    String? size,
    String? color,
    Map<String, dynamic>? specifications,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      vendorName: vendorName ?? this.vendorName,
      vendorLogo: vendorLogo ?? this.vendorLogo,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      size: size ?? this.size,
      color: color ?? this.color,
      specifications: specifications ?? this.specifications,
    );
  }
}

/// Cart summary data
class CartSummary {
  final List<CartItem> items;
  final double subtotal;
  final double totalSavings;
  final double shippingFee;
  final double tax;
  final double total;
  final int totalItems;

  const CartSummary({
    required this.items,
    required this.subtotal,
    required this.totalSavings,
    required this.shippingFee,
    required this.tax,
    required this.total,
    required this.totalItems,
  });

  /// Calculate subtotal from items
  static double calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Calculate total savings from items
  static double calculateTotalSavings(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalSavings);
  }

  /// Calculate total items count
  static int calculateTotalItems(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calculate shipping fee (free shipping over TSh 100,000)
  static double calculateShippingFee(double subtotal) {
    return subtotal >= 100000 ? 0.0 : 5000.0;
  }

  /// Calculate tax (18% VAT)
  static double calculateTax(double subtotal) {
    return subtotal * 0.18;
  }

  /// Calculate total amount
  static double calculateTotal(double subtotal, double shippingFee, double tax) {
    return subtotal + shippingFee + tax;
  }

  /// Create cart summary from items
  factory CartSummary.fromItems(List<CartItem> items) {
    final subtotal = calculateSubtotal(items);
    final totalSavings = calculateTotalSavings(items);
    final shippingFee = calculateShippingFee(subtotal);
    final tax = calculateTax(subtotal);
    final total = calculateTotal(subtotal, shippingFee, tax);
    final totalItems = calculateTotalItems(items);

    return CartSummary(
      items: items,
      subtotal: subtotal,
      totalSavings: totalSavings,
      shippingFee: shippingFee,
      tax: tax,
      total: total,
      totalItems: totalItems,
    );
  }
}

/// Cart state enum
enum CartState {
  loading,
  loaded,
  empty,
  error,
}

/// Cart action types
enum CartAction {
  add,
  remove,
  updateQuantity,
  clear,
  toggleFavorite,
}
