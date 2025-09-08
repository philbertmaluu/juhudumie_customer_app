import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/theme/index.dart';
import 'shared/utilities/route_manager.dart';
import 'modules/map/src/map_module.dart';
import 'modules/shops/src/shops_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Maps service
  await MapInitializationService.initialize();

  // Initialize shop service with sample data
  ShopService.instance.loadSampleData();

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
            initialRoute: AppRouteManager.initialRoute,
            routes: AppRouteManager.routes,
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
