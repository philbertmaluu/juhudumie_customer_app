import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/message_data.dart';

/// Conversation card widget for displaying conversation previews
class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;

  const ConversationCard({
    super.key,
    required this.conversation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.sm,
        ),
        padding: AppSpacing.cardPaddingMd,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            
            AppSpacing.gapHorizontalMd,
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          conversation.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDarkMode
                                ? AppColors.onDarkSurface
                                : AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Time and unread badge
                      Row(
                        children: [
                          // Time
                          Text(
                            conversation.formattedLastMessageTime,
                            style: AppTextStyles.caption.copyWith(
                              color: isDarkMode
                                  ? AppColors.onDarkSurface.withOpacity(0.6)
                                  : AppColors.onSurface.withOpacity(0.6),
                            ),
                          ),
                          
                          // Unread badge
                          if (conversation.unreadCount > 0) ...[
                            AppSpacing.gapHorizontalXs,
                            _buildUnreadBadge(isDarkMode),
                          ],
                        ],
                      ),
                    ],
                  ),
                  
                  AppSpacing.gapVerticalXs,
                  
                  // Subtitle
                  if (conversation.subtitle != null)
                    Text(
                      conversation.subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: isDarkMode
                            ? AppColors.onDarkSurface.withOpacity(0.7)
                            : AppColors.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  AppSpacing.gapVerticalXs,
                  
                  // Last message
                  Row(
                    children: [
                      // Message type icon
                      _buildMessageTypeIcon(),
                      
                      AppSpacing.gapHorizontalXs,
                      
                      // Message content
                      Expanded(
                        child: Text(
                          _getLastMessagePreview(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.8)
                                : AppColors.onSurface.withOpacity(0.8),
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build avatar widget
  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getAvatarColor(),
      ),
      child: Center(
        child: Text(
          conversation.avatar ?? _getDefaultAvatar(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  /// Build unread badge
  Widget _buildUnreadBadge(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        conversation.unreadCount > 99 ? '99+' : '${conversation.unreadCount}',
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  /// Build message type icon
  Widget _buildMessageTypeIcon() {
    final lastMessage = conversation.lastMessage;
    if (lastMessage == null) return const SizedBox.shrink();

    IconData icon;
    switch (lastMessage.type) {
      case MessageType.image:
        icon = Icons.image_outlined;
        break;
      case MessageType.orderUpdate:
        icon = Icons.shopping_bag_outlined;
        break;
      case MessageType.deliveryUpdate:
        icon = Icons.local_shipping_outlined;
        break;
      case MessageType.system:
        icon = Icons.info_outline;
        break;
      default:
        icon = Icons.message_outlined;
    }

    return Icon(
      icon,
      size: 14,
      color: AppColors.primary,
    );
  }

  /// Get avatar color based on conversation type
  Color _getAvatarColor() {
    switch (conversation.type) {
      case ConversationType.vendor:
        return AppColors.primary.withOpacity(0.1);
      case ConversationType.delivery:
        return Colors.orange.withOpacity(0.1);
      case ConversationType.jihudumie:
        return Colors.blue.withOpacity(0.1);
      case ConversationType.orderSupport:
        return Colors.green.withOpacity(0.1);
    }
  }

  /// Get default avatar based on conversation type
  String _getDefaultAvatar() {
    switch (conversation.type) {
      case ConversationType.vendor:
        return '🏪';
      case ConversationType.delivery:
        return '🚚';
      case ConversationType.jihudumie:
        return '🎧';
      case ConversationType.orderSupport:
        return '📦';
    }
  }

  /// Get last message preview
  String _getLastMessagePreview() {
    final lastMessage = conversation.lastMessage;
    if (lastMessage == null) return 'No messages yet';

    switch (lastMessage.type) {
      case MessageType.image:
        return '📷 Image';
      case MessageType.orderUpdate:
        return '📦 Order Update: ${lastMessage.content}';
      case MessageType.deliveryUpdate:
        return '🚚 Delivery Update: ${lastMessage.content}';
      case MessageType.system:
        return 'ℹ️ ${lastMessage.content}';
      default:
        return lastMessage.content;
    }
  }
}
