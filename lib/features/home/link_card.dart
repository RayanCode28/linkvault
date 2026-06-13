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
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: AppShadows.card,
            ),
            // Altura fija: todos los cards miden igual, sin importar si el
            // enlace capturó título/descripción o solo muestra el favicon.
            child: Stack(
              children: [
                SizedBox(
                  height: 88,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Miniatura pegada al borde izquierdo, cubriendo la altura
                      // completa del card; el recorte de las esquinas lo aplica
                      // el Container (clipBehavior).
                      LinkThumbnail(
                        link: link,
                        size: 88,
                        width: 88,
                        height: double.infinity,
                        borderRadius: BorderRadius.zero,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flexible: si no cabe en 2 líneas, el título cede
                              // espacio y se recorta con "…" en vez de desbordar.
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        link.title,
                                        style: AppTextStyles.cardTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _StatusIndicator(link: link),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      link.domain,
                                      style: AppTextStyles.cardMeta,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (collection != null) ...[
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        '${collection.emoji} ${collection.name}',
                                        style: AppTextStyles.cardMeta,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 1),
                              Text(
                                DateFormat.yMMMd(Localizations.localeOf(context)
                                        .toString())
                                    .format(link.createdAt),
                                style: AppTextStyles.cardDate,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Corazón superpuesto en la esquina superior izquierda,
                // simétrico al punto verde de la derecha; queda sobre la
                // miniatura. La sombra lo hace legible en imágenes claras.
                if (link.favorite)
                  const Positioned(
                    top: 10,
                    left: 11,
                    child: Text(
                      '♥',
                      style: TextStyle(
                        color: AppColors.heart,
                        fontSize: 10,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
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
    // Punto verde en los no leídos (arriba a la derecha). El corazón de
    // favorito se dibuja aparte, superpuesto a la izquierda del card.
    if (!link.read) {
      return Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
          boxShadow: AppShadows.dotPulse,
        ),
      );
    }
    return const SizedBox(width: 8);
  }
}
