import 'package:flutter/material.dart';

/// Profile data models
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? coverImage;
  final String? bio;
  final String? location;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isVerified;
  final bool isPremium;
  final DateTime joinDate;
  final UserStats stats;
  final List<UserAddress> addresses;
  final List<PaymentMethod> paymentMethods;
  final UserPreferences preferences;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.coverImage,
    this.bio,
    this.location,
    this.dateOfBirth,
    this.gender,
    this.isVerified = false,
    this.isPremium = false,
    required this.joinDate,
    required this.stats,
    required this.addresses,
    required this.paymentMethods,
    required this.preferences,
  });

  /// Get display name with verification badge
  String get displayName => isVerified ? '$name ✓' : name;

  /// Get formatted join date
  String get formattedJoinDate {
    final now = DateTime.now();
    final difference = now.difference(joinDate);

    if (difference.inDays < 30) {
      return 'Joined ${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Joined $months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Joined $years year${years > 1 ? 's' : ''} ago';
    }
  }
}

/// User statistics
class UserStats {
  final int totalOrders;
  final int totalSpent;
  final int totalReviews;
  final double averageRating;
  final int wishlistItems;
  final int following;
  final int followers;
  final int points;
  final String membershipLevel;

  const UserStats({
    required this.totalOrders,
    required this.totalSpent,
    required this.totalReviews,
    required this.averageRating,
    required this.wishlistItems,
    required this.following,
    required this.followers,
    required this.points,
    required this.membershipLevel,
  });

  /// Get formatted total spent
  String get formattedTotalSpent => 'TSh ${totalSpent.toStringAsFixed(0)}';

  /// Get membership badge color
  String get membershipBadgeColor {
    switch (membershipLevel.toLowerCase()) {
      case 'gold':
        return '#FFD700';
      case 'silver':
        return '#C0C0C0';
      case 'bronze':
        return '#CD7F32';
      default:
        return '#6B7280';
    }
  }
}

/// User address
class UserAddress {
  final String id;
  final String title;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String region;
  final String postalCode;
  final String country;
  final bool isDefault;
  final bool isHome;
  final bool isWork;

  const UserAddress({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
    this.isHome = false,
    this.isWork = false,
  });

  /// Get formatted address
  String get formattedAddress =>
      '$address, $city, $region $postalCode, $country';

  /// Get address type icon
  String get addressTypeIcon {
    if (isHome) return '🏠';
    if (isWork) return '🏢';
    return '📍';
  }
}

/// Payment method
class PaymentMethod {
  final String id;
  final String type; // 'card', 'mobile_money', 'bank'
  final String name;
  final String? lastFourDigits;
  final String? provider;
  final bool isDefault;
  final bool isActive;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.lastFourDigits,
    this.provider,
    this.isDefault = false,
    this.isActive = true,
  });

  /// Get payment method icon
  String get icon {
    switch (type) {
      case 'card':
        return '💳';
      case 'mobile_money':
        return '📱';
      case 'bank':
        return '🏦';
      default:
        return '💰';
    }
  }

  /// Get display name
  String get displayName {
    if (lastFourDigits != null) {
      return '$name ****$lastFourDigits';
    }
    return name;
  }
}

/// User preferences
class UserPreferences {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final String language;
  final String currency;
  final String theme;
  final bool locationServices;
  final bool analyticsTracking;

  const UserPreferences({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.language = 'en',
    this.currency = 'TSh',
    this.theme = 'system',
    this.locationServices = true,
    this.analyticsTracking = true,
  });
}

/// Profile menu item
class ProfileMenuItem {
  final String id;
  final String title;
  final String? subtitle;
  final String icon;
  final String? badge;
  final bool hasArrow;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.badge,
    this.hasArrow = true,
    this.onTap,
  });
}

/// Profile section
class ProfileSection {
  final String title;
  final List<ProfileMenuItem> items;
  final bool showDivider;

  const ProfileSection({
    required this.title,
    required this.items,
    this.showDivider = true,
  });
}
