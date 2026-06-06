import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/neon_bg.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                child: Text('Collections', style: AppTextStyles.screenTitle),
              ),
              Expanded(
                child: Consumer<LinksProvider>(
                  builder: (ctx, provider, _) {
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      itemCount: mockCollections.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        if (i == mockCollections.length) {
                          return _AddCollectionRow(onTap: () => context.push('/paywall'));
                        }
                        final col = mockCollections[i];
                        final count = provider.byCollection(col.id).length;
                        return _CollectionRow(
                          emoji: col.emoji,
                          name: col.name,
                          count: count,
                          onTap: () => context.push('/collections/${col.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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

  const _CollectionRow({
    required this.emoji,
    required this.name,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  Text('$count links', style: AppTextStyles.collectionCount),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _AddCollectionRow extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCollectionRow({required this.onTap});

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
                child: Icon(Icons.add_rounded, color: AppColors.accent, size: 20),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New collection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textSec)),
                Text('Free: 3/3 used · Unlock more with Pro', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
