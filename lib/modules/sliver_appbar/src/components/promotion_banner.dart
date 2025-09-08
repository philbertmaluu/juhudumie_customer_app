import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Media item for promotion banner
class PromotionMediaItem {
  final String id;
  final String url;
  final MediaType type;
  final String? title;
  final String? subtitle;
  final String? actionUrl;

  const PromotionMediaItem({
    required this.id,
    required this.url,
    required this.type,
    this.title,
    this.subtitle,
    this.actionUrl,
  });
}

/// Media types supported by promotion banner
enum MediaType { image, video }

/// Decorative shapes for promotion banner
enum DecorativeShape {
  chatBubble,
  organicBlob,
  fluidWave,
  softRounded,
  cloudShape,
  amoeba,
  liquid,
  organic,
}

/// Promotion banner widget with random decorative shapes and carousel support
class PromotionBanner extends StatefulWidget {
  final List<PromotionMediaItem> mediaItems;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool showIndicators;
  final DecorativeShape? fixedShape;

  const PromotionBanner({
    super.key,
    required this.mediaItems,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.height = 200.0,
    this.padding,
    this.margin,
    this.shadows,
    this.onTap,
    this.showIndicators = true,
    this.fixedShape,
  });

  @override
  State<PromotionBanner> createState() => _PromotionBannerState();
}

class _PromotionBannerState extends State<PromotionBanner>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  DecorativeShape _currentShape = DecorativeShape.chatBubble;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Select random shape if not fixed
    if (widget.fixedShape == null) {
      _selectRandomShape();
    } else {
      _currentShape = widget.fixedShape!;
    }

    _animationController.forward();

    if (widget.autoPlay && widget.mediaItems.length > 1) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _selectRandomShape() {
    final random = Random();
    final shapes = DecorativeShape.values;
    _currentShape = shapes[random.nextInt(shapes.length)];
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (mounted) {
        _nextSlide();
      }
    });
  }

  void _nextSlide() {
    if (_currentIndex < widget.mediaItems.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }

    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // Select new random shape for each slide
    if (widget.fixedShape == null) {
      _selectRandomShape();
      setState(() {});
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Select new random shape for each slide
    if (widget.fixedShape == null) {
      _selectRandomShape();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: widget.height,
      margin:
          widget.margin ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.9 + (0.1 * _animation.value),
            child: Opacity(
              opacity: _animation.value,
              child: _buildBannerContent(isDarkMode),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerContent(bool isDarkMode) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: widget.shadows ?? _getDefaultShadows(isDarkMode),
        ),
        child: ClipPath(
          clipper: _OrganicShapeClipper(),
          child: Stack(
            children: [
              // Decorative shape background
              _buildDecorativeShape(isDarkMode),

              // Media content
              _buildMediaContent(),

              // Gradient overlay for better text readability
              _buildGradientOverlay(),

              // Content overlay
              _buildContentOverlay(isDarkMode),

              // Page indicators
              if (widget.showIndicators && widget.mediaItems.length > 1)
                _buildPageIndicators(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeShape(bool isDarkMode) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _DecorativeShapePainter(
          shape: _currentShape,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: widget.mediaItems.length,
      itemBuilder: (context, index) {
        final mediaItem = widget.mediaItems[index];
        return _buildMediaItem(mediaItem);
      },
    );
  }

  Widget _buildMediaItem(PromotionMediaItem mediaItem) {
    switch (mediaItem.type) {
      case MediaType.image:
        return Image.network(
          mediaItem.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        );
      case MediaType.video:
        return Container(
          color: AppColors.primary.withOpacity(0.1),
          child: const Center(
            child: Icon(
              Icons.play_circle_filled,
              size: 60,
              color: AppColors.primary,
            ),
          ),
        );
    }
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
          ),
        ),
      ),
    );
  }

  Widget _buildContentOverlay(bool isDarkMode) {
    if (widget.mediaItems.isEmpty) return const SizedBox.shrink();

    final currentItem = widget.mediaItems[_currentIndex];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentItem.title != null)
              Text(
                currentItem.title!,
                style: AppTextStyles.headingSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (currentItem.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                currentItem.subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicators(bool isDarkMode) {
    return Positioned(
      top: 16,
      right: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.mediaItems.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  index == _currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _getDefaultShadows(bool isDarkMode) {
    return [
      BoxShadow(
        color:
            isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: AppColors.primary.withOpacity(0.1),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
}

/// Custom painter for decorative shapes
class _DecorativeShapePainter extends CustomPainter {
  final DecorativeShape shape;
  final bool isDarkMode;

  _DecorativeShapePainter({required this.shape, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (shape) {
      case DecorativeShape.chatBubble:
        _paintChatBubble(canvas, size, paint);
        break;
      case DecorativeShape.organicBlob:
        _paintOrganicBlob(canvas, size, paint);
        break;
      case DecorativeShape.fluidWave:
        _paintFluidWave(canvas, size, paint);
        break;
      case DecorativeShape.softRounded:
        _paintSoftRounded(canvas, size, paint);
        break;
      case DecorativeShape.cloudShape:
        _paintCloudShape(canvas, size, paint);
        break;
      case DecorativeShape.amoeba:
        _paintAmoeba(canvas, size, paint);
        break;
      case DecorativeShape.liquid:
        _paintLiquid(canvas, size, paint);
        break;
      case DecorativeShape.organic:
        _paintOrganic(canvas, size, paint);
        break;
    }
  }

  void _paintChatBubble(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Main bubble body with organic curves
    path.moveTo(width * 0.15, height * 0.1);
    path.quadraticBezierTo(
      width * 0.05,
      height * 0.05,
      width * 0.1,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.08,
      height * 0.3,
      width * 0.15,
      height * 0.4,
    );
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.5,
      width * 0.3,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.4,
      height * 0.7,
      width * 0.5,
      height * 0.75,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.8,
      width * 0.7,
      height * 0.75,
    );
    path.quadraticBezierTo(
      width * 0.8,
      height * 0.7,
      width * 0.85,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.5,
      width * 0.88,
      height * 0.4,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.3,
      width * 0.85,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.8,
      height * 0.1,
      width * 0.7,
      height * 0.08,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.05,
      width * 0.5,
      height * 0.08,
    );
    path.quadraticBezierTo(
      width * 0.4,
      height * 0.1,
      width * 0.3,
      height * 0.12,
    );
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.1,
      width * 0.15,
      height * 0.1,
    );

    // Chat bubble tail
    path.moveTo(width * 0.25, height * 0.8);
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.9,
      width * 0.1,
      height * 0.85,
    );
    path.quadraticBezierTo(
      width * 0.05,
      height * 0.8,
      width * 0.1,
      height * 0.75,
    );
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.78,
      width * 0.25,
      height * 0.8,
    );
    path.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary.withOpacity(0.15),
        AppColors.primary.withOpacity(0.08),
        AppColors.primary.withOpacity(0.12),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintOrganicBlob(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create a very organic, amoeba-like shape
    path.moveTo(width * 0.3, height * 0.1);
    path.quadraticBezierTo(
      width * 0.1,
      height * 0.05,
      width * 0.05,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.02,
      height * 0.4,
      width * 0.1,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.8,
      width * 0.3,
      height * 0.9,
    );
    path.quadraticBezierTo(
      width * 0.5,
      height * 0.95,
      width * 0.7,
      height * 0.9,
    );
    path.quadraticBezierTo(
      width * 0.85,
      height * 0.8,
      width * 0.9,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.95,
      height * 0.4,
      width * 0.9,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.85,
      height * 0.05,
      width * 0.7,
      height * 0.1,
    );
    path.quadraticBezierTo(
      width * 0.5,
      height * 0.08,
      width * 0.3,
      height * 0.1,
    );
    path.close();

    paint.shader = RadialGradient(
      center: Alignment.center,
      colors: [
        AppColors.primary.withOpacity(0.2),
        AppColors.primary.withOpacity(0.1),
        AppColors.primary.withOpacity(0.05),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintFluidWave(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create fluid wave-like shape
    path.moveTo(0, height * 0.3);
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.1,
      width * 0.4,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.3,
      width * 0.8,
      height * 0.1,
    );
    path.quadraticBezierTo(width * 0.9, height * 0.05, width, height * 0.15);
    path.quadraticBezierTo(
      width * 0.95,
      height * 0.3,
      width * 0.8,
      height * 0.4,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.5,
      width * 0.4,
      height * 0.4,
    );
    path.quadraticBezierTo(width * 0.2, height * 0.3, 0, height * 0.5);
    path.lineTo(0, height);
    path.lineTo(0, height * 0.3);
    path.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary.withOpacity(0.18),
        AppColors.primary.withOpacity(0.1),
        AppColors.primary.withOpacity(0.06),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintSoftRounded(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create soft, rounded organic shape
    path.moveTo(width * 0.2, height * 0.1);
    path.quadraticBezierTo(
      width * 0.1,
      height * 0.05,
      width * 0.05,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.02,
      height * 0.3,
      width * 0.1,
      height * 0.5,
    );
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.7,
      width * 0.3,
      height * 0.8,
    );
    path.quadraticBezierTo(
      width * 0.5,
      height * 0.85,
      width * 0.7,
      height * 0.8,
    );
    path.quadraticBezierTo(
      width * 0.85,
      height * 0.7,
      width * 0.9,
      height * 0.5,
    );
    path.quadraticBezierTo(
      width * 0.95,
      height * 0.3,
      width * 0.9,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.85,
      height * 0.05,
      width * 0.7,
      height * 0.1,
    );
    path.quadraticBezierTo(
      width * 0.5,
      height * 0.08,
      width * 0.3,
      height * 0.1,
    );
    path.quadraticBezierTo(
      width * 0.25,
      height * 0.1,
      width * 0.2,
      height * 0.1,
    );
    path.close();

    paint.shader = RadialGradient(
      center: Alignment.center,
      colors: [
        AppColors.primary.withOpacity(0.16),
        AppColors.primary.withOpacity(0.08),
        AppColors.primary.withOpacity(0.04),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintCloudShape(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create cloud-like organic shape
    path.moveTo(width * 0.3, height * 0.4);
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.2,
      width * 0.4,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.5,
      height * 0.1,
      width * 0.6,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.8,
      height * 0.2,
      width * 0.85,
      height * 0.4,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.6,
      width * 0.8,
      height * 0.7,
    );
    path.quadraticBezierTo(
      width * 0.7,
      height * 0.8,
      width * 0.5,
      height * 0.75,
    );
    path.quadraticBezierTo(
      width * 0.3,
      height * 0.8,
      width * 0.2,
      height * 0.7,
    );
    path.quadraticBezierTo(
      width * 0.1,
      height * 0.6,
      width * 0.15,
      height * 0.4,
    );
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.3,
      width * 0.3,
      height * 0.4,
    );
    path.close();

    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withOpacity(0.2),
        AppColors.primary.withOpacity(0.12),
        AppColors.primary.withOpacity(0.06),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintAmoeba(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create amoeba-like organic shape
    path.moveTo(width * 0.4, height * 0.2);
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.1,
      width * 0.1,
      height * 0.3,
    );
    path.quadraticBezierTo(
      width * 0.05,
      height * 0.5,
      width * 0.15,
      height * 0.7,
    );
    path.quadraticBezierTo(
      width * 0.25,
      height * 0.85,
      width * 0.4,
      height * 0.9,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.95,
      width * 0.8,
      height * 0.9,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.8,
      width * 0.95,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.4,
      width * 0.8,
      height * 0.3,
    );
    path.quadraticBezierTo(
      width * 0.7,
      height * 0.2,
      width * 0.6,
      height * 0.25,
    );
    path.quadraticBezierTo(
      width * 0.5,
      height * 0.2,
      width * 0.4,
      height * 0.2,
    );
    path.close();

    paint.shader = RadialGradient(
      center: Alignment.center,
      colors: [
        AppColors.primary.withOpacity(0.22),
        AppColors.primary.withOpacity(0.14),
        AppColors.primary.withOpacity(0.08),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintLiquid(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create liquid-like flowing shape
    path.moveTo(width * 0.1, height * 0.3);
    path.cubicTo(
      width * 0.05,
      height * 0.1,
      width * 0.2,
      height * 0.05,
      width * 0.4,
      height * 0.1,
    );
    path.cubicTo(
      width * 0.6,
      height * 0.15,
      width * 0.8,
      height * 0.1,
      width * 0.9,
      height * 0.2,
    );
    path.cubicTo(
      width * 0.95,
      height * 0.4,
      width * 0.9,
      height * 0.6,
      width * 0.8,
      height * 0.7,
    );
    path.cubicTo(
      width * 0.7,
      height * 0.8,
      width * 0.5,
      height * 0.85,
      width * 0.3,
      height * 0.8,
    );
    path.cubicTo(
      width * 0.1,
      height * 0.75,
      width * 0.05,
      height * 0.6,
      width * 0.1,
      height * 0.4,
    );
    path.cubicTo(
      width * 0.12,
      height * 0.35,
      width * 0.1,
      height * 0.3,
      width * 0.1,
      height * 0.3,
    );
    path.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary.withOpacity(0.19),
        AppColors.primary.withOpacity(0.11),
        AppColors.primary.withOpacity(0.07),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  void _paintOrganic(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create completely organic, natural shape
    path.moveTo(width * 0.35, height * 0.15);
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.08,
      width * 0.1,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.05,
      height * 0.35,
      width * 0.12,
      height * 0.5,
    );
    path.quadraticBezierTo(
      width * 0.18,
      height * 0.65,
      width * 0.3,
      height * 0.75,
    );
    path.quadraticBezierTo(
      width * 0.45,
      height * 0.8,
      width * 0.6,
      height * 0.78,
    );
    path.quadraticBezierTo(
      width * 0.75,
      height * 0.75,
      width * 0.85,
      height * 0.65,
    );
    path.quadraticBezierTo(
      width * 0.92,
      height * 0.5,
      width * 0.88,
      height * 0.35,
    );
    path.quadraticBezierTo(
      width * 0.85,
      height * 0.2,
      width * 0.75,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.12,
      width * 0.45,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.4,
      height * 0.15,
      width * 0.35,
      height * 0.15,
    );
    path.close();

    paint.shader = RadialGradient(
      center: Alignment.center,
      colors: [
        AppColors.primary.withOpacity(0.17),
        AppColors.primary.withOpacity(0.09),
        AppColors.primary.withOpacity(0.05),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _DecorativeShapePainter &&
        (oldDelegate.shape != shape || oldDelegate.isDarkMode != isDarkMode);
  }
}

/// Custom clipper for organic, shapeless banner edges
class _OrganicShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create organic, chat bubble-like clipping path
    path.moveTo(width * 0.1, height * 0.1);
    path.quadraticBezierTo(
      width * 0.05,
      height * 0.05,
      width * 0.08,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.06,
      height * 0.25,
      width * 0.12,
      height * 0.35,
    );
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.45,
      width * 0.25,
      height * 0.5,
    );
    path.quadraticBezierTo(
      width * 0.35,
      height * 0.55,
      width * 0.45,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.55,
      height * 0.65,
      width * 0.65,
      height * 0.6,
    );
    path.quadraticBezierTo(
      width * 0.75,
      height * 0.55,
      width * 0.85,
      height * 0.5,
    );
    path.quadraticBezierTo(
      width * 0.92,
      height * 0.45,
      width * 0.88,
      height * 0.35,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.25,
      width * 0.85,
      height * 0.15,
    );
    path.quadraticBezierTo(
      width * 0.8,
      height * 0.05,
      width * 0.7,
      height * 0.08,
    );
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.1,
      width * 0.5,
      height * 0.12,
    );
    path.quadraticBezierTo(
      width * 0.4,
      height * 0.1,
      width * 0.3,
      height * 0.08,
    );
    path.quadraticBezierTo(
      width * 0.2,
      height * 0.05,
      width * 0.1,
      height * 0.1,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
