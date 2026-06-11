import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/links_provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_button.dart';

const _emojiChoices = [
  '📁', '🎬', '📚', '📰', '🍕', '💡', '🎵', '🎮', '💪', '✈️', '🛍️', '💼',
];

/// Creates a collection when [collection] is null, renames it otherwise.
void showCollectionFormSheet(BuildContext context, {Collection? collection}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    useSafeArea: true,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: context.read<LinksProvider>(),
      child: CollectionFormSheet(collection: collection),
    ),
  );
}

class CollectionFormSheet extends StatefulWidget {
  final Collection? collection;

  const CollectionFormSheet({super.key, this.collection});

  @override
  State<CollectionFormSheet> createState() => _CollectionFormSheetState();
}

class _CollectionFormSheetState extends State<CollectionFormSheet> {
  late final TextEditingController _nameController;
  late String _emoji;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.collection?.name ?? '');
    _emoji = widget.collection?.emoji ?? _emojiChoices.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = context.l10n.collectionNameError);
      return;
    }
    final provider = context.read<LinksProvider>();
    if (widget.collection == null) {
      await provider.addCollection(name, _emoji);
    } else {
      await provider.renameCollection(widget.collection!.id, name, _emoji);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: AppRadius.sheetTop,
        border: Border(
          top: BorderSide(color: AppColors.accentBorder, width: 1),
          left: BorderSide(color: AppColors.accentBorder, width: 1),
          right: BorderSide(color: AppColors.accentBorder, width: 1),
        ),
        boxShadow: AppShadows.sheet,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              widget.collection == null
                  ? context.l10n.newCollection
                  : context.l10n.editCollection,
              style: AppTextStyles.sheetTitle,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              autofocus: true,
              maxLength: 40,
              style: const TextStyle(color: AppColors.text, fontSize: 15),
              decoration: InputDecoration(
                hintText: context.l10n.collectionNameHint,
                errorText: _error,
                counterText: '',
              ),
              textInputAction: TextInputAction.done,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 14),
            Text(context.l10n.iconSection, style: AppTextStyles.sectionHeader),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final emoji in _emojiChoices)
                  GestureDetector(
                    onTap: () => setState(() => _emoji = emoji),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: emoji == _emoji ? AppColors.accentDim : AppColors.surface,
                        borderRadius: AppRadius.colIcon,
                        border: Border.all(
                          color: emoji == _emoji ? AppColors.accentBorder : AppColors.border,
                        ),
                      ),
                      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            NeonButton(
              label: widget.collection == null
                  ? context.l10n.createCollection
                  : context.l10n.saveChanges,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
