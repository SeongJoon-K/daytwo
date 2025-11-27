// 설명: "지금 인기 있는 분들" 섹션에서 반복되는 프로필 리스트 아이템.
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../theme/colors.dart';
import '../common/daytwo_tag.dart';
import '../common/daytwo_animations.dart';

class ProfileListItem extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onTap;
  final bool isLiked;
  final VoidCallback onLike;

  const ProfileListItem({
    super.key,
    required this.profile,
    required this.onTap,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = profile.photoUrl ?? 'assets/images/mock_profile_1.jpg';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DaytwoSpacing.s16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 64,
                height: 64,
                child: _buildListItemImage(imagePath),
              ),
            ),
            const SizedBox(width: DaytwoSpacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${profile.name} · ${profile.age}', style: DaytwoTypography.textTheme.titleMedium),
                  const SizedBox(height: DaytwoSpacing.s4),
                  Text('${_genderLabel(profile.gender)} · ${profile.location} · ${profile.job}', style: DaytwoTypography.textTheme.bodyMedium),
                  const SizedBox(height: DaytwoSpacing.s4),
                  Wrap(
                    spacing: DaytwoSpacing.s8,
                    runSpacing: DaytwoSpacing.s4,
                    children: [
                      DaytwoTag(label: 'MBTI ${profile.mbti}', icon: Icons.bolt_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: DaytwoSpacing.s12),
            DaytwoAnimations.scalePopOnTap(
              onTap: onLike,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? DaytwoColors.primary : DaytwoColors.textSecondary,
              ),
            ),
            const SizedBox(width: DaytwoSpacing.s8),
            SizedBox(
              height: 40,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: DaytwoColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: onTap,
                child: const Text('보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildListItemImage(String imagePath) {
  if (imagePath.startsWith('data:image')) {
    final base64Data = imagePath.split(',').last;
    return Image.memory(base64Decode(base64Data), fit: BoxFit.cover);
  }
  if (imagePath.startsWith('http')) {
    return Image.network(imagePath, fit: BoxFit.cover);
  }
  return Image.asset(imagePath, fit: BoxFit.cover);
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
