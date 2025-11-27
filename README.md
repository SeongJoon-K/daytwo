# daytwo 🫶

Flutter 기반 소개팅/매칭 앱 프로토타입입니다. 4개의 탭(Home/Matches/Messages/Profile)으로 추천·좋아요·매칭·채팅·프로필 편집 플로우를 제공합니다. 웹 우선으로 만들어졌으며 Toss 스타일의 가벼운 UI를 적용했습니다.

## 주요 기능 ✨
- 이메일 회원가입/로그인/로그아웃
- 홈: 오늘의 추천 카드 + 인기 리스트, 좋아요 → 상호 시 매칭·채팅방 생성
- 매칭/메시지: 매칭 리스트, 채팅방 리스트, 미읽음 뱃지, 1:1 채팅
- 프로필: 내 정보 열람/수정(이미지·성별·MBTI 등), 정책/고객센터 화면

## 도메인 모델 🗂️
- `AuthUser`, `UserProfile` (gender 포함), `MatchItem`, `ChatRoom`, `Message`
- 상태 관리: `AppState`(Provider/ChangeNotifier)로 인증·추천·좋아요·매칭·채팅 mock 데이터 관리

## 디자인 시스템 🎨
- 색상: primary #4C7FFB, soft/strong variants, neutral 그레이/네이비
- 타이포: Toss 느낌의 굵기/행간 스케일 확장
- 컴포넌트: 커스텀 바텀탭, 로고(`DaytwoLogo`), 태그(`DaytwoTag`), 프라이머리/세컨더리 버튼 등

## 실행 방법 🚀
```bash
flutter pub get
flutter run -d chrome --web-port 5001 --web-hostname localhost
```

## 폴더 구조 📂
- `lib/core` 탭 쉘/탭 정의
- `lib/screens` 각 탭/화면(Home, Matches, Messages, Profile, Auth, Legal/Support)
- `lib/state/app_state.dart` 전역 상태 관리
- `lib/models` 도메인 모델
- `lib/theme` 색상/타이포/컴포넌트 토큰
- `lib/widgets` 공통 UI 컴포넌트
- `assets/images`, `assets/branding`(예정) 이미지/브랜딩 리소스
