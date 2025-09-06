/// Game card model for memory match game
class GameCard {
  final String id;
  final String emoji;
  final bool isFlipped;
  final bool isMatched;
  final int position;

  const GameCard({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
    required this.position,
  });

  /// Create a copy with updated properties
  GameCard copyWith({
    String? id,
    String? emoji,
    bool? isFlipped,
    bool? isMatched,
    int? position,
  }) {
    return GameCard(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      position: position ?? this.position,
    );
  }
}

/// Game difficulty levels
enum GameDifficulty { easy, medium, hard }

/// Game state
enum GameState { initial, playing, paused, completed, gameOver }

/// Game statistics
class GameStats {
  final int moves;
  final int matches;
  final int timeElapsed; // in seconds
  final int score;
  final GameDifficulty difficulty;
  final DateTime? startTime;
  final DateTime? endTime;

  const GameStats({
    this.moves = 0,
    this.matches = 0,
    this.timeElapsed = 0,
    this.score = 0,
    this.difficulty = GameDifficulty.easy,
    this.startTime,
    this.endTime,
  });

  /// Create a copy with updated properties
  GameStats copyWith({
    int? moves,
    int? matches,
    int? timeElapsed,
    int? score,
    GameDifficulty? difficulty,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return GameStats(
      moves: moves ?? this.moves,
      matches: matches ?? this.matches,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      score: score ?? this.score,
      difficulty: difficulty ?? this.difficulty,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// Get formatted time string
  String get formattedTime {
    final minutes = timeElapsed ~/ 60;
    final seconds = timeElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Calculate accuracy percentage
  double get accuracy {
    if (moves == 0) return 0.0;
    return (matches / moves * 100).clamp(0.0, 100.0);
  }
}

/// Game configuration
class GameConfig {
  final GameDifficulty difficulty;
  final int gridSize;
  final int totalCards;
  final int pairs;
  final Duration timeLimit;
  final List<String> emojis;

  const GameConfig({
    required this.difficulty,
    required this.gridSize,
    required this.totalCards,
    required this.pairs,
    required this.timeLimit,
    required this.emojis,
  });

  /// Get configuration for difficulty level
  static GameConfig getConfigForDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return const GameConfig(
          difficulty: GameDifficulty.easy,
          gridSize: 4,
          totalCards: 16,
          pairs: 8,
          timeLimit: Duration(minutes: 5),
          emojis: ['🎮', '🎯', '🎲', '🎪', '🎨', '🎭', '🎸', '🎺'],
        );
      case GameDifficulty.medium:
        return const GameConfig(
          difficulty: GameDifficulty.medium,
          gridSize: 6,
          totalCards: 36,
          pairs: 18,
          timeLimit: Duration(minutes: 8),
          emojis: [
            '🎮',
            '🎯',
            '🎲',
            '🎪',
            '🎨',
            '🎭',
            '🎸',
            '🎺',
            '🎤',
            '🎧',
            '🎵',
            '🎶',
            '🎼',
            '🎹',
            '🥁',
            '🎻',
            '🎺',
            '🎷',
          ],
        );
      case GameDifficulty.hard:
        return const GameConfig(
          difficulty: GameDifficulty.hard,
          gridSize: 8,
          totalCards: 64,
          pairs: 32,
          timeLimit: Duration(minutes: 12),
          emojis: [
            '🎮',
            '🎯',
            '🎲',
            '🎪',
            '🎨',
            '🎭',
            '🎸',
            '🎺',
            '🎤',
            '🎧',
            '🎵',
            '🎶',
            '🎼',
            '🎹',
            '🥁',
            '🎻',
            '🎺',
            '🎷',
            '🎸',
            '🎵',
            '🎶',
            '🎼',
            '🎹',
            '🥁',
            '🎻',
            '🎺',
            '🎷',
            '🎸',
            '🎵',
            '🎶',
            '🎼',
            '🎹',
          ],
        );
    }
  }
}

/// Game achievement
class GameAchievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const GameAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Create a copy with updated properties
  GameAchievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return GameAchievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

/// Game leaderboard entry
class LeaderboardEntry {
  final String playerName;
  final int score;
  final int timeElapsed;
  final GameDifficulty difficulty;
  final DateTime date;
  final int rank;

  const LeaderboardEntry({
    required this.playerName,
    required this.score,
    required this.timeElapsed,
    required this.difficulty,
    required this.date,
    required this.rank,
  });

  /// Get formatted time string
  String get formattedTime {
    final minutes = timeElapsed ~/ 60;
    final seconds = timeElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
