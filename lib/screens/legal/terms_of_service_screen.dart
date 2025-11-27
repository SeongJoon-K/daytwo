import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/daytwo_app_bar.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaytwoAppBar(title: '이용약관'),
      body: ListView(
        padding: const EdgeInsets.all(DaytwoSpacing.s24),
        children: const [
          _Section(
            title: '1. 서비스 개요',
            body:
                'daytwo는 30·40대를 위한 소개팅/매칭 서비스를 제공합니다. 본 약관은 daytwo 서비스를 사용하는 모든 이용자에게 적용됩니다.',
          ),
          _Section(
            title: '2. 계정 및 보안',
            body:
                '이메일·비밀번호 기반 계정을 사용하며, 계정 정보 보호는 사용자 책임입니다. 타인 계정 도용, 공유를 금지합니다.',
          ),
          _Section(
            title: '3. 매칭 및 커뮤니케이션',
            body:
                '상호 좋아요 시 매칭이 성사되며 채팅 기능을 사용할 수 있습니다. 부적절한 메시지, 스팸, 광고 행위는 제한될 수 있습니다.',
          ),
          _Section(
            title: '4. 콘텐츠 및 권리',
            body:
                '사용자가 업로드한 프로필 정보와 메시지에 대한 책임은 사용자 본인에게 있습니다. 법령 위반 콘텐츠는 사전 통보 없이 삭제될 수 있습니다.',
          ),
          _Section(
            title: '5. 책임의 한계',
            body:
                'daytwo는 기술적 문제나 제3자 요인으로 인한 서비스 중단, 데이터 손실 등에 대해 법적 책임을 지지 않습니다.',
          ),
          _Section(
            title: '6. 약관 변경',
            body:
                '약관은 사전 고지 후 변경될 수 있으며, 변경 후 계속 이용 시 변경된 약관에 동의한 것으로 간주됩니다.',
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
