import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/links_provider.dart';
import '../../core/theme.dart';

/// Horizontal chip row to pick a collection (or none) for a link.
class CollectionPicker extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const CollectionPicker({super.key, required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final collections = context.watch<LinksProvider>().collections;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _PickerChip(
            label: 'None',
            active: selectedId == null,
            onTap: () => onChanged(null),
          ),
          for (final col in collections) ...[
            const SizedBox(width: 8),
            _PickerChip(
              label: '${col.emoji} ${col.name}',
              active: selectedId == col.id,
              onTap: () => onChanged(col.id),
            ),
          ],
        ],
      ),
    );
  }
}

class _PickerChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PickerChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.chip,
          borderRadius: AppRadius.chip,
          border: active ? null : Border.all(color: AppColors.border, width: 1),
          boxShadow: active ? AppShadows.chipActive : null,
        ),
        child: Text(
          label,
          style: active ? AppTextStyles.chipActive : AppTextStyles.chipInactive,
        ),
      ),
    );
  }
}
