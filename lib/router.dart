import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snuz_app/providers/auth_provider.dart';
import 'package:snuz_app/screens/auth_screen.dart';
import 'package:snuz_app/screens/overview.dart';
import 'package:snuz_app/screens/profile.dart';

/// Creates and configures the GoRouter instance for the app
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/auth';

      // Redirect to auth screen if not authenticated and not already there
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth';
      }

      // Redirect to home if authenticated and on auth screen
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const OverviewScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
