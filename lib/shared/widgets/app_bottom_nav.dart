import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBg,
        border: Border(
          top: BorderSide(color: AppColors.navBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.link_rounded, label: 'Links', active: currentIndex == 0, onTap: () => onTap(0)),
              _NavItem(icon: Icons.grid_view_rounded, label: 'Collections', active: currentIndex == 1, onTap: () => onTap(1)),
              _NavItem(icon: Icons.search_rounded, label: 'Search', active: currentIndex == 2, onTap: () => onTap(2)),
              _NavItem(icon: Icons.settings_rounded, label: 'Settings', active: currentIndex == 3, onTap: () => onTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            active
                ? Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.35),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: AppColors.accent, size: 22),
                  )
                : Icon(icon, color: AppColors.textMuted, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: active ? AppTextStyles.navLabelActive : AppTextStyles.navLabel,
            ),
          ],
        ),
      ),
    );
  }
}
