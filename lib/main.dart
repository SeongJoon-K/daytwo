import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'core/app_shell.dart';
import 'state/app_state.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const DaytwoApp(),
    ),
  );
}

/// Root widget that injects the global design system.
class DaytwoApp extends StatelessWidget {
  const DaytwoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'daytwo',
      debugShowCheckedModeBanner: false,
      theme: buildDaytwoTheme(),
      home: Consumer<AppState>(
        builder: (context, appState, _) {
          if (appState.isLoggedIn) {
            return const DaytwoShell();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
