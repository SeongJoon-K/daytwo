// 설명: 앱 전체 UI에서 사용하는 로컬 상태를 관리하는 ChangeNotifier.
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';
import '../models/chat_room.dart';
import '../models/match_item.dart';
import '../models/message.dart';
import '../models/user_profile.dart';

class AppState extends ChangeNotifier {
  AuthUser? currentAuthUser;
  late UserProfile currentUser;
  late UserProfile recommendedUser;
  final List<UserProfile> popularUsers = [];
  final List<MatchItem> matches = [];
  final List<ChatRoom> chatRooms = [];
  final Map<String, AuthUser> _userStore = {};

  bool get isLoggedIn => currentAuthUser != null;

  AppState() {
    _seedData();
  }

  void _seedData() {
    currentUser = UserProfile(
      id: 'me',
      name: '성준',
      age: 37,
      job: '브랜드 기획',
      location: '서울',
      mbti: 'ENTP',
      intro: '도시와 사람을 좋아하는 브랜드 디렉터',
      photoUrl: 'assets/images/mock_profile_1.jpg',
    );

    recommendedUser = UserProfile(
      id: 'u1',
      name: '소담',
      age: 36,
      job: '브랜딩 리드',
      location: '한남',
      mbti: 'ENFP',
      intro: '도심과 자연 사이에서 영감을 찾는 리더',
      photoUrl: 'assets/images/mock_profile_1.jpg',
      likedMe: true,
    );

    popularUsers.addAll([
      UserProfile(
        id: 'u2',
        name: '리나',
        age: 34,
        job: 'UX 디자이너',
        location: '성수',
        mbti: 'INFJ',
        intro: '경험을 설계하는 UX 디자이너',
        photoUrl: 'assets/images/mock_profile_1.jpg',
        likedMe: true,
      ),
      UserProfile(
        id: 'u3',
        name: '주호',
        age: 37,
        job: '전략 컨설턴트',
        location: '여의도',
        mbti: 'ENTJ',
        intro: '데이터 기반 전략가',
        photoUrl: 'assets/images/mock_profile_1.jpg',
      ),
      UserProfile(
        id: 'u4',
        name: '다은',
        age: 35,
        job: '와인 디렉터',
        location: '서초',
        mbti: 'ISFP',
        intro: '향과 색으로 이야기하는 와인 디렉터',
        photoUrl: 'assets/images/mock_profile_1.jpg',
        likedMe: true,
      ),
    ]);

    matches.addAll(
      popularUsers.map(
        (u) => MatchItem(
          id: 'm-${u.id}',
          user: u,
          lastActivityText: '대화 가능 · 5분 전',
          isMatched: false,
        ),
      ),
    );

    final ChatRoom seedRoom = ChatRoom(
      id: 'room-1',
      partner: popularUsers.first,
      messages: [
        Message(
          id: 'msg-1',
          roomId: 'room-1',
          senderId: popularUsers.first.id,
          text: '안녕하세요! 주말에 전시 보러 가실래요?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        Message(
          id: 'msg-2',
          roomId: 'room-1',
          senderId: currentUser.id,
          text: '좋아요! 추천하실 곳 있나요?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
        ),
      ],
    );
    chatRooms.add(seedRoom);

    final demoAuth = AuthUser(
      id: 'auth-me',
      email: 'demo@daytwo.app',
      password: _hashPassword('daytwo123'),
      name: currentUser.name,
      age: currentUser.age,
      job: currentUser.job,
      location: currentUser.location,
      mbti: currentUser.mbti,
      intro: currentUser.intro,
      photoUrl: currentUser.photoUrl,
    );
    _userStore[demoAuth.email] = demoAuth;
  }

  String _hashPassword(String input) {
    final salted = 'daytwo::$input';
    return base64UrlEncode(utf8.encode(salted));
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    final normalized = _normalizeEmail(email);
    if (_userStore.containsKey(normalized)) {
      return false;
    }
    final auth = AuthUser(
      id: 'auth-${DateTime.now().microsecondsSinceEpoch}',
      email: normalized,
      password: _hashPassword(password),
      name: name,
      age: age,
      job: '직무 미입력',
      location: '지역 미입력',
      mbti: 'MBTI 미입력',
      intro: '소개를 추가해 보세요.',
      photoUrl: 'assets/images/mock_profile_1.jpg',
    );
    _userStore[normalized] = auth;
    currentAuthUser = auth;
    currentUser = UserProfile.fromAuthUser(auth);
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    final normalized = _normalizeEmail(email);
    final auth = _userStore[normalized];
    if (auth == null) return false;
    if (auth.password != _hashPassword(password)) {
      return false;
    }
    currentAuthUser = auth;
    currentUser = UserProfile.fromAuthUser(auth);
    notifyListeners();
    return true;
  }

  void logout() {
    currentAuthUser = null;
    notifyListeners();
  }

  void updateCurrentUser(UserProfile updated) {
    currentUser = updated;
    if (recommendedUser.id == updated.id) {
      recommendedUser = updated;
    }
    for (var i = 0; i < popularUsers.length; i++) {
      if (popularUsers[i].id == updated.id) {
        popularUsers[i] = updated;
        break;
      }
    }
    notifyListeners();
  }

  bool toggleLike(UserProfile user) {
    user.likedByMe = !user.likedByMe;
    bool matched = false;
    if (user.likedByMe && user.likedMe) {
      matched = _ensureMatch(user);
    }
    notifyListeners();
    return matched;
  }

  bool _ensureMatch(UserProfile user) {
    final match = matches.firstWhere(
      (m) => m.user.id == user.id,
      orElse: () {
        final newMatch = MatchItem(
          id: 'm-${user.id}',
          user: user,
          lastActivityText: '방금 전 · 1km 이내',
          isMatched: false,
        );
        matches.add(newMatch);
        return newMatch;
      },
    );
    if (match.isMatched) return false;
    match.isMatched = true;
    ensureChatRoom(user);
    return true;
  }

  ChatRoom ensureChatRoom(UserProfile user) {
    final room = chatRooms.where((r) => r.partner.id == user.id);
    if (room.isNotEmpty) {
      return room.first;
    }
    final newRoom = ChatRoom(
      id: 'room-${user.id}',
      partner: user,
      messages: [],
    );
    chatRooms.add(newRoom);
    return newRoom;
  }

  void sendMessage({required String roomId, required String text}) {
    if (text.trim().isEmpty) return;
    final room = chatRooms.firstWhere((element) => element.id == roomId);
    room.messages.add(
      Message(
        id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
        roomId: roomId,
        senderId: currentUser.id,
        text: text.trim(),
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void receiveMessage({required String roomId, required String text}) {
    final room = chatRooms.firstWhere((element) => element.id == roomId);
    room.messages.add(
      Message(
        id: 'msg-${DateTime.now().microsecondsSinceEpoch + 1}',
        roomId: roomId,
        senderId: room.partner.id,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  UserProfile editableCopyOfCurrentUser() => currentUser.copyWith();

  UserProfile saveEditedProfile({
    required String name,
    required int age,
    required String job,
    required String location,
    required String mbti,
    required String intro,
    String? photoUrl,
  }) {
    final updated = currentUser.copyWith(
      name: name,
      age: age,
      job: job,
      location: location,
      mbti: mbti,
      intro: intro,
      photoUrl: photoUrl ?? currentUser.photoUrl,
    );
    if (currentAuthUser != null) {
      final auth = currentAuthUser!.copyWith(
        name: name,
        age: age,
        job: job,
        location: location,
        mbti: mbti,
        intro: intro,
        photoUrl: photoUrl ?? currentAuthUser!.photoUrl,
      );
      currentAuthUser = auth;
      _userStore[auth.email] = auth;
    }
    updateCurrentUser(updated);
    return updated;
  }

  int get matchedCount => matches.where((m) => m.isMatched).length;

  MatchItem? matchForUser(String userId) {
    return matches.firstWhere(
      (element) => element.user.id == userId,
      orElse: () => MatchItem(
        id: 'm-$userId',
        user: recommendedUser,
        lastActivityText: '방금 전',
      ),
    );
  }
}
