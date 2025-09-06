import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/game_data.dart';

/// Game stats widget
class GameStatsWidget extends StatelessWidget {
  final GameStats stats;
  final GameConfig config;

  const GameStatsWidget({super.key, required this.stats, required this.config});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardPaddingMd,
      margin: AppSpacing.screenPaddingMd,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.gapHorizontalXs,
              Text(
                'Game Stats',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface
                          : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalMd,

          // Stats grid
          Row(
            children: [
              // Time
              Expanded(
                child: _buildStatItem(
                  'Time',
                  stats.formattedTime,
                  Icons.timer_outlined,
                  isDarkMode,
                ),
              ),

              _buildStatDivider(isDarkMode),

              // Moves
              Expanded(
                child: _buildStatItem(
                  'Moves',
                  '${stats.moves}',
                  Icons.touch_app_outlined,
                  isDarkMode,
                ),
              ),

              _buildStatDivider(isDarkMode),

              // Matches
              Expanded(
                child: _buildStatItem(
                  'Matches',
                  '${stats.matches}',
                  Icons.check_circle_outline,
                  isDarkMode,
                ),
              ),

              _buildStatDivider(isDarkMode),

              // Score
              Expanded(
                child: _buildStatItem(
                  'Score',
                  '${stats.score}',
                  Icons.star_outline,
                  isDarkMode,
                ),
              ),
            ],
          ),

          AppSpacing.gapVerticalMd,

          // Progress bar
          _buildProgressBar(isDarkMode),
        ],
      ),
    );
  }

  /// Build stat item
  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        AppSpacing.gapVerticalXs,
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color:
                isDarkMode
                    ? AppColors.onDarkSurface.withOpacity(0.7)
                    : AppColors.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build stat divider
  Widget _buildStatDivider(bool isDarkMode) {
    return Container(
      width: 1,
      height: 40,
      color:
          isDarkMode
              ? AppColors.onDarkSurface.withOpacity(0.1)
              : AppColors.onSurface.withOpacity(0.1),
    );
  }

  /// Build progress bar
  Widget _buildProgressBar(bool isDarkMode) {
    final progress = config.pairs > 0 ? stats.matches / config.pairs : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTextStyles.caption.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              '${stats.matches}/${config.pairs}',
              style: AppTextStyles.caption.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.gapVerticalXs,
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.1)
                  : AppColors.onSurface.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 6,
        ),
      ],
    );
  }
}
