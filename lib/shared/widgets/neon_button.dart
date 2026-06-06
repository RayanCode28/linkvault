import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NeonButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.button,
        boxShadow: AppShadows.ctaButton,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: const Color(0xFF020A07),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
