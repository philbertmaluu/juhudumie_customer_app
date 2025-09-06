import 'package:flutter/material.dart';
import 'components/custom_sliver_appbar.dart';
import 'components/custom_bottom_navbar.dart';

import 'services/sliver_appbar_service.dart';
import 'models/promotion_data.dart';

/// Sliver app bar module for handling custom app bar with promotions
class SliverAppBarModule {
  // Private constructor to prevent instantiation
  SliverAppBarModule._();

  /// Get the custom sliver app bar widget
  static Widget getCustomSliverAppBar({
    SliverAppBarConfig? config,
    Widget? title,
    List<Widget>? actions,
    bool pinned = true,
    bool floating = false,
    bool snap = false,
    double? expandedHeight,
    double? collapsedHeight,
  }) {
    return CustomSliverAppBar(
      config: config ?? SliverAppBarService.appBarConfig,
      title: title,
      actions: actions,
      pinned: pinned,
      floating: floating,
      snap: snap,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
    );
  }

  /// Get app bar configuration
  static SliverAppBarConfig get appBarConfig =>
      SliverAppBarService.appBarConfig;

  /// Get active promotions
  static List<PromotionBanner> getActivePromotions() {
    return SliverAppBarService.getActivePromotions();
  }

  /// Get featured promotion
  static PromotionBanner? getFeaturedPromotion() {
    return SliverAppBarService.getFeaturedPromotion();
  }

  /// Check if there are active promotions
  static bool hasActivePromotions() {
    return SliverAppBarService.hasActivePromotions();
  }

  /// Get promotion count
  static int getPromotionCount() {
    return SliverAppBarService.getPromotionCount();
  }

  /// Get promotion by ID
  static PromotionBanner? getPromotionById(String id) {
    return SliverAppBarService.getPromotionById(id);
  }

  /// Get promotions by type
  static List<PromotionBanner> getPromotionsByType(PromotionType type) {
    return SliverAppBarService.getPromotionsByType(type);
  }

  /// Get custom bottom navigation bar
  static Widget getCustomBottomNavBar({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return CustomBottomNavBar(currentIndex: currentIndex, onTap: onTap);
  }

  /// Get floating bottom navigation bar wrapper
  static Widget getFloatingBottomNavBar({
    required int currentIndex,
    required Function(int) onTap,
    required Widget child,
  }) {
    return FloatingBottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      child: child,
    );
  }
}
