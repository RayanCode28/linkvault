import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets/neon_bg.dart';
import '../../shared/widgets/neon_button.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    icon: Icon(Icons.close_rounded, color: AppColors.textSec),
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
                      child: Center(
                        child: Icon(Icons.link_rounded, color: AppColors.accent, size: 38),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        decoration: BoxDecoration(
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
                  'You save a lot.\nNever lose any of it.',
                  style: AppTextStyles.paywallHeadline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Upgrade to LinkVault Pro',
                  style: TextStyle(color: AppColors.textSec, fontSize: 14),
                ),
                const SizedBox(height: 28),
                // Features
                ..._features.map((f) => Padding(
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
                          Text(f.label, style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(f.sub, style: TextStyle(color: AppColors.textSec, fontSize: 12.5)),
                        ],
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                // Pricing cards
                Row(
                  children: [
                    Expanded(child: _PricingCard(
                      label: 'MONTHLY',
                      price: r'$1.99',
                      sub: 'per month',
                      highlighted: false,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _PricingCard(
                      label: 'YEARLY',
                      price: r'$9.99',
                      sub: 'per year',
                      highlighted: true,
                    )),
                  ],
                ),
                const SizedBox(height: 20),
                NeonButton(
                  label: 'Start Free Trial',
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                Text(
                  '3-day free trial · Cancel anytime · Restore purchases',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String label;
  final String sub;
  const _Feature(this.icon, this.label, this.sub);
}

const _features = [
  _Feature(Icons.grid_view_rounded, 'Unlimited collections', 'Organize without limits'),
  _Feature(Icons.cloud_rounded, 'Cloud backup', 'Your links, safe forever'),
  _Feature(Icons.shield_rounded, 'No ads, ever', 'Pure, distraction-free saving'),
  _Feature(Icons.star_rounded, 'Priority support', 'We\'ve got your back'),
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
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSec)),
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
          Text(sub, style: TextStyle(fontSize: 10.5, color: AppColors.textSec)),
        ],
      ),
    );
  }
}
