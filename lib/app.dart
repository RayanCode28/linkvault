import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/links_provider.dart';

class LinkVaultApp extends StatelessWidget {
  final GoRouter router;

  const LinkVaultApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LinksProvider(),
      child: MaterialApp.router(
        title: 'LinkVault',
        theme: buildAppTheme(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
