import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/message_data.dart';

/// Chat message bubble component with WhatsApp-like design
class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool showAvatar;
  final bool isDarkMode;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar) ...[
            _buildAvatar(),
            const SizedBox(width: AppSpacing.sm),
          ] else if (!isMe) ...[
            const SizedBox(width: 40), // Space for avatar alignment
            const SizedBox(width: AppSpacing.sm),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Message bubble
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isMe
                            ? (isDarkMode
                                ? const Color(0xFF1E3A8A)
                                : const Color(0xFF3B82F6))
                            : (isDarkMode
                                ? const Color(0xFF374151)
                                : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8),
                      topRight: const Radius.circular(8),
                      bottomLeft: Radius.circular(isMe ? 8 : 2),
                      bottomRight: Radius.circular(isMe ? 2 : 8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message content
                      Text(
                        message.content,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              isMe
                                  ? Colors.white
                                  : (isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF1F2937)),
                          height: 1.3,
                        ),
                      ),

                      // Timestamp
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.timestamp),
                            style: AppTextStyles.caption.copyWith(
                              color:
                                  isMe
                                      ? Colors.white.withOpacity(0.8)
                                      : (isDarkMode
                                          ? Colors.white.withOpacity(0.6)
                                          : const Color(0xFF6B7280)),
                            ),
                          ),

                          if (isMe) ...[
                            const SizedBox(width: 4),
                            Icon(
                              message.status == MessageStatus.read
                                  ? Icons.done_all_rounded
                                  : Icons.done_rounded,
                              size: 14,
                              color:
                                  message.status == MessageStatus.read
                                      ? const Color(0xFF60A5FA)
                                      : Colors.white.withOpacity(0.8),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Sender name (only for other person's messages)
                if (!isMe && showAvatar) ...[
                  const SizedBox(height: 4),
                  Text(
                    message.senderName,
                    style: AppTextStyles.caption.copyWith(
                      color:
                          isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build avatar
  Widget _buildAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.person_rounded, color: AppColors.primary, size: 14),
    );
  }

  /// Format timestamp
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      // Today - show time only
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // Other days - show date and time
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
