// 설명: 유저의 기본 정보를 표현하는 모델 (향후 활동지수 등 확장 예정).
import 'auth_user.dart';

class UserProfile {
  final String id;
  String name;
  int age;
  String job;
  String location;
  String mbti;
  String intro;
  String? photoUrl; // TODO: 활동 지수, 취향 태그 등 확장 예정.

  bool likedByMe;
  bool likedMe;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.job,
    required this.location,
    required this.mbti,
    required this.intro,
    this.photoUrl,
    this.likedByMe = false,
    this.likedMe = false,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? job,
    String? location,
    String? mbti,
    String? intro,
    String? photoUrl,
    bool? likedByMe,
    bool? likedMe,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      job: job ?? this.job,
      location: location ?? this.location,
      mbti: mbti ?? this.mbti,
      intro: intro ?? this.intro,
      photoUrl: photoUrl ?? this.photoUrl,
      likedByMe: likedByMe ?? this.likedByMe,
      likedMe: likedMe ?? this.likedMe,
    );
  }

  factory UserProfile.fromAuthUser(AuthUser user) {
    return UserProfile(
      id: user.id,
      name: user.name,
      age: user.age,
      job: user.job ?? '직무 미입력',
      location: user.location ?? '지역 미입력',
      mbti: user.mbti ?? 'MBTI 미입력',
      intro: user.intro ?? '소개를 추가해 보세요.',
      photoUrl: user.photoUrl,
    );
  }
}
