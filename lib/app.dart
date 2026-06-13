import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/links_provider.dart';
import 'core/locale_provider.dart';
import 'core/share_intent_service.dart';
import 'features/home/add_link_sheet.dart';
import 'shared/l10n.dart';
import 'shared/router.dart';

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

  // A link shared from another app opens the Add Link sheet pre-filled with
  // the URL, forcing the user to file it into a collection (or create one)
  // so shared links stay organized instead of landing uncategorized.
  void _onSharedUrl(Uri url) {
    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;
    showAddLinkSheet(navContext, initialUrl: url.toString());
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
