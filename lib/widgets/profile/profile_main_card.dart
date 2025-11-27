// 설명: 홈 상단 "오늘의 추천" 영역에 배치되는 대형 프로필 카드.
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class ProfileMainCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onTap;
  final Widget? overlayAction;
  final bool enableHero;

  const ProfileMainCard({
    super.key,
    required this.profile,
    required this.onTap,
    this.overlayAction,
    this.enableHero = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.88;
    final double cardHeight = size.height * 0.45;
    const borderRadius = BorderRadius.all(Radius.circular(24));
    final String imagePath = profile.photoUrl ?? 'assets/images/mock_profile_1.jpg';
    final genderLabel = _genderLabel(profile.gender);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.symmetric(vertical: DaytwoSpacing.s8),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: enableHero
                        ? Hero(tag: 'profile-hero-${profile.id}', child: _buildProfileImage(imagePath))
                        : _buildProfileImage(imagePath),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      DaytwoSpacing.s20,
                      DaytwoSpacing.s24,
                      DaytwoSpacing.s20,
                      DaytwoSpacing.s24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DaytwoSpacing.s12,
                            vertical: DaytwoSpacing.s4,
                          ),
                          decoration: BoxDecoration(
                            color: DaytwoColors.surface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('오늘의 추천', style: DaytwoTypography.textTheme.labelMedium?.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(height: DaytwoSpacing.s12),
                        Text(
                          '${profile.name} · ${profile.age} · $genderLabel',
                          style: DaytwoTypography.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: DaytwoSpacing.s8),
                        Text(
                          '${profile.job} · ${profile.location}',
                          style: DaytwoTypography.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        const SizedBox(height: DaytwoSpacing.s4),
                        Text(
                          'MBTI: ${profile.mbti}',
                          style: DaytwoTypography.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  if (overlayAction != null)
                    Positioned(
                      top: DaytwoSpacing.s16,
                      right: DaytwoSpacing.s16,
                      child: overlayAction!,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileImage(String imagePath) {
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
