// 설명: 상대방과의 채팅방 정보를 보관하는 모델.
import 'user_profile.dart';
import 'message.dart';

class ChatRoom {
  final String id;
  final UserProfile partner;
  final List<Message> messages;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.partner,
    required this.messages,
    this.unreadCount = 0,
  });

  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;
}
