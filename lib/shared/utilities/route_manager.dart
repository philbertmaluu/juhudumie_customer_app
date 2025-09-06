import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/splash/src/splash_module.dart';
import '../../modules/onboarding/src/onboarding_module.dart';
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
    home: (context) => const HomeScreen(),

    // Authentication routes (placeholder for future implementation)
    auth: (context) => const PlaceholderScreen(title: 'Authentication'),
    login: (context) => const PlaceholderScreen(title: 'Login'),
    register: (context) => const PlaceholderScreen(title: 'Register'),

    // User profile routes (placeholder for future implementation)
    profile: (context) => const PlaceholderScreen(title: 'Profile'),
    settings: (context) => const PlaceholderScreen(title: 'Settings'),

    // E-commerce routes (placeholder for future implementation)
    cart: (context) => const PlaceholderScreen(title: 'Shopping Cart'),
    checkout: (context) => const PlaceholderScreen(title: 'Checkout'),
    orders: (context) => const PlaceholderScreen(title: 'Orders'),
    products: (context) => const PlaceholderScreen(title: 'Products'),
    productDetail:
        (context) => const PlaceholderScreen(title: 'Product Detail'),
    categories: (context) => const PlaceholderScreen(title: 'Categories'),
    search: (context) => const PlaceholderScreen(title: 'Search'),
    favorites: (context) => const PlaceholderScreen(title: 'Favorites'),

    // Utility routes (placeholder for future implementation)
    notifications: (context) => const PlaceholderScreen(title: 'Notifications'),
    help: (context) => const PlaceholderScreen(title: 'Help & Support'),
    about: (context) => const PlaceholderScreen(title: 'About'),
  };

  /// Get initial route
  static String get initialRoute => splash;

  /// Navigate to a route
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Navigate to a route and replace current route
  static Future<T?> navigateToReplacement<
    T extends Object?,
    TO extends Object?
  >(BuildContext context, String routeName, {Object? arguments, TO? result}) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate to a route and clear all previous routes
  static Future<T?> navigateToAndClearStack<T extends Object?>(
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

  /// Pop current route
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
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
    return Scaffold(
      appBar: AppGradientComponents.gradientAppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed:
                () => AppRouteManager.navigateToAndClearStack(
                  context,
                  AppRouteManager.home,
                ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              Theme.of(context).brightness == Brightness.dark
                  ? const LinearGradient(
                    colors: [AppColors.darkBackground, AppColors.darkSurface],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : AppColors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppGradientComponents.gradientIcon(Icons.construction, size: 80),
              AppSpacing.gapVerticalXxl,
              Text(
                title,
                style: AppTextStyles.headingLarge,
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                AppSpacing.gapVerticalSm,
                Text(
                  subtitle!,
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
              AppSpacing.gapVerticalLg,
              Text(
                'This screen is under construction',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalLg,
              ElevatedButton(
                onPressed: () => AppRouteManager.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Home screen widget (moved from main.dart)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        final config = SliverAppBarModule.appBarConfig;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Custom sliver app bar
              SliverAppBarModule.getCustomSliverAppBar(
                config: config,
                pinned: true,
                floating: false,
                snap: false,
              ),

              // Content section
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient:
                        isDarkMode
                            ? AppColors.darkBackgroundGradient
                            : AppColors.backgroundGradient,
                  ),
                  child: Column(
                    children: [
                      // Promotions grid
                      _buildPromotionsSection(context, isDarkMode),

                      // Sample content
                      _buildSampleContent(context, isDarkMode, themeManager),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton:
              AppGradientComponents.gradientFloatingActionButton(
                onPressed:
                    () => AppRouteManager.navigateTo(
                      context,
                      AppRouteManager.products,
                    ),
                child: const Icon(Icons.add),
              ),
        );
      },
    );
  }

  /// Build promotions section
  Widget _buildPromotionsSection(BuildContext context, bool isDarkMode) {
    final promotions = SliverAppBarModule.getActivePromotions();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Promotions',
            style: AppTextStyles.headingMedium.copyWith(
              color:
                  isDarkMode ? AppColors.onDarkSurface : AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Promotions grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promotion = promotions[index];
              return _buildPromotionCard(context, promotion, isDarkMode);
            },
          ),
        ],
      ),
    );
  }

  /// Build individual promotion card
  Widget _buildPromotionCard(
    BuildContext context,
    dynamic promotion,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onBackground.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppColors.darkShadow : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promotion type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                SliverAppBarService.getPromotionTypeDisplayName(promotion.type),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // Promotion title
            Text(
              promotion.title,
              style: AppTextStyles.bodyLarge.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Promotion subtitle
            Text(
              promotion.subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build sample content
  Widget _buildSampleContent(
    BuildContext context,
    bool isDarkMode,
    ThemeManager themeManager,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Products',
            style: AppTextStyles.headingMedium.copyWith(
              color:
                  isDarkMode ? AppColors.onDarkSurface : AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Sample product cards
          ...List.generate(
            3,
            (index) => _buildSampleProductCard(context, index, isDarkMode),
          ),

          AppSpacing.gapVerticalXxl,

          // Theme toggle button
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (themeManager.isDarkMode) {
                  themeManager.setLightTheme();
                } else {
                  themeManager.setDarkTheme();
                }
              },
              child: Text(themeManager.isDarkMode ? 'Light Mode' : 'Dark Mode'),
            ),
          ),
        ],
      ),
    );
  }

  /// Build sample product card
  Widget _buildSampleProductCard(
    BuildContext context,
    int index,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onBackground.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.1)
                      : AppColors.onBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.6)
                      : AppColors.onBackground.withOpacity(0.6),
            ),
          ),

          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample Product ${index + 1}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'High-quality product description',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.7)
                            : AppColors.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(index + 1) * 25}.99',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get the appropriate theme icon based on current theme mode
  IconData _getThemeIcon(ThemeManager themeManager) {
    switch (themeManager.themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Show theme selection menu
  void _showThemeMenu(BuildContext context, ThemeManager themeManager) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose Theme', style: AppTextStyles.headingMedium),
                AppSpacing.gapVerticalLg,
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: const Text('Light'),
                  subtitle: const Text('Always use light theme'),
                  trailing:
                      themeManager.themeMode == ThemeMode.light
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                  onTap: () {
                    themeManager.setLightTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Dark'),
                  subtitle: const Text('Always use dark theme'),
                  trailing:
                      themeManager.themeMode == ThemeMode.dark
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                  onTap: () {
                    themeManager.setDarkTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_auto),
                  title: const Text('System'),
                  subtitle: const Text('Follow system theme'),
                  trailing:
                      themeManager.themeMode == ThemeMode.system
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                  onTap: () {
                    themeManager.setSystemTheme();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
