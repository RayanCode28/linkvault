import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/neon_bg.dart';
import 'add_link_sheet.dart';
import 'filter_chips_bar.dart';
import 'link_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LinkFilter _filter = LinkFilter.all;

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('LinkVault', style: AppTextStyles.appBar),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded, color: AppColors.textSec),
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),
        body: Stack(
          children: [
            Consumer<LinksProvider>(
              builder: (ctx, provider, _) {
                final items = provider.filtered(_filter);
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tappable search bar
                          GestureDetector(
                            onTap: () => context.go('/search'),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadius.card,
                                border: Border.all(color: AppColors.border, width: 1),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.search_rounded, color: AppColors.textMuted, size: 17),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search links...',
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FilterChipsBar(
                            selected: _filter,
                            onChanged: (f) => setState(() => _filter = f),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    if (items.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(provider.links.isEmpty ? '🔗' : '🔍',
                                  style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              Text(
                                provider.links.isEmpty
                                    ? 'No links saved yet'
                                    : 'No links match this filter',
                                style: const TextStyle(color: AppColors.textSec, fontSize: 14),
                              ),
                              if (provider.links.isEmpty) ...[
                                const SizedBox(height: 6),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    'Tap + to add a link, or share one from any app',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => LinkCard(link: items[i]),
                          childCount: items.length,
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              },
            ),
            // FAB
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => showAddLinkSheet(context),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: AppRadius.fab,
                    boxShadow: AppShadows.fab,
                  ),
                  child: const Icon(Icons.add_rounded, color: Color(0xFF020A07), size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
