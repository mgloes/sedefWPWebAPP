import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:universal_html/html.dart' as universal_html;
import 'package:sedefwpwebapp/models/get_all_message_for_main_phones_model/get_all_message_for_main_phones_model.dart';
import 'package:sedefwpwebapp/models/get_all_message_model/get_all_message_model.dart';
import 'package:sedefwpwebapp/models/message_model/message_model.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';
import 'package:sedefwpwebapp/view_models/main_view_model.dart';
import 'package:sedefwpwebapp/widgets/pdf_viewer_widget.dart';
import '../contants.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final MainViewModel _mainViewModel = MainViewModel();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  String? selectedMainPhoneId;
  String? selectedPhoneId;
  String? selectedContactPhone;
  String? selectedMainPhone;
  
  // Okunmamış mesaj sayılarını takip etmek için
  // Key: "mainPhone_contactPhone" formatında
  // Map<String, int> unreadCounts = {};
  
  // Collapse durumları
  bool _isPhonePanelCollapsed = false;
  bool _isContactsPanelCollapsed = false;
  
  // İlk yükleme kontrolü
  bool _isInitialLoad = true;
  int _previousUnreadCount = 0;

  @override
  void initState() {
    super.initState();
    // Veri yükleme işlemleri initState'de yapılır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
    
    // Page visibility değişikliklerini dinle (başka tab'dan döndüğünde)
    html.document.addEventListener('visibilitychange', (_) {
      if (!html.document.hidden!) {
        _refreshUnreadCountOnFocus();
      }
    });
    
    // Window focus event'ini dinle
    html.window.onFocus.listen((_) {
      _refreshUnreadCountOnFocus();
    });
    
    // Mesaj listesini dinle ve yeni mesaj geldiğinde scroll et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        _mainViewModel.messages,
        (previous, next) {
          if (next.isNotEmpty && previous != null && next.length > previous.length) {
            // Yeni mesaj geldiğinde ses çal (sadece alınan mesajlar için)
            final newMessage = next.last;
            if (newMessage.senderPhoneNumber != selectedMainPhone && newMessage.senderPhoneNumber != "902164911946") {
              if(previous.isNotEmpty && !_isInitialLoad){
                _playMessageSound();
              }
            }
            // Yeni mesaj geldiğinde scroll et
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
      );
      
      // AllMessages listesini dinle ve totalUnreadCount artışını kontrol et
      ref.listenManual(
        _mainViewModel.allMessages,
        (previous, next) {
          // İlk yükleme sırasında ses çalma
          if (_isInitialLoad) {
            return;
          }
          
          // Eğer sayfa hidden ise hiç ses çalma, yalnızca title güncelle
          // if (html.document.hidden ?? false) {
          //   print('🔔 Sayfa hidden, ses çalmıyor');
          //   return;
          // }
          
          // Toplam okunmamış mesaj sayısını hesapla
          int currentUnreadCount = 0;
          try {
            for (var phoneData in next) {
              if (phoneData.messages != null) {
                for (var message in phoneData.messages!) {
                  if (message.conversation != null) {
                    currentUnreadCount += (message.conversation!.notAnsweredMessageCount ?? 0);
                  }
                }
              }
            }
          } catch (e) {
            print('🔔 Unread count hesaplama hatası: $e');
          }
          
          // Eğer unread count değişmişse
          if (currentUnreadCount != _previousUnreadCount) {
            print('🔔 Unread count değişti: $_previousUnreadCount -> $currentUnreadCount');
            
            // Eğer unread count artmışsa ve sayfa visible ise ses çal
            if (currentUnreadCount > _previousUnreadCount) {
              _playMessageSound();
            }
            
            // Yeni değeri sakla ve title'ı güncelle
            setState(() {
              _previousUnreadCount = currentUnreadCount;
            });
            _updateBrowserTitle(currentUnreadCount);
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
    
    // Browser notification izni iste
    _requestNotificationPermission();
    
    // Başlangıç unread count'u sakla
    _previousUnreadCount = _calculateTotalUnreadCount();
    
    // İlk yükleme tamamlandı
    setState(() {
      _isInitialLoad = false;
    });
  }
  
  Future<void> _requestNotificationPermission() async {
    try {
      final permission = await html.Notification.requestPermission();
      print('🔔 Notification permission: $permission');
    } catch (e) {
      print('🔔 Notification permission hatası: $e');
    }
  }

  // Sayfa focus aldığında unread count'u yenile
  Future<void> _refreshUnreadCountOnFocus() async {
    try {
      print('🔔 Sayfa focus aldı, veri yenileniyor...');
      
      // Direkt olarak getAllMessages çağır (Riverpod state'i günceller)
      // await _mainViewModel.getAllMessages(ref, context);
      
      // Biraz bekle ki state güncellensin
      // await Future.delayed(const Duration(milliseconds: 500));
      
      // // Unread count'u yenile ama DİKKAT: ses çalınmasını engelle
      // final newUnreadCount = _calculateTotalUnreadCount();
      // print('🔔 Yenilenen unread count: $_previousUnreadCount -> $newUnreadCount (ses YOK)');
      
      // // State'i güncelle (listener ses çalmayacak çünkü `html.document.hidden` false olacak)
      // setState(() {
      //   _previousUnreadCount = newUnreadCount;
      // });
      // _updateBrowserTitle(newUnreadCount);
    } catch (e) {
      print('🔔 Focus refresh hatası: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Tarayıcı başlığını güncelle
  void _updateBrowserTitle(int unreadCount) {
    try {
      final loggedUser = ref.read(_mainViewModel.loggedUser);
        if (loggedUser.role != "ADMIN") {
        unreadCount = (unreadCount / 2).ceil(); // ceil ile yuvarla
      }

      if (unreadCount > 0) {
        html.document.title = '($unreadCount) Sedef Döviz WhatsApp Destek';
      } else {
        html.document.title = 'Sedef Döviz WhatsApp Destek';
      }
    } catch (e) {
    }
  }

  // Toplam okunmamış mesaj sayısını hesapla
  int _calculateTotalUnreadCount() {
    int total = 0;
    try {
      final allMessages = ref.read(_mainViewModel.allMessages);
      final loggedUser = ref.read(_mainViewModel.loggedUser);
      
      for (var phoneData in allMessages) {
        if (phoneData.messages != null) {
          // Her konuşmanın notAnsweredMessageCount değerlerini topla
          for (var message in phoneData.messages!) {
            if (message.conversation != null) {
              total += (message.conversation!.notAnsweredMessageCount ?? 0) > 0 ? 1 : 0;
            }
          }
        }
      }
      
      // Admin değilse sayıyı yarıya böl
      // if (loggedUser.role != "ADMIN") {
      //   total = (total / 2).ceil(); // ceil ile yuvarla
      // }
    } catch (e) {
    }
    return total;
  }

  // Mesaj sesi çalma fonksiyonu
  Future<void> _playMessageSound() async {
    // Ses çal
    try {
      await _audioPlayer.setVolume(0.8);
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      print('🔔 Ses çalma hatası: $e');
    }
    
    // Browser notification göster
    try {
      if (html.Notification.permission == 'granted') {
        // html.Notification('🔔 Yeni Mesaj Geldi!', 
        //   body: 'Sedef Döviz WhatsApp\'ta yeni bir mesaj aldınız.',
        //   icon: 'icons/Icon-192.png',
        // );
      } else if (html.Notification.permission == 'default') {
        // İzin verilmemişse tekrar sor
        final permission = await html.Notification.requestPermission();
        if (permission == 'granted') {
          // html.Notification('🔔 Yeni Mesaj Geldi!', 
          //   body: 'Sedef Döviz WhatsApp\'ta yeni bir mesaj aldınız.',
          //   icon: 'icons/Icon-192.png',
          // );
        }
      }
    } catch (e) {
      print('🔔 Notification hatası: $e');
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

    // ref.read(_mainViewModel.messages.notifier).state.add(MessageModel(
    //   id: null,
    //   senderPhoneNumber: selectedMainPhone == "Özel Mesajlar" ? "902164911946" : selectedMainPhone!,
    //   senderNameSurname: (ref.read(_mainViewModel.loggedUser).name ?? "") + " " + (ref.read(_mainViewModel.loggedUser).surname ?? ""),
    //   receiverPhoneNumber: selectedContactPhone,
    //   textBody: _messageController.text,
    //   messageType: "text",
    //   createdDate: DateTime.now(),
    //   timestamp: DateTime.now().toIso8601String(),
    // ));
    setState(() {
      
    });
    // Burada mesaj gönderme API'si çağrılabilir
    // Şimdilik sadece mesajı temizliyoruz
    _messageController.clear();
    
    // Mesaj gönderildikten sonra scroll et ve TextField'a focus ver
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _messageFocusNode.requestFocus();
    });
  }

  // Konum gönderme fonksiyonu
  Future<void> _sendLocation() async {
    if (selectedContactPhone == null || selectedMainPhone == null) return;

    try {
      print('📍 Konum alınıyor...');
      
      // Tarayıcıdan konum al
      // final position = await _getLocationFromBrowser();
      
      // if (position == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Konum alınamadı'), backgroundColor: Colors.red),
      //   );
      //   return;
      // }
      // print('📍 Konum alındı: ${position['latitude']}, ${position['longitude']}');
      
      // Konum mesajını WhatsApp formatında gönder
      final locationUrl = 'https://maps.google.com/?q=${40.87944685858887},${29.231872558713608}';
      
      _mainViewModel.socket.sink.add(json.encode({
        "PhoneNumberId": selectedMainPhoneId,
        "To": selectedContactPhone,
        "AccessToken": wpAccessToken,
        "MessageType": "location",
        "Latitude": 40.87944685858887,
        "Longitude": 29.231872558713608,
        "LocationUrl": locationUrl,
      }));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📍 Konum gönderildi'), backgroundColor: Colors.green),
      );
    } catch (e) {
      print('📍 Konum gönderme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum gönderilemedi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Tarayıcıdan konum almak
  

  Future<void> _pickAndSendFile() async {
    if (selectedContactPhone == null || selectedMainPhone == null || selectedMainPhoneId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce bir konuşma seçin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true, // Web için gerekli
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        
        // Dosya boyutu kontrolü (örnek: max 50MB)
        if (file.size > 50 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dosya boyutu 50MB\'dan büyük olamaz'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Loading göster
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // XFile oluştur (Web için bytes kullanılır)
        XFile xFile = XFile.fromData(
          file.bytes!,
          name: file.name,
          mimeType: _getMimeType(file.extension ?? ''),
        );

        // Caption input dialog
        String? caption = await _showCaptionDialog(file.name);
        
        // Dosyayı gönder
        await _mainViewModel.sendMedia(
          ref,
          context,
          selectedMainPhone!,
          selectedContactPhone!,
          xFile,
          caption ?? '',
          selectedMainPhoneId!,
        );

        // Loading kapat
        Navigator.of(context).pop();

        // Başarı mesajı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${file.name} başarıyla gönderildi'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {          
        });
        // Mesajları yenile
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

      }
    } catch (e) {
      // Loading varsa kapat
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      print('Dosya seçme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosya seçiminde hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showCaptionDialog(String fileName) async {
    String caption = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dosya Açıklaması'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Dosya: $fileName'),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => caption = value,
                decoration: const InputDecoration(
                  hintText: 'Açıklama ekleyin (isteğe bağlı)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(caption),
              child: const Text('Gönder'),
            ),
          ],
        );
      },
    );
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      case '.mp4':
        return 'video/mp4';
      case '.avi':
        return 'video/avi';
      case '.mov':
        return 'video/quicktime';
      case '.txt':
        return 'text/plain';
      case '.zip':
        return 'application/zip';
      case '.rar':
        return 'application/x-rar-compressed';
      default:
        return 'application/octet-stream';
    }
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

  void _togglePhonePanel() {
    setState(() {
      _isPhonePanelCollapsed = !_isPhonePanelCollapsed;
    });
  }

  void _toggleContactsPanel() {
    setState(() {
      _isContactsPanelCollapsed = !_isContactsPanelCollapsed;
    });
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
            onPressed: () async {
              Navigator.of(context).pop();
              await sharedPrefsClear("accessToken");
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
    void _showConversation() {
    context.go('/conversations');
  }

  void _showEndConversationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görüşmeyi Bitir'),
        content: const Text('Bu görüşmeyi sonlandırmak istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _endConversation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Görüşmeyi Bitir'),
          ),
        ],
      ),
    );
  }

  Future<void> _endConversation() async {
    if (selectedContactPhone != null) {
      await _mainViewModel.updateConversationStatus(
        ref, 
        context, 
        selectedContactPhone!, 
        false // Konuşma durumunu false (bitmiş) olarak ayarla
      );
      
      // Başarılı olduğunda konuşma listesini yenile
      selectedContactPhone = null;
      selectedMainPhone = null;
      selectedMainPhoneId = null;
      await _mainViewModel.getAllMessages(ref, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod state'leri izle
    final phoneNumbers = ref.watch(_mainViewModel.phoneNumbers);
    final allMessages = ref.watch(_mainViewModel.allMessages);
    final messages = ref.watch(_mainViewModel.messages);
    final loggedUser = ref.watch(_mainViewModel.loggedUser);

    // Okunmamış mesaj sayısını hesapla ve tarayıcı başlığını güncelle
    final totalUnreadCount = _calculateTotalUnreadCount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateBrowserTitle(totalUnreadCount);
    });

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
      width: _isPhonePanelCollapsed ? 73 : 286,
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
                if (!_isPhonePanelCollapsed) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset("assets/images/logo.png", height: 32)
                  ),
                  const Spacer(),
                ],
                // Toggle button
                IconButton(
                  onPressed: _togglePhonePanel,
                  icon: Icon(
                    _isPhonePanelCollapsed ? Icons.menu : Icons.menu_open,
                    color: Colors.white,
                  ),
                  tooltip: _isPhonePanelCollapsed ? 'Genişlet' : 'Küçült',
                ),
                if (!_isPhonePanelCollapsed) ...[
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    tooltip: 'Çıkış Yap',
                  ),
                ],
              ],
            ),
          ),
          
          // Collapsed state - only icons
          if (_isPhonePanelCollapsed) ...[
            // User icon
            if (loggedUser.name != null)
              Container(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 16,
                  child: Text(
                    loggedUser.name?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            
            // Phone numbers as icons
            Expanded(
              child: ListView.builder(
                itemCount: phoneNumbers.length,
                itemBuilder: (context, index) {
                  final phone = phoneNumbers[index];
                  final isSelected = selectedPhoneId == phone.phoneNumberId;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: IconButton(
                      onPressed: () => _selectPhone(phone.phoneNumber ?? '', phone.phoneNumberId ?? ''),
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? secondaryColor.withOpacity(0.3) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.phone,
                          color: (phone.status ?? false) ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                      ),
                      tooltip: phone.title ?? 'Bilinmeyen Hat',
                    ),
                  );
                },
              ),
            ),
          ],
          
          // Expanded state - full content
          if (!_isPhonePanelCollapsed) ...[
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
                                try {
                                  final phoneMessages = ref.watch(_mainViewModel.allMessages).where((e) => e.phoneNumber == phoneKey);
                                  if (phoneMessages.isNotEmpty && phoneMessages.first.messages != null) {
                                    // Cevaplanmamış mesajı olan müşteri sayısını say (mesaj sayısını değil)
                                    totalUnread = phoneMessages.first.messages!
                                        .where((e) => e.conversation != null && (e.conversation!.notAnsweredMessageCount ?? 0) > 0)
                                        .length; // .length kullanarak kaç tane müşteri olduğunu sayıyoruz
                                  }
                                } catch (e) {
                                  totalUnread = 0;
                                }
                                
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
                            onTap: () => _selectPhone(phone.phoneNumber ?? '', phone.phoneNumberId ?? ''),
                          ),
                        );
                      },
                    ),
            ),
            
            // Settings Button
            ref.read(_mainViewModel.loggedUser).role != "ADMIN" ?Container() :  Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showConversation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.send_time_extension_outlined),
                  label: const Text('Atamalar'),
                ),
              ),
            ),

          ref.read(_mainViewModel.loggedUser).role != "ADMIN" ?Container() :  Container(
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
    
    // Mesajları son mesaj tarihine göre sırala (yeni mesajlar üstte)
    filteredMessages.sort((a, b) {
      final dateA = a.lastMessageDate ?? DateTime(1970);
      final dateB = b.lastMessageDate ?? DateTime(1970);
      return dateB.compareTo(dateA); // Descending order (yeni mesajlar üstte)
    });
    
    return Container(
      width: _isContactsPanelCollapsed ? 73 : 350,
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
                if (!_isContactsPanelCollapsed) ...[
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
                  const SizedBox(width: 8),
                ],
                // Toggle button
                IconButton(
                  onPressed: _toggleContactsPanel,
                  icon: Icon(
                    _isContactsPanelCollapsed ? Icons.chat : Icons.chat_outlined,
                    color: secondaryColor,
                  ),
                  tooltip: _isContactsPanelCollapsed ? 'Konuşmaları Genişlet' : 'Konuşmaları Küçült',
                ),
              ],
            ),
          ),
          
          // Collapsed state - only icons
          if (_isContactsPanelCollapsed) ...[
            Expanded(
              child: ListView.builder(
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final message = filteredMessages[index];
                  final isSelected = selectedContactPhone == message.phoneNumber;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: () => _selectContact(
                            message.phoneNumber ?? '', 
                            selectedPhoneId ?? ''
                          ),
                          icon: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected ? secondaryColor.withOpacity(0.1) : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CircleAvatar(
                              backgroundColor: mainColor,
                              radius: 16,
                              child: Text(
                                message.phoneNumberNameSurname?.substring(0, 1).toUpperCase() ?? '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          tooltip: message.phoneNumberNameSurname ?? 'Bilinmeyen',
                        ),
                        // Unread count badge
                        Builder(
                          builder: (context) {
                            // String key = "${selectedPhoneId}_${message.phoneNumber}";
                            // int unreadCount = unreadCounts[key] ?? 0;
                            int unreadCount = message.conversation?.notAnsweredMessageCount ?? 0;

                            if (unreadCount > 0) {
                              return Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          
          // Expanded state - full content
          if (!_isContactsPanelCollapsed) ...[
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
                                    int unreadCount = message.conversation?.notAnsweredMessageCount ?? 0;
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
                        (ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.phoneNumberNameSurname   ?? 'Konuşma') + ' ($selectedContactPhone)' ,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.converisationStatus == true ?  Text(
                        " Atanan Kişi: " + (ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.assignedUserInfo ?? 'Atanmamış' ) ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ) : Container(),
                      ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.converisationStatus == true ? Text(
                        " Geçen Süre: " + (detailedFormatTime(ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.assignedDate ?? DateTime.now())) ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ) : Container(),
                     
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
                // Görüşmeyi Bitir Butonu
               ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.converisationStatus == true && ref.read(_mainViewModel.allMessages).where((e) => e.phoneNumber == selectedMainPhone).first.messages!.where((e) => e.phoneNumber == selectedContactPhone).first.assignedUserInfo  == ((ref.read(_mainViewModel.loggedUser).name ?? "") + " " + (ref.read(_mainViewModel.loggedUser).surname ?? "")) ? Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: ElevatedButton.icon(
                    onPressed: () => _showEndConversationDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.call_end, size: 18),
                    label: const Text('Görüşmeyi Bitir'),
                  ),
                ): Container(),
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
                      return ChatBubble(
                        message: message,
                        isUser: message.senderPhoneNumber == (selectedMainPhone == "Özel Mesajlar" ? "902164911946" : selectedMainPhone),
                        context: context,
                      );
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
                // File picker button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _pickAndSendFile,
                    icon: const Icon(Icons.attach_file, color: Color(0xFF667eea)),
                    tooltip: 'Dosya Ekle',
                  ),
                ),
                const SizedBox(width: 8),
                // Location button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendLocation,
                    icon: const Icon(Icons.location_on, color: Color(0xFF667eea)),
                    tooltip: 'Konum Gönder',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
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
  String detailedFormatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    List<String> parts = [];
    
    // Gün hesaplama
    if (difference.inDays > 0) {
      parts.add('${difference.inDays} gün');
    }
    
    // Saat hesaplama (günler çıkarıldıktan sonra kalan saatler)
    final remainingHours = difference.inHours % 24;
    if (remainingHours > 0) {
      parts.add('$remainingHours saat');
    }
    
    // Dakika hesaplama (saatler çıkarıldıktan sonra kalan dakikalar)
    final remainingMinutes = difference.inMinutes % 60;
    if (remainingMinutes > 0) {
      parts.add('$remainingMinutes dakika');
    }
    
    // Saniye hesaplama (dakikalar çıkarıldıktan sonra kalan saniyeler)
    final remainingSeconds = difference.inSeconds % 60;
    if (parts.isEmpty && remainingSeconds >= 0) {
      if (remainingSeconds < 30) {
        return 'şimdi';
      } else {
        parts.add('$remainingSeconds saniye');
      }
    }
    
    // Sonucu birleştir
    if (parts.isEmpty) {
      return 'şimdi';
    } else if (parts.length == 1) {
      return parts[0];
    } else if (parts.length == 2) {
      return '${parts[0]} ${parts[1]}';
    } else {
      // 3 veya daha fazla parça varsa ilk ikisini göster
      return '${parts[0]} ${parts[1]}';
    }
  }
}

class ChatBubble extends ConsumerWidget {
  final MessageModel message;
  final bool isUser;
  final BuildContext context;

  const ChatBubble({
    super.key, 
    required this.message, 
    required this.isUser,
    required this.context,
  });

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
          Flexible(fit: FlexFit.tight, flex: 0,
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onSecondaryTap: () => _showMessageContextMenu(context),
                  child: Container(
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
                    child: _buildMessageContent(),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text((message.senderNameSurname != null ? message.senderNameSurname! : "") + ' · ' +
                      (message.createdDate != null 
                          ? _formatTime(message.createdDate!)
                          : ''),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (message.messageType == "text") ...[
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _copyMessage(),
                          child: Tooltip(
                            message: 'Kopyala',
                            child: Icon(
                              Icons.content_copy,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
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

  Widget _buildMessageContent() {
    switch (message.messageType) {
      case "text":
        return Container(constraints: BoxConstraints(maxWidth: 250),
          child: Text(
            message.textBody ?? '',
            style: TextStyle(
              color: isUser ? Colors.white : const Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
        );
      case "location":
        return _buildLocationWidget();
      case "image":
        return _buildImageWidget();
      case "document":
      case "file":
        return _buildFileWidget();
      case "audio":
        return _buildAudioWidget();
      case "video":
        return _buildVideoWidget();
      default:
        return Text(
          'Desteklenmeyen dosya türü: ${message.messageType}',
          style: TextStyle(
            color: isUser ? Colors.white70 : Colors.grey.shade600,
            fontSize: 14,
          ),
        );
    }
  }

  Widget _buildLocationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: isUser ? Colors.white : const Color(0xFF2D3748),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Konum',
              style: TextStyle(
                color: isUser ? Colors.white : const Color(0xFF2D3748),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUser ? Colors.white24 : Colors.grey.shade300,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: () {
                // Haritayı aç
                if (message.latitude != null && message.longitude != null) {
                  final url = 'https://maps.google.com/?q=${message.latitude},${message.longitude}';
                  html.window.open(url, '_blank');
                }
              },
              child: Stack(
                children: [
                  // Leaflet Harita HTML
                  _buildLeafletMap(message.latitude ?? 0, message.longitude ?? 0),
                  // Marker overlay
                  Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${message.latitude?.toStringAsFixed(4)}, ${message.longitude?.toStringAsFixed(4)}',
          style: TextStyle(
            color: isUser ? Colors.white70 : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget() {
    if (message.imageUrl?.isEmpty ?? true) {
      return const Text('Resim bulunamadı');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullScreenMedia(message.imageUrl!, 'image'),
          child: Container(
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
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.download,
              size: 16,
              color: isUser ? Colors.white70 : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _downloadFile(message.imageUrl!, 'resim.jpg'),
              child: Text(
                'İndir',
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF667eea),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFileWidget() {
    String fileName = message.imageCaption ?? 'dosya';
    String? fileUrl = message.imageUrl;
    
    if (fileUrl == null || fileUrl.isEmpty) {
      return const Text('Dosya bulunamadı');
    }

    // Dosya uzantısından dosya tipini belirle (caption'dan veya varsayılan)
    String extension = '';
    if (fileName.contains('.')) {
      extension = path.extension(fileName).toLowerCase();
    } else {
      // Varsayılan uzantı dosya tipine göre
      switch (message.messageType) {
        case 'document':
          extension = '.pdf';
          fileName = fileName + '.pdf';
          break;
        case 'audio':
          extension = '.mp3';
          fileName = fileName + '.mp3';
          break;
        case 'video':
          extension = '.mp4';
          fileName = fileName + '.mp4';
          break;
        default:
          extension = '.file';
          fileName = fileName + '.file';
      }
    }
    
    IconData fileIcon = _getFileIcon(extension);
    String fileType = _getFileType(extension);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 180), // 250'den 180'e düşürdüm
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUser ? Colors.white.withOpacity(0.3) : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                fileIcon,
                size: 28, // 32'den 28'e küçülttüm
                color: isUser ? Colors.white : const Color(0xFF667eea),
              ),
              const SizedBox(width: 8), // 12'den 8'e küçülttüm
              Expanded( // Flexible yerine Expanded kullandım ve sınırlı alan içinde
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFF2D3748),
                        fontSize: 13, // 14'ten 13'e küçülttüm
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1, // 2'den 1'e değiştirdim
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileType,
                      style: TextStyle(
                        color: isUser ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 11, // 12'den 11'e küçülttüm
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Önizleme butonu (sadece belirli dosya tipleri için)
            if (_canPreview(extension)) ...[
              GestureDetector(
                onTap: () => _showFullScreenMedia(fileUrl, extension),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: isUser ? Colors.white70 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Önizle',
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFF667eea),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
            // İndirme butonu
            GestureDetector(
              onTap: () => _downloadFile(fileUrl, fileName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download,
                    size: 16,
                    color: isUser ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'İndir',
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF667eea),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAudioWidget() {
    String? audioUrl = message.imageUrl;
    
    if (audioUrl == null || audioUrl.isEmpty) {
      return const Text('Ses dosyası bulunamadı');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 180), // 250'den 180'e düşürdüm
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUser ? Colors.white.withOpacity(0.3) : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.audiotrack,
                size: 28, // 32'den 28'e küçülttüm
                color: isUser ? Colors.white : const Color(0xFF667eea),
              ),
              const SizedBox(width: 8), // 12'den 8'e küçülttüm
              Expanded( // Column'u da sınırlı alanda tutmak için Expanded kullandım
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ses Dosyası',
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFF2D3748),
                        fontSize: 13, // 14'ten 13'e küçülttüm
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Audio',
                      style: TextStyle(
                        color: isUser ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 11, // 12'den 11'e küçülttüm
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Çal butonu
            GestureDetector(
              onTap: () => _playAudio(audioUrl),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow,
                    size: 16,
                    color: isUser ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Çal',
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF667eea),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // İndirme butonu
            GestureDetector(
              onTap: () => _downloadFile(audioUrl, 'ses.mp3'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download,
                    size: 16,
                    color: isUser ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'İndir',
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF667eea),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoWidget() {
    String? videoUrl = message.imageUrl;
    
    if (videoUrl == null || videoUrl.isEmpty) {
      return const Text('Video dosyası bulunamadı');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullScreenMedia(videoUrl, 'video'),
          child: Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.black12,
            ),
            child: Stack(
              children: [
                // Video thumbnail placeholder
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Video bilgi overlay
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.videocam,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Video',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Oynat butonu
            GestureDetector(
              onTap: () => _playVideo(videoUrl),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow,
                    size: 16,
                    color: isUser ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Oynat',
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF667eea),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // İndirme butonu
            GestureDetector(
              onTap: () => _downloadFile(videoUrl, 'video.mp4'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download,
                    size: 16,
                    color: isUser ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'İndir',
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF667eea),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.xls':
      case '.xlsx':
        return Icons.table_chart;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      case '.zip':
      case '.rar':
      case '.7z':
        return Icons.archive;
      case '.txt':
        return Icons.text_snippet;
      case '.mp3':
      case '.wav':
      case '.ogg':
        return Icons.audiotrack;
      case '.mp4':
      case '.avi':
      case '.mov':
        return Icons.video_file;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileType(String extension) {
    switch (extension) {
      case '.pdf':
        return 'PDF Dosyası';
      case '.doc':
      case '.docx':
        return 'Word Dosyası';
      case '.xls':
      case '.xlsx':
        return 'Excel Dosyası';
      case '.ppt':
      case '.pptx':
        return 'PowerPoint Dosyası';
      case '.zip':
      case '.rar':
      case '.7z':
        return 'Arşiv Dosyası';
      case '.txt':
        return 'Metin Dosyası';
      case '.mp3':
      case '.wav':
      case '.ogg':
        return 'Ses Dosyası';
      case '.mp4':
      case '.avi':
      case '.mov':
        return 'Video Dosyası';
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return 'Resim Dosyası';
      default:
        return 'Dosya';
    }
  }

  bool _canPreview(String extension) {
    const previewableExtensions = [
      '.jpg', '.jpeg', '.png', '.gif', // Resimler
      '.pdf', '.txt', // Dokümanlar
      '.mp3', '.wav', '.ogg', // Ses dosyaları
      '.mp4', '.avi', '.mov', // Video dosyaları
    ];
    return previewableExtensions.contains(extension);
  }

  void _showFullScreenMedia(String mediaId, String type) {
    final mediaUrl = envPath + "/Message/getMedia?mediaId=" + mediaId;
    
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: _buildPreviewWidget(mediaUrl, type),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                onPressed: () => _downloadFile(mediaId, 'dosya'),
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewWidget(String url, String type) {
    switch (type.toLowerCase()) {
      case 'image':
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: url,
            httpHeaders: getGeneralHeaders(isAuth: true),
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, color: Colors.white, size: 50),
            ),
          ),
        );
      case 'video':
      case '.mp4':
      case '.avi':
      case '.mov':
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Video Dosyası',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Videoyu oynatmak için aşağıdaki butonları kullanın',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _playVideo(url.replaceAll(envPath + "/Message/getMedia?mediaId=", "")),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Videoyu Oynat'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => _downloadFile(url.replaceAll(envPath + "/Message/getMedia?mediaId=", ""), 'video.mp4'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.download),
                      label: const Text('İndir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case '.pdf':
        return _buildPdfViewer(url);
      case '.txt':
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text(
              'Metin dosyası önizlemesi bu sürümde desteklenmiyor.\nİndirmek için sol üstteki indirme butonunu kullanın.',
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        );
      default:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_present, color: Colors.white, size: 80),
              SizedBox(height: 20),
              Text(
                'Bu dosya türü için önizleme desteklenmiyor',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
  }

  void _downloadFile(String mediaId, String fileName) async {
    try {
      final url = envPath + "/Message/getMedia?mediaId=" + mediaId;
      
      // Web üzerinde dosya indirme
      universal_html.AnchorElement anchorElement = universal_html.AnchorElement(href: url);
      anchorElement.download = fileName;
      anchorElement.click();
      
      // Alternatif olarak url_launcher kullanabilir
      // await launchUrl(Uri.parse(url));
      
    } catch (e) {
      print('Dosya indirme hatası: $e');
      // Hata durumunda kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosya indirilemedi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _playAudio(String audioUrl) async {
    try {
      final url = envPath + "/Message/getMedia?mediaId=" + audioUrl;
      
      // AudioPlayer instance'ı oluştur
      final AudioPlayer audioPlayer = AudioPlayer();
      
      // Ses dosyasını çal
      await audioPlayer.play(UrlSource(url));
      
    } catch (e) {
      print('Ses çalma hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ses dosyası çalınamadı: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _playVideo(String videoUrl) async {
    try {
      final url = envPath + "/Message/getMedia?mediaId=" + videoUrl;
      
      // Web'de video oynatmak için yeni bir tab/window açalım
      universal_html.window.open(url, '_blank');
      
    } catch (e) {
      print('Video oynatma hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video oynatılamadı: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = time.day == now.day && time.month == now.month && time.year == now.year;
    
    // Saat formatı
    final hourMinute = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    
    if (isToday) {
      // Bugün - sadece saat
      return hourMinute;
    } else {
      // Diğer günler - tarih + saat
      final day = time.day.toString().padLeft(2, '0');
      final month = time.month.toString().padLeft(2, '0');
      
      if (time.year == now.year) {
        // Bu yıl - gün/ay saat
        return '$day/$month $hourMinute';
      } else {
        // Farklı yıl - gün/ay/yıl saat
        final year = time.year.toString().substring(2);
        return '$day/$month/$year $hourMinute';
      }
    }
  }

  void _copyMessage() {
    if (message.messageType == "text" && message.textBody != null) {
      Clipboard.setData(ClipboardData(text: message.textBody!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mesaj kopyalandı'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showMessageContextMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          onTap: () => _copyMessage(),
          child: const Row(
            children: [
              Icon(Icons.content_copy, size: 18),
              SizedBox(width: 8),
              Text('Kopyala'),
            ],
          ),
        ),
        if (message.messageType == "text") ...[
          PopupMenuItem(
            onTap: () {
              final text = '${message.senderNameSurname}\n${message.textBody}';
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mesaj ve gönderenin adı kopyalandı'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.person_add, size: 18),
                SizedBox(width: 8),
                Text('Göndereni de Kopyala'),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPdfViewer(String url) {
    // URL kontrolü - eğer medya ID'si ise tam URL oluştur
    String pdfUrl = url;
    if (!url.contains('http')) {
      pdfUrl = envPath + "/Message/getMedia?mediaId=" + url;
    }
    
    // PDF viewer widget'ı doğrudan kullan - full screen overlay gösterir
    return PdfViewerWidget(pdfUrl: pdfUrl);
  }

  // Leaflet harita widget'ı
  Widget _buildLeafletMap(double latitude, double longitude) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 48,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              'Konum: $latitude, $longitude',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tıklayarak haritada aç',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 11,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }


}