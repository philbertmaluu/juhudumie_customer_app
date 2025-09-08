import 'package:flutter/material.dart';
import 'promotion_banner.dart' as banner;

/// Floating promotion banner that overlays content with z-index
class FloatingPromotionBanner extends StatefulWidget {
  final List<banner.PromotionMediaItem> mediaItems;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool showIndicators;
  final banner.DecorativeShape? fixedShape;
  final double topOffset;
  final bool isVisible;

  const FloatingPromotionBanner({
    super.key,
    required this.mediaItems,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.height = 180.0,
    this.padding,
    this.margin,
    this.shadows,
    this.onTap,
    this.showIndicators = true,
    this.fixedShape,
    this.topOffset = 0.0,
    this.isVisible = true,
  });

  @override
  State<FloatingPromotionBanner> createState() =>
      _FloatingPromotionBannerState();
}

class _FloatingPromotionBannerState extends State<FloatingPromotionBanner>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _slideController.forward();
    }
  }

  @override
  void didUpdateWidget(FloatingPromotionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _slideController.forward();
      } else {
        _slideController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Positioned(
              top: widget.topOffset,
              left: 0,
              right: 0,
              child: Container(
                height: widget.height,
                margin:
                    widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: banner.PromotionBanner(
                    mediaItems: widget.mediaItems,
                    autoPlay: widget.autoPlay,
                    autoPlayInterval: widget.autoPlayInterval,
                    height: widget.height,
                    padding: widget.padding,
                    margin: EdgeInsets.zero,
                    shadows:
                        [], // Remove shadows from inner banner since we handle it here
                    onTap: widget.onTap,
                    showIndicators: widget.showIndicators,
                    fixedShape: widget.fixedShape,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Wrapper widget that provides floating promotion banner functionality
class FloatingPromotionBannerWrapper extends StatefulWidget {
  final Widget child;
  final List<banner.PromotionMediaItem>? mediaItems;
  final bool showBanner;
  final double bannerHeight;
  final double topOffset;

  const FloatingPromotionBannerWrapper({
    super.key,
    required this.child,
    this.mediaItems,
    this.showBanner = true,
    this.bannerHeight = 180.0,
    this.topOffset = 0.0,
  });

  @override
  State<FloatingPromotionBannerWrapper> createState() =>
      _FloatingPromotionBannerWrapperState();
}

class _FloatingPromotionBannerWrapperState
    extends State<FloatingPromotionBannerWrapper> {
  bool _isBannerVisible = true;
  late ScrollController _scrollController;
  double _bannerTopOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _bannerTopOffset = widget.topOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;

    // Make banner stick to top when scrolling down
    if (currentOffset > widget.topOffset) {
      setState(() {
        _bannerTopOffset = 0.0; // Stick to top
        _isBannerVisible = true;
      });
    } else {
      setState(() {
        _bannerTopOffset = widget.topOffset - currentOffset; // Follow scroll
        _isBannerVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default media items if none provided
    final mediaItems =
        widget.mediaItems ??
        [
          const banner.PromotionMediaItem(
            id: '1',
            url:
                'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
            type: banner.MediaType.image,
            title: 'Discover Amazing Products',
            subtitle: 'Shop from verified vendors',
          ),
          const banner.PromotionMediaItem(
            id: '2',
            url:
                'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
            type: banner.MediaType.image,
            title: 'Fast & Reliable Delivery',
            subtitle: 'Get your orders delivered quickly',
          ),
          const banner.PromotionMediaItem(
            id: '3',
            url:
                'https://images.unsplash.com/photo-1556742111-a301076d9d18?w=800',
            type: banner.MediaType.image,
            title: 'Quality Guaranteed',
            subtitle: 'Premium products at great prices',
          ),
        ];

    return Stack(
      children: [
        // Main content
        widget.child,

        // Floating promotion banner
        if (widget.showBanner)
          FloatingPromotionBanner(
            mediaItems: mediaItems,
            height: widget.bannerHeight,
            topOffset: _bannerTopOffset,
            isVisible: _isBannerVisible,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Floating promotion banner tapped!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
      ],
    );
  }
}
