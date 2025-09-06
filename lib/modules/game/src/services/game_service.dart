import 'dart:async';
import '../models/game_data.dart';

/// Service for managing memory match game
class GameService {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  List<GameCard> _cards = [];
  GameState _gameState = GameState.initial;
  GameStats _gameStats = const GameStats();
  GameConfig _gameConfig = GameConfig.getConfigForDifficulty(
    GameDifficulty.easy,
  );
  Timer? _gameTimer;
  List<GameCard> _flippedCards = [];
  List<GameAchievement> _achievements = [];
  List<LeaderboardEntry> _leaderboard = [];

  /// Get current cards
  List<GameCard> get cards => List.unmodifiable(_cards);

  /// Get current game state
  GameState get gameState => _gameState;

  /// Get current game stats
  GameStats get gameStats => _gameStats;

  /// Get current game config
  GameConfig get gameConfig => _gameConfig;

  /// Get achievements
  List<GameAchievement> get achievements => List.unmodifiable(_achievements);

  /// Get leaderboard
  List<LeaderboardEntry> get leaderboard => List.unmodifiable(_leaderboard);

  /// Initialize game with difficulty
  void initializeGame(GameDifficulty difficulty) {
    _gameConfig = GameConfig.getConfigForDifficulty(difficulty);
    _gameStats = GameStats(difficulty: difficulty, startTime: DateTime.now());
    _gameState = GameState.initial;
    _flippedCards.clear();
    _generateCards();
    _loadAchievements();
    _loadLeaderboard();
  }

  /// Start the game
  void startGame() {
    if (_gameState == GameState.initial) {
      _gameState = GameState.playing;
      _gameStats = _gameStats.copyWith(startTime: DateTime.now());
      _startTimer();
    }
  }

  /// Pause the game
  void pauseGame() {
    if (_gameState == GameState.playing) {
      _gameState = GameState.paused;
      _gameTimer?.cancel();
    }
  }

  /// Resume the game
  void resumeGame() {
    if (_gameState == GameState.paused) {
      _gameState = GameState.playing;
      _startTimer();
    }
  }

  /// Reset the game
  void resetGame() {
    _gameTimer?.cancel();
    _gameState = GameState.initial;
    _gameStats = GameStats(difficulty: _gameConfig.difficulty);
    _flippedCards.clear();
    _generateCards();
  }

  /// Flip a card
  void flipCard(int position) {
    if (_gameState != GameState.playing) return;
    if (_flippedCards.length >= 2) return;

    final cardIndex = _cards.indexWhere((card) => card.position == position);
    if (cardIndex == -1) return;

    final card = _cards[cardIndex];
    if (card.isFlipped || card.isMatched) return;

    // Flip the card
    _cards[cardIndex] = card.copyWith(isFlipped: true);
    _flippedCards.add(_cards[cardIndex]);

    // Check for match if two cards are flipped
    if (_flippedCards.length == 2) {
      _checkForMatch();
    }
  }

  /// Check for match between flipped cards
  void _checkForMatch() {
    if (_flippedCards.length != 2) return;

    final card1 = _flippedCards[0];
    final card2 = _flippedCards[1];

    // Increment moves
    _gameStats = _gameStats.copyWith(moves: _gameStats.moves + 1);

    if (card1.emoji == card2.emoji) {
      // Match found
      _handleMatch(card1, card2);
    } else {
      // No match - flip cards back after delay
      Timer(const Duration(milliseconds: 1000), () {
        _flipCardsBack();
      });
    }
  }

  /// Handle successful match
  void _handleMatch(GameCard card1, GameCard card2) {
    final card1Index = _cards.indexWhere((card) => card.id == card1.id);
    final card2Index = _cards.indexWhere((card) => card.id == card2.id);

    if (card1Index != -1 && card2Index != -1) {
      _cards[card1Index] = _cards[card1Index].copyWith(isMatched: true);
      _cards[card2Index] = _cards[card2Index].copyWith(isMatched: true);
    }

    _flippedCards.clear();

    // Update stats
    _gameStats = _gameStats.copyWith(
      matches: _gameStats.matches + 1,
      score: _calculateScore(),
    );

    // Check if game is completed
    if (_isGameCompleted()) {
      _completeGame();
    }
  }

  /// Flip cards back when no match
  void _flipCardsBack() {
    for (final card in _flippedCards) {
      final cardIndex = _cards.indexWhere((c) => c.id == card.id);
      if (cardIndex != -1) {
        _cards[cardIndex] = _cards[cardIndex].copyWith(isFlipped: false);
      }
    }
    _flippedCards.clear();
  }

  /// Check if game is completed
  bool _isGameCompleted() {
    return _cards.every((card) => card.isMatched);
  }

  /// Complete the game
  void _completeGame() {
    _gameTimer?.cancel();
    _gameState = GameState.completed;
    _gameStats = _gameStats.copyWith(endTime: DateTime.now());
    _checkAchievements();
    _updateLeaderboard();
  }

  /// Calculate score
  int _calculateScore() {
    final baseScore = _gameStats.matches * 100;
    final timeBonus =
        (_gameConfig.timeLimit.inSeconds - _gameStats.timeElapsed) ~/ 10;
    final accuracyBonus = (_gameStats.accuracy * 2).round();
    return (baseScore + timeBonus + accuracyBonus).clamp(0, 10000);
  }

  /// Start game timer
  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState == GameState.playing) {
        _gameStats = _gameStats.copyWith(
          timeElapsed: _gameStats.timeElapsed + 1,
        );

        // Check time limit
        if (_gameStats.timeElapsed >= _gameConfig.timeLimit.inSeconds) {
          _gameOver();
        }
      }
    });
  }

  /// Game over due to time limit
  void _gameOver() {
    _gameTimer?.cancel();
    _gameState = GameState.gameOver;
    _gameStats = _gameStats.copyWith(endTime: DateTime.now());
  }

  /// Generate cards for the game
  void _generateCards() {
    _cards.clear();
    final emojis = List<String>.from(_gameConfig.emojis);
    final pairs = <String>[];

    // Create pairs
    for (int i = 0; i < _gameConfig.pairs; i++) {
      final emoji = emojis[i % emojis.length];
      pairs.addAll([emoji, emoji]);
    }

    // Shuffle pairs
    pairs.shuffle();

    // Create cards
    for (int i = 0; i < pairs.length; i++) {
      _cards.add(GameCard(id: 'card_$i', emoji: pairs[i], position: i));
    }
  }

  /// Load achievements
  void _loadAchievements() {
    _achievements = [
      const GameAchievement(
        id: 'first_match',
        title: 'First Match',
        description: 'Complete your first match',
        icon: '🎯',
      ),
      const GameAchievement(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete a game in under 2 minutes',
        icon: '⚡',
      ),
      const GameAchievement(
        id: 'perfect_game',
        title: 'Perfect Game',
        description: 'Complete a game with 100% accuracy',
        icon: '🏆',
      ),
      const GameAchievement(
        id: 'easy_master',
        title: 'Easy Master',
        description: 'Complete 5 easy games',
        icon: '🥉',
      ),
      const GameAchievement(
        id: 'medium_master',
        title: 'Medium Master',
        description: 'Complete 3 medium games',
        icon: '🥈',
      ),
      const GameAchievement(
        id: 'hard_master',
        title: 'Hard Master',
        description: 'Complete 1 hard game',
        icon: '🥇',
      ),
    ];
  }

  /// Check and unlock achievements
  void _checkAchievements() {
    // This would check game stats against achievement criteria
    // For now, we'll just mark some as unlocked based on simple criteria
    for (int i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];
      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_match':
          shouldUnlock = _gameStats.matches > 0;
          break;
        case 'speed_demon':
          shouldUnlock = _gameStats.timeElapsed < 120;
          break;
        case 'perfect_game':
          shouldUnlock = _gameStats.accuracy >= 100.0;
          break;
        case 'easy_master':
          shouldUnlock = _gameConfig.difficulty == GameDifficulty.easy;
          break;
        case 'medium_master':
          shouldUnlock = _gameConfig.difficulty == GameDifficulty.medium;
          break;
        case 'hard_master':
          shouldUnlock = _gameConfig.difficulty == GameDifficulty.hard;
          break;
      }

      if (shouldUnlock && !achievement.isUnlocked) {
        _achievements[i] = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
      }
    }
  }

  /// Load leaderboard
  void _loadLeaderboard() {
    _leaderboard = [
      LeaderboardEntry(
        playerName: 'Memory Master',
        score: 8500,
        timeElapsed: 95,
        difficulty: GameDifficulty.easy,
        date: DateTime(2024, 1, 15),
        rank: 1,
      ),
      LeaderboardEntry(
        playerName: 'Card Wizard',
        score: 7800,
        timeElapsed: 120,
        difficulty: GameDifficulty.medium,
        date: DateTime(2024, 1, 14),
        rank: 2,
      ),
      LeaderboardEntry(
        playerName: 'Speed Player',
        score: 7200,
        timeElapsed: 85,
        difficulty: GameDifficulty.easy,
        date: DateTime(2024, 1, 13),
        rank: 3,
      ),
    ];
  }

  /// Update leaderboard with current game
  void _updateLeaderboard() {
    if (_gameState == GameState.completed) {
      final newEntry = LeaderboardEntry(
        playerName: 'You',
        score: _gameStats.score,
        timeElapsed: _gameStats.timeElapsed,
        difficulty: _gameStats.difficulty,
        date: DateTime.now(),
        rank: 0, // Will be calculated
      );

      _leaderboard.add(newEntry);
      _leaderboard.sort((a, b) => b.score.compareTo(a.score));

      // Update ranks
      for (int i = 0; i < _leaderboard.length; i++) {
        _leaderboard[i] = LeaderboardEntry(
          playerName: _leaderboard[i].playerName,
          score: _leaderboard[i].score,
          timeElapsed: _leaderboard[i].timeElapsed,
          difficulty: _leaderboard[i].difficulty,
          date: _leaderboard[i].date,
          rank: i + 1,
        );
      }

      // Keep only top 10
      if (_leaderboard.length > 10) {
        _leaderboard = _leaderboard.take(10).toList();
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _gameTimer?.cancel();
  }
}
