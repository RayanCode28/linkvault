import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/links_provider.dart';
import 'shared/router.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF020905),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  final provider = LinksProvider();
  await provider.init();
  final router = await buildRouter();
  runApp(LinkVaultApp(router: router, provider: provider));
}
