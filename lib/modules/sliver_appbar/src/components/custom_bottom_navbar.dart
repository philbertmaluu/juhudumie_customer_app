import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Custom floating bottom navigation bar component
class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: AppSpacing.screenPaddingMd,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                // Primary shadow
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(
                            0.4 * _shadowAnimation.value,
                          )
                          : Colors.black.withOpacity(
                            0.15 * _shadowAnimation.value,
                          ),
                  blurRadius: 20 * _shadowAnimation.value,
                  offset: Offset(0, 8 * _shadowAnimation.value),
                  spreadRadius: 2 * _shadowAnimation.value,
                ),
                // Secondary shadow for depth
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(
                            0.2 * _shadowAnimation.value,
                          )
                          : Colors.black.withOpacity(
                            0.08 * _shadowAnimation.value,
                          ),
                  blurRadius: 40 * _shadowAnimation.value,
                  offset: Offset(0, 16 * _shadowAnimation.value),
                  spreadRadius: 1 * _shadowAnimation.value,
                ),
                // Glow effect
                BoxShadow(
                  color: AppColors.primary.withOpacity(
                    0.1 * _shadowAnimation.value,
                  ),
                  blurRadius: 30 * _shadowAnimation.value,
                  offset: const Offset(0, 0),
                  spreadRadius: 3 * _shadowAnimation.value,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 80,
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: widget.currentIndex == 0,
                      isDarkMode: isDarkMode,
                      onTap: () => widget.onTap(0),
                    ),
                    _buildNavItem(
                      icon: Icons.category_rounded,
                      label: 'Categories',
                      isSelected: widget.currentIndex == 1,
                      isDarkMode: isDarkMode,
                      onTap: () => widget.onTap(1),
                    ),
                    _buildNavItem(
                      icon: Icons.store_rounded,
                      label: 'Shops',
                      isSelected: widget.currentIndex == 2,
                      isDarkMode: isDarkMode,
                      onTap: () => widget.onTap(2),
                    ),
                    _buildNavItem(
                      icon: Icons.message_rounded,
                      label: 'Messages',
                      isSelected: widget.currentIndex == 3,
                      isDarkMode: isDarkMode,
                      onTap: () => widget.onTap(3),
                    ),
                    _buildNavItem(
                      icon: Icons.shopping_cart_rounded,
                      label: 'Cart',
                      isSelected: widget.currentIndex == 4,
                      isDarkMode: isDarkMode,
                      onTap: () => widget.onTap(4),
                    ),
                    _buildNavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: widget.currentIndex == 5,
                      isDarkMode: isDarkMode,
                      onTap: () => widget.onTap(5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build individual navigation item
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () {
          // Add haptic feedback
          // HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedScale(
          scale: isSelected ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            padding: AppSpacing.cardPaddingSm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: AppSpacing.cardPaddingSm,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      icon,
                      key: ValueKey('$icon-$isSelected'),
                      size:
                          isSelected
                              ? AppSpacing.iconMd + 2
                              : AppSpacing.iconMd,
                      color:
                          isSelected
                              ? AppColors.primary
                              : isDarkMode
                              ? AppColors.onDarkSurface.withOpacity(0.6)
                              : AppColors.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                AppSpacing.gapVerticalXs,
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: isSelected ? 11 : 10,
                    color:
                        isSelected
                            ? AppColors.primary
                            : isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.6)
                            : AppColors.onSurface.withOpacity(0.6),
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating bottom navigation bar wrapper
class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Widget child;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main content
          child,
          // Floating bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(currentIndex: currentIndex, onTap: onTap),
          ),
        ],
      ),
    );
  }
}
