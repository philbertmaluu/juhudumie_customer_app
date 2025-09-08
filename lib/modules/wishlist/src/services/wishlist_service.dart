import '../models/wishlist_data.dart';

/// Service for managing wishlist data
class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  List<WishlistItem> _wishlistItems = [];

  /// Get all wishlist items
  List<WishlistItem> get wishlistItems => List.unmodifiable(_wishlistItems);

  /// Get wishlist summary
  WishlistSummary get summary => WishlistSummary.fromItems(_wishlistItems);

  /// Add item to wishlist
  void addToWishlist(WishlistItem item) {
    if (!_wishlistItems.any(
      (wishlistItem) => wishlistItem.productId == item.productId,
    )) {
      _wishlistItems.add(item);
    }
  }

  /// Remove item from wishlist
  void removeFromWishlist(String productId) {
    _wishlistItems.removeWhere((item) => item.productId == productId);
  }

  /// Check if item is in wishlist
  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.productId == productId);
  }

  /// Get wishlist item by product ID
  WishlistItem? getWishlistItem(String productId) {
    try {
      return _wishlistItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Clear wishlist
  void clearWishlist() {
    _wishlistItems.clear();
  }

  /// Get filtered wishlist items
  List<WishlistItem> getFilteredItems(
    WishlistFilter filter, {
    String? category,
  }) {
    List<WishlistItem> filteredItems = List.from(_wishlistItems);

    switch (filter) {
      case WishlistFilter.all:
        break;
      case WishlistFilter.available:
        filteredItems =
            filteredItems.where((item) => item.isAvailable).toList();
        break;
      case WishlistFilter.onSale:
        filteredItems = filteredItems.where((item) => item.isOnSale).toList();
        break;
      case WishlistFilter.recentlyAdded:
        filteredItems.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
      case WishlistFilter.byCategory:
        if (category != null) {
          filteredItems =
              filteredItems.where((item) => item.category == category).toList();
        }
        break;
    }

    return filteredItems;
  }

  /// Get sorted wishlist items
  List<WishlistItem> getSortedItems(
    List<WishlistItem> items,
    WishlistSort sort,
  ) {
    final sortedItems = List<WishlistItem>.from(items);

    switch (sort) {
      case WishlistSort.recentlyAdded:
        sortedItems.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
      case WishlistSort.priceLowToHigh:
        sortedItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case WishlistSort.priceHighToLow:
        sortedItems.sort((a, b) => b.price.compareTo(a.price));
        break;
      case WishlistSort.nameAZ:
        sortedItems.sort((a, b) => a.productName.compareTo(b.productName));
        break;
      case WishlistSort.nameZA:
        sortedItems.sort((a, b) => b.productName.compareTo(a.productName));
        break;
      case WishlistSort.rating:
        sortedItems.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return sortedItems;
  }

  /// Get wishlist statistics
  Map<String, dynamic> getStatistics() {
    final totalItems = _wishlistItems.length;
    final availableItems =
        _wishlistItems.where((item) => item.isAvailable).length;
    final onSaleItems = _wishlistItems.where((item) => item.isOnSale).length;
    final totalValue = _wishlistItems.fold(
      0.0,
      (sum, item) => sum + item.price,
    );
    final totalSavings = _wishlistItems.fold(
      0.0,
      (sum, item) => sum + (item.originalPrice - item.price),
    );

    return {
      'totalItems': totalItems,
      'availableItems': availableItems,
      'onSaleItems': onSaleItems,
      'totalValue': totalValue,
      'totalSavings': totalSavings,
      'averageRating':
          totalItems > 0
              ? _wishlistItems.fold(0.0, (sum, item) => sum + item.rating) /
                  totalItems
              : 0.0,
    };
  }

  /// Initialize with sample data
  void loadSampleData() {
    _wishlistItems = _generateSampleWishlistItems();
  }

  /// Generate sample wishlist items using existing products
  List<WishlistItem> _generateSampleWishlistItems() {
    final now = DateTime.now();

    return [
      WishlistItem(
        id: '1',
        productId: '1',
        productName: 'Wireless Bluetooth Headphones',
        productImage:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300',
        price: 225000,
        originalPrice: 325000,
        vendorName: 'TechGear Pro',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Electronics',
        isAvailable: true,
        addedDate: now.subtract(const Duration(days: 2)),
        isOnSale: true,
        rating: 4.5,
        reviewCount: 1250,
        color: 'Black',
        specifications: {
          'Battery Life': '30 hours',
          'Connectivity': 'Bluetooth 5.0',
          'Weight': '250g',
        },
      ),

      WishlistItem(
        id: '2',
        productId: '2',
        productName: 'Smart Fitness Watch',
        productImage:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300',
        price: 180000,
        originalPrice: 220000,
        vendorName: 'FitTech Solutions',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Electronics',
        isAvailable: true,
        addedDate: now.subtract(const Duration(days: 5)),
        isOnSale: true,
        rating: 4.3,
        reviewCount: 890,
        size: '44mm',
        color: 'Silver',
        specifications: {
          'Battery Life': '7 days',
          'Water Resistance': '5ATM',
          'Display': '1.4" AMOLED',
        },
      ),

      WishlistItem(
        id: '3',
        productId: '3',
        productName: 'Organic Cotton T-Shirt',
        productImage:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
        price: 45000,
        originalPrice: 60000,
        vendorName: 'EcoWear Fashion',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Fashion',
        isAvailable: false,
        addedDate: now.subtract(const Duration(days: 1)),
        isOnSale: true,
        rating: 4.7,
        reviewCount: 234,
        size: 'L',
        color: 'White',
        specifications: {
          'Material': '100% Organic Cotton',
          'Care': 'Machine Washable',
          'Origin': 'Made in Tanzania',
        },
      ),

      WishlistItem(
        id: '4',
        productId: '4',
        productName: 'Premium Coffee Beans',
        productImage:
            'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300',
        price: 75000,
        originalPrice: 75000,
        vendorName: 'Kilimanjaro Coffee Co.',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Food & Beverages',
        isAvailable: true,
        addedDate: now.subtract(const Duration(hours: 6)),
        isOnSale: false,
        rating: 4.8,
        reviewCount: 156,
        specifications: {
          'Origin': 'Kilimanjaro Region',
          'Roast': 'Medium',
          'Weight': '500g',
        },
      ),

      WishlistItem(
        id: '5',
        productId: '5',
        productName: 'Handcrafted Wooden Bowl',
        productImage:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300',
        price: 120000,
        originalPrice: 150000,
        vendorName: 'Tanzanian Crafts',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Home & Garden',
        isAvailable: true,
        addedDate: now.subtract(const Duration(days: 3)),
        isOnSale: true,
        rating: 4.6,
        reviewCount: 78,
        specifications: {
          'Material': 'Mpingo Wood',
          'Finish': 'Natural Oil',
          'Diameter': '25cm',
        },
      ),

      WishlistItem(
        id: '6',
        productId: '6',
        productName: 'Wireless Charging Pad',
        productImage:
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=300',
        price: 100000,
        originalPrice: 150000,
        vendorName: 'ChargeTech',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        category: 'Electronics',
        isAvailable: true,
        addedDate: now.subtract(const Duration(hours: 12)),
        isOnSale: true,
        rating: 4.2,
        reviewCount: 650,
        specifications: {
          'Power': '15W Fast Charging',
          'Compatibility': 'Qi Standard',
          'LED Indicator': 'Yes',
        },
      ),
    ];
  }
}
