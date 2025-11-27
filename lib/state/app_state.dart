// 설명: 앱 전체 UI에서 사용하는 로컬 상태를 관리하는 ChangeNotifier.
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';
import '../models/chat_room.dart';
import '../models/match_item.dart';
import '../models/message.dart';
import '../models/user_profile.dart';
import '../mock/mock_female_profiles.dart';

class AppState extends ChangeNotifier {
  static const _testMaleEmail = 'test_male@daytwo.app';
  static const _testFemaleEmail = 'test_female@daytwo.app';
  static const _defaultPassword = '123456';
  static const _testMaleUserId = 'user-test-male';
  static const _testFemaleUserId = 'user-test-female';
  static const _genderMale = 'male';
  static const _genderFemale = 'female';

  AuthUser? currentAuthUser;
  late UserProfile currentUser;
  late UserProfile recommendedUser;
  final List<UserProfile> popularUsers = [];
  final List<MatchItem> matches = [];
  final List<ChatRoom> chatRooms = [];

  final Map<String, AuthUser> _userStore = {};
  final Map<String, UserProfile> _profileTemplates = {};
  final Map<String, Set<String>> _likesByUser = {};
  final Map<String, List<_MatchRecord>> _matchRecords = {};
  final Map<String, List<_ChatRoomRecord>> _chatRoomRecords = {};
  final Map<String, List<Message>> _roomMessages = {};
  final Map<String, int> _roomUnread = {};
  final Map<String, String> _recommendedMap = {};
  final Map<String, List<String>> _popularMap = {};

  bool get isLoggedIn => currentAuthUser != null;

  AppState() {
    _seedData();
  }

  void _seedData() {
    _profileTemplates[_testMaleUserId] = UserProfile(
      id: _testMaleUserId,
      name: '테스트남',
      age: 32,
      gender: _genderMale,
      job: '기획자',
      location: '서울',
      mbti: 'ENTJ',
      intro: '테스트용 남성 계정입니다.',
      photoUrl: 'assets/images/test_male.jpg',
    );
    _profileTemplates[_testFemaleUserId] = UserProfile(
      id: _testFemaleUserId,
      name: '테스트여',
      age: 30,
      gender: _genderFemale,
      job: '디자이너',
      location: '부산',
      mbti: 'INFP',
      intro: '테스트용 여성 계정입니다.',
      photoUrl: 'assets/images/test_female.jpg',
    );
    _profileTemplates['u2'] = UserProfile(
      id: 'u2',
      name: '리나',
      age: 34,
      gender: _genderFemale,
      job: 'UX 디자이너',
      location: '성수',
      mbti: 'INFJ',
      intro: '경험을 설계하는 UX 디자이너',
      photoUrl: 'assets/images/mock_profile_1.jpg',
    );
    _profileTemplates['u3'] = UserProfile(
      id: 'u3',
      name: '주호',
      age: 37,
      gender: _genderMale,
      job: '전략 컨설턴트',
      location: '여의도',
      mbti: 'ENTJ',
      intro: '데이터 기반 전략가',
      photoUrl: 'assets/images/mock_profile_1.jpg',
    );
    _profileTemplates['u4'] = UserProfile(
      id: 'u4',
      name: '다은',
      age: 35,
      gender: _genderFemale,
      job: '와인 디렉터',
      location: '서초',
      mbti: 'ISFP',
      intro: '향과 색으로 이야기하는 와인 디렉터',
      photoUrl: 'assets/images/mock_profile_1.jpg',
    );

    for (final profile in mockFemaleProfiles) {
      _profileTemplates[profile.id] = profile.copyWith();
    }

    _recommendedMap[_testMaleUserId] = 'female_01';
    _popularMap[_testMaleUserId] = [
      'female_01',
      'female_02',
      'female_03',
      'female_04',
      'female_05',
      _testFemaleUserId,
      'u2',
      'u4',
    ];
    _recommendedMap[_testFemaleUserId] = _testMaleUserId;
    _popularMap[_testFemaleUserId] = [_testMaleUserId, 'u3'];

    for (final id in _profileTemplates.keys) {
      _likesByUser[id] = <String>{};
      _matchRecords[id] = <_MatchRecord>[];
      _chatRoomRecords[id] = <_ChatRoomRecord>[];
    }

    final maleAuth = AuthUser(
      id: _testMaleUserId,
      email: _testMaleEmail,
      password: _hashPassword(_defaultPassword),
      name: _profileTemplates[_testMaleUserId]!.name,
      age: _profileTemplates[_testMaleUserId]!.age,
      gender: _profileTemplates[_testMaleUserId]!.gender,
      job: _profileTemplates[_testMaleUserId]!.job,
      location: _profileTemplates[_testMaleUserId]!.location,
      mbti: _profileTemplates[_testMaleUserId]!.mbti,
      intro: _profileTemplates[_testMaleUserId]!.intro,
      photoUrl: _profileTemplates[_testMaleUserId]!.photoUrl,
    );
    final femaleAuth = AuthUser(
      id: _testFemaleUserId,
      email: _testFemaleEmail,
      password: _hashPassword(_defaultPassword),
      name: _profileTemplates[_testFemaleUserId]!.name,
      age: _profileTemplates[_testFemaleUserId]!.age,
      gender: _profileTemplates[_testFemaleUserId]!.gender,
      job: _profileTemplates[_testFemaleUserId]!.job,
      location: _profileTemplates[_testFemaleUserId]!.location,
      mbti: _profileTemplates[_testFemaleUserId]!.mbti,
      intro: _profileTemplates[_testFemaleUserId]!.intro,
      photoUrl: _profileTemplates[_testFemaleUserId]!.photoUrl,
    );
    _userStore[_normalizeEmail(maleAuth.email)] = maleAuth;
    _userStore[_normalizeEmail(femaleAuth.email)] = femaleAuth;

    final warmUpRoomId = _roomIdFor(_testMaleUserId, 'u2');
    final warmUpMessages = <Message>[
      Message(
        id: 'msg-1',
        roomId: warmUpRoomId,
        senderId: 'u2',
        text: '안녕하세요! 주말에 전시 보러 가실래요?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: 'msg-2',
        roomId: warmUpRoomId,
        senderId: _testMaleUserId,
        text: '좋아요! 추천하실 곳 있나요?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ];
    _roomMessages[warmUpRoomId] = warmUpMessages;
    _roomUnread[warmUpRoomId] = 1;
    _chatRoomRecords[_testMaleUserId]!.add(
      _ChatRoomRecord(roomId: warmUpRoomId, partnerId: 'u2'),
    );

    _hydrateUserView(_testMaleUserId);
  }

  void _hydrateUserView(String userId) {
    _ensureUserContainers(userId);
    currentUser = _cloneProfile(userId);
    recommendedUser = _cloneProfile(
      _recommendedMap[userId] ?? _fallbackRecommendation(userId),
    );
    final popularIds =
        _popularMap[userId] ?? _popularMap[_testMaleUserId] ?? [];
    popularUsers
      ..clear()
      ..addAll(popularIds.map(_cloneProfile));
    _syncMatchesForCurrentUser();
    _syncChatRoomsForCurrentUser();
    _refreshVisibleProfiles();
  }

  UserProfile _cloneProfile(String userId) {
    final template = _profileTemplates[userId];
    if (template == null) {
      return UserProfile(
        id: userId,
      name: 'Unknown',
      age: 0,
      gender: 'other',
      job: '정보 없음',
      location: '정보 없음',
      mbti: '정보 없음',
        intro: '정보 없음',
        photoUrl: 'assets/images/mock_profile_1.jpg',
      );
    }
    return template.copyWith();
  }

  void _ensureUserContainers(String userId) {
    _likesByUser.putIfAbsent(userId, () => <String>{});
    _matchRecords.putIfAbsent(userId, () => <_MatchRecord>[]);
    _chatRoomRecords.putIfAbsent(userId, () => <_ChatRoomRecord>[]);
  }

  String _fallbackRecommendation(String userId) {
    return userId == _testFemaleUserId ? _testMaleUserId : _testFemaleUserId;
  }

  void _refreshVisibleProfiles() {
    _applyLikeState(recommendedUser);
    for (final profile in popularUsers) {
      _applyLikeState(profile);
    }
    for (final match in matches) {
      _applyLikeState(match.user);
    }
    for (final room in chatRooms) {
      _applyLikeState(room.partner);
    }
  }

  void _applyLikeState(UserProfile profile) {
    profile.likedByMe = _isLikedBy(currentUser.id, profile.id);
    profile.likedMe = _isLikedBy(profile.id, currentUser.id);
  }

  bool _isLikedBy(String ownerId, String targetId) {
    return _likesByUser[ownerId]?.contains(targetId) ?? false;
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
    required String gender,
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
      gender: gender,
      job: '직무 미입력',
      location: '지역 미입력',
      mbti: 'MBTI 미입력',
      intro: '소개를 추가해 보세요.',
      photoUrl: 'assets/images/mock_profile_1.jpg',
    );
    _userStore[normalized] = auth;
    _profileTemplates[auth.id] = UserProfile.fromAuthUser(auth);
    _recommendedMap[auth.id] =
        _recommendedMap[_testMaleUserId] ?? _testFemaleUserId;
    _popularMap[auth.id] = List<String>.from(
      _popularMap[_testMaleUserId] ?? [],
    );
    _ensureUserContainers(auth.id);
    currentAuthUser = auth;
    _hydrateUserView(auth.id);
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
    _profileTemplates.putIfAbsent(
      auth.id,
      () => UserProfile.fromAuthUser(auth),
    );
    _recommendedMap.putIfAbsent(
      auth.id,
      () => _fallbackRecommendation(auth.id),
    );
    _popularMap.putIfAbsent(
      auth.id,
      () => List<String>.from(_popularMap[_testMaleUserId] ?? []),
    );
    _hydrateUserView(auth.id);
    notifyListeners();
    return true;
  }

  void logout() {
    currentAuthUser = null;
    notifyListeners();
  }

  void updateCurrentUser(UserProfile updated) {
    _profileTemplates[updated.id] = updated.copyWith();
    _hydrateUserView(updated.id);
    notifyListeners();
  }

  ChatRoom? toggleLike(UserProfile user) {
    final likedSet = _likesByUser[currentUser.id] ?? <String>{};
    if (likedSet.contains(user.id)) {
      likedSet.remove(user.id);
    } else {
      likedSet.add(user.id);
    }
    _likesByUser[currentUser.id] = likedSet;
    _refreshVisibleProfiles();
    ChatRoom? createdRoom;
    if (checkIsMatched(user)) {
      createdRoom = createMatchAndChatRoom(user);
    }
    notifyListeners();
    return createdRoom;
  }

  bool checkIsMatched(UserProfile user) {
    return _isLikedBy(currentUser.id, user.id) &&
        _isLikedBy(user.id, currentUser.id);
  }

  ChatRoom createMatchAndChatRoom(UserProfile user) {
    _markMatchRecord(currentUser.id, user.id);
    _markMatchRecord(user.id, currentUser.id);
    _syncMatchesForCurrentUser();
    _ensureChatRoomRecord(currentUser.id, user.id);
    _ensureChatRoomRecord(user.id, currentUser.id);
    _syncChatRoomsForCurrentUser();
    return chatRooms.firstWhere((room) => room.partner.id == user.id);
  }

  void _markMatchRecord(String ownerId, String partnerId) {
    final records = _matchRecords.putIfAbsent(ownerId, () => <_MatchRecord>[]);
    final record = records.firstWhere(
      (entry) => entry.partnerId == partnerId,
      orElse: () {
        final newRecord = _MatchRecord(
          partnerId: partnerId,
          lastActivityText: '방금 전 · 1km 이내',
        );
        records.add(newRecord);
        return newRecord;
      },
    );
    record.isMatched = true;
    record.lastActivityText = '방금 전 · 1km 이내';
  }

  void _syncMatchesForCurrentUser() {
    final records = _matchRecords[currentUser.id] ?? [];
    matches
      ..clear()
      ..addAll(
        records.map((record) {
          final partner = _cloneProfile(record.partnerId);
          _applyLikeState(partner);
          return MatchItem(
            id: 'm-${record.partnerId}',
            user: partner,
            lastActivityText: record.lastActivityText,
            isMatched: record.isMatched,
          );
        }),
      );
  }

  ChatRoom ensureChatRoom(UserProfile user) {
    _ensureChatRoomRecord(currentUser.id, user.id);
    _syncChatRoomsForCurrentUser();
    return chatRooms.firstWhere((room) => room.partner.id == user.id);
  }

  void _ensureChatRoomRecord(String ownerId, String partnerId) {
    final roomId = _roomIdFor(ownerId, partnerId);
    final records = _chatRoomRecords.putIfAbsent(
      ownerId,
      () => <_ChatRoomRecord>[],
    );
    final exists = records.any((record) => record.roomId == roomId);
    if (!exists) {
      records.add(_ChatRoomRecord(roomId: roomId, partnerId: partnerId));
    }
    _roomMessages.putIfAbsent(roomId, () => <Message>[]);
    _roomUnread.putIfAbsent(roomId, () => 0);
  }

  void _syncChatRoomsForCurrentUser() {
    final records = _chatRoomRecords[currentUser.id] ?? [];
    chatRooms
      ..clear()
      ..addAll(
        records.map((record) {
          final partner = _cloneProfile(record.partnerId);
          _applyLikeState(partner);
          final messages = _roomMessages.putIfAbsent(
            record.roomId,
            () => <Message>[],
          );
          return ChatRoom(
            id: record.roomId,
            partner: partner,
            messages: messages,
            unreadCount: _roomUnread[record.roomId] ?? 0,
          );
        }),
      );
  }

  String _roomIdFor(String a, String b) {
    final sorted = [a, b]..sort();
    return 'room-${sorted.join('-')}';
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
    _roomUnread[roomId] = 0;
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
    _roomUnread[roomId] = (_roomUnread[roomId] ?? 0) + 1;
    notifyListeners();
  }

  void markRoomAsRead(String roomId) {
    _roomUnread[roomId] = 0;
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
      _userStore[_normalizeEmail(auth.email)] = auth;
    }
    updateCurrentUser(updated);
    return updated;
  }

  int get matchedCount {
    return (_matchRecords[currentUser.id] ?? [])
        .where((m) => m.isMatched)
        .length;
  }

  MatchItem? matchForUser(String userId) {
    final records = _matchRecords[currentUser.id] ?? [];
    final record = records.firstWhere(
      (entry) => entry.partnerId == userId,
      orElse: () => _MatchRecord(partnerId: userId, lastActivityText: '방금 전'),
    );
    if (!record.isMatched) return null;
    final partner = _cloneProfile(record.partnerId);
    _applyLikeState(partner);
    return MatchItem(
      id: 'm-${record.partnerId}',
      user: partner,
      lastActivityText: record.lastActivityText,
      isMatched: record.isMatched,
    );
  }
}

class _MatchRecord {
  _MatchRecord({
    required this.partnerId,
    required this.lastActivityText,
  }) : isMatched = false;

  final String partnerId;
  String lastActivityText;
  bool isMatched;
}

class _ChatRoomRecord {
  _ChatRoomRecord({required this.roomId, required this.partnerId});

  final String roomId;
  final String partnerId;
}
