import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NeonBg extends StatelessWidget {
  final Widget child;

  const NeonBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        gradient: RadialGradient(
          center: Alignment(0, -1),
          radius: 1.2,
          colors: [
            Color(0x1700FFD1),
            Colors.transparent,
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}
