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
import '../core/mock_data.dart';
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
        builder: (ctx, state) {
          final id = state.pathParameters['id']!;
          final col = mockCollections.firstWhere((c) => c.id == id);
          return CollectionDetailScreen(collection: col);
        },
      ),
      GoRoute(
        path: '/paywall',
        builder: (ctx, state) => const PaywallScreen(),
      ),
    ],
  );
}

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _routes = ['/', '/collections', '/search', '/settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) {
          setState(() => _index = i);
          context.go(_routes[i]);
        },
      ),
    );
  }
}
