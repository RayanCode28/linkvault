import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/links_provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/collection_picker.dart';
import '../../shared/widgets/neon_button.dart';
import '../collections/collection_form_sheet.dart';

void showAddLinkSheet(BuildContext context,
    {String? collectionId, String? initialUrl}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    useSafeArea: true,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: context.read<LinksProvider>(),
      child: AddLinkSheet(
        initialCollectionId: collectionId,
        initialUrl: initialUrl,
      ),
    ),
  );
}

class AddLinkSheet extends StatefulWidget {
  final String? initialCollectionId;
  final String? initialUrl;

  const AddLinkSheet({super.key, this.initialCollectionId, this.initialUrl});

  @override
  State<AddLinkSheet> createState() => _AddLinkSheetState();
}

class _AddLinkSheetState extends State<AddLinkSheet> {
  final _controller = TextEditingController();
  String? _collectionId;
  String? _error;
  String? _collectionError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _collectionId = widget.initialCollectionId;
    if (widget.initialUrl != null) {
      _controller.text = widget.initialUrl!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text != null && text.isNotEmpty) {
      _controller.text = text;
      setState(() => _error = null);
    }
  }

  /// Opens the collection form inline. If the user is at the free limit we
  /// route them to the paywall instead. A created collection is auto-selected.
  Future<void> _createCollection() async {
    final provider = context.read<LinksProvider>();
    if (!provider.canAddCollection) {
      context.push('/paywall');
      return;
    }
    final created = await showCollectionFormSheet(context);
    if (!mounted || created == null) return;
    setState(() {
      _collectionId = created.id;
      _collectionError = null;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final uri = parseWebUrl(_controller.text);
    if (uri == null) {
      setState(() => _error = context.l10n.urlInvalid);
      return;
    }
    if (_collectionId == null) {
      setState(() => _collectionError = context.l10n.collectionRequired);
      return;
    }
    setState(() => _saving = true);
    final provider = context.read<LinksProvider>();
    final link = await provider.addLink(uri.toString(), collectionId: _collectionId);
    if (!mounted) return;
    Navigator.pop(context);
    if (link != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.linkSaved(link.domain)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
            Text(context.l10n.addLink, style: AppTextStyles.sheetTitle),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              style: const TextStyle(color: AppColors.text, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'https://...',
                errorText: _error,
                prefixIcon: const Icon(Icons.link_rounded, color: AppColors.textMuted, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_paste_rounded, color: AppColors.accent, size: 18),
                  tooltip: context.l10n.paste,
                  onPressed: _paste,
                ),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 14),
            Text(context.l10n.collectionSection, style: AppTextStyles.sectionHeader),
            const SizedBox(height: 8),
            CollectionPicker(
              selectedId: _collectionId,
              allowNone: false,
              onCreateNew: _createCollection,
              onChanged: (id) => setState(() {
                _collectionId = id;
                _collectionError = null;
              }),
            ),
            if (_collectionError != null) ...[
              const SizedBox(height: 6),
              Text(
                _collectionError!,
                style: const TextStyle(color: AppColors.danger, fontSize: 12),
              ),
            ],
            const SizedBox(height: 18),
            NeonButton(
              label: _saving ? context.l10n.savingLink : context.l10n.saveLink,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
