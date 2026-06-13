import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/links_provider.dart';
import 'core/locale_provider.dart';
import 'core/purchase_service.dart';
import 'shared/router.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ===== TEMP (testing): replay onboarding + feature tour every launch.
  // Remove this block when done testing. =====
  final testingPrefs = await SharedPreferences.getInstance();
  await testingPrefs.setBool('onboarded', false);
  await testingPrefs.remove('tour_done');
  // ===== end temp block =====
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
  if (!kIsWeb && Platform.isAndroid) {
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
