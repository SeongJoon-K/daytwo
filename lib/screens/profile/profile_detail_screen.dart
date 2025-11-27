// 설명: 홈/리스트에서 넘어오는 유저의 상세 정보를 보여주는 화면.
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../models/user_profile.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/daytwo_app_bar.dart';
import '../../widgets/common/daytwo_tag.dart';

class ProfileDetailScreen extends StatelessWidget {
  final UserProfile profile;

  const ProfileDetailScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final genderLabel = _genderLabel(profile.gender);
    return Scaffold(
      appBar: DaytwoAppBar(title: profile.name),
      body: ListView(
        padding: const EdgeInsets.all(DaytwoSpacing.s24),
        children: [
          Hero(
            tag: 'profile-hero-${profile.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: _buildImage(),
              ),
            ),
          ),
          const SizedBox(height: DaytwoSpacing.s24),
          Text('${profile.name} · ${profile.age} · $genderLabel', style: DaytwoTypography.textTheme.displaySmall),
          const SizedBox(height: DaytwoSpacing.s8),
          Wrap(
            spacing: DaytwoSpacing.s8,
            runSpacing: DaytwoSpacing.s8,
            children: [
              DaytwoTag(label: genderLabel, icon: Icons.person_outline),
              DaytwoTag(label: profile.job, icon: Icons.work_outline),
              DaytwoTag(label: profile.location, icon: Icons.place_outlined),
              DaytwoTag(label: 'MBTI ${profile.mbti}', icon: Icons.bolt_outlined),
            ],
          ),
          const SizedBox(height: DaytwoSpacing.s24),
          Text('한 줄 소개', style: DaytwoTypography.textTheme.titleMedium),
          const SizedBox(height: DaytwoSpacing.s12),
          Text(profile.intro, style: DaytwoTypography.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final photo = profile.photoUrl ?? 'assets/images/mock_profile_1.jpg';
    if (photo.startsWith('data:image')) {
      return Image.memory(base64Decode(photo.split(',').last), fit: BoxFit.cover);
    }
    if (photo.startsWith('http')) {
      return Image.network(photo, fit: BoxFit.cover);
    }
    return Image.asset(photo, fit: BoxFit.cover);
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
}
