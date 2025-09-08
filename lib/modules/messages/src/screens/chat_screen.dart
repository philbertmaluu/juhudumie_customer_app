import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';
import '../models/message_data.dart';
import '../services/message_service.dart';
import '../components/chat_message_bubble.dart';
import '../components/chat_input_field.dart';

/// Chat screen with WhatsApp-like layout
class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load messages for this conversation
  void _loadMessages() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading messages
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages = _messageService.getMessagesForConversation(
          widget.conversation.id,
        );
        _isLoading = false;
      });

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  /// Send a new message
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: widget.conversation.id,
      senderId: 'current_user', // In real app, get from auth service
      senderName: 'You',
      content: text,
      timestamp: DateTime.now(),
      type: MessageType.text,
      senderType: SenderType.customer,
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate typing indicator from other user
    _simulateTyping();
  }

  /// Simulate typing indicator
  void _simulateTyping() {
    setState(() {
      _isTyping = true;
    });

    // Simulate response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;

          // Add a simulated response
          final responseMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: widget.conversation.id,
            senderId:
                widget.conversation.vendorId ??
                widget.conversation.deliveryManId ??
                'system',
            senderName: widget.conversation.title,
            content: _getSimulatedResponse(),
            timestamp: DateTime.now(),
            type: MessageType.text,
            senderType: _getSenderTypeFromConversation(
              widget.conversation.type,
            ),
            status: MessageStatus.read,
          );

          _messages.add(responseMessage);
        });

        _scrollToBottom();
      }
    });
  }

  /// Get simulated response based on conversation type
  String _getSimulatedResponse() {
    switch (widget.conversation.type) {
      case ConversationType.vendor:
        return 'Thank you for your message! We\'ll get back to you soon.';
      case ConversationType.delivery:
        return 'Your order is on the way! ETA: 30 minutes.';
      case ConversationType.jihudumie:
        return 'Hello! How can we help you today?';
      case ConversationType.orderSupport:
        return 'We\'re looking into your order issue. Will update you shortly.';
    }
  }

  /// Get sender type from conversation type
  SenderType _getSenderTypeFromConversation(ConversationType type) {
    switch (type) {
      case ConversationType.vendor:
        return SenderType.vendor;
      case ConversationType.delivery:
        return SenderType.deliveryMan;
      case ConversationType.jihudumie:
        return SenderType.jihudumie;
      case ConversationType.orderSupport:
        return SenderType.jihudumie;
    }
  }

  /// Scroll to bottom of messages
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Handle back button
  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  /// Handle call action
  void _onCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${widget.conversation.title}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  /// Handle video call action
  void _onVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting video call with ${widget.conversation.title}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  /// Handle more options
  void _onMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMoreOptionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.background,
      appBar: _buildAppBar(isDarkMode),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Messages list
            Expanded(
              child:
                  _isLoading
                      ? _buildLoadingState()
                      : _buildMessagesList(isDarkMode),
            ),

            // Chat input
            ChatInputField(
              controller: _messageController,
              onSend: _sendMessage,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
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
      leading: IconButton(
        onPressed: _onBackPressed,
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child:
                widget.conversation.avatar != null &&
                        widget.conversation.avatar!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        widget.conversation.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getConversationIcon(widget.conversation.type),
                            color: Colors.white,
                            size: 18,
                          );
                        },
                      ),
                    )
                    : Icon(
                      _getConversationIcon(widget.conversation.type),
                      color: Colors.white,
                      size: 18,
                    ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Call button
        IconButton(
          onPressed: _onCall,
          icon: const Icon(Icons.call_rounded, color: Colors.white, size: 22),
        ),

        // Video call button
        IconButton(
          onPressed: _onVideoCall,
          icon: const Icon(
            Icons.videocam_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),

        // More options
        IconButton(
          onPressed: _onMoreOptions,
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build messages list
  Widget _buildMessagesList(bool isDarkMode) {
    if (_messages.isEmpty) {
      return _buildEmptyState(isDarkMode);
    }

    return Container(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _messages.length + (_isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _messages.length && _isTyping) {
            return _buildTypingIndicator(isDarkMode);
          }

          final message = _messages[index];
          final isMe = message.senderId == 'current_user';
          final showAvatar =
              !isMe &&
              (index == 0 || _messages[index - 1].senderId != message.senderId);

          return ChatMessageBubble(
            message: message,
            isMe: isMe,
            showAvatar: showAvatar,
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              child: Icon(
                _getConversationIcon(widget.conversation.type),
                color: AppColors.primary,
                size: 40,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              'Start a conversation',
              style: AppTextStyles.headingSmall.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Send a message to ${widget.conversation.title}',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode
                        ? AppColors.onDarkSurface.withOpacity(0.7)
                        : AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build typing indicator
  Widget _buildTypingIndicator(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Icon(
              _getConversationIcon(widget.conversation.type),
              color: AppColors.primary,
              size: 16,
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Typing bubble
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0, isDarkMode),
                const SizedBox(width: 4),
                _buildTypingDot(1, isDarkMode),
                const SizedBox(width: 4),
                _buildTypingDot(2, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build typing dot
  Widget _buildTypingDot(int index, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animationValue = (value - delay).clamp(0.0, 1.0);
        final opacity = (animationValue * 2 - 1).abs();

        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: (isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface)
                .withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  /// Build more options sheet
  Widget _buildMoreOptionsSheet() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: Icon(
                    _getConversationIcon(widget.conversation.type),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.conversation.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface
                                  : AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getStatusText(),
                        style: AppTextStyles.caption.copyWith(
                          color:
                              isDarkMode
                                  ? AppColors.onDarkSurface.withOpacity(0.7)
                                  : AppColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Options
          _buildOptionTile(
            icon: Icons.info_outline_rounded,
            title: 'View Info',
            onTap: () {
              Navigator.pop(context);
              // Handle view info
            },
            isDarkMode: isDarkMode,
          ),

          _buildOptionTile(
            icon: Icons.search_rounded,
            title: 'Search Messages',
            onTap: () {
              Navigator.pop(context);
              // Handle search
            },
            isDarkMode: isDarkMode,
          ),

          _buildOptionTile(
            icon: Icons.notifications_off_rounded,
            title: 'Mute Notifications',
            onTap: () {
              Navigator.pop(context);
              // Handle mute
            },
            isDarkMode: isDarkMode,
          ),

          _buildOptionTile(
            icon: Icons.block_rounded,
            title: 'Block',
            onTap: () {
              Navigator.pop(context);
              // Handle block
            },
            isDarkMode: isDarkMode,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  /// Build option tile
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isDestructive
                ? Colors.red
                : (isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color:
              isDestructive
                  ? Colors.red
                  : (isDarkMode
                      ? AppColors.onDarkSurface
                      : AppColors.onSurface),
        ),
      ),
      onTap: onTap,
    );
  }

  /// Get conversation icon
  IconData _getConversationIcon(ConversationType type) {
    switch (type) {
      case ConversationType.vendor:
        return Icons.store_rounded;
      case ConversationType.delivery:
        return Icons.local_shipping_rounded;
      case ConversationType.jihudumie:
        return Icons.support_agent_rounded;
      case ConversationType.orderSupport:
        return Icons.help_rounded;
    }
  }

  /// Get status text
  String _getStatusText() {
    switch (widget.conversation.type) {
      case ConversationType.vendor:
        return 'Online';
      case ConversationType.delivery:
        return 'Available';
      case ConversationType.jihudumie:
        return 'Always here to help';
      case ConversationType.orderSupport:
        return 'Support team';
    }
  }
}
