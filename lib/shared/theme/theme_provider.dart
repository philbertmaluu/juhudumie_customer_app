import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';

/// Theme provider builder widget using Provider
class ThemeProviderBuilder extends StatefulWidget {
  final Widget child;

  const ThemeProviderBuilder({super.key, required this.child});

  @override
  State<ThemeProviderBuilder> createState() => _ThemeProviderBuilderState();
}

class _ThemeProviderBuilderState extends State<ThemeProviderBuilder> {
  late ThemeManager _themeManager;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    await _themeManager.initialize();
  }

  @override
  void dispose() {
    _themeManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeManager>(
      create: (_) => _themeManager,
      child: widget.child,
    );
  }
}
