import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/profile_data.dart';

/// Profile header component
class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEditProfile;
  final VoidCallback? onSettings;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onEditProfile,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            _buildProfileContent(isDarkMode),

            // Stats section
            _buildStatsSection(isDarkMode),

            AppSpacing.gapVerticalMd,
          ],
        ),
      ),
    );
  }

  /// Build top bar
  Widget _buildTopBar(bool isDarkMode) {
    return Padding(
      padding: AppSpacing.screenPaddingMd,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onSettings,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Build profile content
  Widget _buildProfileContent(bool isDarkMode) {
    return Padding(
      padding: AppSpacing.screenPaddingMd,
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
                profile.avatar != null
                    ? Image.network(
                      profile.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                    : _buildDefaultAvatar(),
          ),
        ),

        // Verification badge
        if (profile.isVerified)
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
                profile.displayName,
                style: AppTextStyles.headingMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (profile.isPremium)
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
          profile.email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        AppSpacing.gapVerticalXs,

        // Location
        if (profile.location != null)
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
                  profile.location!,
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
          profile.formattedJoinDate,
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
        onPressed: onEditProfile,
        icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
      ),
    );
  }

  /// Build stats section
  Widget _buildStatsSection(bool isDarkMode) {
    return Container(
      margin: AppSpacing.screenPaddingMd,
      padding: AppSpacing.cardPaddingMd,
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
            '${profile.stats.totalOrders}',
            Icons.shopping_bag_outlined,
          ),

          _buildStatDivider(),

          // Reviews
          _buildStatItem(
            'Reviews',
            '${profile.stats.totalReviews}',
            Icons.star_outline,
          ),

          _buildStatDivider(),

          // Points
          _buildStatItem(
            'Points',
            '${profile.stats.points}',
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
}
