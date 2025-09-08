/// Order data models for cart and order management

/// Order status enumeration
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

/// Order item model
class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? variant; // e.g., "Size: Large", "Color: Red"

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.variant,
  });

  /// Calculate total price for this item
  double get totalPrice => price * quantity;

  /// Create a copy with updated values
  OrderItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
    String? variant,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
    );
  }
}

/// Order model
class Order {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final String? notes;
  final Map<String, dynamic>? metadata;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.total,
    this.trackingNumber,
    this.estimatedDelivery,
    this.notes,
    this.metadata,
  });

  /// Get status display text
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  /// Get status color
  String get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return '#FFC107'; // Warning yellow
      case OrderStatus.confirmed:
        return '#17A2B8'; // Info blue
      case OrderStatus.processing:
        return '#007BFF'; // Primary blue
      case OrderStatus.shipped:
        return '#28A745'; // Success green
      case OrderStatus.delivered:
        return '#6C757D'; // Secondary gray
      case OrderStatus.cancelled:
        return '#DC3545'; // Danger red
      case OrderStatus.refunded:
        return '#6F42C1'; // Purple
    }
  }

  /// Check if order can be cancelled
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Check if order can be tracked
  bool get canTrack =>
      status == OrderStatus.shipped || status == OrderStatus.delivered;

  /// Get total number of items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Create a copy with updated values
  Order copyWith({
    String? id,
    String? orderNumber,
    DateTime? orderDate,
    OrderStatus? status,
    List<OrderItem>? items,
    double? subtotal,
    double? shippingCost,
    double? tax,
    double? total,
    String? trackingNumber,
    DateTime? estimatedDelivery,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Order summary for quick display
class OrderSummary {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final int itemCount;
  final double total;

  const OrderSummary({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.itemCount,
    required this.total,
  });

  /// Create from full order
  factory OrderSummary.fromOrder(Order order) {
    return OrderSummary(
      id: order.id,
      orderNumber: order.orderNumber,
      orderDate: order.orderDate,
      status: order.status,
      itemCount: order.totalItems,
      total: order.total,
    );
  }
}

/// Order filter options
enum OrderFilter {
  all,
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

/// Order sort options
enum OrderSort { newest, oldest, totalHigh, totalLow, status }
