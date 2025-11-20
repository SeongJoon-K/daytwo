// 설명: 채팅방 내 개별 메시지를 표현하는 모델.
class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });
}
