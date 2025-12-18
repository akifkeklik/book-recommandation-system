import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonkitap/features/splash/view/splash_screen.dart';
import 'package:sonkitap/features/onboarding/view/onboarding_screen.dart';
import 'package:sonkitap/features/main/view/main_screen.dart';
import 'package:sonkitap/features/book_detail/view/book_detail_screen.dart';
import 'package:sonkitap/features/home/view/home_screen.dart';
import 'package:sonkitap/features/library/view/library_screen.dart';
import 'package:sonkitap/features/favorites/view/favorites_screen.dart';
import 'package:sonkitap/features/profile/view/profile_screen.dart'; // V3.0: Import Profile
import 'package:sonkitap/features/settings/view/settings_screen.dart'; // V3.0: Import Settings

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => const NoTransitionPage(child: LibraryScreen()),
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesScreen()),
        ),
      ],
    ),

    // Standalone screens (pushed on top)
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        final bookId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        final heroTag = state.extra as String?;
        return BookDetailScreen(bookId: bookId, heroTag: heroTag);
      },
    ),
    // V3.0: Add Profile and Settings routes
    GoRoute(
      path: '/profile',
      // Use a custom transition for a premium feel
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation), child: child);
        },
      ),
    ),
     GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
