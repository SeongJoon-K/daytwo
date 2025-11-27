# daytwo Architecture & API Spec

## 1. Project Overview
- 소개팅/매칭 앱(daytwo) 프로토타입. 로그인 후 4개 탭(Home/Matches/Messages/Profile)로 추천·하트·매칭·채팅·프로필 편집 흐름 제공.
- 폴더 역할: `lib/screens` 화면, `lib/widgets` 공통 UI, `lib/models` 도메인 모델, `lib/state/app_state.dart` 전역 로컬 상태(Provider/ChangeNotifier), `lib/core` 탭 쉘/탭 정의, `lib/theme` 디자인 토큰, `assets` 목 이미지.
- 상태 관리: `AppState` 단일 ChangeNotifier로 인증, 추천/인기, 좋아요/매칭, 채팅방·메시지까지 in-memory mock.
- 기능 흐름: 로그인 → 추천/인기 카드 → 좋아요(상호시 매칭/채팅방 생성) → Matches 탭 매칭 확인 → Messages 탭/채팅 → Profile 편집/로그아웃.

## 2. Frontend Architecture
- screens: Home(추천/인기 + 좋아요), Matches(매칭 리스트 → 채팅방 이동), Messages(채팅방 리스트), ChatRoom(1:1 대화), Auth(Login/Register), Profile(내 정보/편집/타인 상세).
- widgets: 공통 앱바/버튼/패딩/바텀탭, 프로필 카드·리스트, 매칭 카드 등 재사용 컴포넌트.
- models: `AuthUser`, `UserProfile`, `MatchItem`, `ChatRoom`, `Message`로 핵심 도메인 표현.
- state: `AppState`가 mock user store, 추천/인기 맵, 좋아요/매칭 기록, 채팅방/메시지, 로그인/회원가입/좋아요/메시지 전송 등 비즈니스 로직을 모두 관리.
- core: `app_shell.dart` + `daytwo_tab.dart`로 4탭 네비게이션 및 라우팅.
- theme: 색상/타이포/간격/컴포넌트 토큰으로 디자인 시스템 구성.
- 개선 포인트: 서비스/리포지토리 계층 분리, 네트워크/에러/로딩 상태 추가, DI 또는 ViewModel 분리 필요.

## 3. Domain Model
### 3.1 User (AuthUser)
- id: string — 내부 사용자 ID
- email: string — 로그인 계정
- name: string
- age: number
- job/location/mbti/intro: string|null — 프로필 정보
- photoUrl: string|null — 이미지 URL 또는 data URI
- password: string — 해시된 비밀번호(백엔드 관리)

#### Example
```json
{
  "id": "user_001",
  "email": "test_male@daytwo.app",
  "name": "테스트남",
  "age": 32,
  "job": "기획자",
  "location": "서울",
  "mbti": "ENTJ",
  "intro": "테스트용 남성 계정입니다.",
  "photoUrl": "https://cdn.daytwo.app/u1.jpg"
}
```

### 3.2 UserProfile
- id: string — user id
- name, age, job, location, mbti, intro: string
- photoUrl: string|null
- likedByMe: boolean — 내가 좋아요
- likedMe: boolean — 상대가 나를 좋아요

#### Example
```json
{
  "id": "user_002",
  "name": "테스트여",
  "age": 30,
  "job": "디자이너",
  "location": "부산",
  "mbti": "INFP",
  "intro": "테스트용 여성 계정입니다.",
  "photoUrl": "https://cdn.daytwo.app/u2.jpg",
  "likedByMe": true,
  "likedMe": true
}
```

### 3.3 Match
- id: string
- userAId/userBId: string
- status: string — `liked|matched|blocked`
- lastActivityText: string — UI 요약
- matchedAt: datetime|null
- createdAt: datetime

#### Example
```json
{
  "id": "match_1001",
  "userAId": "user_001",
  "userBId": "user_002",
  "status": "matched",
  "lastActivityText": "방금 전 · 1km 이내",
  "matchedAt": "2025-01-01T08:30:00Z",
  "createdAt": "2025-01-01T08:00:00Z"
}
```

### 3.4 ChatRoom
- id: string
- participantIds: string[]
- matchId: string|null
- lastMessage: Message|null
- unreadCount: number

#### Example
```json
{
  "id": "room-user_001-user_002",
  "participantIds": ["user_001", "user_002"],
  "matchId": "match_1001",
  "lastMessage": {
    "id": "msg-2",
    "senderId": "user_002",
    "text": "주말에 전시 보실래요?",
    "createdAt": "2025-01-01T08:35:00Z"
  },
  "unreadCount": 1
}
```

### 3.5 Message
- id: string
- roomId: string
- senderId: string
- text: string
- createdAt: datetime
- status: string — `sent|delivered|read`
- attachments: array|null

#### Example
```json
{
  "id": "msg-3",
  "roomId": "room-user_001-user_002",
  "senderId": "user_001",
  "text": "좋아요! 토요일 어때요?",
  "createdAt": "2025-01-01T08:36:00Z",
  "status": "sent",
  "attachments": null
}
```

### 3.6 Subscription (옵션)
- id, userId, plan, startedAt, expiredAt, autoRenew(bool), status

### 3.7 NotificationSettings (옵션)
- id, userId, pushEnabled(bool), marketingOptIn(bool), muteUntil(datetime|null)

## 4. API Spec (REST/JSON)
- Base: `/api/v1`, JWT Bearer 인증.

### Auth
- `POST /api/v1/auth/register` — 이메일 회원가입
  - Request: `{ "email": "user@daytwo.app", "password": "123456", "name": "테스트", "age": 30 }`
  - Response 201: `{ "user": {"id": "user_123", "email": "user@daytwo.app", "name": "테스트", "age": 30}, "accessToken": "jwt-access", "refreshToken": "jwt-refresh" }`
- `POST /api/v1/auth/login` — 로그인/JWT 발급
  - Request: `{ "email": "test_male@daytwo.app", "password": "123456" }`
  - Response 200: `{ "accessToken": "jwt-access", "refreshToken": "jwt-refresh", "user": {"id": "user_001", "name": "테스트남", "age": 32} }`
- `POST /api/v1/auth/refresh` — 토큰 갱신
  - Request: `{ "refreshToken": "jwt-refresh" }`
  - Response 200: `{ "accessToken": "new-access", "refreshToken": "new-refresh" }`
- `POST /api/v1/auth/logout` — 리프레시 무효화
  - Request: Authorization + `{ "refreshToken": "jwt-refresh" }`
  - Response 204

### User/Profile
- `GET /api/v1/users/me` — 내 프로필 조회 → `{ "user": {...UserProfile...} }`
- `PATCH /api/v1/users/me` — 내 프로필 수정
  - Request: `{ "name": "새 이름", "age": 33, "job": "PM", "location": "서울", "mbti": "ENTJ", "intro": "소개", "photoUrl": "https://cdn..." }`
  - Response 200: `{ "user": {...updated...} }`
- `GET /api/v1/users/{id}` — 타인 프로필 조회 → `{ "user": {...} }`
- `GET /api/v1/users/recommendation` — 오늘의 추천 1명, `?seenIds=user_3,user_4` → `{ "user": {...}, "reason": "age_bucket" }`
- `GET /api/v1/users/popular` — 인기 리스트, `?limit=10&offset=0&city=seoul` → `{ "users": [...] }`

### Match
- `POST /api/v1/matches/like` — 좋아요/취소
  - Request: `{ "targetUserId": "user_002", "like": true }`
  - Response 200: `{ "liked": true, "isMatched": true, "matchId": "match_1001", "chatRoomId": "room-user_001-user_002" }`
- `GET /api/v1/matches` — 내 매칭 목록, `?status=matched&limit=20&offset=0` → `{ "matches": [...] }`
- `GET /api/v1/matches/{id}` — 매칭 상세 → `{ "match": {...} }`
- `DELETE /api/v1/matches/{id}` — 매칭 해제/차단 → 204

### Chat
- `GET /api/v1/chat/rooms` — 채팅방 리스트, `?limit=20&offset=0` → `{ "rooms": [...] }`
- `POST /api/v1/chat/rooms` — 채팅방 생성
  - Request: `{ "targetUserId": "user_002", "matchId": "match_1001" }`
  - Response 201: `{ "room": {...ChatRoom...} }`
- `GET /api/v1/chat/rooms/{roomId}` — 채팅방 단건 → `{ "room": {...} }`
- `GET /api/v1/chat/rooms/{roomId}/messages` — 메시지 페이지네이션, `?limit=30&before=2025-01-01T09:00:00Z` → `{ "messages": [...] }`
- `POST /api/v1/chat/rooms/{roomId}/messages` — 메시지 전송
  - Request: `{ "text": "안녕하세요", "attachments": [] }`
  - Response 201: `{ "message": {...Message..., "status": "sent"} }`

## 5. Client <-> API 연동 제안
- `services/api_client.dart`: Dio/http 공통 클라이언트, baseUrl + Auth interceptor + 에러 매핑.
- `services/auth_service.dart`: login/register/refresh/logout.
- `services/user_service.dart`: getMe/updateMe/getUser/getRecommendation/getPopular.
- `services/match_service.dart`: like/list/get.
- `services/chat_service.dart`: listRooms/createRoom/listMessages/sendMessage.
- 상태 연동 의사코드
```dart
class AppState extends ChangeNotifier {
  AppState(this.auth, this.user, this.match, this.chat);

  Future<void> login(String email, String pw) async {
    final res = await auth.login(email, pw);
    currentAuthUser = res.user;
    currentUser = res.userProfile;
    await _loadHomeData();
    notifyListeners();
  }

  Future<void> toggleLike(UserProfile profile) async {
    final res = await match.like(profile.id, like: !profile.likedByMe);
    _updateLikeState(profile.id, res.liked);
    if (res.isMatched) {
      final room = await chat.ensureRoom(res.chatRoomId ?? profile.id);
      _upsertChatRoom(room);
    }
    notifyListeners();
  }
}
```

## 6. 향후 확장 포인트
- 소셜 로그인(OAuth) 추가: `/auth/{provider}/login`, 이메일 미보유 계정 처리, 계정 링크 전략.
- 실시간 채팅(WebSocket/SSE): REST는 기록용, `wss://.../chat/rooms/{id}`로 실시간 + typing/read receipts 이벤트.
- 추천/랭킹: `/users/recommendation`에 필터/랭킹 파라미터, 서버 피드 엔진/AB 테스트 컨트롤.
- 구독/결제: Subscription 엔티티 및 `/billing/subscriptions`, 결제 웹훅 반영.
- 알림: `/notifications/preferences`, `/devices` 토큰 등록, 매칭/메시지 푸시 트리거.
- 보안/신뢰: 신고/차단 `/safety/reports`, 프로필 인증(사진/신분) 플로우.
- 확장성: cursor 기반 페이지네이션, 에러 코드 컨벤션, 오프라인 캐싱, 다국어/시간대 대응.
