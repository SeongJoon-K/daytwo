// 설명: 메인 탭(Home) UI를 구성하고 추천/인기 리스트를 상태와 연동하는 화면.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_room.dart';
import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/common_padding_box.dart';
import '../../widgets/common/daytwo_logo.dart';
import '../../widgets/common/daytwo_tag.dart';
import '../../widgets/common/daytwo_animations.dart';
import '../../widgets/profile/profile_main_card.dart';
import '../../widgets/profile/profile_list_item.dart';
import '../messages/chat_room_screen.dart';
import '../profile/profile_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetail(BuildContext context, UserProfile profile) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileDetailScreen(profile: profile)),
    );
  }

  void _handleLike(BuildContext context, UserProfile user) {
    final room = context.read<AppState>().toggleLike(user);
    if (room != null) {
      _showMatchModal(context, user, room);
    }
  }

  void _showMatchModal(BuildContext context, UserProfile user, ChatRoom room) {
    final navigator = Navigator.of(context);
    showGeneralDialog(
      context: context,
      barrierLabel: 'match-dialog',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(DaytwoSpacing.s24),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(DaytwoSpacing.s24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('❤️', style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: DaytwoSpacing.s12),
                    Text(
                      '${user.name}님과 매칭되었어요! 🎉',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DaytwoSpacing.s8),
                    const Text(
                      '지금 바로 대화를 시작해 보세요.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DaytwoSpacing.s24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('닫기'),
                          ),
                        ),
                        const SizedBox(width: DaytwoSpacing.s12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoomScreen(room: room),
                                ),
                              );
                            },
                            child: const Text('채팅 시작하기'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return DaytwoAnimations.springDialog(animation: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recommended = appState.recommendedUser;
    final popular = appState.popularUsers;
    final matchedCount = appState.matchedCount;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        CommonPaddingBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DaytwoSpacing.s24),
              Row(
                children: [
                  const DaytwoLogo(size: 44, showWordmark: true),
                  const Spacer(),
                  DaytwoTag(label: '매칭 $matchedCount명', icon: Icons.favorite_outline),
                ],
              ),
              const SizedBox(height: DaytwoSpacing.s24),
              Text('오늘의 추천', style: DaytwoTypography.textTheme.displaySmall),
              const SizedBox(height: DaytwoSpacing.s12),
              Text(
                '30·40대를 위한 취향 기반 추천을 확인하세요',
                style: DaytwoTypography.textTheme.bodyLarge,
              ),
              const SizedBox(height: DaytwoSpacing.s24),
              DaytwoAnimations.fadeInUp(
                child: ProfileMainCard(
                  profile: recommended,
                  onTap: () => _openDetail(context, recommended),
                  overlayAction: Material(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: const CircleBorder(),
                    child: DaytwoAnimations.scalePopOnTap(
                      onTap: () => _handleLike(context, recommended),
                      child: Icon(
                        recommended.likedByMe ? Icons.favorite : Icons.favorite_border,
                        color: recommended.likedByMe ? DaytwoColors.primary : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DaytwoSpacing.s32),
              Text(
                '지금 인기 있는 분들',
                style: DaytwoTypography.textTheme.titleMedium,
              ),
              const SizedBox(height: DaytwoSpacing.s16),
              ...popular.asMap().entries.map(
                (entry) => DaytwoAnimations.fadeInUp(
                  delay: Duration(milliseconds: 40 * entry.key),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: DaytwoSpacing.s12),
                    child: ProfileListItem(
                      profile: entry.value,
                      isLiked: entry.value.likedByMe,
                      onLike: () => _handleLike(context, entry.value),
                      onTap: () => _openDetail(context, entry.value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DaytwoSpacing.s32),
      ],
    );
  }
}
