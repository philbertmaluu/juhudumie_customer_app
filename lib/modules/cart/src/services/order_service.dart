import '../models/order_data.dart';

/// Service for managing order data and operations
class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  List<Order> _orders = [];
  OrderFilter _currentFilter = OrderFilter.all;
  OrderSort _currentSort = OrderSort.newest;

  /// Get all orders
  List<Order> get orders => List.unmodifiable(_orders);

  /// Get filtered and sorted orders
  List<Order> get filteredOrders {
    List<Order> filtered = _orders;

    // Apply filter
    if (_currentFilter != OrderFilter.all) {
      final status = _getStatusFromFilter(_currentFilter);
      filtered = filtered.where((order) => order.status == status).toList();
    }

    // Apply sort
    switch (_currentSort) {
      case OrderSort.newest:
        filtered.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        break;
      case OrderSort.oldest:
        filtered.sort((a, b) => a.orderDate.compareTo(b.orderDate));
        break;
      case OrderSort.totalHigh:
        filtered.sort((a, b) => b.total.compareTo(a.total));
        break;
      case OrderSort.totalLow:
        filtered.sort((a, b) => a.total.compareTo(b.total));
        break;
      case OrderSort.status:
        filtered.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
    }

    return filtered;
  }

  /// Get current filter
  OrderFilter get currentFilter => _currentFilter;

  /// Get current sort
  OrderSort get currentSort => _currentSort;

  /// Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  /// Get order by ID
  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get order statistics
  Map<String, int> get orderStatistics {
    final stats = <String, int>{};
    for (final status in OrderStatus.values) {
      stats[status.name] =
          _orders.where((order) => order.status == status).length;
    }
    return stats;
  }

  /// Get total spent
  double get totalSpent {
    return _orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.total);
  }

  /// Set filter
  void setFilter(OrderFilter filter) {
    _currentFilter = filter;
  }

  /// Set sort
  void setSort(OrderSort sort) {
    _currentSort = sort;
  }

  /// Cancel order
  bool cancelOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1 && _orders[orderIndex].canCancel) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(
        status: OrderStatus.cancelled,
      );
      return true;
    }
    return false;
  }

  /// Track order
  String? getTrackingNumber(String orderId) {
    final order = getOrderById(orderId);
    return order?.trackingNumber;
  }

  /// Initialize with sample data
  void loadSampleData() {
    _orders = _generateSampleOrders();
  }

  /// Generate sample orders for demo using existing products
  List<Order> _generateSampleOrders() {
    final now = DateTime.now();

    return [
      Order(
        id: '1',
        orderNumber: 'ORD-2024-001',
        orderDate: now.subtract(const Duration(days: 2)),
        status: OrderStatus.delivered,
        items: [
          OrderItem(
            id: '1-1',
            productId: '1',
            productName: 'Wireless Bluetooth Headphones',
            productImage:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300',
            price: 225000,
            quantity: 1,
            variant: 'Color: Black',
          ),
          OrderItem(
            id: '1-2',
            productId: '2',
            productName: 'Smart Fitness Watch',
            productImage:
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300',
            price: 180000,
            quantity: 1,
            variant: 'Size: 44mm',
          ),
        ],
        subtotal: 405000,
        shippingCost: 15000,
        tax: 42000,
        total: 462000,
        trackingNumber: 'TRK123456789',
        estimatedDelivery: now.subtract(const Duration(days: 1)),
      ),

      Order(
        id: '2',
        orderNumber: 'ORD-2024-002',
        orderDate: now.subtract(const Duration(days: 1)),
        status: OrderStatus.shipped,
        items: [
          OrderItem(
            id: '2-1',
            productId: '3',
            productName: 'Organic Cotton T-Shirt',
            productImage:
                'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
            price: 45000,
            quantity: 2,
            variant: 'Size: L, Color: White',
          ),
        ],
        subtotal: 90000,
        shippingCost: 8000,
        tax: 9800,
        total: 107800,
        trackingNumber: 'TRK987654321',
        estimatedDelivery: now.add(const Duration(days: 2)),
      ),

      Order(
        id: '3',
        orderNumber: 'ORD-2024-003',
        orderDate: now.subtract(const Duration(hours: 6)),
        status: OrderStatus.processing,
        items: [
          OrderItem(
            id: '3-1',
            productId: '4',
            productName: 'Premium Coffee Beans',
            productImage:
                'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300',
            price: 75000,
            quantity: 1,
            variant: 'Origin: Kilimanjaro',
          ),
          OrderItem(
            id: '3-2',
            productId: '5',
            productName: 'Handcrafted Wooden Bowl',
            productImage:
                'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300',
            price: 120000,
            quantity: 1,
            variant: 'Material: Mpingo Wood',
          ),
        ],
        subtotal: 195000,
        shippingCost: 12000,
        tax: 20700,
        total: 227700,
        estimatedDelivery: now.add(const Duration(days: 5)),
      ),

      Order(
        id: '4',
        orderNumber: 'ORD-2024-004',
        orderDate: now.subtract(const Duration(hours: 2)),
        status: OrderStatus.pending,
        items: [
          OrderItem(
            id: '4-1',
            productId: '6',
            productName: 'Wireless Charging Pad',
            productImage:
                'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=300',
            price: 100000,
            quantity: 1,
            variant: 'Power: 15W',
          ),
        ],
        subtotal: 100000,
        shippingCost: 10000,
        tax: 11000,
        total: 121000,
        estimatedDelivery: now.add(const Duration(days: 7)),
      ),

      Order(
        id: '5',
        orderNumber: 'ORD-2024-005',
        orderDate: now.subtract(const Duration(days: 5)),
        status: OrderStatus.cancelled,
        items: [
          OrderItem(
            id: '5-1',
            productId: '1',
            productName: 'Wireless Bluetooth Headphones',
            productImage:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300',
            price: 225000,
            quantity: 1,
            variant: 'Color: White',
          ),
        ],
        subtotal: 225000,
        shippingCost: 15000,
        tax: 24000,
        total: 264000,
      ),
    ];
  }

  /// Convert filter to status
  OrderStatus? _getStatusFromFilter(OrderFilter filter) {
    switch (filter) {
      case OrderFilter.pending:
        return OrderStatus.pending;
      case OrderFilter.confirmed:
        return OrderStatus.confirmed;
      case OrderFilter.processing:
        return OrderStatus.processing;
      case OrderFilter.shipped:
        return OrderStatus.shipped;
      case OrderFilter.delivered:
        return OrderStatus.delivered;
      case OrderFilter.cancelled:
        return OrderStatus.cancelled;
      case OrderFilter.refunded:
        return OrderStatus.refunded;
      case OrderFilter.all:
        return null;
    }
  }
}
