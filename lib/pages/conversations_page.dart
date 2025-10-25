import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sedefwpwebapp/models/conversation_model/conversation_model.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';
import 'package:sedefwpwebapp/view_models/main_view_model.dart';
import '../contants.dart';

class ConversationsPage extends ConsumerStatefulWidget {
  const ConversationsPage({super.key});

  @override
  ConsumerState<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<ConversationsPage> {
  final MainViewModel _mainViewModel = MainViewModel();
  String _searchQuery = '';
  String _statusFilter = 'all'; // all, active, inactive

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    loggedUserToken = await getSharedPrefs(4, "accessToken") ?? "";
    if(loggedUserToken.isEmpty){
      context.go('/');
      return;
    }
    await _mainViewModel.getMyUser(ref, context, needToGo: false);
    await _mainViewModel.getListConversations(ref, context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Bilinmiyor';
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  List<ConversationModel> _getFilteredConversations(List<ConversationModel> conversations) {
    var filtered = conversations.where((conversation) {
      final matchesSearch = _searchQuery.isEmpty ||
          (conversation.customerNameSurname?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (conversation.customerPhoneNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (conversation.userNameSurname?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      final matchesStatus = _statusFilter == 'all' ||
          (_statusFilter == 'active' && (conversation.status ?? false)) ||
          (_statusFilter == 'inactive' && !(conversation.status ?? false));

      return matchesSearch && matchesStatus;
    }).toList();

    // Son oluşturulan tarih sırasına göre sırala
    filtered.sort((a, b) {
      if (a.createdDate == null && b.createdDate == null) return 0;
      if (a.createdDate == null) return 1;
      if (b.createdDate == null) return -1;
      return b.createdDate!.compareTo(a.createdDate!);
    });

    return filtered;
  }



  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(_mainViewModel.conversations);
    final loggedUser = ref.watch(_mainViewModel.loggedUser);
    final filteredConversations = _getFilteredConversations(conversations);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.9),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset("assets/images/logo.png", height: 40,),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Navigation
                _buildNavItem(Icons.chat, 'Chat', () => context.go('/chat')),
                _buildNavItem(Icons.forum, 'Konuşmalar', null, isActive: true),
                if (loggedUser.role == 'ADMIN')
                  _buildNavItem(Icons.settings, 'Ayarlar', () => context.go('/settings')),
                
                const Spacer(),
                
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Konuşmalar',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            'Müşteri konuşmalarını görüntüleyin ve yönetin',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Statistics Cards
                      Row(
                        children: [
                          _buildStatCard(
                            'Toplam',
                            conversations.length.toString(),
                            Icons.forum,
                            Colors.blue,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Aktif',
                            conversations.where((c) => c.status ?? false).length.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Pasif',
                            conversations.where((c) => !(c.status ?? false)).length.toString(),
                            Icons.cancel,
                            Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Search and Filter Bar
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Müşteri adı, telefon numarası veya kullanıcı adı ile ara...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: _statusFilter,
                          underline: const SizedBox(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('Tümü')),
                            DropdownMenuItem(value: 'active', child: Text('Aktif')),
                            DropdownMenuItem(value: 'inactive', child: Text('Pasif')),
                          ],
                          onChanged: (value) => setState(() => _statusFilter = value!),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Conversations List
                  Expanded(
                    child: _buildConversationsList(filteredConversations),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, VoidCallback? onTap, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? secondaryColor.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(List<ConversationModel> conversations) {
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz konuşma bulunamadı',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Müşteriler WhatsApp üzerinden mesaj gönderdiğinde burada görünecek',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // List Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Konuşmalar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${conversations.length} konuşma',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // List Content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildConversationCard(conversation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(ConversationModel conversation) {
    final isActive = conversation.status ?? false;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status Indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 16),
            
            // Conversation Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Info Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation.customerNameSurname ?? 'Bilinmeyen Müşteri',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  conversation.customerPhoneNumber ?? 'Bilinmiyor',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // User Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person,
                                size: 14,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                conversation.userNameSurname ?? 'Atanmamış',
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${conversation.userId ?? 'N/A'}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Additional Info Row
                  Row(
                    children: [
                      // Main Phone Info
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 14,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                conversation.mainPhoneNumber ?? 'Bilinmiyor',
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Creation Date
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(conversation.createdDate),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Status and Answer Info Row
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? 'Aktif' : 'Pasif',
                          style: TextStyle(
                            color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Answer Status
                      if (conversation.isAnswered != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (conversation.isAnswered ?? false) 
                                ? Colors.blue.withOpacity(0.1) 
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                (conversation.isAnswered ?? false) ? Icons.check : Icons.schedule,
                                size: 12,
                                color: (conversation.isAnswered ?? false) ? Colors.blue : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (conversation.isAnswered ?? false) ? 'Cevaplanmış' : 'Beklemede',
                                style: TextStyle(
                                  color: (conversation.isAnswered ?? false) ? Colors.blue : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Unanswered Message Count
                      if ((conversation.notAnsweredMessageCount ?? 0) > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${conversation.notAnsweredMessageCount} cevaplanmamış',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      
                      // End Date
                      if (conversation.conversationEndDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Bitiş: ${_formatDateTime(conversation.conversationEndDate)}',
                              style: TextStyle(
                                color: Colors.orange.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            const SizedBox(width: 16),
            Column(
              children: [
                // Chat button (sadece aktif konuşmalar için)
                if (isActive)
                  IconButton(
                    onPressed: () {
                      // Navigate to chat with this conversation
                      context.go('/chat');
                    },
                    icon: Icon(Icons.chat, color: secondaryColor),
                    tooltip: 'Konuşmaya Git',
                  ),
                
                // Status Switch (tüm konuşmalar için)
                Column(
                  children: [
                    Switch(
                      value: isActive,
                      onChanged: (bool value) async {
                        await _mainViewModel.updateConversation(
                          ref, 
                          context, 
                          conversation.id!, 
                          value
                        );
                        // Conversations listesini yenile
                        await _mainViewModel.getListConversations(ref, context);
                      },
                      activeColor: secondaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(
                      isActive ? 'Aktif' : 'Pasif',
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive ? Colors.green.shade600 : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}