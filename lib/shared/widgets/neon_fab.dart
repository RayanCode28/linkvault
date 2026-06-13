import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Vertical lift so the + button clears the anchored AdMob banner on Home.
/// The same value is applied on Collections so both buttons sit at exactly
/// the same height.
const double kFabLiftAboveAd = 52;

/// The single + action button used across screens (links, collections,
/// collection detail) so they share size, shape, glow and position.
/// [bottomGap] lifts it above the ad banner where one is present.
class NeonFab extends StatelessWidget {
  final VoidCallback onPressed;
  final double bottomGap;
  // Key placed on the button circle itself (for the feature-tour spotlight).
  final Key? spotlightKey;

  const NeonFab({
    super.key,
    required this.onPressed,
    this.bottomGap = 0,
    this.spotlightKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: Container(
        key: spotlightKey,
        decoration: BoxDecoration(
          borderRadius: AppRadius.fab,
          boxShadow: AppShadows.fab,
        ),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: AppColors.accent,
          foregroundColor: const Color(0xFF020A07),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.fab),
          child: const Icon(Icons.add_rounded, size: 24),
        ),
      ),
    );
  }
}
