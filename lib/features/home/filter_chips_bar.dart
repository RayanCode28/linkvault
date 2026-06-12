import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';

/// Minimalist filter row: plain centered labels, the active one in neon cyan
/// (with a subtle glow) — in the spirit of the bottom nav labels.
class FilterChipsBar extends StatelessWidget {
  final LinkFilter selected;
  final ValueChanged<LinkFilter> onChanged;

  const FilterChipsBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Item(label: context.l10n.filterAll, filter: LinkFilter.all, selected: selected, onChanged: onChanged),
          _Item(label: context.l10n.filterUnread, filter: LinkFilter.unread, selected: selected, onChanged: onChanged),
          _Item(label: context.l10n.filterRead, filter: LinkFilter.read, selected: selected, onChanged: onChanged),
          _Item(label: context.l10n.filterSaved, filter: LinkFilter.favorites, selected: selected, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final LinkFilter filter;
  final LinkFilter selected;
  final ValueChanged<LinkFilter> onChanged;

  const _Item({
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
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: isActive ? AppTextStyles.filterActive : AppTextStyles.filterInactive,
          child: Text(label),
        ),
      ),
    );
  }
}
