import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/links_provider.dart';
import 'core/share_intent_service.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class LinkVaultApp extends StatefulWidget {
  final GoRouter router;
  final LinksProvider provider;

  const LinkVaultApp({super.key, required this.router, required this.provider});

  @override
  State<LinkVaultApp> createState() => _LinkVaultAppState();
}

class _LinkVaultAppState extends State<LinkVaultApp> {
  @override
  void initState() {
    super.initState();
    ShareIntentService.listen(_onSharedUrl);
  }

  @override
  void dispose() {
    ShareIntentService.dispose();
    super.dispose();
  }

  Future<void> _onSharedUrl(Uri url) async {
    final link = await widget.provider.addLink(url.toString());
    if (link == null) return;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Link saved · ${link.domain}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: MaterialApp.router(
        title: 'LinkVault',
        theme: buildAppTheme(),
        routerConfig: widget.router,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
