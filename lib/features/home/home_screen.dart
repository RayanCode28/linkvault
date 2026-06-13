import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../core/feature_tour.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/ad_banner.dart';
import '../../shared/widgets/neon_fab.dart';
import '../../shared/widgets/screen_header.dart';
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
  void initState() {
    super.initState();
    // First-run spotlight tour, once the Home UI is laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FeatureTour.maybeStart(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: NeonFab(
          onPressed: () => showAddLinkSheet(context),
          bottomGap: kFabLiftAboveAd,
          spotlightKey: FeatureTour.fabKey,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const ScreenHeader(title: 'LinkVault'),
              Expanded(child: _linksArea(context)),
              // Banner for Free users; collapses for Pro.
              const AdBanner(),
            ],
          ),
        ),
    );
  }

  Widget _linksArea(BuildContext context) {
    return Consumer<LinksProvider>(
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
                            onTap: () => context.push('/search'),
                            child: Container(
                              key: FeatureTour.searchKey,
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadius.card,
                                border: Border.all(color: AppColors.border, width: 1),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 17),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.l10n.searchHint,
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FilterChipsBar(
                            key: FeatureTour.filtersKey,
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
                                    ? context.l10n.emptyNoLinks
                                    : context.l10n.emptyNoMatch,
                                style: const TextStyle(color: AppColors.textSec, fontSize: 14),
                              ),
                              if (provider.links.isEmpty) ...[
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    context.l10n.emptyHint,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
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
                    const SliverToBoxAdapter(child: SizedBox(height: 130)),
                  ],
                );
              },
    );
  }
}
