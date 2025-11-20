import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/matches/matches_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/profile/profile_screen.dart';

enum DaytwoTab { home, matches, messages, profile }

extension DaytwoTabX on DaytwoTab {
  String get label {
    switch (this) {
      case DaytwoTab.home:
        return 'Home';
      case DaytwoTab.matches:
        return 'Matches';
      case DaytwoTab.messages:
        return 'Messages';
      case DaytwoTab.profile:
        return 'Profile';
    }
  }

  IconData get iconData {
    switch (this) {
      case DaytwoTab.home:
        return Icons.home_outlined;
      case DaytwoTab.matches:
        return Icons.favorite_outline;
      case DaytwoTab.messages:
        return Icons.chat_bubble_outline;
      case DaytwoTab.profile:
        return Icons.person_outline;
    }
  }

  Widget get screen {
    switch (this) {
      case DaytwoTab.home:
        return const HomeScreen();
      case DaytwoTab.matches:
        return const MatchesScreen();
      case DaytwoTab.messages:
        return const MessagesScreen();
      case DaytwoTab.profile:
        return const ProfileScreen();
    }
  }
}
