// 설명: 매칭 탭에서 노출되는 매칭 카드 정보를 담는 모델.
import 'user_profile.dart';

class MatchItem {
  final String id;
  final UserProfile user;
  String lastActivityText;
  bool isMatched;

  MatchItem({
    required this.id,
    required this.user,
    required this.lastActivityText,
    this.isMatched = false,
  });
}
