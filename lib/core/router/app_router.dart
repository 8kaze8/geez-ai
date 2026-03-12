import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/features/home/presentation/screens/home_screen.dart';
import 'package:geez_ai/features/explore/presentation/screens/explore_screen.dart';
import 'package:geez_ai/features/chat/presentation/screens/chat_screen.dart';
import 'package:geez_ai/features/chat/presentation/screens/route_loading_screen.dart';
import 'package:geez_ai/features/passport/presentation/screens/passport_screen.dart';
import 'package:geez_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:geez_ai/features/route/presentation/screens/route_detail_screen.dart';
import 'package:geez_ai/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:geez_ai/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:geez_ai/shared/widgets/bottom_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash — no bottom nav
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Onboarding — no bottom nav
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExploreScreen(),
            ),
          ),
          GoRoute(
            path: '/new-route',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: '/passport',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PassportScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: '/route-loading',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RouteLoadingScreen(),
            ),
          ),
          GoRoute(
            path: '/route-detail',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RouteDetailScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/new-route')) return 2;
    if (location.startsWith('/passport')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  bool _showNavBar(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/route-loading')) return false;
    if (location.startsWith('/route-detail')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _showNavBar(context)
          ? BottomNavBar(currentIndex: _currentIndex(context))
          : null,
    );
  }
}
