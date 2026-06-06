import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class FilterChipsBar extends StatelessWidget {
  final LinkFilter selected;
  final ValueChanged<LinkFilter> onChanged;

  const FilterChipsBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(label: 'All', filter: LinkFilter.all, selected: selected, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(label: 'Unread', filter: LinkFilter.unread, selected: selected, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(label: 'Read', filter: LinkFilter.read, selected: selected, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(label: '♥ Saved', filter: LinkFilter.favorites, selected: selected, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final LinkFilter filter;
  final LinkFilter selected;
  final ValueChanged<LinkFilter> onChanged;

  const _Chip({
    required this.label,
    required this.filter,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = filter == selected;
    return GestureDetector(
      onTap: () => onChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.chip,
          borderRadius: AppRadius.chip,
          border: isActive ? null : Border.all(color: AppColors.border, width: 1),
          boxShadow: isActive ? AppShadows.chipActive : null,
        ),
        child: Text(
          label,
          style: isActive ? AppTextStyles.chipActive : AppTextStyles.chipInactive,
        ),
      ),
    );
  }
}
