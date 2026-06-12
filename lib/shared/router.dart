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
import 'widgets/neon_bg.dart';

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
      // IndexedStack keeps every tab alive and built once, so switching tabs
      // is instant — no rebuild, no page transition, no background flash.
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, navShell) => MainShell(navShell: navShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (ctx, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/collections',
                builder: (ctx, state) => const CollectionsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/settings',
                builder: (ctx, state) => const SettingsScreen()),
          ]),
        ],
      ),
      // Search is no longer a tab: it opens from the search bar on Links.
      GoRoute(
        path: '/search',
        builder: (ctx, state) => const SearchScreen(),
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
  final StatefulNavigationShell navShell;
  const MainShell({super.key, required this.navShell});

  @override
  Widget build(BuildContext context) {
    // The neon gradient lives here, behind every tab, so switching tabs
    // never repaints (or flashes) the background.
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: navShell,
        bottomNavigationBar: AppBottomNav(
          currentIndex: navShell.currentIndex,
          // Tapping the active tab again returns it to its initial location.
          onTap: (i) => navShell.goBranch(
            i,
            initialLocation: i == navShell.currentIndex,
          ),
        ),
      ),
    );
  }
}
