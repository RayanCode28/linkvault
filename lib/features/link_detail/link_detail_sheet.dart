import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';

void showLinkDetailSheet(BuildContext context, LinkItem link) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.65),
    useSafeArea: true,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: context.read<LinksProvider>(),
      child: LinkDetailSheet(link: link),
    ),
  );
}

class LinkDetailSheet extends StatelessWidget {
  final LinkItem link;

  const LinkDetailSheet({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    final collection = mockCollections.firstWhere(
      (c) => c.id == link.collectionId,
      orElse: () => const Collection(id: '', name: '', emoji: ''),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: AppRadius.sheetTop,
        border: Border(
          top: BorderSide(color: AppColors.accentBorder, width: 1),
          left: BorderSide(color: AppColors.accentBorder, width: 1),
          right: BorderSide(color: AppColors.accentBorder, width: 1),
        ),
        boxShadow: AppShadows.sheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pull handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large thumbnail
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: link.thumbBg,
                      borderRadius: AppRadius.card,
                    ),
                    child: Center(
                      child: Text(link.thumbEmoji, style: const TextStyle(fontSize: 64)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(link.title, style: AppTextStyles.sheetTitle),
                  const SizedBox(height: 8),
                  Wrap(
                    children: [
                      Text(
                        link.domain,
                        style: GoogleFontsStyle.domain,
                      ),
                      if (collection.name.isNotEmpty)
                        Text(
                          ' · ${collection.emoji} ${collection.name}',
                          style: AppTextStyles.cardMeta,
                        ),
                      Text(' · ${link.date}', style: AppTextStyles.cardDate),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(link.description, style: AppTextStyles.sheetDesc),
                  const SizedBox(height: 14),
                  // Status badges
                  Consumer<LinksProvider>(
                    builder: (ctx, provider, _) {
                      final current = provider.links.firstWhere(
                        (l) => l.id == link.id,
                        orElse: () => link,
                      );
                      return Row(
                        children: [
                          _Badge(
                            label: current.read ? 'Read' : 'Unread',
                            bg: AppColors.accentDim,
                            fg: AppColors.accent,
                          ),
                          if (current.favorite) ...[
                            const SizedBox(width: 8),
                            _Badge(
                              label: '♥ Saved',
                              bg: AppColors.heart.withOpacity(0.15),
                              fg: AppColors.heart,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          // Action bar
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Consumer<LinksProvider>(
              builder: (ctx, provider, _) {
                final current = provider.links.firstWhere(
                  (l) => l.id == link.id,
                  orElse: () => link,
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionBtn(icon: Icons.share_rounded, label: 'Share', color: AppColors.textSec, onTap: () {}),
                    _ActionBtn(
                      icon: current.favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      label: 'Favorite',
                      color: current.favorite ? AppColors.heart : AppColors.textSec,
                      onTap: () => provider.toggleFavorite(link.id),
                    ),
                    _ActionBtn(icon: Icons.edit_rounded, label: 'Edit', color: AppColors.accent, onTap: () {}),
                    _ActionBtn(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: AppColors.danger,
                      onTap: () {
                        provider.deleteLink(link.id);
                        Navigator.pop(context);
                      },
                    ),
                    _ActionBtn(
                      icon: Icons.open_in_new_rounded,
                      label: 'Open',
                      color: AppColors.text,
                      onTap: () async {
                        provider.markRead(link.id);
                        Navigator.pop(context);
                        final uri = Uri.tryParse('https://${link.domain}');
                        if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleFontsStyle {
  static TextStyle get domain => TextStyle(
    color: AppColors.accent,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
