import '../models/cart_data.dart';

/// Service for managing cart operations
class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<CartItem> _cartItems = [];
  CartState _state = CartState.loaded;

  /// Get current cart items
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  /// Get current cart state
  CartState get state => _state;

  /// Get cart summary
  CartSummary get cartSummary => CartSummary.fromItems(_cartItems);

  /// Add item to cart
  Future<bool> addToCart(CartItem item) async {
    try {
      _setState(CartState.loading);

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if item already exists
      final existingIndex = _cartItems.indexWhere(
        (cartItem) =>
            cartItem.productId == item.productId &&
            cartItem.size == item.size &&
            cartItem.color == item.color,
      );

      if (existingIndex != -1) {
        // Update quantity if item exists
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + item.quantity,
        );
      } else {
        // Add new item
        _cartItems.add(item);
      }

      _setState(CartState.loaded);
      return true;
    } catch (e) {
      _setState(CartState.error);
      return false;
    }
  }

  /// Remove item from cart
  Future<bool> removeFromCart(String itemId) async {
    try {
      _setState(CartState.loading);

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      _cartItems.removeWhere((item) => item.id == itemId);

      _setState(_cartItems.isEmpty ? CartState.empty : CartState.loaded);
      return true;
    } catch (e) {
      _setState(CartState.error);
      return false;
    }
  }

  /// Update item quantity
  Future<bool> updateQuantity(String itemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        return await removeFromCart(itemId);
      }

      _setState(CartState.loading);

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
        _setState(CartState.loaded);
        return true;
      }

      _setState(CartState.error);
      return false;
    } catch (e) {
      _setState(CartState.error);
      return false;
    }
  }

  /// Clear entire cart
  Future<bool> clearCart() async {
    try {
      _setState(CartState.loading);

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _cartItems.clear();
      _setState(CartState.empty);
      return true;
    } catch (e) {
      _setState(CartState.error);
      return false;
    }
  }

  /// Get item count
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  /// Check if cart has items
  bool get hasItems => _cartItems.isNotEmpty;

  /// Get total amount
  double get totalAmount => cartSummary.total;

  /// Get subtotal
  double get subtotal => cartSummary.subtotal;

  /// Get total savings
  double get totalSavings => cartSummary.totalSavings;

  /// Check if free shipping applies
  bool get hasFreeShipping => subtotal >= 100000;

  /// Get items by vendor
  Map<String, List<CartItem>> get itemsByVendor {
    final Map<String, List<CartItem>> vendorItems = {};

    for (final item in _cartItems) {
      if (!vendorItems.containsKey(item.vendorName)) {
        vendorItems[item.vendorName] = [];
      }
      vendorItems[item.vendorName]!.add(item);
    }

    return vendorItems;
  }

  /// Get items by category
  Map<String, List<CartItem>> get itemsByCategory {
    final Map<String, List<CartItem>> categoryItems = {};

    for (final item in _cartItems) {
      if (!categoryItems.containsKey(item.category)) {
        categoryItems[item.category] = [];
      }
      categoryItems[item.category]!.add(item);
    }

    return categoryItems;
  }

  /// Load sample cart data for demo
  void loadSampleData() {
    _cartItems = _getSampleCartItems();
    _setState(CartState.loaded);
  }

  /// Get sample cart items
  List<CartItem> _getSampleCartItems() {
    return [
      CartItem(
        id: '1',
        productId: '1',
        productName: 'Wireless Bluetooth Headphones',
        productImage:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300',
        price: 125000,
        originalPrice: 150000,
        quantity: 1,
        vendorName: 'TechGear Pro',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Electronics',
        isAvailable: true,
        color: 'Black',
        specifications: {
          'Battery Life': '20 hours',
          'Connectivity': 'Bluetooth 5.0',
          'Weight': '250g',
        },
      ),
      CartItem(
        id: '2',
        productId: '2',
        productName: 'Organic Cotton T-Shirt',
        productImage:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
        price: 45000,
        originalPrice: 60000,
        quantity: 2,
        vendorName: 'EcoWear Fashion',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Fashion',
        isAvailable: true,
        size: 'L',
        color: 'White',
        specifications: {
          'Material': '100% Organic Cotton',
          'Care': 'Machine Washable',
          'Origin': 'Made in Tanzania',
        },
      ),
      CartItem(
        id: '3',
        productId: '3',
        productName: 'Professional Camera Lens',
        productImage:
            'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=300',
        price: 750000,
        originalPrice: 1000000,
        quantity: 1,
        vendorName: 'PhotoPro Store',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Electronics',
        isAvailable: true,
        specifications: {
          'Focal Length': '50mm',
          'Aperture': 'f/1.8',
          'Mount': 'Canon EF',
        },
      ),
      CartItem(
        id: '4',
        productId: '4',
        productName: 'Stainless Steel Water Bottle',
        productImage:
            'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=300',
        price: 35000,
        originalPrice: 35000,
        quantity: 3,
        vendorName: 'EcoLife Products',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Home & Garden',
        isAvailable: true,
        color: 'Silver',
        specifications: {
          'Capacity': '500ml',
          'Material': 'Stainless Steel',
          'Insulation': 'Double Wall',
        },
      ),
    ];
  }

  /// Set cart state
  void _setState(CartState newState) {
    _state = newState;
  }

  /// Reset cart to empty state
  void reset() {
    _cartItems.clear();
    _setState(CartState.empty);
  }
}
