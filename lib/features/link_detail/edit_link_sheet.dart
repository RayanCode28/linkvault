import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/links_provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/collection_picker.dart';
import '../../shared/widgets/neon_button.dart';

void showEditLinkSheet(BuildContext context, LinkItem link) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    useSafeArea: true,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: context.read<LinksProvider>(),
      child: EditLinkSheet(link: link),
    ),
  );
}

class EditLinkSheet extends StatefulWidget {
  final LinkItem link;

  const EditLinkSheet({super.key, required this.link});

  @override
  State<EditLinkSheet> createState() => _EditLinkSheetState();
}

class _EditLinkSheetState extends State<EditLinkSheet> {
  late final TextEditingController _titleController;
  String? _collectionId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.link.title);
    _collectionId = widget.link.collectionId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final updated = widget.link.copyWith(
      title: title.isEmpty ? widget.link.title : title,
      collectionId: _collectionId,
      clearCollection: _collectionId == null,
    );
    await context.read<LinksProvider>().updateLink(updated);
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
            Text(context.l10n.editLink, style: AppTextStyles.sheetTitle),
            const SizedBox(height: 14),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.text, fontSize: 15),
              decoration: InputDecoration(hintText: context.l10n.titleHint),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 14),
            Text(context.l10n.collectionSection, style: AppTextStyles.sectionHeader),
            const SizedBox(height: 8),
            CollectionPicker(
              selectedId: _collectionId,
              onChanged: (id) => setState(() => _collectionId = id),
            ),
            const SizedBox(height: 18),
            NeonButton(label: context.l10n.saveChanges, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
