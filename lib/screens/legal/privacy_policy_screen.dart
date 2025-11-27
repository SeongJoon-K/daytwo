import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/daytwo_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaytwoAppBar(title: '개인정보 처리방침'),
      body: ListView(
        padding: const EdgeInsets.all(DaytwoSpacing.s24),
        children: const [
          _Section(
            title: '1. 수집하는 개인정보',
            body:
                '이메일, 비밀번호, 이름, 나이, 성별, 프로필 정보, 서비스 이용 기록이 수집될 수 있습니다. 이미지 업로드 시 사진 데이터가 처리됩니다.',
          ),
          _Section(
            title: '2. 이용 목적',
            body:
                '회원 식별, 매칭 추천, 고객 지원, 서비스 품질 개선을 위해 개인정보를 사용합니다. 법령에 따라 보관 기간을 최소화합니다.',
          ),
          _Section(
            title: '3. 보관 및 파기',
            body:
                '서비스 탈퇴 시 또는 목적 달성 후 지체 없이 파기합니다. 법적 보관 의무가 있을 경우 해당 기간 동안 안전하게 보관합니다.',
          ),
          _Section(
            title: '4. 제3자 제공',
            body:
                '법적 요구가 있는 경우를 제외하고 이용자의 동의 없이 제3자에게 제공하지 않습니다. 향후 제공 시 사전 동의를 받습니다.',
          ),
          _Section(
            title: '5. 이용자 권리',
            body:
                '이용자는 자신의 개인정보에 대한 열람·정정·삭제를 요청할 수 있으며, 쿠키 차단 등 선택권을 행사할 수 있습니다.',
          ),
          _Section(
            title: '6. 문의',
            body:
                '개인정보 보호 관련 문의는 고객센터를 통해 접수되며, 최대한 신속히 답변드립니다.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DaytwoSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: DaytwoTypography.textTheme.titleLarge),
          const SizedBox(height: DaytwoSpacing.s8),
          Text(body, style: DaytwoTypography.textTheme.bodyMedium),
          const SizedBox(height: DaytwoSpacing.s16),
          const Divider(),
        ],
      ),
    );
  }
}
