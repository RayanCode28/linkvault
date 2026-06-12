import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_fab.dart';
import 'collection_form_sheet.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  void _onAddTap(BuildContext context) {
    final provider = context.read<LinksProvider>();
    if (provider.canAddCollection) {
      showCollectionFormSheet(context);
    } else {
      context.push('/paywall');
    }
  }

  void _showOptions(BuildContext context, Collection col) {
    final provider = context.read<LinksProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.elevated,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: AppColors.accent),
              title: Text(context.l10n.rename, style: const TextStyle(color: AppColors.text)),
              onTap: () {
                Navigator.pop(ctx);
                showCollectionFormSheet(context, collection: col);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              title: Text(context.l10n.delete, style: const TextStyle(color: AppColors.danger)),
              subtitle: Text(context.l10n.deleteCollectionNote,
                  style: const TextStyle(color: AppColors.textSec, fontSize: 12)),
              onTap: () async {
                Navigator.pop(ctx);
                await provider.deleteCollection(col.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: NeonFab(onPressed: () => _onAddTap(context)),
        body: SafeArea(
          child: Consumer<LinksProvider>(
            builder: (ctx, provider, _) {
              final collections = provider.collections;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                    child: Row(
                      children: [
                        Text(context.l10n.collectionsTitle, style: AppTextStyles.screenTitle),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentDim,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${collections.length}',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                      itemCount: collections.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final col = collections[i];
                        final count = provider.byCollection(col.id).length;
                        return _CollectionRow(
                          emoji: col.emoji,
                          name: col.name,
                          count: count,
                          onTap: () => context.push('/collections/${col.id}'),
                          onLongPress: () => _showOptions(context, col),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
    );
  }
}

class _CollectionRow extends StatelessWidget {
  final String emoji;
  final String name;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CollectionRow({
    required this.emoji,
    required this.name,
    required this.count,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.collection,
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accentDim,
                borderRadius: AppRadius.colIcon,
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.collectionName),
                  Text(context.l10n.linkCount(count), style: AppTextStyles.collectionCount),
                ],
              ),
            ),
            // Explicit edit/delete entry point (long-press still works too).
            GestureDetector(
              onTap: onLongPress,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

