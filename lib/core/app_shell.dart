// 설명: 앱 전반의 탭 네비게이션과 각 화면을 관리하는 쉘 컨테이너.
import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_nav_bar.dart';
import 'daytwo_tab.dart';

/// Root widget that hosts the 4-tab navigation requested.
class DaytwoShell extends StatefulWidget {
  const DaytwoShell({super.key});

  @override
  State<DaytwoShell> createState() => _DaytwoShellState();
}

class _DaytwoShellState extends State<DaytwoShell> {
  DaytwoTab _current = DaytwoTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _current.screen,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        current: _current,
        onChanged: (tab) => setState(() => _current = tab),
      ),
    );
  }
}
