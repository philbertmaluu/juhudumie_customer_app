import 'package:flutter/material.dart';
import '../models/category_data.dart';

/// Service for managing category data
class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  /// Get all categories
  List<Category> getAllCategories() {
    return [
      Category(
        id: '1',
        name: 'Electronics',
        description: 'Smartphones, laptops, gadgets and more',
        imageUrl:
            'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=500',
        icon: Icons.devices,
        color: Colors.blue,
        productCount: 156,
        subcategories: ['Smartphones', 'Laptops', 'Tablets', 'Accessories'],
        isPopular: true,
      ),
      Category(
        id: '2',
        name: 'Fashion',
        description: 'Clothing, shoes, accessories and style',
        imageUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500',
        icon: Icons.checkroom,
        color: Colors.pink,
        productCount: 234,
        subcategories: [
          'Men\'s Clothing',
          'Women\'s Clothing',
          'Shoes',
          'Accessories',
        ],
        isPopular: true,
      ),
      Category(
        id: '3',
        name: 'Home & Garden',
        description: 'Furniture, decor, tools and more',
        imageUrl:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500',
        icon: Icons.home,
        color: Colors.green,
        productCount: 89,
        subcategories: ['Furniture', 'Decor', 'Tools', 'Garden'],
        isNew: true,
      ),
      Category(
        id: '4',
        name: 'Sports & Fitness',
        description: 'Exercise equipment, sports gear and fitness',
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500',
        icon: Icons.sports,
        color: Colors.orange,
        productCount: 67,
        subcategories: [
          'Exercise Equipment',
          'Sports Gear',
          'Fitness',
          'Outdoor',
        ],
      ),
      Category(
        id: '5',
        name: 'Beauty & Health',
        description: 'Cosmetics, skincare, health products',
        imageUrl:
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500',
        icon: Icons.face,
        color: Colors.purple,
        productCount: 123,
        subcategories: ['Cosmetics', 'Skincare', 'Health', 'Personal Care'],
        isPopular: true,
      ),
      Category(
        id: '6',
        name: 'Books & Media',
        description: 'Books, movies, music and educational materials',
        imageUrl:
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500',
        icon: Icons.book,
        color: Colors.brown,
        productCount: 45,
        subcategories: ['Books', 'Movies', 'Music', 'Educational'],
      ),
      Category(
        id: '7',
        name: 'Automotive',
        description: 'Car parts, accessories and maintenance',
        imageUrl:
            'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=500',
        icon: Icons.directions_car,
        color: Colors.red,
        productCount: 78,
        subcategories: ['Parts', 'Accessories', 'Tools', 'Maintenance'],
      ),
      Category(
        id: '8',
        name: 'Food & Beverages',
        description: 'Fresh food, drinks and local specialties',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500',
        icon: Icons.restaurant,
        color: Colors.amber,
        productCount: 189,
        subcategories: [
          'Fresh Food',
          'Beverages',
          'Local Specialties',
          'Snacks',
        ],
        isPopular: true,
      ),
      Category(
        id: '9',
        name: 'Toys & Games',
        description: 'Children toys, games and entertainment',
        imageUrl:
            'https://images.unsplash.com/photo-1558060370-539c927b0d0b?w=500',
        icon: Icons.toys,
        color: Colors.cyan,
        productCount: 56,
        subcategories: [
          'Children Toys',
          'Board Games',
          'Video Games',
          'Educational',
        ],
      ),
      Category(
        id: '10',
        name: 'Jewelry & Watches',
        description: 'Rings, necklaces, watches and accessories',
        imageUrl:
            'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=500',
        icon: Icons.watch,
        color: Colors.indigo,
        productCount: 34,
        subcategories: ['Rings', 'Necklaces', 'Watches', 'Accessories'],
        isNew: true,
      ),
      Category(
        id: '11',
        name: 'Pet Supplies',
        description: 'Food, toys and accessories for pets',
        imageUrl:
            'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=500',
        icon: Icons.pets,
        color: Colors.teal,
        productCount: 42,
        subcategories: ['Pet Food', 'Toys', 'Accessories', 'Health'],
      ),
      Category(
        id: '12',
        name: 'Office Supplies',
        description: 'Stationery, equipment and office essentials',
        imageUrl:
            'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500',
        icon: Icons.business_center,
        color: Colors.grey,
        productCount: 67,
        subcategories: ['Stationery', 'Equipment', 'Furniture', 'Technology'],
      ),
    ];
  }

  /// Get popular categories
  List<Category> getPopularCategories() {
    return getAllCategories().where((category) => category.isPopular).toList();
  }

  /// Get new categories
  List<Category> getNewCategories() {
    return getAllCategories().where((category) => category.isNew).toList();
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    try {
      return getAllCategories().firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search categories by name
  List<Category> searchCategories(String query) {
    if (query.isEmpty) return getAllCategories();

    final lowercaseQuery = query.toLowerCase();
    return getAllCategories().where((category) {
      return category.name.toLowerCase().contains(lowercaseQuery) ||
          category.description.toLowerCase().contains(lowercaseQuery) ||
          category.subcategories.any(
            (sub) => sub.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  /// Get categories by color
  List<Category> getCategoriesByColor(Color color) {
    return getAllCategories()
        .where((category) => category.color == color)
        .toList();
  }

  /// Get categories with minimum product count
  List<Category> getCategoriesWithMinProducts(int minCount) {
    return getAllCategories()
        .where((category) => category.productCount >= minCount)
        .toList();
  }

  /// Get total number of categories
  int getTotalCategories() {
    return getAllCategories().length;
  }

  /// Get total number of products across all categories
  int getTotalProducts() {
    return getAllCategories().fold(
      0,
      (sum, category) => sum + category.productCount,
    );
  }
}
