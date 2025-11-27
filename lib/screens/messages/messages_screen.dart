// 설명: 생성된 채팅방 목록을 보여주고 채팅 화면으로 이동시키는 화면.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../messages/chat_room_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<AppState>().chatRooms;
    if (rooms.isEmpty) {
      return const Center(child: Text('아직 대화가 없어요. 매칭을 성사시켜 보세요!'));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: DaytwoSpacing.s24, vertical: DaytwoSpacing.s24),
      itemBuilder: (_, index) {
        final room = rooms[index];
        final partner = room.partner;
        final lastMessage = room.lastMessage;
        ImageProvider? avatar;
        final photo = partner.photoUrl;
        if (photo != null) {
          if (photo.startsWith('data:image')) {
            avatar = MemoryImage(base64Decode(photo.split(',').last));
          } else if (photo.startsWith('http')) {
            avatar = NetworkImage(photo);
          } else {
            avatar = AssetImage(photo);
          }
        }
        return ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatRoomScreen(roomId: room.id)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: DaytwoSpacing.s8),
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: avatar ?? const AssetImage('assets/images/mock_profile_1.jpg'),
          ),
          title: Text(partner.name),
          subtitle: Text(lastMessage?.text ?? '아직 메시지가 없습니다.'),
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: room.unreadCount > 0
                ? Container(
                    key: ValueKey('unread-${room.id}-${room.unreadCount}'),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${room.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  )
                : Text(
                    lastMessage != null
                        ? '${lastMessage.createdAt.hour.toString().padLeft(2, '0')}:${lastMessage.createdAt.minute.toString().padLeft(2, '0')}'
                        : '',
                    key: ValueKey('time-${room.id}-${lastMessage?.id ?? 'none'}'),
                  ),
          ),
        );
      },
      separatorBuilder: (context, _) => const Divider(height: DaytwoSpacing.s16),
      itemCount: rooms.length,
    );
  }
}
