import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Unified screen header used across Links, Collections and Settings so the
/// title sits at the same level on every tab, followed by a thin divider
/// (matching the bottom-nav hairline) that separates it from the content.
class ScreenHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const ScreenHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Row(
            children: [
              Text(title, style: AppTextStyles.screenTitle),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                trailing!,
              ],
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: AppColors.navBorder),
        const SizedBox(height: 10),
      ],
    );
  }
}
