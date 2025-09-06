/// Model representing the state of the splash screen
class SplashState {
  final bool isInitializing;
  final bool isComplete;
  final String? error;
  final double progress;

  const SplashState({
    this.isInitializing = false,
    this.isComplete = false,
    this.error,
    this.progress = 0.0,
  });

  /// Create a copy of this state with updated values
  SplashState copyWith({
    bool? isInitializing,
    bool? isComplete,
    String? error,
    double? progress,
  }) {
    return SplashState(
      isInitializing: isInitializing ?? this.isInitializing,
      isComplete: isComplete ?? this.isComplete,
      error: error ?? this.error,
      progress: progress ?? this.progress,
    );
  }

  /// Check if splash is in loading state
  bool get isLoading => isInitializing && !isComplete;

  /// Check if splash has completed successfully
  bool get isSuccess => isComplete && error == null;

  /// Check if splash has failed
  bool get isError => error != null;

  @override
  String toString() {
    return 'SplashState(isInitializing: $isInitializing, isComplete: $isComplete, error: $error, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SplashState &&
        other.isInitializing == isInitializing &&
        other.isComplete == isComplete &&
        other.error == error &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return isInitializing.hashCode ^
        isComplete.hashCode ^
        error.hashCode ^
        progress.hashCode;
  }
}
