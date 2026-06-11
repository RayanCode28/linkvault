import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/links_provider.dart';
import 'core/locale_provider.dart';
import 'core/share_intent_service.dart';
import 'shared/l10n.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class LinkVaultApp extends StatefulWidget {
  final GoRouter router;
  final LinksProvider provider;
  final LocaleProvider localeProvider;

  const LinkVaultApp({
    super.key,
    required this.router,
    required this.provider,
    required this.localeProvider,
  });

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
    final messengerContext = scaffoldMessengerKey.currentContext;
    if (messengerContext == null || !messengerContext.mounted) return;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(messengerContext.l10n.linkSaved(link.domain)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.provider),
        ChangeNotifierProvider.value(value: widget.localeProvider),
      ],
      child: Consumer<LocaleProvider>(
        builder: (ctx, localeProvider, _) => MaterialApp.router(
          title: 'LinkVault',
          theme: buildAppTheme(),
          routerConfig: widget.router,
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          // null = device language (automatic); a user choice overrides it.
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
