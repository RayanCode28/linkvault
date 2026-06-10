import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/link_thumbnail.dart';
import 'edit_link_sheet.dart';

void showLinkDetailSheet(BuildContext context, LinkItem link) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    useSafeArea: true,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: context.read<LinksProvider>(),
      child: LinkDetailSheet(linkId: link.id!, fallback: link),
    ),
  );
}

class LinkDetailSheet extends StatelessWidget {
  final int linkId;
  final LinkItem fallback;

  const LinkDetailSheet({super.key, required this.linkId, required this.fallback});

  Future<void> _open(BuildContext context, LinksProvider provider, LinkItem link) async {
    provider.markRead(linkId);
    Navigator.pop(context);
    final uri = parseWebUrl(link.url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _confirmDelete(BuildContext context, LinksProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.elevated,
        title: Text('Delete link?', style: AppTextStyles.sheetTitle),
        content: Text('This cannot be undone.', style: AppTextStyles.sheetDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSec)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await provider.deleteLink(linkId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LinksProvider>(
      builder: (ctx, provider, _) {
        final link = provider.linkById(linkId) ?? fallback;
        final collection = provider.collectionById(link.collectionId);

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
                      SizedBox(
                        width: double.infinity,
                        height: 160,
                        child: LinkThumbnail(link: link, size: 160),
                      ),
                      const SizedBox(height: 16),
                      Text(link.title, style: AppTextStyles.sheetTitle),
                      const SizedBox(height: 8),
                      Wrap(
                        children: [
                          Text(link.domain, style: _domainStyle),
                          if (collection != null)
                            Text(
                              ' · ${collection.emoji} ${collection.name}',
                              style: AppTextStyles.cardMeta,
                            ),
                          Text(' · ${link.date}', style: AppTextStyles.cardDate),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        link.url,
                        style: AppTextStyles.cardDate,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (link.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(link.description, style: AppTextStyles.sheetDesc),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _Badge(
                            label: link.read ? 'Read' : 'Unread',
                            bg: AppColors.accentDim,
                            fg: AppColors.accent,
                          ),
                          if (link.favorite) ...[
                            const SizedBox(width: 8),
                            _Badge(
                              label: '♥ Saved',
                              bg: AppColors.heart.withValues(alpha: 0.15),
                              fg: AppColors.heart,
                            ),
                          ],
                        ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionBtn(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      color: AppColors.textSec,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(text: link.url, subject: link.title),
                      ),
                    ),
                    _ActionBtn(
                      icon: link.favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: 'Favorite',
                      color: link.favorite ? AppColors.heart : AppColors.textSec,
                      onTap: () => provider.toggleFavorite(linkId),
                    ),
                    _ActionBtn(
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      color: AppColors.accent,
                      onTap: () => showEditLinkSheet(context, link),
                    ),
                    _ActionBtn(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: AppColors.danger,
                      onTap: () => _confirmDelete(context, provider),
                    ),
                    _ActionBtn(
                      icon: Icons.open_in_new_rounded,
                      label: 'Open',
                      color: AppColors.text,
                      onTap: () => _open(context, provider, link),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static TextStyle get _domainStyle => const TextStyle(
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
