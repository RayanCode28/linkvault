import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/neon_bg.dart';
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
              body: const Center(
                child: Text('Collection not found',
                    style: TextStyle(color: AppColors.textSec, fontSize: 14)),
              ),
            );
          }

          final items = provider.byCollection(collectionId);
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
                  Text(collection.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(collection.name, style: AppTextStyles.collectionName),
                      Text('${items.length} links', style: AppTextStyles.collectionCount),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showAddLinkSheet(context, collectionId: collectionId),
              backgroundColor: AppColors.accent,
              foregroundColor: const Color(0xFF020A07),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.fab),
              child: const Icon(Icons.add_rounded, size: 22),
            ),
            body: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(collection.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        const Text('No links yet',
                            style: TextStyle(color: AppColors.textSec, fontSize: 14)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => LinkCard(link: items[i]),
                  ),
          );
        },
      ),
    );
  }
}
