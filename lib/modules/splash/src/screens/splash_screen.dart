import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/route_manager.dart';
import '../services/splash_service.dart';
import '../../../onboarding/src/services/onboarding_service.dart';

/// Splash screen widget with gradient design and app initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo scale and rotation animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Text fade animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Overall fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startSplashSequence() async {
    // Start logo animation
    _logoController.forward();

    // Start text animation after a delay
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Initialize app services
    await SplashService.initialize();

    // Wait for minimum splash time
    await Future.delayed(const Duration(milliseconds: 2000));

    // Start fade out animation
    _fadeController.forward();

    // Navigate to appropriate screen after fade completes
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      final shouldShowOnboarding =
          await OnboardingService.shouldShowOnboarding();
      if (shouldShowOnboarding) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRouteManager.onboarding, (route) => false);
      } else {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRouteManager.home, (route) => false);
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? AppColors.darkPrimaryGradient
                  : AppColors.primaryGradient,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with scale and rotation animation
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotationAnimation.value * 0.1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Loading indicator surrounding the logo
                            FadeTransition(
                              opacity: _textFadeAnimation,
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDarkMode
                                        ? AppColors.onDarkSurface.withOpacity(
                                          0.7,
                                        )
                                        : AppColors.onPrimary.withOpacity(0.7),
                                  ),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            // Logo container
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? AppColors.onDarkSurface.withOpacity(
                                          0.1,
                                        )
                                        : AppColors.onPrimary.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isDarkMode
                                          ? AppColors.onDarkSurface.withOpacity(
                                            0.3,
                                          )
                                          : AppColors.onPrimary.withOpacity(
                                            0.3,
                                          ),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.shopping_bag,
                                size: 60,
                                color:
                                    isDarkMode
                                        ? AppColors.onDarkSurface
                                        : AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                AppSpacing.gapVerticalXxl,

                // App name with fade animation
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Jihudumie',
                        style: AppTextStyles.headingLarge.copyWith(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface
                                  : AppColors.onPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      AppSpacing.gapVerticalSm,
                      Text(
                        'Your Shopping Companion',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface.withOpacity(0.8)
                                  : AppColors.onPrimary.withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
