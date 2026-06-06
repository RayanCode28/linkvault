import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class LinkThumbnail extends StatelessWidget {
  final LinkItem link;
  final double size;

  const LinkThumbnail({super.key, required this.link, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: link.thumbBg,
        borderRadius: AppRadius.thumb,
      ),
      child: Center(
        child: Text(link.thumbEmoji, style: TextStyle(fontSize: size * 0.38)),
      ),
    );
  }
}
