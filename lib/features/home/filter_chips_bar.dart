import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';

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
          _Chip(label: context.l10n.filterAll, filter: LinkFilter.all, selected: selected, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(label: context.l10n.filterUnread, filter: LinkFilter.unread, selected: selected, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(label: context.l10n.filterRead, filter: LinkFilter.read, selected: selected, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(label: context.l10n.filterSaved, filter: LinkFilter.favorites, selected: selected, onChanged: onChanged),
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
