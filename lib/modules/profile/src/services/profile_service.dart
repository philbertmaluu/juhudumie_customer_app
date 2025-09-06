import '../models/profile_data.dart';

/// Service for managing user profile data
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  UserProfile? _userProfile;
  bool _isLoading = false;

  /// Get current user profile
  UserProfile? get userProfile => _userProfile;

  /// Check if profile is loading
  bool get isLoading => _isLoading;

  /// Load user profile
  Future<UserProfile?> loadProfile() async {
    _isLoading = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Load sample profile data
      _userProfile = _getSampleProfile();
      return _userProfile;
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile(UserProfile updatedProfile) async {
    try {
      _isLoading = true;

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      _userProfile = updatedProfile;
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
    }
  }

  /// Get profile menu sections
  List<ProfileSection> getProfileMenuSections() {
    return [
      // Account section
      ProfileSection(
        title: 'Account',
        items: [
          ProfileMenuItem(
            id: 'orders',
            title: 'My Orders',
            subtitle: 'Track and manage your orders',
            icon: '📦',
            badge: '3',
          ),
          ProfileMenuItem(
            id: 'wishlist',
            title: 'Wishlist',
            subtitle: 'Items you saved for later',
            icon: '❤️',
            badge: '12',
          ),
          ProfileMenuItem(
            id: 'reviews',
            title: 'My Reviews',
            subtitle: 'Reviews you\'ve written',
            icon: '⭐',
            badge: '8',
          ),
          ProfileMenuItem(
            id: 'addresses',
            title: 'Addresses',
            subtitle: 'Manage your delivery addresses',
            icon: '📍',
          ),
          ProfileMenuItem(
            id: 'payment_methods',
            title: 'Payment Methods',
            subtitle: 'Manage your payment options',
            icon: '💳',
          ),
        ],
      ),

      // Shopping section
      ProfileSection(
        title: 'Shopping',
        items: [
          ProfileMenuItem(
            id: 'coupons',
            title: 'Coupons & Vouchers',
            subtitle: 'Your available discounts',
            icon: '🎫',
            badge: '5',
          ),
          ProfileMenuItem(
            id: 'points',
            title: 'Reward Points',
            subtitle: 'Earn and redeem points',
            icon: '🎁',
            badge: '2,450',
          ),
          ProfileMenuItem(
            id: 'subscriptions',
            title: 'Subscriptions',
            subtitle: 'Manage your subscriptions',
            icon: '🔄',
          ),
          ProfileMenuItem(
            id: 'recommendations',
            title: 'Recommendations',
            subtitle: 'Personalized for you',
            icon: '🎯',
          ),
        ],
      ),

      // Support section
      ProfileSection(
        title: 'Support',
        items: [
          ProfileMenuItem(
            id: 'help_center',
            title: 'Help Center',
            subtitle: 'Get help and support',
            icon: '❓',
          ),
          ProfileMenuItem(
            id: 'contact_us',
            title: 'Contact Us',
            subtitle: 'Get in touch with us',
            icon: '📞',
          ),
          ProfileMenuItem(
            id: 'feedback',
            title: 'Feedback',
            subtitle: 'Share your thoughts',
            icon: '💬',
          ),
          ProfileMenuItem(
            id: 'report_issue',
            title: 'Report an Issue',
            subtitle: 'Report problems or bugs',
            icon: '🐛',
          ),
        ],
      ),

      // Settings section
      ProfileSection(
        title: 'Settings',
        items: [
          ProfileMenuItem(
            id: 'notifications',
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            icon: '🔔',
          ),
          ProfileMenuItem(
            id: 'privacy',
            title: 'Privacy & Security',
            subtitle: 'Control your privacy settings',
            icon: '🔒',
          ),
          ProfileMenuItem(
            id: 'language',
            title: 'Language & Region',
            subtitle: 'Change language and region',
            icon: '🌍',
          ),
          ProfileMenuItem(
            id: 'about',
            title: 'About',
            subtitle: 'App version and info',
            icon: 'ℹ️',
          ),
        ],
      ),
    ];
  }

  /// Get sample user profile
  UserProfile _getSampleProfile() {
    return UserProfile(
      id: '1',
      name: 'John Mwalimu',
      email: 'john.mwalimu@email.com',
      phone: '+255 123 456 789',
      avatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      coverImage:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      bio:
          'Passionate shopper and tech enthusiast. Love discovering new products and sharing reviews with the community.',
      location: 'Dar es Salaam, Tanzania',
      dateOfBirth: DateTime(1990, 5, 15),
      gender: 'Male',
      isVerified: true,
      isPremium: true,
      joinDate: DateTime(2022, 3, 10),
      stats: UserStats(
        totalOrders: 47,
        totalSpent: 1250000,
        totalReviews: 23,
        averageRating: 4.8,
        wishlistItems: 12,
        following: 156,
        followers: 89,
        points: 2450,
        membershipLevel: 'Gold',
      ),
      addresses: [
        UserAddress(
          id: '1',
          title: 'Home',
          fullName: 'John Mwalimu',
          phone: '+255 123 456 789',
          address: '123 Mlimani Street',
          city: 'Dar es Salaam',
          region: 'Dar es Salaam',
          postalCode: '11000',
          country: 'Tanzania',
          isDefault: true,
          isHome: true,
        ),
        UserAddress(
          id: '2',
          title: 'Work',
          fullName: 'John Mwalimu',
          phone: '+255 123 456 789',
          address: '456 Business District',
          city: 'Dar es Salaam',
          region: 'Dar es Salaam',
          postalCode: '11001',
          country: 'Tanzania',
          isWork: true,
        ),
      ],
      paymentMethods: [
        PaymentMethod(
          id: '1',
          type: 'mobile_money',
          name: 'M-Pesa',
          lastFourDigits: '1234',
          provider: 'Vodacom',
          isDefault: true,
        ),
        PaymentMethod(
          id: '2',
          type: 'card',
          name: 'Visa Card',
          lastFourDigits: '5678',
          provider: 'CRDB Bank',
        ),
      ],
      preferences: UserPreferences(
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: false,
        language: 'en',
        currency: 'TSh',
        theme: 'system',
        locationServices: true,
        analyticsTracking: true,
      ),
    );
  }

  /// Clear profile data
  void clearProfile() {
    _userProfile = null;
  }
}
