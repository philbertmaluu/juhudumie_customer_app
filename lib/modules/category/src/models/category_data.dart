import 'package:flutter/material.dart';

/// Category data model
class Category {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final IconData icon;
  final Color color;
  final int productCount;
  final List<String> subcategories;
  final bool isPopular;
  final bool isNew;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.color,
    required this.productCount,
    required this.subcategories,
    this.isPopular = false,
    this.isNew = false,
  });

  /// Create a copy of this category with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    IconData? icon,
    Color? color,
    int? productCount,
    List<String>? subcategories,
    bool? isPopular,
    bool? isNew,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      productCount: productCount ?? this.productCount,
      subcategories: subcategories ?? this.subcategories,
      isPopular: isPopular ?? this.isPopular,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, productCount: $productCount)';
  }
}

/// Subcategory data model
class Subcategory {
  final String id;
  final String name;
  final String categoryId;
  final String imageUrl;
  final IconData icon;
  final int productCount;

  const Subcategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imageUrl,
    required this.icon,
    required this.productCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subcategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Subcategory(id: $id, name: $name, productCount: $productCount)';
  }
}
