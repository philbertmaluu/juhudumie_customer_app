import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/game_data.dart';
import '../services/game_service.dart';
import '../components/game_card_widget.dart';
import '../components/game_stats_widget.dart';

/// Memory Match Game Screen
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameService _gameService = GameService();

  @override
  void initState() {
    super.initState();
    _gameService.initializeGame(GameDifficulty.easy);
  }

  @override
  void dispose() {
    _gameService.dispose();
    super.dispose();
  }

  /// Handle card tap
  void _onCardTap(int position) {
    _gameService.flipCard(position);
    setState(() {});
  }

  /// Start new game
  void _startNewGame() {
    _gameService.resetGame();
    setState(() {});
  }

  /// Start the game
  void _startGame() {
    _gameService.startGame();
    setState(() {});
  }

  /// Pause/Resume game
  void _togglePause() {
    if (_gameService.gameState == GameState.playing) {
      _gameService.pauseGame();
    } else if (_gameService.gameState == GameState.paused) {
      _gameService.resumeGame();
    }
    setState(() {});
  }

  /// Show difficulty selection
  void _showDifficultySelection() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Difficulty'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDifficultyOption(
                  GameDifficulty.easy,
                  'Easy',
                  '4x4 Grid',
                  '🥉',
                ),
                _buildDifficultyOption(
                  GameDifficulty.medium,
                  'Medium',
                  '6x6 Grid',
                  '🥈',
                ),
                _buildDifficultyOption(
                  GameDifficulty.hard,
                  'Hard',
                  '8x8 Grid',
                  '🥇',
                ),
              ],
            ),
          ),
    );
  }

  /// Build difficulty option
  Widget _buildDifficultyOption(
    GameDifficulty difficulty,
    String title,
    String description,
    String icon,
  ) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        Navigator.of(context).pop();
        _gameService.initializeGame(difficulty);
        setState(() {});
      },
    );
  }

  /// Show game completion dialog
  void _showGameCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('🎉 Congratulations!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You completed the game!'),
                AppSpacing.gapVerticalSm,
                Text('Score: ${_gameService.gameStats.score}'),
                Text('Time: ${_gameService.gameStats.formattedTime}'),
                Text('Moves: ${_gameService.gameStats.moves}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startNewGame();
                },
                child: const Text('Play Again'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startNewGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('New Game'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.background,
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(isDarkMode),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? AppColors.darkPrimaryGradient
                  : AppColors.primaryGradient,
        ),
      ),
      title: Text(
        'Memory Match',
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showDifficultySelection,
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
      ],
    );
  }

  /// Build body content
  Widget _buildBody(bool isDarkMode) {
    return Column(
      children: [
        // Game stats
        GameStatsWidget(
          stats: _gameService.gameStats,
          config: _gameService.gameConfig,
        ),

        // Game controls
        _buildGameControls(isDarkMode),

        // Game grid
        Expanded(child: _buildGameGrid(isDarkMode)),
      ],
    );
  }

  /// Build game controls
  Widget _buildGameControls(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Start/New Game button
          ElevatedButton.icon(
            onPressed:
                _gameService.gameState == GameState.initial
                    ? _startGame
                    : _startNewGame,
            icon: Icon(
              _gameService.gameState == GameState.initial
                  ? Icons.play_arrow
                  : Icons.refresh,
            ),
            label: Text(
              _gameService.gameState == GameState.initial
                  ? 'Start Game'
                  : 'New Game',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),

          // Pause/Resume button
          if (_gameService.gameState == GameState.playing ||
              _gameService.gameState == GameState.paused)
            ElevatedButton.icon(
              onPressed: _togglePause,
              icon: Icon(
                _gameService.gameState == GameState.playing
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              label: Text(
                _gameService.gameState == GameState.playing
                    ? 'Pause'
                    : 'Resume',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  /// Build game grid
  Widget _buildGameGrid(bool isDarkMode) {
    if (_gameService.gameState == GameState.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameCompletionDialog();
      });
    }

    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gameService.gameConfig.gridSize,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: _gameService.cards.length,
        itemBuilder: (context, index) {
          final card = _gameService.cards[index];
          return GameCardWidget(
            card: card,
            onTap: () => _onCardTap(card.position),
            size: _calculateCardSize(),
          );
        },
      ),
    );
  }

  /// Calculate card size based on grid size
  double _calculateCardSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 32.0; // Total horizontal padding
    final spacing =
        (_gameService.gameConfig.gridSize - 1) * 8.0; // Total spacing
    final availableWidth = screenWidth - padding - spacing;
    return availableWidth / _gameService.gameConfig.gridSize;
  }
}
