import '../models/product_data.dart';

/// Service for managing product data
class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  /// Get featured products
  List<Product> getFeaturedProducts() {
    return [
      Product(
        id: '1',
        name: 'Wireless Bluetooth Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 225000,
        originalPrice: 325000,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300',
        vendorName: 'TechGear Pro',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        rating: 4.5,
        reviewCount: 1250,
        soldCount: 8500,
        tags: ['Electronics', 'Audio', 'Wireless'],
        isOnSale: true,
        isNew: false,
        isVerified: true,
        category: 'Electronics',
        brand: 'TechGear',
        images: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300',
          'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=300',
        ],
        specifications: {
          'Battery Life': '30 hours',
          'Connectivity': 'Bluetooth 5.0',
          'Weight': '250g',
        },
      ),
      Product(
        id: '2',
        name: 'Smart Fitness Watch',
        description: 'Advanced fitness tracking with heart rate monitor',
        price: 500000,
        originalPrice: 625000,
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300',
        vendorName: 'FitTech Solutions',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        rating: 4.7,
        reviewCount: 2100,
        soldCount: 12000,
        tags: ['Electronics', 'Fitness', 'Smart Watch'],
        isOnSale: true,
        isNew: true,
        isVerified: true,
        category: 'Electronics',
        brand: 'FitTech',
        images: [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300',
          'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=300',
        ],
        specifications: {
          'Display': '1.4" AMOLED',
          'Battery Life': '7 days',
          'Water Resistance': '5ATM',
        },
      ),
      Product(
        id: '3',
        name: 'Premium Cotton T-Shirt',
        description: '100% organic cotton t-shirt with modern fit',
        price: 62500,
        originalPrice: 87500,
        imageUrl:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
        vendorName: 'EcoWear Fashion',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        rating: 4.3,
        reviewCount: 890,
        soldCount: 5600,
        tags: ['Fashion', 'Clothing', 'Organic'],
        isOnSale: true,
        isNew: false,
        isVerified: true,
        category: 'Fashion',
        brand: 'EcoWear',
        images: [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=300',
        ],
        specifications: {
          'Material': '100% Organic Cotton',
          'Care': 'Machine Washable',
          'Origin': 'Made in USA',
        },
      ),
      Product(
        id: '4',
        name: 'Professional Camera Lens',
        description:
            'High-quality 50mm f/1.8 lens for professional photography',
        price: 750000,
        originalPrice: 1000000,
        imageUrl:
            'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=300',
        vendorName: 'PhotoPro Equipment',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        rating: 4.8,
        reviewCount: 450,
        soldCount: 2100,
        tags: ['Electronics', 'Photography', 'Professional'],
        isOnSale: true,
        isNew: false,
        isVerified: true,
        category: 'Electronics',
        brand: 'PhotoPro',
        images: [
          'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=300',
          'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=300',
        ],
        specifications: {
          'Focal Length': '50mm',
          'Aperture': 'f/1.8',
          'Mount': 'Canon EF',
        },
      ),
      Product(
        id: '5',
        name: 'Ergonomic Office Chair',
        description: 'Comfortable ergonomic chair for long work sessions',
        price: 400000,
        originalPrice: 500000,
        imageUrl:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300',
        vendorName: 'OfficeComfort',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        rating: 4.4,
        reviewCount: 320,
        soldCount: 1800,
        tags: ['Furniture', 'Office', 'Ergonomic'],
        isOnSale: true,
        isNew: false,
        isVerified: true,
        category: 'Furniture',
        brand: 'OfficeComfort',
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300',
          'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=300',
        ],
        specifications: {
          'Material': 'Mesh & Foam',
          'Weight Capacity': '300 lbs',
          'Adjustable': 'Height & Armrests',
        },
      ),
      Product(
        id: '6',
        name: 'Wireless Charging Pad',
        description: 'Fast wireless charging pad for smartphones',
        price: 100000,
        originalPrice: 150000,
        imageUrl:
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=300',
        vendorName: 'ChargeTech',
        vendorLogo:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50',
        rating: 4.2,
        reviewCount: 650,
        soldCount: 4200,
        tags: ['Electronics', 'Charging', 'Wireless'],
        isOnSale: true,
        isNew: true,
        isVerified: true,
        category: 'Electronics',
        brand: 'ChargeTech',
        images: [
          'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=300',
          'https://images.unsplash.com/photo-1609592807905-1b3a1a473b1c?w=300',
        ],
        specifications: {
          'Power': '15W Fast Charging',
          'Compatibility': 'Qi Standard',
          'LED Indicator': 'Yes',
        },
      ),
    ];
  }

  /// Get products by category
  List<Product> getProductsByCategory(String category) {
    return getFeaturedProducts()
        .where((product) => product.category == category)
        .toList();
  }

  /// Get new products
  List<Product> getNewProducts() {
    return getFeaturedProducts().where((product) => product.isNew).toList();
  }

  /// Get sale products
  List<Product> getSaleProducts() {
    return getFeaturedProducts().where((product) => product.isOnSale).toList();
  }

  /// Get product categories
  List<ProductCategory> getCategories() {
    return [
      const ProductCategory(
        id: 'electronics',
        name: 'Electronics',
        icon: 'electronics',
        imageUrl:
            'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200',
        productCount: 1250,
      ),
      const ProductCategory(
        id: 'fashion',
        name: 'Fashion',
        icon: 'fashion',
        imageUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200',
        productCount: 890,
      ),
      const ProductCategory(
        id: 'home',
        name: 'Home & Garden',
        icon: 'home',
        imageUrl:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=200',
        productCount: 650,
      ),
      const ProductCategory(
        id: 'sports',
        name: 'Sports',
        icon: 'sports',
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200',
        productCount: 420,
      ),
      const ProductCategory(
        id: 'books',
        name: 'Books',
        icon: 'books',
        imageUrl:
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=200',
        productCount: 320,
      ),
      const ProductCategory(
        id: 'beauty',
        name: 'Beauty',
        icon: 'beauty',
        imageUrl:
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=200',
        productCount: 280,
      ),
    ];
  }

  /// Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return getFeaturedProducts();

    final lowercaseQuery = query.toLowerCase();
    return getFeaturedProducts().where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery) ||
          product.category.toLowerCase().contains(lowercaseQuery) ||
          product.brand.toLowerCase().contains(lowercaseQuery) ||
          product.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
}
