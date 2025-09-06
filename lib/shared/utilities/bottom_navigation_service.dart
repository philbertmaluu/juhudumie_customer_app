import 'package:flutter/material.dart';

/// Service to handle bottom navigation logic and page shifting
class BottomNavigationService {
  static const String _homeRoute = '/home';
  static const String _categoryRoute = '/category';
  static const String _messagesRoute = '/messages';
  static const String _cartRoute = '/cart';
  static const String _profileRoute = '/profile';

  /// Handle bottom navigation tap with consistent logic
  static void handleNavigationTap(
    BuildContext context,
    int index, {
    int? currentIndex,
    VoidCallback? onSamePageTap,
  }) {
    // If tapping the same page, execute custom callback or do nothing
    if (currentIndex != null && currentIndex == index) {
      if (onSamePageTap != null) {
        onSamePageTap();
      }
      return;
    }

    // Handle navigation based on selected tab
    switch (index) {
      case 0: // Home
        _navigateToHome(context);
        break;
      case 1: // Categories
        _navigateToCategories(context);
        break;
      case 2: // Messages
        _navigateToMessages(context);
        break;
      case 3: // Cart
        _navigateToCart(context);
        break;
      case 4: // Profile
        _navigateToProfile(context);
        break;
      default:
        _showComingSoonMessage(context, 'Unknown page');
    }
  }

  /// Navigate to home page
  static void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(_homeRoute, (route) => false);
  }

  /// Navigate to categories page
  static void _navigateToCategories(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(_categoryRoute, (route) => false);
  }

  /// Navigate to messages page
  static void _navigateToMessages(BuildContext context) {
    _showComingSoonMessage(context, 'Messages');
  }

  /// Navigate to cart page
  static void _navigateToCart(BuildContext context) {
    _showComingSoonMessage(context, 'Cart');
  }

  /// Navigate to profile page
  static void _navigateToProfile(BuildContext context) {
    _showComingSoonMessage(context, 'Profile');
  }

  /// Show coming soon message for unimplemented features
  static void _showComingSoonMessage(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Get the current bottom navigation index based on current route
  static int getCurrentIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case _homeRoute:
        return 0;
      case _categoryRoute:
        return 1;
      case _messagesRoute:
        return 2;
      case _cartRoute:
        return 3;
      case _profileRoute:
        return 4;
      default:
        return 0; // Default to home
    }
  }

  /// Check if a route is currently active
  static bool isRouteActive(BuildContext context, String route) {
    return ModalRoute.of(context)?.settings.name == route;
  }

  /// Get all available routes
  static List<String> getAllRoutes() {
    return [
      _homeRoute,
      _categoryRoute,
      _messagesRoute,
      _cartRoute,
      _profileRoute,
    ];
  }

  /// Get route name by index
  static String getRouteByIndex(int index) {
    switch (index) {
      case 0:
        return _homeRoute;
      case 1:
        return _categoryRoute;
      case 2:
        return _messagesRoute;
      case 3:
        return _cartRoute;
      case 4:
        return _profileRoute;
      default:
        return _homeRoute;
    }
  }

  /// Get index by route name
  static int getIndexByRoute(String route) {
    switch (route) {
      case _homeRoute:
        return 0;
      case _categoryRoute:
        return 1;
      case _messagesRoute:
        return 2;
      case _cartRoute:
        return 3;
      case _profileRoute:
        return 4;
      default:
        return 0;
    }
  }
}
