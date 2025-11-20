// 설명: 메인 탭(Home) UI를 구성하고 추천/인기 리스트를 상태와 연동하는 화면.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/common_padding_box.dart';
import '../../widgets/profile/profile_main_card.dart';
import '../../widgets/profile/profile_list_item.dart';
import '../profile/profile_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetail(BuildContext context, UserProfile profile) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileDetailScreen(profile: profile)),
    );
  }

  void _handleLike(BuildContext context, UserProfile user) {
    final matched = context.read<AppState>().toggleLike(user);
    if (matched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.name}님과 매칭되었어요! Messages 탭에서 대화를 시작해 보세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recommended = appState.recommendedUser;
    final popular = appState.popularUsers;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        CommonPaddingBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DaytwoSpacing.s32),
              Text('오늘의 추천', style: DaytwoTypography.textTheme.displaySmall),
              const SizedBox(height: DaytwoSpacing.s12),
              Text(
                '30·40대를 위한 취향 기반 추천을 확인하세요',
                style: DaytwoTypography.textTheme.bodyLarge,
              ),
              const SizedBox(height: DaytwoSpacing.s24),
              ProfileMainCard(
                profile: recommended,
                onTap: () => _openDetail(context, recommended),
                overlayAction: Material(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () => _handleLike(context, recommended),
                    icon: Icon(
                      recommended.likedByMe ? Icons.favorite : Icons.favorite_border,
                      color: recommended.likedByMe ? DaytwoColors.primary : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DaytwoSpacing.s32),
              Text('지금 인기 있는 분들', style: DaytwoTypography.textTheme.titleMedium),
              const SizedBox(height: DaytwoSpacing.s16),
              ...popular.map(
                (profile) => Padding(
                  padding: const EdgeInsets.only(bottom: DaytwoSpacing.s12),
                  child: ProfileListItem(
                    profile: profile,
                    isLiked: profile.likedByMe,
                    onLike: () => _handleLike(context, profile),
                    onTap: () => _openDetail(context, profile),
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
