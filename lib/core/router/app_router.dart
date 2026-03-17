import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/router/route_names.dart';
import 'package:geez_ai/features/auth/domain/auth_state.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/auth/presentation/screens/login_screen.dart';
import 'package:geez_ai/features/auth/presentation/screens/signup_screen.dart';
import 'package:geez_ai/features/home/presentation/screens/home_screen.dart';
import 'package:geez_ai/features/explore/presentation/screens/explore_screen.dart';
import 'package:geez_ai/features/chat/presentation/screens/chat_screen.dart';
import 'package:geez_ai/features/chat/presentation/screens/route_loading_screen.dart';
import 'package:geez_ai/features/passport/presentation/screens/passport_screen.dart';
import 'package:geez_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:geez_ai/features/feedback/presentation/screens/feedback_screen.dart';
import 'package:geez_ai/features/route/presentation/screens/route_detail_screen.dart';
import 'package:geez_ai/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:geez_ai/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:geez_ai/shared/widgets/bottom_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Auth-aware routes that do not require authentication.
const _publicRoutes = {
  RoutePaths.splash,
  RoutePaths.login,
  RoutePaths.signup,
};

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.read(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: _AuthRefreshNotifier(ref),
    redirect: (context, state) {
      final currentPath = state.uri.path;
      final isPublicRoute = _publicRoutes.contains(currentPath);
      final isOnboarding = currentPath == RoutePaths.onboarding;
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;

      // While checking auth state, stay on splash.
      if (isLoading) {
        return currentPath == RoutePaths.splash ? null : RoutePaths.splash;
      }

      // Not authenticated -- redirect to login.
      // Allow staying on login/signup, but redirect away from splash.
      if (!isAuthenticated) {
        if (currentPath == RoutePaths.splash) return RoutePaths.login;
        return isPublicRoute ? null : RoutePaths.login;
      }

      // Authenticated -- redirect away from public routes to home.
      if (isAuthenticated && isPublicRoute) {
        return RoutePaths.home;
      }

      // Authenticated and on onboarding -- allow it.
      if (isAuthenticated && isOnboarding) {
        return null;
      }

      // No redirect needed.
      return null;
    },
    routes: [
      // --- Public routes (no bottom nav) ---

      GoRoute(
        path: RoutePaths.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      GoRoute(
        path: RoutePaths.signup,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      GoRoute(
        path: RoutePaths.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // --- Authenticated shell with bottom navigation ---

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.explore,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExploreScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.newRoute,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.passport,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PassportScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.routeLoading,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RouteLoadingScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.routeDetail,
            pageBuilder: (context, state) {
              final routeId = state.pathParameters['routeId']!;
              return NoTransitionPage(
                child: RouteDetailScreen(routeId: routeId),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.feedback,
            pageBuilder: (context, state) {
              final routeId = state.pathParameters['routeId']!;
              return CustomTransitionPage(
                key: state.pageKey,
                child: FeedbackScreen(routeId: routeId),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
});

// ---------------------------------------------------------------------------
// Scaffold with bottom navigation bar
// ---------------------------------------------------------------------------

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
    if (location.startsWith('/route/')) return false;
    if (location.startsWith('/feedback/')) return false;
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

// ---------------------------------------------------------------------------
// Auth refresh notifier -- triggers GoRouter.redirect on auth state changes
// ---------------------------------------------------------------------------

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._ref) {
    _subscription = _ref.listen<AuthState>(authStateProvider, (prev, next) {
      notifyListeners();
    });
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
