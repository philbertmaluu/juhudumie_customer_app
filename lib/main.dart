import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/theme/index.dart';
import 'modules/splash/src/splash_module.dart';

void main() {
  runApp(const JihudumieApp());
}

class JihudumieApp extends StatelessWidget {
  const JihudumieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProviderBuilder(
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Jihudumie Customer App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeManager.themeMode,
            home: SplashModule.splashScreen,
            routes: {
              '/home': (context) => const HomeScreen(),
              '/splash': (context) => SplashModule.splashScreen,
            },
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: MediaQuery.of(context).textScaler),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          appBar: AppGradientComponents.gradientAppBar(
            title: const Text('Jihudumie'),
            actions: [
              IconButton(
                icon: Icon(_getThemeIcon(themeManager)),
                onPressed: () => _showThemeMenu(context, themeManager),
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppGradientComponents.gradientIcon(
                    Icons.shopping_bag,
                    size: 80,
                  ),
                  AppSpacing.gapVerticalXxl,
                  Text(
                    'Welcome to Jihudumie',
                    style: AppTextStyles.headingLarge,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapVerticalLg,
                  Text(
                    'Your one-stop shop for everything you need',
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapVerticalLg,
                ],
              ),
            ),
          ),
          floatingActionButton:
              AppGradientComponents.gradientFloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
        );
      },
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
