import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/links_provider.dart';
import 'core/locale_provider.dart';
import 'core/purchase_service.dart';
import 'shared/router.dart';
import 'shared/widgets/ad_banner.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase powers the Pro cloud backup (Auth + Cloud Storage). Reads
  // android/app/google-services.json; guarded so a missing config never
  // crashes startup (the app just runs without cloud backup).
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF020905),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  final provider = LinksProvider();
  await provider.init();
  // Purchases and ads start in the background; the app launches as Free
  // and upgrades as soon as the entitlement is known.
  unawaited(PurchaseService.init(onProChanged: provider.setPro));
  if (adsEnabled && !kIsWeb && Platform.isAndroid) {
    unawaited(MobileAds.instance.initialize());
  }
  final localeProvider = LocaleProvider();
  await localeProvider.init();
  final router = await buildRouter();
  runApp(LinkVaultApp(
    router: router,
    provider: provider,
    localeProvider: localeProvider,
  ));
}
