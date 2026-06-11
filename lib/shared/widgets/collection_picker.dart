import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/links_provider.dart';
import '../../core/theme.dart';
import '../l10n.dart';

/// Dropdown to pick a collection (or none) for a link.
class CollectionPicker extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const CollectionPicker({super.key, required this.selectedId, required this.onChanged});

  /// Sentinel for "no collection" — DropdownButton renders null values as the hint.
  static const _none = '';

  @override
  Widget build(BuildContext context) {
    final collections = context.watch<LinksProvider>().collections;
    final value =
        collections.any((c) => c.id == selectedId) ? selectedId! : _none;
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: AppColors.elevated,
      borderRadius: AppRadius.card,
      icon: const Icon(Icons.expand_more_rounded, color: AppColors.accent, size: 20),
      style: const TextStyle(color: AppColors.text, fontSize: 14),
      items: [
        DropdownMenuItem(
          value: _none,
          child: Text(
            context.l10n.noCollection,
            style: const TextStyle(color: AppColors.textSec, fontSize: 14),
          ),
        ),
        for (final col in collections)
          DropdownMenuItem(
            value: col.id,
            child: Text(
              '${col.emoji} ${col.name}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (v) => onChanged(v == _none ? null : v),
    );
  }
}
