import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; // Corrected Import

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  // V2.0: Calculates the current index based on the route location
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/favorites')) {
      return 2;
    }
    return 0; // Default to home
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      // The body is now the child passed by GoRouter's ShellRoute
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/library');
              break;
            case 2:
              context.go('/favorites');
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_outlined),
            activeIcon: const Icon(Icons.book),
            label: l10n.library,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
        ],
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
