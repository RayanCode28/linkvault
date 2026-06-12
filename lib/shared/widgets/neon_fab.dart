import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// The single + action button used across screens (links, collections,
/// collection detail) so they share size, shape, glow and position.
class NeonFab extends StatelessWidget {
  final VoidCallback onPressed;

  const NeonFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
