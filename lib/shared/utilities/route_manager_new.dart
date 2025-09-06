import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/splash/src/splash_module.dart';
import '../../modules/onboarding/src/onboarding_module.dart';
import '../../modules/landing/src/landing_module.dart';
import '../../modules/sliver_appbar/src/sliver_appbar_module.dart';
import '../../modules/sliver_appbar/src/services/sliver_appbar_service.dart';
import '../theme/index.dart';

/// Route manager for handling app navigation and route definitions
class AppRouteManager {
  // Private constructor to prevent instantiation
  AppRouteManager._();

  /// Route names constants
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String sliverAppBarDemo = '/sliver-appbar-demo';
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String categories = '/categories';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';

  /// Get all app routes
  static Map<String, WidgetBuilder> get routes => {
    // Splash and Onboarding routes
    splash: (context) => SplashModule.splashScreen,
    onboarding: (context) => OnboardingModule.onboardingScreen,
    home: (context) => const LandingScreen(),

    // Authentication routes (placeholder for future implementation)
    auth: (context) => const PlaceholderScreen(title: 'Authentication'),
    login: (context) => const PlaceholderScreen(title: 'Login'),
    register: (context) => const PlaceholderScreen(title: 'Register'),

    // User profile routes (placeholder for future implementation)
    profile: (context) => const PlaceholderScreen(title: 'Profile'),
    settings: (context) => const PlaceholderScreen(title: 'Settings'),

    // Shopping routes (placeholder for future implementation)
    cart: (context) => const PlaceholderScreen(title: 'Shopping Cart'),
    checkout: (context) => const PlaceholderScreen(title: 'Checkout'),
    orders: (context) => const PlaceholderScreen(title: 'Orders'),

    // Product routes (placeholder for future implementation)
    products: (context) => const PlaceholderScreen(title: 'Products'),
    productDetail:
        (context) => const PlaceholderScreen(title: 'Product Detail'),
    categories: (context) => const PlaceholderScreen(title: 'Categories'),
    search: (context) => const PlaceholderScreen(title: 'Search'),

    // Other routes (placeholder for future implementation)
    favorites: (context) => const PlaceholderScreen(title: 'Favorites'),
    notifications: (context) => const PlaceholderScreen(title: 'Notifications'),
    help: (context) => const PlaceholderScreen(title: 'Help'),
    about: (context) => const PlaceholderScreen(title: 'About'),
  };

  /// Navigate to a specific route
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  static Future<T?> navigateAndReplace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate and clear all previous routes
  static Future<T?> navigateAndClearStack<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous screen
  static void goBack(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// Placeholder screen for routes that haven't been implemented yet
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PlaceholderScreen({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        foregroundColor:
            isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? AppColors.darkBackgroundGradient
                  : AppColors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.5)
                        : AppColors.onBackground.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.headingLarge.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onBackground,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.7)
                            : AppColors.onBackground.withOpacity(0.7),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'This screen is under development',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.5)
                          : AppColors.onBackground.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
