import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_bg.dart';
import '../../shared/widgets/neon_fab.dart';
import '../home/add_link_sheet.dart';
import '../home/link_card.dart';

class CollectionDetailScreen extends StatelessWidget {
  final String collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Consumer<LinksProvider>(
        builder: (ctx, provider, _) {
          // Virtual "Uncategorized" collection: links with no collection.
          // Read-only — no add button, can't be edited or deleted.
          if (collectionId == kUncategorizedId) {
            final items = provider.uncategorizedLinks;
            return _scaffold(
              context,
              leading: const Icon(Icons.inbox_rounded, color: AppColors.accent, size: 22),
              title: context.l10n.uncategorized,
              items: items,
              fab: null,
            );
          }

          final collection = provider.collectionById(collectionId);
          // Collection was deleted while this screen was open.
          if (collection == null) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSec),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Text(context.l10n.collectionNotFound,
                    style: const TextStyle(color: AppColors.textSec, fontSize: 14)),
              ),
            );
          }

          return _scaffold(
            context,
            leading: Text(collection.emoji, style: const TextStyle(fontSize: 22)),
            title: collection.name,
            items: provider.byCollection(collectionId),
            fab: NeonFab(
              onPressed: () => showAddLinkSheet(context, collectionId: collectionId),
            ),
          );
        },
      ),
    );
  }

  Widget _scaffold(
    BuildContext context, {
    required Widget leading,
    required String title,
    required List<LinkItem> items,
    required Widget? fab,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSec),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            leading,
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.collectionName),
                Text(context.l10n.linkCount(items.length),
                    style: AppTextStyles.collectionCount),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: fab,
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme(
                    data: const IconThemeData(color: AppColors.textMuted, size: 32),
                    child: leading,
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.noLinksYet,
                      style: const TextStyle(color: AppColors.textSec, fontSize: 14)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: items.length,
              itemBuilder: (ctx, i) => LinkCard(link: items[i]),
            ),
    );
  }
}
