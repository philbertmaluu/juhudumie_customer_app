/// Shop service for managing shop data and operations

import '../models/shop_data.dart';

/// Shop service class
class ShopService {
  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  static ShopService get instance => _instance;

  List<Shop> _shops = [];
  ShopSearchFilters _currentFilters = const ShopSearchFilters();
  List<Shop> _filteredShops = [];

  /// Get all shops
  List<Shop> get shops => _shops;

  /// Get filtered shops
  List<Shop> get filteredShops => _filteredShops;

  /// Get current filters
  ShopSearchFilters get currentFilters => _currentFilters;

  /// Load sample shop data
  void loadSampleData() {
    _shops = _generateSampleShops();
    _applyFilters();
  }

  /// Search shops
  void searchShops(String query) {
    _currentFilters = _currentFilters.copyWith(query: query);
    _applyFilters();
  }

  /// Set category filter
  void setCategoryFilter(ShopFilter category) {
    _currentFilters = _currentFilters.copyWith(category: category);
    _applyFilters();
  }

  /// Set sort option
  void setSortBy(ShopSort sortBy) {
    _currentFilters = _currentFilters.copyWith(sortBy: sortBy);
    _applyFilters();
  }

  /// Toggle verified only filter
  void toggleVerifiedOnly() {
    _currentFilters = _currentFilters.copyWith(
      verifiedOnly: !_currentFilters.verifiedOnly,
    );
    _applyFilters();
  }

  /// Toggle premium only filter
  void togglePremiumOnly() {
    _currentFilters = _currentFilters.copyWith(
      premiumOnly: !_currentFilters.premiumOnly,
    );
    _applyFilters();
  }

  /// Toggle nearby only filter
  void toggleNearbyOnly() {
    _currentFilters = _currentFilters.copyWith(
      nearbyOnly: !_currentFilters.nearbyOnly,
    );
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _currentFilters = const ShopSearchFilters();
    _applyFilters();
  }

  /// Apply current filters to shops
  void _applyFilters() {
    List<Shop> filtered = List.from(_shops);

    // Apply search query
    if (_currentFilters.query.isNotEmpty) {
      filtered =
          filtered.where((shop) {
            return shop.name.toLowerCase().contains(
                  _currentFilters.query.toLowerCase(),
                ) ||
                shop.description.toLowerCase().contains(
                  _currentFilters.query.toLowerCase(),
                ) ||
                shop.tagline.toLowerCase().contains(
                  _currentFilters.query.toLowerCase(),
                ) ||
                shop.categoryText.toLowerCase().contains(
                  _currentFilters.query.toLowerCase(),
                );
          }).toList();
    }

    // Apply category filter
    if (_currentFilters.category != ShopFilter.all) {
      filtered =
          filtered.where((shop) {
            switch (_currentFilters.category) {
              case ShopFilter.verified:
                return shop.isVerified;
              case ShopFilter.premium:
                return shop.isPremium;
              case ShopFilter.nearby:
                return shop.distanceFromUser <= _currentFilters.maxDistance;
              default:
                return shop.category ==
                    _getCategoryFromFilter(_currentFilters.category);
            }
          }).toList();
    }

    // Apply additional filters
    if (_currentFilters.verifiedOnly) {
      filtered = filtered.where((shop) => shop.isVerified).toList();
    }

    if (_currentFilters.premiumOnly) {
      filtered = filtered.where((shop) => shop.isPremium).toList();
    }

    if (_currentFilters.nearbyOnly) {
      filtered =
          filtered
              .where(
                (shop) => shop.distanceFromUser <= _currentFilters.maxDistance,
              )
              .toList();
    }

    // Apply rating filter
    if (_currentFilters.minRating > 0) {
      filtered =
          filtered
              .where(
                (shop) =>
                    shop.rating.averageRating >= _currentFilters.minRating,
              )
              .toList();
    }

    // Apply sorting
    filtered.sort(_getSortComparator());

    _filteredShops = filtered;
  }

  /// Get category from filter
  ShopCategory _getCategoryFromFilter(ShopFilter filter) {
    switch (filter) {
      case ShopFilter.fashion:
        return ShopCategory.fashion;
      case ShopFilter.electronics:
        return ShopCategory.electronics;
      case ShopFilter.food:
        return ShopCategory.food;
      case ShopFilter.beauty:
        return ShopCategory.beauty;
      case ShopFilter.home:
        return ShopCategory.home;
      case ShopFilter.sports:
        return ShopCategory.sports;
      case ShopFilter.books:
        return ShopCategory.books;
      case ShopFilter.automotive:
        return ShopCategory.automotive;
      case ShopFilter.health:
        return ShopCategory.health;
      default:
        return ShopCategory.other;
    }
  }

  /// Get sort comparator
  int Function(Shop, Shop) _getSortComparator() {
    switch (_currentFilters.sortBy) {
      case ShopSort.name:
        return (a, b) => a.name.compareTo(b.name);
      case ShopSort.rating:
        return (a, b) =>
            b.rating.averageRating.compareTo(a.rating.averageRating);
      case ShopSort.distance:
        return (a, b) => a.distanceFromUser.compareTo(b.distanceFromUser);
      case ShopSort.newest:
        return (a, b) => b.joinedDate.compareTo(a.joinedDate);
      case ShopSort.oldest:
        return (a, b) => a.joinedDate.compareTo(b.joinedDate);
      case ShopSort.mostProducts:
        return (a, b) => b.totalProducts.compareTo(a.totalProducts);
      case ShopSort.mostOrders:
        return (a, b) => b.totalOrders.compareTo(a.totalOrders);
    }
  }

  /// Get shop by ID
  Shop? getShopById(String id) {
    try {
      return _shops.firstWhere((shop) => shop.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get shop statistics
  Map<String, int> get shopStatistics {
    return {
      'total': _shops.length,
      'fashion': _shops.where((s) => s.category == ShopCategory.fashion).length,
      'electronics':
          _shops.where((s) => s.category == ShopCategory.electronics).length,
      'food': _shops.where((s) => s.category == ShopCategory.food).length,
      'beauty': _shops.where((s) => s.category == ShopCategory.beauty).length,
      'home': _shops.where((s) => s.category == ShopCategory.home).length,
      'sports': _shops.where((s) => s.category == ShopCategory.sports).length,
      'books': _shops.where((s) => s.category == ShopCategory.books).length,
      'automotive':
          _shops.where((s) => s.category == ShopCategory.automotive).length,
      'health': _shops.where((s) => s.category == ShopCategory.health).length,
      'other': _shops.where((s) => s.category == ShopCategory.other).length,
      'verified': _shops.where((s) => s.isVerified).length,
      'premium': _shops.where((s) => s.isPremium).length,
      'nearby': _shops.where((s) => s.distanceFromUser <= 5.0).length,
    };
  }

  /// Generate sample shops data
  List<Shop> _generateSampleShops() {
    return [
      // Fashion Shops
      Shop(
        id: 'shop_1',
        name: 'Fashion Forward',
        description: 'Trendy clothing and accessories for modern women',
        tagline: 'Style that speaks volumes',
        logoUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&h=200&fit=crop',
        bannerUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=200&fit=crop',
        category: ShopCategory.fashion,
        status: ShopStatus.active,
        ownerName: 'Sarah Johnson',
        ownerEmail: 'sarah@fashionforward.com',
        ownerPhone: '+255 123 456 789',
        address: '123 Fashion Street, Dar es Salaam',
        city: 'Dar es Salaam',
        country: 'Tanzania',
        latitude: -6.7924,
        longitude: 39.2083,
        joinedDate: DateTime.now().subtract(const Duration(days: 30)),
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        rating: const ShopRating(
          averageRating: 4.5,
          totalReviews: 128,
          ratingDistribution: {5: 80, 4: 35, 3: 10, 2: 2, 1: 1},
        ),
        featuredProducts: [
          ShopProduct(
            id: 'prod_1',
            name: 'Summer Dress',
            imageUrl:
                'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=150&h=150&fit=crop',
            price: 45000,
            currency: 'TSh',
            stock: 15,
            isAvailable: true,
          ),
          ShopProduct(
            id: 'prod_2',
            name: 'Designer Handbag',
            imageUrl:
                'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=150&h=150&fit=crop',
            price: 120000,
            currency: 'TSh',
            stock: 8,
            isAvailable: true,
          ),
        ],
        advertisements: [
          ShopAdvertisement(
            id: 'ad_1',
            title: 'Summer Collection 2024',
            imageUrl:
                'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=200&fit=crop',
            description: 'New arrivals for the summer season',
            startDate: DateTime.now().subtract(const Duration(days: 5)),
            endDate: DateTime.now().add(const Duration(days: 25)),
            isActive: true,
          ),
        ],
        videos: [
          ShopVideo(
            id: 'vid_1',
            title: 'Fashion Show 2024',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=200&fit=crop',
            videoUrl: 'https://example.com/video1.mp4',
            description: 'Our latest fashion show featuring new collections',
            duration: const Duration(minutes: 5, seconds: 30),
            uploadDate: DateTime.now().subtract(const Duration(days: 3)),
            views: 1250,
            isFeatured: true,
          ),
        ],
        totalProducts: 156,
        totalOrders: 342,
        isVerified: true,
        isPremium: true,
        metadata: {'featured': true, 'trending': true},
      ),

      // Electronics Shop
      Shop(
        id: 'shop_2',
        name: 'Tech Hub Tanzania',
        description: 'Latest electronics and gadgets at competitive prices',
        tagline: 'Technology for everyone',
        logoUrl:
            'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200&h=200&fit=crop',
        bannerUrl:
            'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400&h=200&fit=crop',
        category: ShopCategory.electronics,
        status: ShopStatus.active,
        ownerName: 'Ahmed Hassan',
        ownerEmail: 'ahmed@techhub.co.tz',
        ownerPhone: '+255 987 654 321',
        address: '456 Tech Avenue, Dar es Salaam',
        city: 'Dar es Salaam',
        country: 'Tanzania',
        latitude: -6.7924,
        longitude: 39.2083,
        joinedDate: DateTime.now().subtract(const Duration(days: 45)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
        rating: const ShopRating(
          averageRating: 4.8,
          totalReviews: 89,
          ratingDistribution: {5: 70, 4: 15, 3: 3, 2: 1, 1: 0},
        ),
        featuredProducts: [
          ShopProduct(
            id: 'prod_3',
            name: 'Smartphone Galaxy S24',
            imageUrl:
                'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=150&h=150&fit=crop',
            price: 850000,
            currency: 'TSh',
            stock: 12,
            isAvailable: true,
          ),
          ShopProduct(
            id: 'prod_4',
            name: 'Wireless Headphones',
            imageUrl:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=150&h=150&fit=crop',
            price: 180000,
            currency: 'TSh',
            stock: 25,
            isAvailable: true,
          ),
        ],
        advertisements: [
          ShopAdvertisement(
            id: 'ad_2',
            title: 'Tech Sale 2024',
            imageUrl:
                'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=300&h=200&fit=crop',
            description: 'Up to 30% off on all electronics',
            startDate: DateTime.now().subtract(const Duration(days: 2)),
            endDate: DateTime.now().add(const Duration(days: 8)),
            isActive: true,
          ),
        ],
        videos: [
          ShopVideo(
            id: 'vid_2',
            title: 'Product Review: Latest Smartphones',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=300&h=200&fit=crop',
            videoUrl: 'https://example.com/video2.mp4',
            description: 'In-depth review of the latest smartphone models',
            duration: const Duration(minutes: 8, seconds: 15),
            uploadDate: DateTime.now().subtract(const Duration(days: 1)),
            views: 890,
            isFeatured: false,
          ),
        ],
        totalProducts: 234,
        totalOrders: 567,
        isVerified: true,
        isPremium: false,
        metadata: {'featured': false, 'trending': true},
      ),

      // Food Shop
      Shop(
        id: 'shop_3',
        name: 'Mama\'s Kitchen',
        description: 'Authentic Tanzanian cuisine and fresh ingredients',
        tagline: 'Taste of home',
        logoUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=200&h=200&fit=crop',
        bannerUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=200&fit=crop',
        category: ShopCategory.food,
        status: ShopStatus.active,
        ownerName: 'Fatuma Mwalimu',
        ownerEmail: 'fatuma@mamaskitchen.co.tz',
        ownerPhone: '+255 456 789 012',
        address: '789 Food Street, Dar es Salaam',
        city: 'Dar es Salaam',
        country: 'Tanzania',
        latitude: -6.7924,
        longitude: 39.2083,
        joinedDate: DateTime.now().subtract(const Duration(days: 60)),
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
        rating: const ShopRating(
          averageRating: 4.7,
          totalReviews: 203,
          ratingDistribution: {5: 150, 4: 45, 3: 7, 2: 1, 1: 0},
        ),
        featuredProducts: [
          ShopProduct(
            id: 'prod_5',
            name: 'Ugali & Nyama Choma',
            imageUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=150&h=150&fit=crop',
            price: 15000,
            currency: 'TSh',
            stock: 50,
            isAvailable: true,
          ),
          ShopProduct(
            id: 'prod_6',
            name: 'Fresh Vegetables',
            imageUrl:
                'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=150&h=150&fit=crop',
            price: 5000,
            currency: 'TSh',
            stock: 100,
            isAvailable: true,
          ),
        ],
        advertisements: [
          ShopAdvertisement(
            id: 'ad_3',
            title: 'Weekend Special',
            imageUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
            description: 'Special weekend menu with traditional dishes',
            startDate: DateTime.now().subtract(const Duration(days: 1)),
            endDate: DateTime.now().add(const Duration(days: 2)),
            isActive: true,
          ),
        ],
        videos: [
          ShopVideo(
            id: 'vid_3',
            title: 'Cooking Traditional Tanzanian Food',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
            videoUrl: 'https://example.com/video3.mp4',
            description: 'Learn to cook authentic Tanzanian dishes',
            duration: const Duration(minutes: 12, seconds: 45),
            uploadDate: DateTime.now().subtract(const Duration(days: 5)),
            views: 2100,
            isFeatured: true,
          ),
        ],
        totalProducts: 78,
        totalOrders: 445,
        isVerified: true,
        isPremium: true,
        metadata: {'featured': true, 'trending': false},
      ),

      // Beauty Shop
      Shop(
        id: 'shop_4',
        name: 'Beauty Haven',
        description: 'Premium beauty products and skincare essentials',
        tagline: 'Beauty redefined',
        logoUrl:
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=200&h=200&fit=crop',
        bannerUrl:
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=200&fit=crop',
        category: ShopCategory.beauty,
        status: ShopStatus.active,
        ownerName: 'Grace Mwamba',
        ownerEmail: 'grace@beautyhaven.co.tz',
        ownerPhone: '+255 321 654 987',
        address: '321 Beauty Lane, Dar es Salaam',
        city: 'Dar es Salaam',
        country: 'Tanzania',
        latitude: -6.7924,
        longitude: 39.2083,
        joinedDate: DateTime.now().subtract(const Duration(days: 20)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
        rating: const ShopRating(
          averageRating: 4.3,
          totalReviews: 67,
          ratingDistribution: {5: 40, 4: 20, 3: 5, 2: 2, 1: 0},
        ),
        featuredProducts: [
          ShopProduct(
            id: 'prod_7',
            name: 'Anti-Aging Serum',
            imageUrl:
                'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=150&h=150&fit=crop',
            price: 95000,
            currency: 'TSh',
            stock: 20,
            isAvailable: true,
          ),
          ShopProduct(
            id: 'prod_8',
            name: 'Moisturizing Cream',
            imageUrl:
                'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=150&h=150&fit=crop',
            price: 35000,
            currency: 'TSh',
            stock: 35,
            isAvailable: true,
          ),
        ],
        advertisements: [
          ShopAdvertisement(
            id: 'ad_4',
            title: 'Beauty Week Special',
            imageUrl:
                'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
            description: '20% off on all beauty products',
            startDate: DateTime.now().subtract(const Duration(days: 3)),
            endDate: DateTime.now().add(const Duration(days: 4)),
            isActive: true,
          ),
        ],
        videos: [
          ShopVideo(
            id: 'vid_4',
            title: 'Beauty Routine Tips',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
            videoUrl: 'https://example.com/video4.mp4',
            description: 'Daily beauty routine for healthy skin',
            duration: const Duration(minutes: 6, seconds: 20),
            uploadDate: DateTime.now().subtract(const Duration(days: 2)),
            views: 567,
            isFeatured: false,
          ),
        ],
        totalProducts: 89,
        totalOrders: 123,
        isVerified: false,
        isPremium: false,
        metadata: {'featured': false, 'trending': false},
      ),

      // Home & Garden Shop
      Shop(
        id: 'shop_5',
        name: 'Home Comfort',
        description: 'Everything for your home and garden needs',
        tagline: 'Making homes beautiful',
        logoUrl:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=200&h=200&fit=crop',
        bannerUrl:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&h=200&fit=crop',
        category: ShopCategory.home,
        status: ShopStatus.active,
        ownerName: 'John Mwangi',
        ownerEmail: 'john@homecomfort.co.tz',
        ownerPhone: '+255 654 321 098',
        address: '654 Garden Road, Dar es Salaam',
        city: 'Dar es Salaam',
        country: 'Tanzania',
        latitude: -6.7924,
        longitude: 39.2083,
        joinedDate: DateTime.now().subtract(const Duration(days: 75)),
        lastActive: DateTime.now().subtract(const Duration(hours: 3)),
        rating: const ShopRating(
          averageRating: 4.6,
          totalReviews: 145,
          ratingDistribution: {5: 100, 4: 35, 3: 8, 2: 2, 1: 0},
        ),
        featuredProducts: [
          ShopProduct(
            id: 'prod_9',
            name: 'Garden Tools Set',
            imageUrl:
                'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=150&h=150&fit=crop',
            price: 75000,
            currency: 'TSh',
            stock: 18,
            isAvailable: true,
          ),
          ShopProduct(
            id: 'prod_10',
            name: 'Decorative Vases',
            imageUrl:
                'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=150&h=150&fit=crop',
            price: 25000,
            currency: 'TSh',
            stock: 30,
            isAvailable: true,
          ),
        ],
        advertisements: [
          ShopAdvertisement(
            id: 'ad_5',
            title: 'Home Makeover Sale',
            imageUrl:
                'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=200&fit=crop',
            description: 'Transform your home with our special offers',
            startDate: DateTime.now().subtract(const Duration(days: 7)),
            endDate: DateTime.now().add(const Duration(days: 13)),
            isActive: true,
          ),
        ],
        videos: [
          ShopVideo(
            id: 'vid_5',
            title: 'Home Decorating Ideas',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=200&fit=crop',
            videoUrl: 'https://example.com/video5.mp4',
            description: 'Creative ideas for home decoration',
            duration: const Duration(minutes: 10, seconds: 30),
            uploadDate: DateTime.now().subtract(const Duration(days: 4)),
            views: 1450,
            isFeatured: true,
          ),
        ],
        totalProducts: 167,
        totalOrders: 289,
        isVerified: true,
        isPremium: false,
        metadata: {'featured': false, 'trending': true},
      ),
    ];
  }

  /// Get shop statistics
  Map<String, int> getShopStatistics() {
    return {
      'total': _shops.length,
      'fashion': _shops.where((s) => s.category == ShopCategory.fashion).length,
      'electronics':
          _shops.where((s) => s.category == ShopCategory.electronics).length,
      'food': _shops.where((s) => s.category == ShopCategory.food).length,
      'beauty': _shops.where((s) => s.category == ShopCategory.beauty).length,
      'home': _shops.where((s) => s.category == ShopCategory.home).length,
      'sports': _shops.where((s) => s.category == ShopCategory.sports).length,
      'books': _shops.where((s) => s.category == ShopCategory.books).length,
      'automotive':
          _shops.where((s) => s.category == ShopCategory.automotive).length,
      'health': _shops.where((s) => s.category == ShopCategory.health).length,
      'other': _shops.where((s) => s.category == ShopCategory.other).length,
      'verified': _shops.where((s) => s.isVerified).length,
      'premium': _shops.where((s) => s.isPremium).length,
    };
  }

  /// Get filtered shops with custom parameters
  List<Shop> getFilteredShops({
    String query = '',
    ShopFilter filter = ShopFilter.all,
    ShopSort sort = ShopSort.name,
  }) {
    var filtered = List<Shop>.from(_shops);

    // Apply search query
    if (query.isNotEmpty) {
      filtered =
          filtered.where((shop) {
            return shop.name.toLowerCase().contains(query.toLowerCase()) ||
                shop.description.toLowerCase().contains(query.toLowerCase()) ||
                shop.tagline.toLowerCase().contains(query.toLowerCase()) ||
                shop.categoryText.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }

    // Apply category filter
    if (filter != ShopFilter.all) {
      filtered =
          filtered.where((shop) {
            switch (filter) {
              case ShopFilter.verified:
                return shop.isVerified;
              case ShopFilter.premium:
                return shop.isPremium;
              case ShopFilter.nearby:
                return shop.distanceFromUser <= 10.0; // Default 10km radius
              default:
                return shop.category == _getCategoryFromFilter(filter);
            }
          }).toList();
    }

    // Apply sorting
    switch (sort) {
      case ShopSort.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ShopSort.rating:
        filtered.sort(
          (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
        );
        break;
      case ShopSort.distance:
        filtered.sort(
          (a, b) => a.distanceFromUser.compareTo(b.distanceFromUser),
        );
        break;
      case ShopSort.newest:
        filtered.sort((a, b) => b.joinedDate.compareTo(a.joinedDate));
        break;
      case ShopSort.oldest:
        filtered.sort((a, b) => a.joinedDate.compareTo(b.joinedDate));
        break;
      case ShopSort.mostProducts:
        filtered.sort((a, b) => b.totalProducts.compareTo(a.totalProducts));
        break;
      case ShopSort.mostOrders:
        filtered.sort((a, b) => b.totalOrders.compareTo(a.totalOrders));
        break;
    }

    return filtered;
  }
}
