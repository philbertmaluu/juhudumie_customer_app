import 'package:flutter/material.dart';
import '../../../../shared/theme/index.dart';

/// Chat input field component with WhatsApp-like design
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isDarkMode;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isDarkMode,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = widget.controller.text.trim().isNotEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _sendMessage() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSend();
    }
  }

  void _onAttachmentPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentSheet(),
    );
  }

  void _onEmojiPressed() {
    // Handle emoji picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emoji picker coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        border: Border(
          top: BorderSide(
            color:
                widget.isDarkMode
                    ? const Color(0xFF374151)
                    : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode
                        ? const Color(0xFFF9FAFB)
                        : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _onAttachmentPressed,
                icon: Icon(
                  Icons.attach_file_rounded,
                  color:
                      widget.isDarkMode
                          ? const Color(0xFF374151)
                          : const Color(0xFF374151),
                  size: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      widget.isDarkMode
                          ? const Color(0xFFF9FAFB)
                          : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Text field
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        maxLines: 5,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              widget.isDarkMode
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFF1F2937),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color:
                                widget.isDarkMode
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),

                    // Emoji button
                    IconButton(
                      onPressed: _onEmojiPressed,
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color:
                            widget.isDarkMode
                                ? const Color(0xFF6B7280)
                                : const Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Send button
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color:
                    _isTyping
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF3B82F6).withOpacity(0.3),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _isTyping ? _sendMessage : null,
                icon: Icon(
                  Icons.send_rounded,
                  color:
                      _isTyping ? Colors.white : Colors.white.withOpacity(0.5),
                  size: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build attachment sheet
  Widget _buildAttachmentSheet() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.darkSurface : Colors.white,
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
                Text(
                  'Attach',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color:
                        widget.isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color:
                        widget.isDarkMode
                            ? AppColors.onDarkSurface
                            : AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Options
          _buildAttachmentOption(
            icon: Icons.camera_alt_rounded,
            title: 'Camera',
            subtitle: 'Take a photo',
            onTap: () {
              Navigator.pop(context);
              _handleCamera();
            },
          ),

          _buildAttachmentOption(
            icon: Icons.photo_library_rounded,
            title: 'Gallery',
            subtitle: 'Choose from gallery',
            onTap: () {
              Navigator.pop(context);
              _handleGallery();
            },
          ),

          _buildAttachmentOption(
            icon: Icons.attach_file_rounded,
            title: 'Document',
            subtitle: 'Share a file',
            onTap: () {
              Navigator.pop(context);
              _handleDocument();
            },
          ),

          _buildAttachmentOption(
            icon: Icons.location_on_rounded,
            title: 'Location',
            subtitle: 'Share your location',
            onTap: () {
              Navigator.pop(context);
              _handleLocation();
            },
          ),

          _buildAttachmentOption(
            icon: Icons.contact_phone_rounded,
            title: 'Contact',
            subtitle: 'Share a contact',
            onTap: () {
              Navigator.pop(context);
              _handleContact();
            },
          ),
        ],
      ),
    );
  }

  /// Build attachment option
  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color:
              widget.isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(
          color:
              widget.isDarkMode
                  ? AppColors.onDarkSurface.withOpacity(0.7)
                  : AppColors.onSurface.withOpacity(0.7),
        ),
      ),
      onTap: onTap,
    );
  }

  /// Handle camera
  void _handleCamera() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera feature coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Handle gallery
  void _handleGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery feature coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Handle document
  void _handleDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document sharing coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Handle location
  void _handleLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location sharing coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Handle contact
  void _handleContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact sharing coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
