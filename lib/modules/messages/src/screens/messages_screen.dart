import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/index.dart';
import '../../../../shared/utilities/bottom_navigation_service.dart';
import '../../../sliver_appbar/src/sliver_appbar_module.dart';
import '../models/message_data.dart';
import '../services/message_service.dart';
import '../components/conversation_card.dart';
import '../components/order_tracking_card.dart';
import '../components/delivery_map_modal.dart';
import 'chat_screen.dart';

/// Messages screen for customer-vendor communication and delivery tracking
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  final MessageService _messageService = MessageService();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<Conversation> _allConversations = [];
  List<Conversation> _filteredConversations = [];
  List<OrderTracking> _orderTracking = [];
  String _searchQuery = '';
  bool _isLoading = true;
  int _currentBottomNavIndex = 3; // Messages tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Load initial data
  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _messageService.initializeService();
      setState(() {
        _allConversations = _messageService.conversations;
        _filteredConversations = _allConversations;
        _orderTracking = _messageService.orderTracking;
        _isLoading = false;
      });
    });
  }

  /// Handle search
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredConversations = _allConversations;
      } else {
        _filteredConversations = _messageService.searchConversations(query);
      }
    });
  }

  /// Handle bottom navigation tap
  void _onBottomNavTap(int index) {
    final previousIndex = _currentBottomNavIndex;

    setState(() {
      _currentBottomNavIndex = index;
    });

    BottomNavigationService.handleNavigationTap(
      context,
      index,
      currentIndex: previousIndex,
      onSamePageTap: () {
        // Optional: Handle same page tap
      },
    );
  }

  /// Handle conversation tap
  void _onConversationTap(Conversation conversation) {
    // Mark as read
    _messageService.markConversationAsRead(conversation.id);

    // Navigate to chat screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversation: conversation),
      ),
    );
  }

  /// Handle call delivery man
  void _onCallDeliveryMan(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phone'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle message delivery man
  void _onMessageDeliveryMan(String deliveryManId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening chat with delivery partner'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show delivery map modal
  void _showDeliveryMapModal(OrderTracking tracking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DeliveryMapModal(
            tracking: tracking,
            onCallDeliveryMan:
                tracking.deliveryManPhone != null
                    ? () {
                      Navigator.of(context).pop();
                      _onCallDeliveryMan(tracking.deliveryManPhone!);
                    }
                    : null,
            onMessageDeliveryMan:
                tracking.deliveryManId != null
                    ? () {
                      Navigator.of(context).pop();
                      _onMessageDeliveryMan(tracking.deliveryManId!);
                    }
                    : null,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBarModule.getFloatingBottomNavBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _onBottomNavTap,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        appBar: _buildAppBar(isDarkMode),
        body: _isLoading ? _buildLoadingState() : _buildBody(isDarkMode),
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
      title: Text(
        'Messages',
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Unread count badge
        //theme toggle
        Consumer<ThemeManager>(
          builder: (context, themeManager, _) {
            return IconButton(
              icon: Icon(
                themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                themeManager.toggleTheme();
              },
            );
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Orders'),
          Tab(text: 'Support'),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build body content
  Widget _buildBody(bool isDarkMode) {
    return Column(
      children: [
        // Search bar
        _buildSearchSection(isDarkMode),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllConversations(isDarkMode),
              _buildOrderTracking(isDarkMode),
              _buildSupportConversations(isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  /// Build search section
  Widget _buildSearchSection(bool isDarkMode) {
    return Container(
      padding: AppSpacing.screenPaddingMd,
      child: Column(
        children: [
          // Professional search bar with modern design (matching shops screen style)
          Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDarkMode
                        ? [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ]
                        : [Colors.white, Colors.grey[50]!],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                // Search icon with background
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                // Search input area
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Focus on search field
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search conversations',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface
                                    : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Find your messages and conversations',
                          style: AppTextStyles.caption.copyWith(
                            color:
                                isDarkMode
                                    ? AppColors.onDarkSurface.withOpacity(0.7)
                                    : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Voice search button
                Container(
                  width: 1,
                  height: 24,
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.3)
                          : Colors.grey[300],
                ),
                GestureDetector(
                  onTap: () {
                    // Handle voice search
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice search coming soon!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.mic_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Clear search button (when there's text)
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.clear_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build all conversations tab
  Widget _buildAllConversations(bool isDarkMode) {
    if (_filteredConversations.isEmpty) {
      return _buildEmptyState(
        'No conversations found',
        'Start a conversation with vendors or check your order updates',
        Icons.chat_bubble_outline,
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: _filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = _filteredConversations[index];
        return ConversationCard(
          conversation: conversation,
          onTap: () => _onConversationTap(conversation),
        );
      },
    );
  }

  /// Build order tracking tab
  Widget _buildOrderTracking(bool isDarkMode) {
    if (_orderTracking.isEmpty) {
      return _buildEmptyState(
        'No order tracking available',
        'Your order updates will appear here',
        Icons.local_shipping_outlined,
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: _orderTracking.length,
      itemBuilder: (context, index) {
        final tracking = _orderTracking[index];
        final isLatest = index == 0;

        return OrderTrackingCard(
          tracking: tracking,
          isLatest: isLatest,
          onCallDeliveryMan:
              tracking.deliveryManPhone != null
                  ? () => _onCallDeliveryMan(tracking.deliveryManPhone!)
                  : null,
          onMessageDeliveryMan:
              tracking.deliveryManId != null
                  ? () => _onMessageDeliveryMan(tracking.deliveryManId!)
                  : null,
          onTrackOnMap: () => _showDeliveryMapModal(tracking),
        );
      },
    );
  }

  /// Build support conversations tab
  Widget _buildSupportConversations(bool isDarkMode) {
    final supportConversations =
        _allConversations
            .where(
              (conv) =>
                  conv.type == ConversationType.jihudumie ||
                  conv.type == ConversationType.orderSupport,
            )
            .toList();

    if (supportConversations.isEmpty) {
      return _buildEmptyState(
        'No support conversations',
        'Contact Jihudumie support for assistance',
        Icons.support_agent,
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.md + 100, // Space for bottom nav
      ),
      itemCount: supportConversations.length,
      itemBuilder: (context, index) {
        final conversation = supportConversations[index];
        return ConversationCard(
          conversation: conversation,
          onTap: () => _onConversationTap(conversation),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon,
    bool isDarkMode,
  ) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color:
                  isDarkMode
                      ? AppColors.onDarkSurface.withOpacity(0.3)
                      : AppColors.onSurface.withOpacity(0.3),
            ),
            AppSpacing.gapVerticalLg,
            Text(
              title,
              style: AppTextStyles.headingSmall.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalSm,
            Text(
              subtitle,
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
}
