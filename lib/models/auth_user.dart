// 설명: 이메일 기반 로컬 인증 유저 정보를 담는 모델.
class AuthUser {
  final String id;
  final String email;
  final String password; // 간단한 해시 적용된 문자열
  final String name;
  final int age;
  final String? job;
  final String? location;
  final String? mbti;
  final String? intro;
  final String? photoUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    this.job,
    this.location,
    this.mbti,
    this.intro,
    this.photoUrl,
  });

  AuthUser copyWith({
    String? name,
    int? age,
    String? job,
    String? location,
    String? mbti,
    String? intro,
    String? photoUrl,
  }) {
    return AuthUser(
      id: id,
      email: email,
      password: password,
      name: name ?? this.name,
      age: age ?? this.age,
      job: job ?? this.job,
      location: location ?? this.location,
      mbti: mbti ?? this.mbti,
      intro: intro ?? this.intro,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
