import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// This widget provides the main application shell, which includes a
// persistent BottomNavigationBar. It wraps the child routes defined
// within the ShellRoute in the app's router configuration. This allows
// for persistent navigation state across the main sections of the app
// (Family, Zones, Menu).
class MainShellScreen extends StatelessWidget {
  final Widget child;
  const MainShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child, // The current page/route is displayed here.
      bottomNavigationBar: BottomNavigationBar(
        // The currentIndex is determined by the current route's location.
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: l10n.bottomNavUsers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.security_outlined),
            activeIcon: const Icon(Icons.security),
            label: l10n.bottomNavZones,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu),
            label: l10n.bottomNavMenu,
          ),
        ],
      ),
    );
  }

  // Determines which tab is currently selected based on the route path.
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/family')) {
      return 0;
    }
    if (location.startsWith('/zones')) {
      return 1;
    }
    if (location.startsWith('/menu')) {
      return 2;
    }
    return 1; // Default to the 'Zones' tab.
  }

  // Navigates to the corresponding route when a bottom navigation item is tapped.
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/family');
        break;
      case 1:
        GoRouter.of(context).go('/zones');
        break;
      case 2:
        GoRouter.of(context).go('/menu');
        break;
    }
  }
}
