import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/links_provider.dart';
import '../../core/theme.dart';
import '../l10n.dart';

/// Dropdown to pick a collection for a link.
///
/// When [allowNone] is true it offers a "No collection" entry (used when
/// editing). When false the picker is mandatory and shows a hint until a
/// collection is chosen. If [onCreateNew] is provided, a "New collection"
/// entry at the bottom lets the user create one without leaving the sheet.
class CollectionPicker extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final bool allowNone;
  final VoidCallback? onCreateNew;

  const CollectionPicker({
    super.key,
    required this.selectedId,
    required this.onChanged,
    this.allowNone = true,
    this.onCreateNew,
  });

  /// Sentinel for "no collection" — DropdownButton renders null values as the hint.
  static const _none = '';

  /// Sentinel for the "create a new collection" entry.
  static const _createNew = '__create_new__';

  @override
  Widget build(BuildContext context) {
    final collections = context.watch<LinksProvider>().collections;
    final hasSelection = collections.any((c) => c.id == selectedId);
    final String? value =
        hasSelection ? selectedId : (allowNone ? _none : null);
    return DropdownButtonFormField<String>(
      // Re-key on the value so a programmatic selection (e.g. right after
      // creating a collection inline) is reflected in the field.
      key: ValueKey('collection_picker_$value'),
      initialValue: value,
      isExpanded: true,
      dropdownColor: AppColors.elevated,
      borderRadius: AppRadius.card,
      icon: const Icon(Icons.expand_more_rounded, color: AppColors.accent, size: 20),
      style: const TextStyle(color: AppColors.text, fontSize: 14),
      hint: allowNone
          ? null
          : Text(
              context.l10n.selectCollectionHint,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
      items: [
        if (allowNone)
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
        if (onCreateNew != null)
          DropdownMenuItem(
            value: _createNew,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded, color: AppColors.accent, size: 18),
                const SizedBox(width: 6),
                Text(
                  context.l10n.newCollection,
                  style: const TextStyle(color: AppColors.accent, fontSize: 14),
                ),
              ],
            ),
          ),
      ],
      onChanged: (v) {
        if (v == _createNew) {
          onCreateNew?.call();
          return;
        }
        onChanged(v == _none ? null : v);
      },
    );
  }
}
