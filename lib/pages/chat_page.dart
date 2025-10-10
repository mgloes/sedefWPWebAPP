import 'dart:convert';
import 'dart:html' as html;

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sedefwpwebapp/models/get_all_message_for_main_phones_model/get_all_message_for_main_phones_model.dart';
import 'package:sedefwpwebapp/models/get_all_message_model/get_all_message_model.dart';
import 'package:sedefwpwebapp/models/message_model/message_model.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';
import 'package:sedefwpwebapp/view_models/main_view_model.dart';
import '../contants.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MainViewModel _mainViewModel = MainViewModel();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  String? selectedMainPhoneId;
  String? selectedPhoneId;
  String? selectedContactPhone;
  String? selectedMainPhone;
  
  // Okunmamış mesaj sayılarını takip etmek için
  // Key: "mainPhone_contactPhone" formatında
  Map<String, int> unreadCounts = {};

  @override
  void initState() {
    super.initState();
    // Veri yükleme işlemleri initState'de yapılır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
    
    // Mesaj listesini dinle ve yeni mesaj geldiğinde scroll et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        _mainViewModel.messages,
        (previous, next) {
          if (next.isNotEmpty && previous != null && next.length > previous.length) {
            // Yeni mesaj geldiğinde ses çal (sadece alınan mesajlar için)
            final newMessage = next.last;
            if (newMessage.senderPhoneNumber != selectedMainPhone) {
              _playMessageSound();
            }
            
            // Yeni mesaj geldiğinde scroll et
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
      );
      
      // AllMessages listesini dinle ve yeni mesaj geldiğinde unread count artır
      ref.listenManual(
        _mainViewModel.allMessages,
        (previous, next) {
          if (previous != null && next.isNotEmpty) {
            // Yeni mesaj geldiğinde unread count'u güncelle
            for (var phoneData in next) {
              if (phoneData.messages != null) {
                for (var message in phoneData.messages!) {
                  String key = "${phoneData.phoneNumber}_${message.phoneNumber}";
                  
                  // Eğer bu konuşma şu anda açık değilse unread count artır
                  if (selectedMainPhone != phoneData.phoneNumber || 
                      selectedContactPhone != message.phoneNumber) {
                    
                    // Önceki listede bu mesaj var mı kontrol et
                    bool isNewMessage = true;
                    if (previous.isNotEmpty) {
                      var previousPhoneData = previous.firstWhere(
                        (p) => p.phoneNumber == phoneData.phoneNumber, 
                        orElse: () => GetAllMessageForMainPhonesModel(phoneNumber: '', messages: [])
                      );
                      
                      if (previousPhoneData.phoneNumber?.isNotEmpty == true && 
                          previousPhoneData.messages != null) {
                        var previousMessage = previousPhoneData.messages!.firstWhere(
                          (m) => m.phoneNumber == message.phoneNumber,
                          orElse: () => GetAllMessageModel(phoneNumber: '', lastMessage: '', lastMessageDate: DateTime.now())
                        );
                        
                        // Aynı mesaj varsa ve tarih aynıysa yeni değil
                        if (previousMessage.phoneNumber?.isNotEmpty == true &&
                            previousMessage.lastMessage == message.lastMessage &&
                            previousMessage.lastMessageDate == message.lastMessageDate) {
                          isNewMessage = false;
                        }
                      }
                    }
                    
                    if (isNewMessage) {
                      // Yeni mesaj geldiğinde ses çal
                      _playMessageSound();
                      
                      setState(() {
                        unreadCounts[key] = (unreadCounts[key] ?? 0) + 1;
                      });
                    }
                  }
                }
              }
            }
          }
        },
      );
    });
  }

  Future<void> _loadInitialData() async {
    loggedUserToken = await getSharedPrefs(4, "accessToken") ?? "";
    if(loggedUserToken.isEmpty){
      context.go('/');
      return;
    }
    await _mainViewModel.getMyUser(ref, context);
    await _mainViewModel.connectToSocket(ref, context);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Mesaj sesi çalma fonksiyonu
  Future<void> _playMessageSound() async {
    try {
      // Assets klasöründeki notification.mp3 dosyasını çal
      await _audioPlayer.play(AssetSource('assets/sounds/notification.mp3'));
    } catch (e) {
      try {
        // Alternatif: Volume ayarlayıp tekrar dene
        await _audioPlayer.setVolume(0.5);
        await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      } catch (e2) {
        // Son çare: Console'da mesaj göster
        print('🔔 Yeni mesaj geldi! (Ses çalamadı)');
        
        // Web için HTML5 notification gösterebiliriz
        try {
          html.Notification('Yeni Mesaj', body: 'WhatsApp Web\'de yeni bir mesaj aldınız!');
        } catch (e3) {
          // Hiçbir şey yapma, sadece console log
        }
      }
    }
  }

  void _selectPhone(String phoneId, String mainPhoneId) {
    setState(() {
      selectedPhoneId = phoneId;
      selectedContactPhone = null;
      selectedMainPhone = null;
      selectedMainPhoneId = mainPhoneId;
      ref.read(_mainViewModel.messages.notifier).state = [];
    });
  }

  void _selectContact(String contactPhone, String mainPhone) {
    setState(() {
      selectedContactPhone = contactPhone;
      selectedMainPhone = mainPhone;
      
      // Bu kontak seçildiğinde unread count'u sıfırla
      String key = "${mainPhone}_${contactPhone}";
      unreadCounts[key] = 0;
    });
    
    // Seçilen kontak için mesajları yükle
    _mainViewModel.GetMessagesByPhoneNumber(ref, context, contactPhone, mainPhone);
    
    // Mesajları yükledikten sonra en alta scroll et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || 
        selectedContactPhone == null || 
        selectedMainPhone == null) return;

    _mainViewModel.socket.sink.add(json.encode(
     {
      "PhoneNumberId": selectedMainPhoneId,
      "To": selectedContactPhone,
      "AccessToken": wpAccessToken,
      "MessageType": "text",
      "Message": _messageController.text
}
    ));

    ref.read(_mainViewModel.messages.notifier).state.add(MessageModel(
      id: null,
      senderPhoneNumber: selectedMainPhone,
      receiverPhoneNumber: selectedContactPhone,
      textBody: _messageController.text,
      messageType: "text",
      timestamp: DateTime.now().toIso8601String(),
    ));
    setState(() {
      
    });
    // Burada mesaj gönderme API'si çağrılabilir
    // Şimdilik sadece mesajı temizliyoruz
    _messageController.clear();
    
    // Mesaj gönderildikten sonra scroll et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Reverse ListView için minimum scroll position'a git (en alt)
      _scrollController.animateTo(
        0.0, // Reverse ListView'de 0 en alt demek
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    context.go('/settings');
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod state'leri izle
    final phoneNumbers = ref.watch(_mainViewModel.phoneNumbers);
    final allMessages = ref.watch(_mainViewModel.allMessages);
    final messages = ref.watch(_mainViewModel.messages);
    final loggedUser = ref.watch(_mainViewModel.loggedUser);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          // Left Panel - Phone Numbers
          _buildPhoneNumberPanel(phoneNumbers, loggedUser),
          
          // Middle Panel - Contacts
          if (selectedPhoneId != null) _buildContactsPanel(allMessages),
          
          // Right Panel - Chat
          Expanded(
            child: selectedContactPhone != null 
                ? _buildChatPanel(messages) 
                : _buildEmptyPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberPanel(List<PhoneNumberModel> phoneNumbers, dynamic loggedUser) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: mainColor,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
        ),
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
                  child: Image.asset("assets/images/logo.png", height: 32)
                ),
                const Spacer(),
                IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Çıkış Yap',
                ),
              ],
            ),
          ),
          
          // User Info
          if (loggedUser.name != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: secondaryColor,
                    child: Text(
                      loggedUser.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loggedUser.name ?? 'Kullanıcı',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   loggedUser.email ?? '',
                        //   style: TextStyle(
                        //     color: Colors.white.withOpacity(0.7),
                        //     fontSize: 12,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // Phone Numbers Title
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: const Text(
              'Sahip Olduğunuz Hatlar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Phone Numbers List
          Expanded(
            child: phoneNumbers.isEmpty
                ? const Center(
                    child: Text(
                      'Henüz telefon hattı yok',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    itemCount: phoneNumbers.length,
                    itemBuilder: (context, index) {
                      final phone = phoneNumbers[index];
                      final isSelected = selectedPhoneId == phone.phoneNumberId;
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? secondaryColor.withOpacity(0.3) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: (phone.status ?? false) ? Colors.green : Colors.grey,
                            radius: 8,
                          ),
                          title: Text(
                            phone.title ?? 'Bilinmeyen Hat',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            phone.phoneNumber ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          trailing: Builder(
                            builder: (context) {
                              // Bu telefon hattı için toplam unread count hesapla
                              int totalUnread = 0;
                              String phoneKey = phone.phoneNumber ?? '';
                              
                              unreadCounts.forEach((key, value) {
                                if (key.startsWith('${phoneKey}_')) {
                                  totalUnread += value;
                                }
                              });
                              
                              if (totalUnread > 0) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    totalUnread > 99 ? '99+' : totalUnread.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          onTap: () => _selectPhone(phone.phoneNumber ?? '',phone.phoneNumberId ?? ''),
                        ),
                      );
                    },
                  ),
          ),
          
          // Settings Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.settings),
                label: const Text('Ayarlar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsPanel(List<GetAllMessageForMainPhonesModel> allMessages) {
    // Seçilen telefon numarasına ait konuşmaları filtrele
    final filteredMessages = <GetAllMessageModel>[];
    
    for (var phoneGroup in allMessages) {
      if (phoneGroup.phoneNumber == selectedPhoneId) {
        if (phoneGroup.messages != null) {
          filteredMessages.addAll(phoneGroup.messages!);
        }
      }
    }
    
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat, color: secondaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Konuşmalar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                Text(
                  '${filteredMessages.length} konuşma',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Contacts List
          Expanded(
            child: filteredMessages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bu hat için konuşma yok',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index];
                      final isSelected = selectedContactPhone == message.phoneNumber;
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? secondaryColor.withOpacity(0.1) : null,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: mainColor,
                            child: Text(
                              message.phoneNumberNameSurname?.substring(0, 1).toUpperCase() ?? '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            message.phoneNumberNameSurname ?? 'Bilinmeyen',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            message.lastMessage ?? 'Mesaj yok',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (message.lastMessageDate != null)
                                Text(
                                  _formatTime(message.lastMessageDate!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              // Unread count göster
                              Builder(
                                builder: (context) {
                                  String key = "${selectedPhoneId}_${message.phoneNumber}";
                                  int unreadCount = unreadCounts[key] ?? 0;
                                  if (unreadCount > 0) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                          onTap: () => _selectContact(
                            message.phoneNumber ?? '', 
                            selectedPhoneId ?? ''
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatPanel(List<MessageModel> messages) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: const DecorationImage(
          image: NetworkImage('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23f8f9fa"/></svg>'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF667eea),
                  child: Text(
                    selectedContactPhone?.substring(0, 1).toUpperCase() ?? '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.phoneNumberNameSurname   ?? 'Konuşma') + ' ($selectedContactPhone)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${messages.length} mesaj',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Refresh messages
                    if (selectedContactPhone != null && selectedMainPhone != null) {
                      _mainViewModel.GetMessagesByPhoneNumber(
                        ref, context, selectedContactPhone!, selectedMainPhone!
                      );
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Yenile',
                ),
              ],
            ),
          ),
          
          // Messages
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      'Henüz mesaj yok',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Mesajlar en alttan başlasın
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // Reverse olduğu için index'i tersine çevir
                      final reversedIndex = messages.length - 1 - index;
                      final message = messages[reversedIndex];
                      return ChatBubble(message: message, isUser: message.senderPhoneNumber == selectedMainPhone);
                    },
                  ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF667eea)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    textInputAction: TextInputAction.send, // Enter tuşunu send olarak belirle
                    maxLines: 1, // Tek satırlı yap ki Enter tuşu mesaj göndersin
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF667eea),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                    tooltip: 'Gönder',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPanel() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 128,
              color: Colors.grey,
            ),
            SizedBox(height: 24),
            Text(
              'Sedef WP Web',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bir konuşma seçin ve mesajlaşmaya başlayın',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}g';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}s';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}dk';
    } else {
      return 'şimdi';
    }
  }
}

class ChatBubble extends ConsumerWidget {
  final MessageModel message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

 
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF667eea).withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: Color(0xFF667eea),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF667eea)
                        : const Color(0xFFF1F3F4),
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                      bottomLeft: isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                    ),
                  ),
                  child:message.messageType == "text" ? Text(
                    message.textBody ?? '',
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF2D3748),
                      fontSize: 14,
                    ),
                  ): message.messageType == "image" ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CachedNetworkImage yerine Image.network deneyelim
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: envPath + "/Message/getMedia?mediaId=" + message.imageUrl!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            httpHeaders: getGeneralHeaders(isAuth: true),
                            cacheManager: DefaultCacheManager(),
                            placeholder: (context, url) => Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              print('CachedNetworkImage Error: $error');
                              // Hata durumunda Image.network'e fallback
                              return Image.network(
                                envPath + "/Message/getMedia?mediaId=" + message.imageUrl!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                headers: getGeneralHeaders(isAuth: true),
                                errorBuilder: (context, imgError, stackTrace) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error, color: Colors.red, size: 32),
                                          SizedBox(height: 8),
                                          Text('Resim yüklenemedi', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ) : const Text(
                    'Desteklenmeyen mesaj türü',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.createdDate != null 
                      ? _formatTime(message.createdDate!)
                      : '',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF667eea),
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

}