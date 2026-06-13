import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_fab.dart';
import '../../shared/widgets/screen_header.dart';
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
      floatingActionButton: NeonFab(
        onPressed: () => _onAddTap(context),
        bottomGap: kFabLiftAboveAd,
      ),
      body: SafeArea(
        child: Consumer<LinksProvider>(
          builder: (ctx, provider, _) {
            return Column(
              children: [
                ScreenHeader(
                  title: context.l10n.collectionsTitle,
                  trailing: _CountBadge(count: provider.collections.length),
                ),
                Expanded(child: _content(context, provider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context, LinksProvider provider) {
    final collections = provider.collections;
    final rows = <Widget>[
      // Fixed virtual "Uncategorized" collection: holds links with no
      // collection. It can't be renamed, deleted or added to directly.
      _CollectionRow(
        leading: const Icon(Icons.inbox_rounded, color: AppColors.accent, size: 22),
        name: context.l10n.uncategorized,
        count: provider.uncategorizedLinks.length,
        onTap: () => context.push('/collections/$kUncategorizedId'),
      ),
    ];
    // Separador + encabezado que divide la colección virtual "Sin categoría"
    // de las colecciones del usuario.
    if (collections.isNotEmpty) {
      rows.add(const SizedBox(height: 18));
      rows.add(Divider(height: 1, color: AppColors.border));
      rows.add(const SizedBox(height: 12));
      rows.add(Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 4),
        child: Text(context.l10n.myCollections, style: AppTextStyles.sectionHeader),
      ));
    }
    for (final col in collections) {
      rows.add(const SizedBox(height: 8));
      rows.add(_CollectionRow(
        leading: Text(col.emoji, style: const TextStyle(fontSize: 22)),
        name: col.name,
        count: provider.byCollection(col.id).length,
        onTap: () => context.push('/collections/${col.id}'),
        onOptions: () => _showOptions(context, col),
      ));
    }
    // With own collections the list scrolls. Otherwise the few rows sit at
    // the top and the prompt is centered in the remaining space, like the
    // empty state on the Links tab.
    if (provider.hasOwnCollections) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
        children: rows,
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: rows),
        ),
        Expanded(child: Center(child: _emptyHint(context))),
      ],
    );
  }

  Widget _emptyHint(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📁', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(context.l10n.collectionsEmptyTitle,
              style: const TextStyle(color: AppColors.textSec, fontSize: 14)),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              context.l10n.collectionsEmptyHint,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
            ),
          ),
        ],
      );
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentDim,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CollectionRow extends StatelessWidget {
  final Widget leading;
  final String name;
  final int count;
  final VoidCallback onTap;
  // When null the row is not editable/deletable (the Uncategorized row).
  final VoidCallback? onOptions;

  const _CollectionRow({
    required this.leading,
    required this.name,
    required this.count,
    required this.onTap,
    this.onOptions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onOptions,
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
              child: Center(child: leading),
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
            if (onOptions != null)
              // Explicit edit/delete entry point (long-press still works too).
              GestureDetector(
                onTap: onOptions,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: 20),
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
