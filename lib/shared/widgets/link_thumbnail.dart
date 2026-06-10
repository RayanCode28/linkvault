import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class LinkThumbnail extends StatelessWidget {
  final LinkItem link;
  final double size;

  const LinkThumbnail({super.key, required this.link, this.size = 60});

  @override
  Widget build(BuildContext context) {
    final imageUrl = link.imageUrl;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: AppColors.surfaceHover,
        borderRadius: AppRadius.thumb,
      ),
      child: imageUrl == null
          ? _fallback()
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 150),
              placeholder: (_, __) => _fallback(),
              errorWidget: (_, __, ___) => _fallback(),
            ),
    );
  }

  Widget _fallback() => Center(
        child: Text('🔗', style: TextStyle(fontSize: size * 0.38)),
      );
}
