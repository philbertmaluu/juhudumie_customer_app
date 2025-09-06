import '../models/message_data.dart';

/// Service for managing messages and conversations
class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  List<Conversation> _conversations = [];
  List<OrderTracking> _orderTracking = [];

  /// Get all conversations
  List<Conversation> get conversations => List.unmodifiable(_conversations);

  /// Get order tracking data
  List<OrderTracking> get orderTracking => List.unmodifiable(_orderTracking);

  /// Initialize service with sample data
  void initializeService() {
    _loadSampleConversations();
    _loadSampleOrderTracking();
  }

  /// Load sample conversations
  void _loadSampleConversations() {
    _conversations = [
      // Vendor conversation
      Conversation(
        id: 'conv_1',
        title: 'TechStore Tanzania',
        subtitle: 'Electronics & Gadgets',
        avatar: '🏪',
        type: ConversationType.vendor,
        orderId: 'ORD-2024-001',
        vendorId: 'vendor_1',
        messages: [
          Message(
            id: 'msg_1',
            conversationId: 'conv_1',
            content: 'Hello! I have a question about my order #ORD-2024-001',
            type: MessageType.text,
            senderType: SenderType.customer,
            senderId: 'customer_1',
            senderName: 'You',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_2',
            conversationId: 'conv_1',
            content:
                'Hi! I can help you with that. What would you like to know?',
            type: MessageType.text,
            senderType: SenderType.vendor,
            senderId: 'vendor_1',
            senderName: 'TechStore Tanzania',
            senderAvatar: '🏪',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 1, minutes: 45),
            ),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_3',
            conversationId: 'conv_1',
            content: 'When will my order be shipped?',
            type: MessageType.text,
            senderType: SenderType.customer,
            senderId: 'customer_1',
            senderName: 'You',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 1, minutes: 30),
            ),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_4',
            conversationId: 'conv_1',
            content:
                'Your order will be shipped within 24 hours. You\'ll receive a tracking number via SMS.',
            type: MessageType.text,
            senderType: SenderType.vendor,
            senderId: 'vendor_1',
            senderName: 'TechStore Tanzania',
            senderAvatar: '🏪',
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            status: MessageStatus.delivered,
          ),
        ],
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
        unreadCount: 0,
      ),

      // Delivery conversation
      Conversation(
        id: 'conv_2',
        title: 'John Mwalimu',
        subtitle: 'Delivery Partner',
        avatar: '🚚',
        type: ConversationType.delivery,
        orderId: 'ORD-2024-001',
        deliveryManId: 'delivery_1',
        messages: [
          Message(
            id: 'msg_5',
            conversationId: 'conv_2',
            content:
                'Hello! I\'m your delivery partner. I\'m on my way to deliver your order.',
            type: MessageType.text,
            senderType: SenderType.deliveryMan,
            senderId: 'delivery_1',
            senderName: 'John Mwalimu',
            senderAvatar: '🚚',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_6',
            conversationId: 'conv_2',
            content: 'Great! What\'s your estimated arrival time?',
            type: MessageType.text,
            senderType: SenderType.customer,
            senderId: 'customer_1',
            senderName: 'You',
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_7',
            conversationId: 'conv_2',
            content:
                'I should be there in about 15 minutes. I\'m currently in Kinondoni area.',
            type: MessageType.text,
            senderType: SenderType.deliveryMan,
            senderId: 'delivery_1',
            senderName: 'John Mwalimu',
            senderAvatar: '🚚',
            timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
            status: MessageStatus.delivered,
          ),
        ],
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 20)),
        unreadCount: 1,
      ),

      // Jihudumie support
      Conversation(
        id: 'conv_3',
        title: 'Jihudumie Support',
        subtitle: 'Customer Service',
        avatar: '🎧',
        type: ConversationType.jihudumie,
        messages: [
          Message(
            id: 'msg_8',
            conversationId: 'conv_3',
            content: 'Welcome to Jihudumie! How can we help you today?',
            type: MessageType.text,
            senderType: SenderType.jihudumie,
            senderId: 'jihudumie_1',
            senderName: 'Jihudumie Support',
            senderAvatar: '🎧',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            status: MessageStatus.read,
          ),
        ],
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
      ),

      // Order support
      Conversation(
        id: 'conv_4',
        title: 'Order Support',
        subtitle: 'ORD-2024-002',
        avatar: '📦',
        type: ConversationType.orderSupport,
        orderId: 'ORD-2024-002',
        messages: [
          Message(
            id: 'msg_9',
            conversationId: 'conv_4',
            content: 'Your order has been processed and is ready for shipping.',
            type: MessageType.orderUpdate,
            senderType: SenderType.system,
            senderId: 'system_1',
            senderName: 'System',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            status: MessageStatus.read,
          ),
        ],
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
      ),
    ];
  }

  /// Load sample order tracking data
  void _loadSampleOrderTracking() {
    _orderTracking = [
      OrderTracking(
        orderId: 'ORD-2024-001',
        status: 'In Transit',
        description: 'Your order is on the way to you',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        location: 'Kinondoni, Dar es Salaam',
        deliveryManId: 'delivery_1',
        deliveryManName: 'John Mwalimu',
        deliveryManPhone: '+255 123 456 789',
        estimatedDelivery: '15 minutes',
      ),
      OrderTracking(
        orderId: 'ORD-2024-001',
        status: 'Out for Delivery',
        description: 'Your order has left the warehouse',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        location: 'Jihudumie Warehouse',
        deliveryManId: 'delivery_1',
        deliveryManName: 'John Mwalimu',
        deliveryManPhone: '+255 123 456 789',
        estimatedDelivery: '1 hour',
      ),
      OrderTracking(
        orderId: 'ORD-2024-001',
        status: 'Shipped',
        description: 'Your order has been shipped',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        location: 'Jihudumie Warehouse',
        estimatedDelivery: '2-3 hours',
      ),
      OrderTracking(
        orderId: 'ORD-2024-001',
        status: 'Processing',
        description: 'Your order is being prepared',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        location: 'Jihudumie Warehouse',
        estimatedDelivery: '4-6 hours',
      ),
      OrderTracking(
        orderId: 'ORD-2024-001',
        status: 'Order Confirmed',
        description: 'Your order has been confirmed',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        location: 'Online',
        estimatedDelivery: '1-2 days',
      ),
    ];
  }

  /// Get conversations by type
  List<Conversation> getConversationsByType(ConversationType type) {
    return _conversations.where((conv) => conv.type == type).toList();
  }

  /// Get conversation by ID
  Conversation? getConversationById(String id) {
    try {
      return _conversations.firstWhere((conv) => conv.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get messages for conversation
  List<Message> getMessagesForConversation(String conversationId) {
    final conversation = getConversationById(conversationId);
    return conversation?.messages ?? [];
  }

  /// Send a message
  void sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    SenderType senderType = SenderType.customer,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    Map<String, dynamic>? metadata,
  }) {
    final conversationIndex = _conversations.indexWhere(
      (conv) => conv.id == conversationId,
    );

    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      final newMessage = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: conversationId,
        content: content,
        type: type,
        senderType: senderType,
        senderId: senderId ?? 'customer_1',
        senderName: senderName ?? 'You',
        senderAvatar: senderAvatar,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
        metadata: metadata,
      );

      final updatedMessages = List<Message>.from(conversation.messages)
        ..add(newMessage);

      _conversations[conversationIndex] = conversation.copyWith(
        messages: updatedMessages,
        lastMessageTime: DateTime.now(),
      );
    }
  }

  /// Mark conversation as read
  void markConversationAsRead(String conversationId) {
    final conversationIndex = _conversations.indexWhere(
      (conv) => conv.id == conversationId,
    );

    if (conversationIndex != -1) {
      _conversations[conversationIndex] = _conversations[conversationIndex]
          .copyWith(unreadCount: 0);
    }
  }

  /// Get order tracking for specific order
  List<OrderTracking> getOrderTracking(String orderId) {
    return _orderTracking
        .where((tracking) => tracking.orderId == orderId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get total unread count
  int get totalUnreadCount {
    return _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  /// Search conversations
  List<Conversation> searchConversations(String query) {
    if (query.isEmpty) return _conversations;

    final lowercaseQuery = query.toLowerCase();
    return _conversations.where((conv) {
      return conv.title.toLowerCase().contains(lowercaseQuery) ||
          conv.subtitle?.toLowerCase().contains(lowercaseQuery) == true ||
          conv.lastMessage?.content.toLowerCase().contains(lowercaseQuery) ==
              true;
    }).toList();
  }

  /// Create new conversation
  void createConversation({
    required String title,
    String? subtitle,
    String? avatar,
    required ConversationType type,
    String? orderId,
    String? vendorId,
    String? deliveryManId,
  }) {
    final newConversation = Conversation(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      avatar: avatar,
      type: type,
      orderId: orderId,
      vendorId: vendorId,
      deliveryManId: deliveryManId,
      lastMessageTime: DateTime.now(),
    );

    _conversations.insert(0, newConversation);
  }
}
