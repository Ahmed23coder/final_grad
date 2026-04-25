import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './bottom_nav_bar.dart';
import './home_menu_drawer.dart';

/// The main shell of the application.
/// 
/// Uses [StatefulNavigationShell] to persist tab state across switches.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern is to go to the initial location of the branch
      // when tapping the already active tab.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows bottom nav to float properly over content
      drawerScrimColor: Colors.transparent, // Prevents background from darkening
      drawer: const HomeMenuDrawer(), // Drawer attached globally to shell
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
