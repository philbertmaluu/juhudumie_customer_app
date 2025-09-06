import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/route_manager.dart';
import '../models/onboarding_data.dart';
import '../services/onboarding_service.dart';

/// Main onboarding screen with page view and navigation
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingService.totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() async {
    await OnboardingService.skipOnboarding();
    if (mounted) {
      AppRouteManager.navigateToAndClearStack(context, AppRouteManager.home);
    }
  }

  void _completeOnboarding() async {
    await OnboardingService.completeOnboarding();
    if (mounted) {
      AppRouteManager.navigateToAndClearStack(context, AppRouteManager.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final steps = OnboardingService.onboardingSteps;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? AppColors.darkBackgroundGradient
                  : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button (top right only)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface.withOpacity(0.7)
                                  : AppColors.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    return OnboardingStepWidget(data: steps[index]);
                  },
                ),
              ),

              // Bottom navigation area
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicators (right side)
                    Row(
                      children: List.generate(
                        steps.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? AppColors.primary
                                    : (isDarkMode
                                        ? AppColors.onDarkSurface.withOpacity(
                                          0.3,
                                        )
                                        : AppColors.onBackground.withOpacity(
                                          0.3,
                                        )),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Floating action button (left side)
                    FloatingActionButton(
                      onPressed:
                          _currentPage < steps.length - 1
                              ? _nextPage
                              : _completeOnboarding,
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: const CircleBorder(),
                      child: Icon(
                        _currentPage < steps.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual onboarding step widget
class OnboardingStepWidget extends StatelessWidget {
  final OnboardingData data;

  const OnboardingStepWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Onboarding image
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image fails to load
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? AppColors.darkSurface.withOpacity(0.3)
                              : AppColors.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.1)
                                : AppColors.onBackground.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _getStepIcon(),
                      size: 120,
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface.withOpacity(0.6)
                              : AppColors.onBackground.withOpacity(0.6),
                    ),
                  );
                },
              ),
            ),
          ),

          AppSpacing.gapVerticalXxl,

          // Title
          Text(
            data.title,
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),

          AppSpacing.gapVerticalLg,

          // Description
          Text(
            data.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.8)
                      : AppColors.onBackground.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),

          AppSpacing.gapVerticalXxl,
        ],
      ),
    );
  }

  /// Get appropriate icon for each step
  IconData _getStepIcon() {
    switch (data.title) {
      case 'Welcome to Jihudumie':
        return Icons.shopping_bag;
      case 'Amazing Features':
        return Icons.star;
      case 'Ready to Shop?':
        return Icons.rocket_launch;
      default:
        return Icons.shopping_cart;
    }
  }
}
