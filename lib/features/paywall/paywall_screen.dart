import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../core/links_provider.dart';
import '../../core/purchase_service.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_bg.dart';
import '../../shared/widgets/neon_button.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<Package>? _packages;
  Package? _selected;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final packages = await PurchaseService.getPackages();
    if (!mounted || packages == null) return;
    setState(() {
      _packages = packages;
      // Preselect the highlighted plan: annual when present, else the first.
      _selected = packages.firstWhere(
        (p) => p.packageType == PackageType.annual,
        orElse: () => packages.first,
      );
    });
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _buy() async {
    final package = _selected;
    if (package == null) {
      _toast(context.l10n.purchasesUnavailable);
      return;
    }
    setState(() => _busy = true);
    final outcome = await PurchaseService.purchase(package);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (outcome) {
      case PurchaseOutcome.success:
        context.read<LinksProvider>().setPro(true);
        _toast(context.l10n.purchaseSuccess);
        Navigator.pop(context);
      case PurchaseOutcome.cancelled:
        break;
      case PurchaseOutcome.failed:
        _toast(context.l10n.purchaseFailed);
    }
  }

  Future<void> _restore() async {
    if (!PurchaseService.isConfigured) {
      _toast(context.l10n.purchasesUnavailable);
      return;
    }
    setState(() => _busy = true);
    final restored = await PurchaseService.restore();
    if (!mounted) return;
    setState(() => _busy = false);
    if (restored) {
      context.read<LinksProvider>().setPro(true);
      _toast(context.l10n.restoreSuccess);
      Navigator.pop(context);
    } else {
      _toast(context.l10n.restoreNothing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<LinksProvider>().isPro;
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSec),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 8),
                // App icon + PRO badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.accentDim,
                        borderRadius: AppRadius.proIcon,
                        border: Border.all(color: AppColors.accentBorder, width: 2),
                        boxShadow: AppShadows.sheet,
                      ),
                      child: const Center(
                        child: Icon(Icons.link_rounded, color: AppColors.accent, size: 38),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: AppRadius.badge,
                        ),
                        child: Text('PRO', style: AppTextStyles.proBadge),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Headline
                Text(
                  context.l10n.paywallHeadline,
                  style: AppTextStyles.paywallHeadline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  context.l10n.paywallSub,
                  style: const TextStyle(color: AppColors.textSec, fontSize: 14),
                ),
                const SizedBox(height: 28),
                // Features
                ..._features(context).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accentDim,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Icon(f.icon, color: AppColors.accent, size: 20)),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.label, style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(f.sub, style: const TextStyle(color: AppColors.textSec, fontSize: 12.5)),
                        ],
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                if (isPro)
                  _proActiveCard(context)
                else ...[
                  _pricingCards(context),
                  const SizedBox(height: 20),
                  _busy
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: CircularProgressIndicator(color: AppColors.accent),
                        )
                      : NeonButton(
                          label: context.l10n.unlockPro,
                          onPressed: _buy,
                        ),
                  TextButton(
                    onPressed: _busy ? null : _restore,
                    child: Text(
                      context.l10n.restorePurchases,
                      style: const TextStyle(color: AppColors.textSec, fontSize: 12.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _proActiveCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.accentDim,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent, width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 28),
          const SizedBox(height: 8),
          Text(context.l10n.proActive,
              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 2),
          Text(context.l10n.proActiveSub,
              style: const TextStyle(color: AppColors.textSec, fontSize: 12.5)),
        ],
      ),
    );
  }

  /// Real store packages when offerings loaded; otherwise the static
  /// preview prices (dev builds without a RevenueCat key).
  Widget _pricingCards(BuildContext context) {
    final packages = _packages;
    if (packages == null) {
      return Row(
        children: [
          Expanded(child: _PricingCard(
            label: context.l10n.monthly,
            price: r'$1.99',
            sub: context.l10n.perMonth,
            highlighted: false,
          )),
          const SizedBox(width: 10),
          Expanded(child: _PricingCard(
            label: context.l10n.yearly,
            price: r'$9.99',
            sub: context.l10n.perYear,
            highlighted: true,
          )),
        ],
      );
    }
    return Row(
      children: [
        for (final package in packages) ...[
          if (package != packages.first) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selected = package),
              child: _PricingCard(
                label: _packageLabel(context, package),
                price: package.storeProduct.priceString,
                sub: _packageSub(context, package),
                highlighted: package == _selected,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _packageLabel(BuildContext context, Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return context.l10n.monthly;
      case PackageType.annual:
        return context.l10n.yearly;
      case PackageType.lifetime:
        return context.l10n.lifetime;
      default:
        return package.packageType.name.toUpperCase();
    }
  }

  String _packageSub(BuildContext context, Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return context.l10n.perMonth;
      case PackageType.annual:
        return context.l10n.perYear;
      default:
        return context.l10n.oneTimePayment;
    }
  }
}

class _Feature {
  final IconData icon;
  final String label;
  final String sub;
  const _Feature(this.icon, this.label, this.sub);
}

List<_Feature> _features(BuildContext context) => [
      _Feature(Icons.grid_view_rounded, context.l10n.featCollections, context.l10n.featCollectionsSub),
      _Feature(Icons.cloud_rounded, context.l10n.featCloud, context.l10n.featCloudSub),
      _Feature(Icons.shield_rounded, context.l10n.featNoAds, context.l10n.featNoAdsSub),
      _Feature(Icons.star_rounded, context.l10n.featSupport, context.l10n.featSupportSub),
    ];

class _PricingCard extends StatelessWidget {
  final String label;
  final String price;
  final String sub;
  final bool highlighted;

  const _PricingCard({
    required this.label,
    required this.price,
    required this.sub,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.accentDim : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? AppColors.accent : AppColors.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSec)),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: highlighted ? AppColors.accent : AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10.5, color: AppColors.textSec)),
        ],
      ),
    );
  }
}
