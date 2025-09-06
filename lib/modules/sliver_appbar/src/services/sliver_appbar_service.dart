import '../models/promotion_data.dart';

/// Service for managing sliver app bar data and promotions
class SliverAppBarService {
  // Private constructor to prevent instantiation
  SliverAppBarService._();

  /// Get sliver app bar configuration
  static SliverAppBarConfig get appBarConfig => SliverAppBarConfig(
    appLogo: 'assets/logo/jihudumie_logo.png', // You can add your logo here
    appName: 'Jihudumie',
    promotions: _getPromotions(),
    showSearchBar: true,
    showNotifications: true,
    showCart: true,
    expandedHeight: 350.0,
    collapsedHeight: 80.0,
  );

  /// Get sample promotions data
  static List<PromotionBanner> _getPromotions() {
    final now = DateTime.now();
    return [
      PromotionBanner(
        id: '1',
        title: 'Flash Sale!',
        subtitle: 'Up to 70% OFF on Electronics',
        imageUrl: 'assets/promotions/flash_sale.png',
        actionText: 'Shop Now',
        actionUrl: '/flash-sale',
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 3)),
        type: PromotionType.flashSale,
      ),
      PromotionBanner(
        id: '2',
        title: 'New Arrivals',
        subtitle: 'Discover the Latest Fashion Trends',
        imageUrl: 'assets/promotions/new_arrivals.png',
        actionText: 'Explore',
        actionUrl: '/new-arrivals',
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 7)),
        type: PromotionType.newArrival,
      ),
      PromotionBanner(
        id: '3',
        title: 'Seasonal Sale',
        subtitle: 'Winter Collection at Amazing Prices',
        imageUrl: 'assets/promotions/seasonal.png',
        actionText: 'View Collection',
        actionUrl: '/seasonal',
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 15)),
        type: PromotionType.seasonal,
      ),
      PromotionBanner(
        id: '4',
        title: 'Clearance',
        subtitle: 'Last Chance - Limited Stock Available',
        imageUrl: 'assets/promotions/clearance.png',
        actionText: 'Grab Deals',
        actionUrl: '/clearance',
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 2)),
        type: PromotionType.clearance,
      ),
    ];
  }

  /// Get promotion by ID
  static PromotionBanner? getPromotionById(String id) {
    try {
      return _getPromotions().firstWhere((promo) => promo.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get promotions by type
  static List<PromotionBanner> getPromotionsByType(PromotionType type) {
    return _getPromotions().where((promo) => promo.type == type).toList();
  }

  /// Get active promotions
  static List<PromotionBanner> getActivePromotions() {
    return _getPromotions().where((promo) => promo.isValid).toList();
  }

  /// Get featured promotion
  static PromotionBanner? getFeaturedPromotion() {
    final active = getActivePromotions();
    return active.isNotEmpty ? active.first : null;
  }

  /// Check if there are any active promotions
  static bool hasActivePromotions() {
    return getActivePromotions().isNotEmpty;
  }

  /// Get promotion count
  static int getPromotionCount() {
    return getActivePromotions().length;
  }

  /// Get promotion type display name
  static String getPromotionTypeDisplayName(PromotionType type) {
    switch (type) {
      case PromotionType.banner:
        return 'Banner';
      case PromotionType.flashSale:
        return 'Flash Sale';
      case PromotionType.newArrival:
        return 'New Arrivals';
      case PromotionType.seasonal:
        return 'Seasonal';
      case PromotionType.clearance:
        return 'Clearance';
    }
  }

  /// Get promotion type color (you can customize these)
  static String getPromotionTypeColor(PromotionType type) {
    switch (type) {
      case PromotionType.banner:
        return '#6366F1';
      case PromotionType.flashSale:
        return '#EF4444';
      case PromotionType.newArrival:
        return '#10B981';
      case PromotionType.seasonal:
        return '#F59E0B';
      case PromotionType.clearance:
        return '#8B5CF6';
    }
  }
}
