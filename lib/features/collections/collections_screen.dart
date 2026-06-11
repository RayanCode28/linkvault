import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/l10n.dart';
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                child: Text(context.l10n.collectionsTitle, style: AppTextStyles.screenTitle),
              ),
              Expanded(
                child: Consumer<LinksProvider>(
                  builder: (ctx, provider, _) {
                    final collections = provider.collections;
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      itemCount: collections.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        if (i == collections.length) {
                          return _AddCollectionRow(
                            canAdd: provider.canAddCollection,
                            used: collections.length,
                            onTap: () => _onAddTap(context),
                          );
                        }
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
                    );
                  },
                ),
              ),
            ],
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
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _AddCollectionRow extends StatelessWidget {
  final bool canAdd;
  final int used;
  final VoidCallback onTap;

  const _AddCollectionRow({required this.canAdd, required this.used, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: AppRadius.collection,
          border: Border.all(color: AppColors.border, width: 1.5),
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
              child: Center(
                child: Icon(
                  canAdd ? Icons.add_rounded : Icons.lock_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.newCollection,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textSec)),
                Text(
                  canAdd
                      ? context.l10n.freeUsage(used, kFreeCollectionLimit)
                      : context.l10n.freeUsageLocked(used, kFreeCollectionLimit),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
