// 설명: 내 프로필 정보를 상태와 연결해 보여주고 수정 화면으로 이동하는 화면.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/secondary_button.dart';
import '../../widgets/common/primary_button.dart';
import 'edit_profile_screen.dart';
import '../legal/terms_of_service_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../support/support_center_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;
    final avatarImage = _resolveProfileImage(user.photoUrl);

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: DaytwoSpacing.s24,
        vertical: DaytwoSpacing.s32,
      ),
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Colors.black12,
          backgroundImage: avatarImage,
          child: avatarImage == null
              ? Text(
                  user.name.characters.first,
                  style: DaytwoTypography.textTheme.displaySmall?.copyWith(color: Colors.white),
                )
              : null,
        ),
        const SizedBox(height: DaytwoSpacing.s16),
        Text('${user.name} · ${user.age} · ${_genderLabel(user.gender)}', style: DaytwoTypography.textTheme.displaySmall),
        const SizedBox(height: DaytwoSpacing.s8),
        Text('${user.job} / ${user.location} · ${_genderLabel(user.gender)}', style: DaytwoTypography.textTheme.bodyMedium),
        const SizedBox(height: DaytwoSpacing.s8),
        Text(user.intro, style: DaytwoTypography.textTheme.bodyLarge),
        const SizedBox(height: DaytwoSpacing.s12),
        Chip(label: Text('MBTI ${user.mbti}')),
        const SizedBox(height: DaytwoSpacing.s24),
        PrimaryButton(
          label: '프로필 수정',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          ),
        ),
        const SizedBox(height: DaytwoSpacing.s12),
        SecondaryButton(label: '계정 설정', onPressed: () {}),
        const SizedBox(height: DaytwoSpacing.s32),
        Card(
          child: ListTile(
            title: const Text('매칭 현황'),
            subtitle: Text('현재 ${appState.matchedCount}명의 매칭이 진행 중이에요.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        const SizedBox(height: DaytwoSpacing.s16),
        ListTile(
          title: const Text('구독 정보'),
          subtitle: const Text('프리미엄 · 2025.12 까지'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: DaytwoSpacing.s16),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('이용약관'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('개인정보 처리방침'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.support_agent_outlined),
          title: const Text('고객센터 / 문의'),
          subtitle: const Text('help@daytwo.app'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupportCenterScreen()),
          ),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('알림 설정'),
          value: true,
          onChanged: (_) {},
        ),
        const SizedBox(height: DaytwoSpacing.s24),
        TextButton(
          onPressed: () {
            context.read<AppState>().logout();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('로그아웃', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }
}

String _genderLabel(String gender) {
  switch (gender) {
    case 'male':
      return '남자';
    case 'female':
      return '여자';
    default:
      return '기타';
  }
}

ImageProvider? _resolveProfileImage(String? image) {
  if (image == null) return null;
  if (image.startsWith('data:image')) {
    return MemoryImage(base64Decode(image.split(',').last));
  }
  if (image.startsWith('http')) {
    return NetworkImage(image);
  }
  return AssetImage(image);
}
