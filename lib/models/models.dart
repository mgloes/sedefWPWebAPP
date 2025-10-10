
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatar;
  final DateTime lastMessageTime;
  final String lastMessage;
  final int unreadCount;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.avatar,
    required this.lastMessageTime,
    required this.lastMessage,
    this.unreadCount = 0,
  });
}


enum MessageStatus { sending, sent, delivered, read }