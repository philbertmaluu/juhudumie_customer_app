import '../models/product_details_data.dart';
import '../../../landing/src/models/product_data.dart';
import '../../../landing/src/services/product_service.dart';

/// Service for managing product details and cart operations
class ProductDetailsService {
  static final ProductDetailsService _instance =
      ProductDetailsService._internal();
  factory ProductDetailsService() => _instance;
  ProductDetailsService._internal();

  final List<CartItem> _cartItems = [];
  final ProductService _productService = ProductService();

  /// Get product details by ID
  ProductDetails getProductDetails(String productId) {
    // Get base product from product service
    final products = _productService.getFeaturedProducts();
    final baseProduct = products.firstWhere(
      (product) => product.id == productId,
      orElse: () => products.first,
    );

    // Convert to detailed product
    return _convertToProductDetails(baseProduct);
  }

  /// Convert base product to detailed product
  ProductDetails _convertToProductDetails(Product product) {
    return ProductDetails(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      originalPrice: product.originalPrice,
      imageUrl: product.imageUrl,
      vendorName: product.vendorName,
      vendorLogo: product.vendorLogo,
      rating: product.rating,
      reviewCount: product.reviewCount,
      soldCount: product.soldCount,
      tags: product.tags,
      isOnSale: product.isOnSale,
      isNew: product.isNew,
      isVerified: product.isVerified,
      category: product.category,
      brand: product.brand,
      images: product.images,
      specifications: product.specifications,
      imageUrls: _getProductImages(product.id),
      detailedDescription: _getProductDescription(product.id),
      detailedSpecifications: _getProductSpecifications(product.id),
      features: _getProductFeatures(product.id),
      warranty: _getProductWarranty(product.id),
      shippingInfo: _getShippingInfo(product.id),
      stockQuantity: _getStockQuantity(product.id),
      isInStock: _getIsInStock(product.id),
      averageRating: product.rating,
      totalReviews: product.reviewCount,
      reviews: _getProductReviews(product.id),
      relatedProducts: _getRelatedProducts(product.id),
    );
  }

  /// Get product images
  List<String> _getProductImages(String productId) {
    final imageMap = {
      '1': [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500',
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=500',
        'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      ],
      '2': [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
        'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500',
        'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=500',
      ],
      '3': [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500',
        'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=500',
      ],
    };
    return imageMap[productId] ?? [imageMap['1']!.first];
  }

  /// Get product description
  String _getProductDescription(String productId) {
    final descriptions = {
      '1':
          'Experience premium sound quality with these wireless Bluetooth headphones. Featuring active noise cancellation, 30-hour battery life, and comfortable over-ear design. Perfect for music lovers, gamers, and professionals who demand the best audio experience.',
      '2':
          'Track your fitness goals with this advanced smart fitness watch. Monitor heart rate, sleep patterns, GPS tracking, and receive notifications. Water-resistant design with 7-day battery life. Your perfect companion for an active lifestyle.',
      '3':
          'Celebrate special moments with this beautifully decorated birthday cake. Made with premium ingredients and custom decorations. Available in various flavors and sizes. Perfect for birthdays, anniversaries, and celebrations.',
    };
    return descriptions[productId] ??
        'High-quality product with excellent features and performance.';
  }

  /// Get product specifications
  List<String> _getProductSpecifications(String productId) {
    final specs = {
      '1': [
        'Driver Size: 40mm',
        'Frequency Response: 20Hz - 20kHz',
        'Battery Life: 30 hours',
        'Charging Time: 2 hours',
        'Connectivity: Bluetooth 5.0',
        'Weight: 250g',
        'Noise Cancellation: Active',
      ],
      '2': [
        'Display: 1.4" AMOLED',
        'Battery Life: 7 days',
        'Water Resistance: 5ATM',
        'Sensors: Heart rate, GPS, Accelerometer',
        'Connectivity: Bluetooth 5.0',
        'Weight: 45g',
        'Compatibility: iOS & Android',
      ],
      '3': [
        'Size: 8 inches',
        'Flavor: Vanilla with chocolate frosting',
        'Serves: 8-10 people',
        'Allergens: Contains dairy, eggs, wheat',
        'Storage: Refrigerate',
        'Shelf Life: 3 days',
        'Decoration: Custom message available',
      ],
      '4': [
        'Screen Size: 6.7"',
        'Resolution: 1284 x 2778',
        'Storage: 256GB',
        'Camera: 12MP Triple',
        'Battery: 3687mAh',
        'Processor: A15 Bionic',
        'Operating System: iOS 15',
      ],
      '5': [
        'Processor: Intel Core i7',
        'RAM: 16GB',
        'Storage: 512GB SSD',
        'Graphics: NVIDIA RTX 3060',
        'Display: 15.6" FHD',
        'Battery: 4-cell',
        'Operating System: Windows 11',
      ],
      '6': [
        'Material: 100% Cotton',
        'Size: Available in S, M, L, XL',
        'Color: Navy Blue',
        'Care: Machine washable',
        'Origin: Made in Tanzania',
        'Style: Casual',
        'Season: All season',
      ],
      '7': [
        'Capacity: 500ml',
        'Material: Stainless Steel',
        'Insulation: 12 hours hot, 24 hours cold',
        'Lid: Leak-proof',
        'Weight: 350g',
        'Dimensions: 7.5" x 2.8"',
        'Warranty: 1 year',
      ],
      '8': [
        'Type: Running Shoes',
        'Size: Available in 6-12',
        'Material: Mesh upper, rubber sole',
        'Color: Black/White',
        'Weight: 280g',
        'Features: Cushioned, breathable',
        'Brand: Local Tanzanian',
      ],
      '9': [
        'Type: Smartphone',
        'Screen: 6.1" LCD',
        'Storage: 64GB',
        'Camera: 12MP',
        'Battery: 3000mAh',
        'OS: Android 12',
        'Price: Affordable',
      ],
      '10': [
        'Type: Laptop',
        'Screen: 14" HD',
        'RAM: 8GB',
        'Storage: 256GB SSD',
        'Processor: Intel i5',
        'OS: Windows 11',
        'Weight: 1.5kg',
      ],
    };
    return specs[productId] ??
        [
          'Brand: Generic',
          'Model: Standard',
          'Type: Electronic',
          'Warranty: 1 year',
        ];
  }

  /// Get product features
  List<String> _getProductFeatures(String productId) {
    final features = {
      '1': [
        'Active Noise Cancellation',
        '30-hour battery life',
        'Quick charge (10 min = 3 hours)',
        'Comfortable over-ear design',
        'Premium sound quality',
        'Foldable for easy storage',
      ],
      '2': [
        '24/7 heart rate monitoring',
        'Sleep tracking',
        'GPS tracking',
        'Water resistant',
        'Smart notifications',
        'Multiple sport modes',
      ],
      '3': [
        'Fresh daily baking',
        'Custom decorations',
        'Premium ingredients',
        'Various flavors available',
        'Delivery available',
        'Custom messages',
      ],
      '4': [
        'Large display',
        'Triple camera system',
        'Long battery life',
        'Fast processor',
        '5G connectivity',
        'Premium build quality',
      ],
      '5': [
        'High performance',
        'Gaming ready',
        'Fast SSD storage',
        'Dedicated graphics',
        'Backlit keyboard',
        'Long battery life',
      ],
      '6': [
        'Comfortable fit',
        'Durable material',
        'Easy care',
        'Classic style',
        'Local production',
        'Affordable price',
      ],
      '7': [
        'Excellent insulation',
        'Leak-proof design',
        'Durable construction',
        'Easy to clean',
        'BPA-free',
        'Long-lasting',
      ],
      '8': [
        'Comfortable cushioning',
        'Breathable material',
        'Durable sole',
        'Lightweight design',
        'Good traction',
        'Local brand',
      ],
      '9': [
        'Affordable price',
        'Good performance',
        'Latest Android',
        'Decent camera',
        'Reliable battery',
        'Local support',
      ],
      '10': [
        'Portable design',
        'Good performance',
        'Fast storage',
        'Latest Windows',
        'Lightweight',
        'Great value',
      ],
    };
    return features[productId] ??
        ['Premium quality', 'Excellent performance', 'Great value'];
  }

  /// Get product warranty
  String _getProductWarranty(String productId) {
    final warranties = {
      '1': '2 years manufacturer warranty',
      '2': '1 year manufacturer warranty',
      '3': 'Freshness guarantee - 3 days',
      '4': '1 year manufacturer warranty',
      '5': '2 years manufacturer warranty',
      '6': '6 months warranty',
      '7': '1 year warranty',
      '8': '6 months warranty',
      '9': '1 year warranty',
      '10': '2 years warranty',
    };
    return warranties[productId] ?? '1 year warranty';
  }

  /// Get shipping info
  String _getShippingInfo(String productId) {
    return 'Free shipping on orders over TSh 100,000. Standard delivery: 2-3 business days. Express delivery: 1 business day.';
  }

  /// Get stock quantity
  int _getStockQuantity(String productId) {
    final stock = {
      '1': 15,
      '2': 8,
      '3': 3,
      '4': 12,
      '5': 5,
      '6': 20,
      '7': 18,
      '8': 25,
      '9': 30,
      '10': 7,
    };
    return stock[productId] ?? 10;
  }

  /// Get stock status
  bool _getIsInStock(String productId) {
    return _getStockQuantity(productId) > 0;
  }

  /// Get product reviews
  List<ProductReview> _getProductReviews(String productId) {
    return [
      ProductReview(
        id: '1',
        userId: 'user1',
        userName: 'John Doe',
        userAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        rating: 5.0,
        comment:
            'Excellent product! Great quality and fast delivery. Highly recommended!',
        date: DateTime(2024, 1, 15),
        images: [],
        isVerified: true,
      ),
      ProductReview(
        id: '2',
        userId: 'user2',
        userName: 'Jane Smith',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100',
        rating: 4.5,
        comment:
            'Very good product. Minor issues but overall satisfied with the purchase.',
        date: DateTime(2024, 1, 10),
        images: [],
        isVerified: true,
      ),
    ];
  }

  /// Get related products
  List<Product> _getRelatedProducts(String productId) {
    final products = _productService.getFeaturedProducts();
    return products
        .where((product) => product.id != productId)
        .take(4)
        .toList();
  }

  /// Add item to cart
  void addToCart(ProductDetails product, int quantity) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = CartItem(
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        price: product.price,
        quantity: _cartItems[existingIndex].quantity + quantity,
        vendorName: product.vendorName,
        isInStock: product.isInStock,
      );
    } else {
      _cartItems.add(
        CartItem(
          productId: product.id,
          productName: product.name,
          productImage: product.imageUrl,
          price: product.price,
          quantity: quantity,
          vendorName: product.vendorName,
          isInStock: product.isInStock,
        ),
      );
    }
  }

  /// Get cart items
  List<CartItem> getCartItems() => List.unmodifiable(_cartItems);

  /// Get cart total
  double getCartTotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Get cart item count
  int getCartItemCount() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Clear cart
  void clearCart() {
    _cartItems.clear();
  }
}
