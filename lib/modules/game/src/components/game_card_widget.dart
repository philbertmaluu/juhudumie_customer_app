import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/game_data.dart';

/// Game card widget for memory match game
class GameCardWidget extends StatefulWidget {
  final GameCard card;
  final VoidCallback? onTap;
  final double size;

  const GameCardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.size = 60.0,
  });

  @override
  State<GameCardWidget> createState() => _GameCardWidgetState();
}

class _GameCardWidgetState extends State<GameCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(GameCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      if (widget.card.isFlipped) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.card.isMatched ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnimation.value * 3.14159),
            child:
                _flipAnimation.value < 0.5
                    ? _buildCardBack(isDarkMode)
                    : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _buildCardFront(isDarkMode),
                    ),
          );
        },
      ),
    );
  }

  /// Build card back (hidden state)
  Widget _buildCardBack(bool isDarkMode) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.primary : AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.help_outline_rounded,
          color: Colors.white,
          size: widget.size * 0.4,
        ),
      ),
    );
  }

  /// Build card front (revealed state)
  Widget _buildCardFront(bool isDarkMode) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color:
            widget.card.isMatched
                ? Colors.green.withOpacity(0.3)
                : isDarkMode
                ? AppColors.darkSurface
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              widget.card.isMatched
                  ? Colors.green
                  : isDarkMode
                  ? AppColors.outlineVariant
                  : AppColors.outline,
          width: widget.card.isMatched ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                widget.card.isMatched
                    ? Colors.green.withOpacity(0.3)
                    : isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
            blurRadius: widget.card.isMatched ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.card.emoji,
          style: TextStyle(fontSize: widget.size * 0.5),
        ),
      ),
    );
  }
}
