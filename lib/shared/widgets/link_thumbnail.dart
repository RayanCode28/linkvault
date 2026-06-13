import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class LinkThumbnail extends StatelessWidget {
  final LinkItem link;
  final double size;

  /// Explicit box dimensions. When null they fall back to [size] (square),
  /// which is what the cards use. The detail header passes a full-bleed width.
  final double? width;
  final double? height;

  /// Corner rounding of the image box. Defaults to the card thumb radius;
  /// the detail header overrides it to round only the top corners.
  final BorderRadius borderRadius;

  const LinkThumbnail({
    super.key,
    required this.link,
    this.size = 60,
    this.width,
    this.height,
    this.borderRadius = AppRadius.thumb,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = link.imageUrl;
    return Container(
      width: width ?? size,
      height: height ?? size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.surfaceHover,
        borderRadius: borderRadius,
      ),
      child: imageUrl == null
          ? _favicon()
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 150),
              placeholder: (_, __) => _favicon(),
              errorWidget: (_, __, ___) => _favicon(),
            ),
    );
  }

  /// When the page has no og:image, show the site favicon instead of
  /// a bare emoji so the card still hints at what the link is about.
  Widget _favicon() {
    final domain = link.domain;
    if (domain.isEmpty) return _fallback();
    return Center(
      child: SizedBox(
        width: size * 0.5,
        height: size * 0.5,
        child: CachedNetworkImage(
          imageUrl: 'https://www.google.com/s2/favicons?domain=$domain&sz=128',
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 150),
          placeholder: (_, __) => _fallback(),
          errorWidget: (_, __, ___) => _fallback(),
        ),
      ),
    );
  }

  Widget _fallback() => Center(
        child: Text('🔗', style: TextStyle(fontSize: size * 0.38)),
      );
}
