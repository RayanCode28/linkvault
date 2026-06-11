import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../core/links_provider.dart';
import '../../shared/widgets/link_thumbnail.dart';
import '../link_detail/link_detail_sheet.dart';

class LinkCard extends StatelessWidget {
  final LinkItem link;

  const LinkCard({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    final collection =
        context.watch<LinksProvider>().collectionById(link.collectionId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showLinkDetailSheet(context, link),
          borderRadius: AppRadius.card,
          splashColor: Colors.transparent,
          highlightColor: AppColors.surfaceHover.withValues(alpha: 0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinkThumbnail(link: link),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link.title,
                        style: AppTextStyles.cardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        collection == null
                            ? link.domain
                            : '${link.domain} · ${collection.emoji} ${collection.name}',
                        style: AppTextStyles.cardMeta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.yMMMd(Localizations.localeOf(context).toString())
                            .format(link.createdAt),
                        style: AppTextStyles.cardDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusIndicator(link: link),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final LinkItem link;

  const _StatusIndicator({required this.link});

  @override
  Widget build(BuildContext context) {
    if (!link.read) {
      return Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
          boxShadow: AppShadows.dotPulse,
        ),
      );
    }
    if (link.favorite) {
      return const Text(
        '♥',
        style: TextStyle(color: AppColors.heart, fontSize: 12),
      );
    }
    return const SizedBox(width: 8);
  }
}
