import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/neon_bg.dart';
import '../home/filter_chips_bar.dart';
import '../home/link_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  LinkFilter _filter = LinkFilter.all;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          title: TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(color: AppColors.text, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search links...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: _query.isNotEmpty ? AppColors.accent : AppColors.textMuted,
                size: 20,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: AppRadius.card,
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.card,
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.card,
                borderSide: BorderSide(color: AppColors.accentBorder),
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        body: Consumer<LinksProvider>(
          builder: (ctx, provider, _) {
            List<LinkItem> results;
            if (_query.isEmpty) {
              results = [];
            } else {
              results = provider.search(_query);
              // Apply filter on top of search
              if (_filter != LinkFilter.all) {
                results = results.where((l) {
                  switch (_filter) {
                    case LinkFilter.unread: return !l.read;
                    case LinkFilter.read: return l.read;
                    case LinkFilter.favorites: return l.favorite;
                    default: return true;
                  }
                }).toList();
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                FilterChipsBar(
                  selected: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _query.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_rounded, color: AppColors.textMuted, size: 36),
                              const SizedBox(height: 8),
                              Text('Start typing...', style: TextStyle(color: AppColors.textSec, fontSize: 14)),
                            ],
                          ),
                        )
                      : results.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🔍', style: TextStyle(fontSize: 32)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No results for "$_query"',
                                    style: TextStyle(color: AppColors.textSec, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: results.length,
                              itemBuilder: (ctx, i) => LinkCard(link: results[i]),
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
