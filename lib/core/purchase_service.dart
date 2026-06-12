import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat entitlement that unlocks Pro features.
const kProEntitlement = 'Link Vault Pro';

/// Public Google Play API key from the RevenueCat dashboard. Injected at
/// build time so it never lives in the repo:
///   flutter run --dart-define=REVENUECAT_API_KEY=goog_xxx
const _apiKey = String.fromEnvironment('REVENUECAT_API_KEY');

/// Thin wrapper over the RevenueCat SDK. Without an API key (debug builds,
/// tests) every call is a no-op and the app behaves as Free.
class PurchaseService {
  PurchaseService._();

  static bool _configured = false;
  static bool get isConfigured => _configured;

  /// Configures the SDK and reports entitlement changes through
  /// [onProChanged] (initial state + every later update).
  static Future<void> init({required ValueChanged<bool> onProChanged}) async {
    if (_apiKey.isEmpty || kIsWeb || !Platform.isAndroid) return;
    try {
      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);
      await Purchases.configure(PurchasesConfiguration(_apiKey));
      _configured = true;
      Purchases.addCustomerInfoUpdateListener(
        (info) => onProChanged(hasPro(info)),
      );
      onProChanged(hasPro(await Purchases.getCustomerInfo()));
    } on PlatformException catch (e) {
      debugPrint('PurchaseService.init failed: ${e.message}');
    }
  }

  static bool hasPro(CustomerInfo info) =>
      info.entitlements.active.containsKey(kProEntitlement);

  /// Packages of the current offering, or null when unavailable
  /// (not configured, no network, offering empty).
  static Future<List<Package>?> getPackages() async {
    if (!_configured) return null;
    try {
      final offerings = await Purchases.getOfferings();
      final packages = offerings.current?.availablePackages;
      return (packages == null || packages.isEmpty) ? null : packages;
    } on PlatformException catch (e) {
      debugPrint('PurchaseService.getPackages failed: ${e.message}');
      return null;
    }
  }

  /// Returns the result of a purchase attempt; `cancelled` shows no error.
  static Future<PurchaseOutcome> purchase(Package package) async {
    if (!_configured) return PurchaseOutcome.failed;
    try {
      final result =
          await Purchases.purchase(PurchaseParams.package(package));
      return hasPro(result.customerInfo)
          ? PurchaseOutcome.success
          : PurchaseOutcome.failed;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome.cancelled;
      }
      debugPrint('PurchaseService.purchase failed: ${e.message}');
      return PurchaseOutcome.failed;
    }
  }

  /// True when restoring found an active Pro entitlement.
  static Future<bool> restore() async {
    if (!_configured) return false;
    try {
      return hasPro(await Purchases.restorePurchases());
    } on PlatformException catch (e) {
      debugPrint('PurchaseService.restore failed: ${e.message}');
      return false;
    }
  }
}

enum PurchaseOutcome { success, cancelled, failed }
