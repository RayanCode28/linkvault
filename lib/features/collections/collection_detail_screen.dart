import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/neon_bg.dart';
import '../home/link_card.dart';

class CollectionDetailScreen extends StatelessWidget {
  final Collection collection;

  const CollectionDetailScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: AppColors.textSec),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Text(collection.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Consumer<LinksProvider>(
                builder: (ctx, provider, _) {
                  final count = provider.byCollection(collection.id).length;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(collection.name, style: AppTextStyles.collectionName),
                      Text('$count links', style: AppTextStyles.collectionCount),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        body: Consumer<LinksProvider>(
          builder: (ctx, provider, _) {
            final items = provider.byCollection(collection.id);
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(collection.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text('No links yet', style: TextStyle(color: AppColors.textSec, fontSize: 14)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: items.length,
              itemBuilder: (ctx, i) => LinkCard(link: items[i]),
            );
          },
        ),
      ),
    );
  }
}
