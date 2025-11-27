// 설명: 선택한 채팅방의 메시지 히스토리를 보여주고 새 메시지를 전송하는 화면.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_room.dart';
import '../../state/app_state.dart';
import '../../theme/spacing.dart';

class ChatRoomScreen extends StatefulWidget {
  final String? roomId;
  final ChatRoom? room;

  const ChatRoomScreen({super.key, this.roomId, this.room})
    : assert(roomId != null || room != null, 'roomId 또는 room 중 하나는 필수입니다.');

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String get _roomId => widget.room?.id ?? widget.roomId!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppState>().markRoomAsRead(_roomId);
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<AppState>().sendMessage(roomId: _roomId, text: text);
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final room =
        widget.room ??
        appState.chatRooms.firstWhere((element) => element.id == _roomId);
    final partner = room.partner;
    return Scaffold(
      appBar: AppBar(title: Text(partner.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(DaytwoSpacing.s16),
              itemCount: room.messages.length,
              itemBuilder: (context, index) {
                final message = room.messages[index];
                final isMine = message.senderId == appState.currentUser.id;
                return Align(
                  alignment: isMine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isMine ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isMine ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(DaytwoSpacing.s16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: '메시지를 입력하세요'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: DaytwoSpacing.s12),
                  IconButton(icon: const Icon(Icons.send), onPressed: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
