import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../core/links_provider.dart';

/// Real unit id injected at build time:
///   flutter build appbundle --dart-define=ADMOB_BANNER_ID=ca-app-pub-xxx/yyy
const _envBannerId = String.fromEnvironment('ADMOB_BANNER_ID');

/// In release, ads exist only when the real unit id was injected — a build
/// without the define ships completely ad-free (AdMob SDK never initializes).
/// Debug/profile builds fall back to Google's public test unit.
const _bannerAdUnitId = kReleaseMode
    ? _envBannerId
    : (_envBannerId == '' ? 'ca-app-pub-3940256099942544/6300978111' : _envBannerId);

/// Whether this build serves ads at all. main.dart skips MobileAds
/// initialization when false.
const adsEnabled = _bannerAdUnitId != '';

/// Anchored banner shown to Free users only. Takes no space while the ad
/// loads, on non-Android platforms, or once the user is Pro.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (!adsEnabled || kIsWeb || !Platform.isAndroid) return;
    final ad = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdBanner failed to load: ${error.message}');
          ad.dispose();
          if (mounted) setState(() => _ad = null);
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    final isPro = context.watch<LinksProvider>().isPro;
    if (isPro || ad == null || !_loaded) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
