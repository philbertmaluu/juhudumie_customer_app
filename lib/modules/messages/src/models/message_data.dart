/// Message data models for customer-vendor communication and delivery tracking

/// Message type enumeration
enum MessageType { text, image, orderUpdate, deliveryUpdate, system }

/// Message sender type
enum SenderType { customer, vendor, deliveryMan, system, jihudumie }

/// Message status
enum MessageStatus { sent, delivered, read, failed }

/// Individual message model
class Message {
  final String id;
  final String conversationId;
  final String content;
  final MessageType type;
  final SenderType senderType;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.type,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.metadata,
  });

  /// Create a copy with updated properties
  Message copyWith({
    String? id,
    String? conversationId,
    String? content,
    MessageType? type,
    SenderType? senderType,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    DateTime? timestamp,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      type: type ?? this.type,
      senderType: senderType ?? this.senderType,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get formatted timestamp
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if message is from customer
  bool get isFromCustomer => senderType == SenderType.customer;

  /// Check if message is from vendor
  bool get isFromVendor => senderType == SenderType.vendor;

  /// Check if message is from delivery man
  bool get isFromDeliveryMan => senderType == SenderType.deliveryMan;

  /// Check if message is system message
  bool get isSystemMessage => senderType == SenderType.system;
}

/// Conversation model
class Conversation {
  final String id;
  final String title;
  final String? subtitle;
  final String? avatar;
  final ConversationType type;
  final String? orderId;
  final String? vendorId;
  final String? deliveryManId;
  final List<Message> messages;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const Conversation({
    required this.id,
    required this.title,
    this.subtitle,
    this.avatar,
    required this.type,
    this.orderId,
    this.vendorId,
    this.deliveryManId,
    this.messages = const [],
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isActive = true,
    this.metadata,
  });

  /// Create a copy with updated properties
  Conversation copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? avatar,
    ConversationType? type,
    String? orderId,
    String? vendorId,
    String? deliveryManId,
    List<Message>? messages,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
      vendorId: vendorId ?? this.vendorId,
      deliveryManId: deliveryManId ?? this.deliveryManId,
      messages: messages ?? this.messages,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get last message
  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// Get formatted last message time
  String get formattedLastMessageTime {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Conversation type enumeration
enum ConversationType { vendor, delivery, jihudumie, orderSupport }

/// Order tracking information
class OrderTracking {
  final String orderId;
  final String status;
  final String description;
  final DateTime timestamp;
  final String? location;
  final String? deliveryManId;
  final String? deliveryManName;
  final String? deliveryManPhone;
  final String? estimatedDelivery;

  const OrderTracking({
    required this.orderId,
    required this.status,
    required this.description,
    required this.timestamp,
    this.location,
    this.deliveryManId,
    this.deliveryManName,
    this.deliveryManPhone,
    this.estimatedDelivery,
  });

  /// Get formatted timestamp
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Delivery man information
class DeliveryMan {
  final String id;
  final String name;
  final String phone;
  final String? avatar;
  final double rating;
  final int totalDeliveries;
  final String? currentLocation;
  final bool isOnline;

  const DeliveryMan({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar,
    required this.rating,
    required this.totalDeliveries,
    this.currentLocation,
    this.isOnline = false,
  });

  /// Get formatted rating
  String get formattedRating => rating.toStringAsFixed(1);

  /// Get status text
  String get statusText => isOnline ? 'Online' : 'Offline';
}

/// Vendor information
class Vendor {
  final String id;
  final String name;
  final String? avatar;
  final double rating;
  final String? description;
  final bool isOnline;
  final String? responseTime;

  const Vendor({
    required this.id,
    required this.name,
    this.avatar,
    required this.rating,
    this.description,
    this.isOnline = false,
    this.responseTime,
  });

  /// Get formatted rating
  String get formattedRating => rating.toStringAsFixed(1);

  /// Get status text
  String get statusText => isOnline ? 'Online' : 'Offline';
}
