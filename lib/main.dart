import 'package:flutter/material.dart';
import 'shared/theme/index.dart';

void main() {
  runApp(const JihudumieApp());
}

class JihudumieApp extends StatelessWidget {
  const JihudumieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jihudumie Customer App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jihudumie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 80, color: AppColors.primary),
              SizedBox(height: 24),
              Text(
                'Welcome to Jihudumie',
                style: AppTextStyles.headingLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Your one-stop shop for everything you need',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
