import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../../../game/src/game_module.dart';
import '../../../wishlist/src/wishlist_module.dart';
import '../models/profile_data.dart';
import '../services/profile_service.dart';
import '../components/profile_menu_section.dart';

/// Profile screen for user account management
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final ScrollController _scrollController = ScrollController();

  UserProfile? _userProfile;
  List<ProfileSection> _menuSections = [];
  bool _isLoading = true;
  int _currentBottomNavIndex = 5; // Profile tab is selected

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load profile data
  void _loadProfileData() {
    setState(() {
      _isLoading = true;
    });

    _profileService.loadProfile().then((profile) {
      setState(() {
        _userProfile = profile;
        _menuSections = _profileService.getProfileMenuSections();
        _isLoading = false;
      });
    });
  }

  /// Handle bottom navigation tap
  void _onBottomNavTap(int index) {
    // Store the previous index before updating
    final previousIndex = _currentBottomNavIndex;

    setState(() {
      _currentBottomNavIndex = index;
    });

    // Use the bottom navigation service for consistent navigation logic
    BottomNavigationService.handleNavigationTap(
      context,
      index,
      currentIndex: previousIndex,
      onSamePageTap: () {
        // Scroll to top when tapping profile while already on profile
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  /// Handle edit profile
  void _onEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature coming soon! ✏️'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  /// Handle theme toggle
  void _onThemeToggle() {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    themeManager.toggleTheme();
  }

  /// Handle menu item tap
  void _onMenuItemTap(ProfileMenuItem item) {
    // Handle different menu items
    switch (item.id) {
      case 'orders':
        _navigateToOrders();
        break;
      case 'wishlist':
        _showWishlistModal();
        break;
      case 'reviews':
        _showComingSoon('My Reviews');
        break;
      case 'addresses':
        _showComingSoon('Addresses');
        break;
      case 'payment_methods':
        _showComingSoon('Payment Methods');
        break;
      case 'coupons':
        _showComingSoon('Coupons & Vouchers');
        break;
      case 'points':
        _showComingSoon('Reward Points');
        break;
      case 'subscriptions':
        _showComingSoon('Subscriptions');
        break;
      case 'recommendations':
        _showComingSoon('Recommendations');
        break;
      case 'help_center':
        _showComingSoon('Help Center');
        break;
      case 'contact_us':
        _showComingSoon('Contact Us');
        break;
      case 'feedback':
        _showComingSoon('Feedback');
        break;
      case 'report_issue':
        _showComingSoon('Report an Issue');
        break;
      case 'notifications':
        _showComingSoon('Notifications');
        break;
      case 'privacy':
        _showComingSoon('Privacy & Security');
        break;
      case 'language':
        _showComingSoon('Language & Region');
        break;
      case 'about':
        _showAboutDialog();
        break;
      default:
        _showComingSoon(item.title);
    }
  }

  /// Navigate to orders tab in cart screen
  void _navigateToOrders() {
    // Navigate to cart screen with orders tab selected
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cart',
      (route) => false,
      arguments: {'initialTab': 1}, // 1 = Orders tab, 0 = Cart tab
    );
  }

  /// Show wishlist modal
  void _showWishlistModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WishlistModal(),
    );
  }

  /// Show coming soon message
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon! 🚀'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show about dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Jihudumie'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Version: 1.0.0'),
                SizedBox(height: 8),
                Text('Build: 2024.01.01'),
                SizedBox(height: 8),
                Text('A modern e-commerce platform for Tanzania.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBarModule.getFloatingBottomNavBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _onBottomNavTap,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        body: Stack(
          children: [
            _isLoading
                ? _buildLoadingState()
                : _buildProfileContent(isDarkMode),

            // Floating game button
            if (!_isLoading)
              FloatingGameButton(
                onTap: () {
                  Navigator.of(context).pushNamed('/game');
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build profile content
  Widget _buildProfileContent(bool isDarkMode) {
    if (_userProfile == null) {
      return _buildErrorState(isDarkMode);
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Sliver App Bar with profile header
        _buildSliverAppBar(isDarkMode),

        // Menu sections
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final section = _menuSections[index];
            return ProfileMenuSection(
              section: section,
              onItemTap: _onMenuItemTap,
            );
          }, childCount: _menuSections.length),
        ),

        // Bottom spacing
        SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.sm + 24), // Space for bottom nav
        ),
      ],
    );
  }

  /// Build sliver app bar
  Widget _buildSliverAppBar(bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 260.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient:
                isDarkMode
                    ? AppColors.darkPrimaryGradient
                    : AppColors.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top bar with settings
                _buildTopBar(isDarkMode),

                // Profile content
                _buildProfileHeaderContent(isDarkMode),

                // Stats section
                _buildStatsSection(isDarkMode),

                AppSpacing.gapVerticalSm,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build top bar
  Widget _buildTopBar(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer<ThemeManager>(
            builder: (context, themeManager, child) {
              return IconButton(
                onPressed: _onThemeToggle,
                icon: Icon(
                  themeManager.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build profile header content
  Widget _buildProfileHeaderContent(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),

          AppSpacing.gapHorizontalMd,

          // Profile info
          Expanded(child: _buildProfileInfo(isDarkMode)),

          // Edit button
          _buildEditButton(isDarkMode),
        ],
      ),
    );
  }

  /// Build avatar
  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child:
                _userProfile!.avatar != null
                    ? Image.network(
                      _userProfile!.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                    : _buildDefaultAvatar(),
          ),
        ),

        // Verification badge
        if (_userProfile!.isVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
          ),
      ],
    );
  }

  /// Build default avatar
  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.person, color: Colors.grey, size: 40),
    );
  }

  /// Build profile info
  Widget _buildProfileInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name with verification
        Row(
          children: [
            Expanded(
              child: Text(
                _userProfile!.displayName,
                style: AppTextStyles.headingMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_userProfile!.isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PREMIUM',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),

        AppSpacing.gapVerticalXs,

        // Email
        Text(
          _userProfile!.email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        AppSpacing.gapVerticalXs,

        // Location
        if (_userProfile!.location != null)
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 16,
              ),
              AppSpacing.gapHorizontalXs,
              Expanded(
                child: Text(
                  _userProfile!.location!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

        AppSpacing.gapVerticalXs,

        // Join date
        Text(
          _userProfile!.formattedJoinDate,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  /// Build edit button
  Widget _buildEditButton(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: _onEditProfile,
        icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
      ),
    );
  }

  /// Build stats section
  Widget _buildStatsSection(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Orders
          _buildStatItem(
            'Orders',
            '${_userProfile!.stats.totalOrders}',
            Icons.shopping_bag_outlined,
          ),

          _buildStatDivider(),

          // Reviews
          _buildStatItem(
            'Reviews',
            '${_userProfile!.stats.totalReviews}',
            Icons.star_outline,
          ),

          _buildStatDivider(),

          // Points
          _buildStatItem(
            'Points',
            '${_userProfile!.stats.points}',
            Icons.card_giftcard_outlined,
          ),
        ],
      ),
    );
  }

  /// Build stat item
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          AppSpacing.gapVerticalXs,
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build stat divider
  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.3),
    );
  }

  /// Build error state
  Widget _buildErrorState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 120,
              color: Colors.red.withOpacity(0.5),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              'Unable to load profile',
              style: AppTextStyles.headingMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Please check your connection and try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            ElevatedButton(
              onPressed: _loadProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
