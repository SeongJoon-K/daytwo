import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/daytwo_app_bar.dart';
import '../../widgets/common/primary_button.dart';

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaytwoAppBar(title: '고객센터'),
      body: ListView(
        padding: const EdgeInsets.all(DaytwoSpacing.s24),
        children: [
          Text('무엇을 도와드릴까요?', style: DaytwoTypography.textTheme.headlineSmall),
          const SizedBox(height: DaytwoSpacing.s8),
          Text(
            '매칭/결제/계정 관련 문의를 남겨주시면 최대 1 영업일 내 답변드립니다.',
            style: DaytwoTypography.textTheme.bodyMedium,
          ),
          const SizedBox(height: DaytwoSpacing.s24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(DaytwoSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FAQ', style: DaytwoTypography.textTheme.titleLarge),
                  const SizedBox(height: DaytwoSpacing.s12),
                  _FaqItem(
                    question: '매칭은 어떻게 성사되나요?',
                    answer: '서로 좋아요를 누르면 자동으로 매칭되고 채팅방이 생성됩니다.',
                  ),
                  _FaqItem(
                    question: '계정을 삭제하고 싶어요.',
                    answer: '설정 > 계정 관리에서 탈퇴 요청을 하시면 7일 내 처리됩니다.',
                  ),
                  _FaqItem(
                    question: '프로필 사진은 어떻게 관리되나요?',
                    answer: '업로드된 사진은 암호화된 스토리지에 보관되며, 이용자가 직접 삭제할 수 있습니다.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DaytwoSpacing.s24),
          Text('문의하기', style: DaytwoTypography.textTheme.titleLarge),
          const SizedBox(height: DaytwoSpacing.s12),
          Text('help@daytwo.app 로 메일을 보내주시거나 아래 버튼을 눌러 메일 앱을 여세요.',
              style: DaytwoTypography.textTheme.bodyMedium),
          const SizedBox(height: DaytwoSpacing.s12),
          PrimaryButton(
            label: '메일 보내기',
            onPressed: () {}, // TODO: launch mailto when wiring deep links.
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DaytwoSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: DaytwoTypography.textTheme.titleMedium),
          const SizedBox(height: DaytwoSpacing.s8),
          Text(answer, style: DaytwoTypography.textTheme.bodyMedium),
          const SizedBox(height: DaytwoSpacing.s12),
          const Divider(),
        ],
      ),
    );
  }
}
