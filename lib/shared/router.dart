import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/collections/collections_screen.dart';
import '../features/collections/collection_detail_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/paywall/paywall_screen.dart';
import 'widgets/app_bottom_nav.dart';

Future<GoRouter> buildRouter() async {
  final prefs = await SharedPreferences.getInstance();
  final onboarded = prefs.getBool('onboarded') ?? false;

  return GoRouter(
    initialLocation: onboarded ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (ctx, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (ctx, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (ctx, state) => const HomeScreen()),
          GoRoute(path: '/collections', builder: (ctx, state) => const CollectionsScreen()),
          GoRoute(path: '/search', builder: (ctx, state) => const SearchScreen()),
          GoRoute(path: '/settings', builder: (ctx, state) => const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: '/collections/:id',
        builder: (ctx, state) =>
            CollectionDetailScreen(collectionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/paywall',
        builder: (ctx, state) => const PaywallScreen(),
      ),
    ],
  );
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _routes = ['/', '/collections', '/search', '/settings'];

  @override
  Widget build(BuildContext context) {
    // Derive the active tab from the current location so the indicator
    // stays in sync no matter how the user navigated here.
    final location = GoRouterState.of(context).uri.path;
    final index = _routes.indexOf(location);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: index == -1 ? 0 : index,
        onTap: (i) => context.go(_routes[i]),
      ),
    );
  }
}
