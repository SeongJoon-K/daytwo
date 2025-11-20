// 설명: 매칭이 성사된 상대 목록을 보여주고 채팅방으로 이동시키는 화면.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../messages/chat_room_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  void _openChat(BuildContext context, String partnerId) {
    final appState = context.read<AppState>();
    final match = appState.matches.firstWhere((m) => m.user.id == partnerId);
    final room = appState.ensureChatRoom(match.user);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatRoomScreen(roomId: room.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = context.watch<AppState>().matches.where((m) => m.isMatched).toList();
    if (matches.isEmpty) {
      return const Center(child: Text('아직 매칭된 상대가 없어요. 좋아요를 눌러보세요!'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(DaytwoSpacing.s24),
      itemBuilder: (context, index) {
        final match = matches[index];
        final user = match.user;
        ImageProvider? avatar;
        if (user.photoUrl != null) {
          if (user.photoUrl!.startsWith('data:image')) {
            avatar = MemoryImage(base64Decode(user.photoUrl!.split(',').last));
          } else if (user.photoUrl!.startsWith('http')) {
            avatar = NetworkImage(user.photoUrl!);
          } else {
            avatar = AssetImage(user.photoUrl!);
          }
        }
        return ListTile(
          onTap: () => _openChat(context, user.id),
          leading: CircleAvatar(
            backgroundImage: avatar ?? const AssetImage('assets/images/mock_profile_1.jpg'),
          ),
          title: Text(user.name),
          subtitle: Text(match.lastActivityText),
          trailing: const Icon(Icons.chevron_right),
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: DaytwoSpacing.s12),
      itemCount: matches.length,
    );
  }
}
