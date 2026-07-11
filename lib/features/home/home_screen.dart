import 'package:flutter/material.dart';
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
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
            // Barra de búsqueda y filtros fijos: no hacen scroll con la
            // lista, para que siempre estén accesibles aunque haya muchos
            // enlaces guardados.
            _searchBar(context),
            FilterChipsBar(
              key: FeatureTour.filtersKey,
              selected: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 12),
            Expanded(child: _linksArea(context)),
            // Banner for Free users; collapses for Pro.
            const AdBanner(),
          ],
        ),
      ),
    );
  }

  // In-place search: filters the list right here instead of pushing a
  // near-identical /search screen (the transition between the two read as
  // a glitchy overlap — tester feedback).
  Widget _searchBar(BuildContext context) {
    final active = _query.isNotEmpty;
    return Container(
      key: FeatureTour.searchKey,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(
            color: active ? AppColors.accentBorder : AppColors.border,
            width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded,
              color: active ? AppColors.accent : AppColors.textMuted, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: AppColors.text, fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: context.l10n.searchHint,
                hintStyle:
                    const TextStyle(color: AppColors.textMuted, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          if (active)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
              child: const Icon(Icons.close_rounded,
                  color: AppColors.textMuted, size: 18),
            ),
        ],
      ),
    );
  }

  List<LinkItem> _visibleLinks(LinksProvider provider) {
    if (_query.isEmpty) return provider.filtered(_filter);
    final results = provider.search(_query);
    switch (_filter) {
      case LinkFilter.unread:
        return results.where((l) => !l.read).toList();
      case LinkFilter.read:
        return results.where((l) => l.read).toList();
      case LinkFilter.favorites:
        return results.where((l) => l.favorite).toList();
      default:
        return results;
    }
  }

  Widget _linksArea(BuildContext context) {
    return Consumer<LinksProvider>(
      builder: (ctx, provider, _) {
        final items = _visibleLinks(provider);
        return CustomScrollView(
          // Empty state is a static view: no scroll gesture when there is
          // nothing to scroll through.
          physics: items.isEmpty ? const NeverScrollableScrollPhysics() : null,
          slivers: [
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
                            : _query.isNotEmpty
                                ? context.l10n.noResults(_query)
                                : context.l10n.emptyNoMatch,
                        style: const TextStyle(
                            color: AppColors.textSec, fontSize: 14),
                      ),
                      if (provider.links.isEmpty) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            context.l10n.emptyHint,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else ...[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => LinkCard(link: items[i]),
                  childCount: items.length,
                ),
              ),
              // Room so the FAB and ad banner never cover the last card.
              const SliverToBoxAdapter(child: SizedBox(height: 130)),
            ],
          ],
        );
      },
    );
  }
}
