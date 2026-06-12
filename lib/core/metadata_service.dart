import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'models.dart';

class LinkMetadata {
  final String? title;
  final String? description;
  final String? imageUrl;

  const LinkMetadata({this.title, this.description, this.imageUrl});
}

/// Fetches Open Graph metadata (title, description, image) for a web page.
/// Hardened against hostile pages: only http/https URLs are fetched, the
/// response is read as a stream and capped at [_maxBytes], non-HTML
/// content is ignored, and the whole operation has a hard timeout.
class MetadataService {
  static const _maxBytes = 512 * 1024;
  static const _timeout = Duration(seconds: 8);
  static const _maxFieldLength = 500;

  // Browser-like UA: many sites (Instagram, X, Amazon, news sites) refuse or
  // strip Open Graph tags for unknown clients.
  static const _browserUa =
      'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36';

  static final _unescape = HtmlUnescape();

  static final _metaTagRe = RegExp(r'<meta\s[^>]*>', caseSensitive: false);
  static final _titleRe = RegExp(r'<title[^>]*>([\s\S]*?)</title>', caseSensitive: false);
  static final _attrRe = RegExp(
      '(property|name|content)\\s*=\\s*("([^"]*)"|\'([^\']*)\')',
      caseSensitive: false);

  static Future<LinkMetadata> fetch(Uri url) async {
    if (url.scheme != 'http' && url.scheme != 'https') {
      return const LinkMetadata();
    }
    // Content thumbnail derived from the URL itself (e.g. the YouTube video
    // frame). It is far more reliable than scraping og:image — those sites
    // block bots or paint the preview with JS — and gives us the *content*
    // image instead of the platform logo. Used as a fallback so a real
    // og:image still wins when present.
    final platformImage = thumbnailForKnownPlatform(url);

    // Video platforms (YouTube, TikTok, Vimeo) serve a JS/consent wall to
    // bots, so og scraping returns no title. Their public oEmbed endpoints
    // return the real content title + thumbnail as JSON without any auth.
    final oEmbed = _oEmbedEndpoint(url);
    if (oEmbed != null) {
      final meta = await _fetchOEmbed(oEmbed, url, platformImage);
      if (meta != null) return meta;
    }

    final client = http.Client();
    try {
      final request = http.Request('GET', url)
        ..followRedirects = true
        ..maxRedirects = 4
        ..headers['User-Agent'] = _browserUa
        ..headers['Accept'] =
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        ..headers['Accept-Language'] = 'en-US,en;q=0.9';
      final response = await client.send(request).timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return LinkMetadata(imageUrl: platformImage);
      }

      final contentType = response.headers['content-type'] ?? '';
      if (contentType.isNotEmpty &&
          !contentType.contains('text/html') &&
          !contentType.contains('application/xhtml')) {
        return LinkMetadata(imageUrl: platformImage);
      }

      final bytes = <int>[];
      await for (final chunk in response.stream.timeout(_timeout)) {
        bytes.addAll(chunk);
        if (bytes.length >= _maxBytes) break;
      }
      final html = utf8.decode(bytes, allowMalformed: true);
      final meta = parse(html, url);
      return meta.imageUrl == null
          ? LinkMetadata(
              title: meta.title,
              description: meta.description,
              imageUrl: platformImage,
            )
          : meta;
    } on Exception {
      // Network errors, timeouts and malformed responses are not fatal:
      // the link is simply saved with whatever thumbnail we can derive.
      return LinkMetadata(imageUrl: platformImage);
    } finally {
      client.close();
    }
  }

  /// Returns the oEmbed JSON endpoint for platforms that expose one, or null.
  /// oEmbed gives the real content title + thumbnail without auth, which is
  /// what these sites hide from a plain page scrape.
  static String? _oEmbedEndpoint(Uri url) {
    var host = url.host.toLowerCase();
    if (host.startsWith('www.')) host = host.substring(4);
    if (host.startsWith('m.')) host = host.substring(2);
    final target = Uri.encodeComponent(url.toString());
    if (host == 'youtube.com' ||
        host == 'youtu.be' ||
        host == 'music.youtube.com' ||
        host == 'gaming.youtube.com') {
      return 'https://www.youtube.com/oembed?url=$target&format=json';
    }
    if (host == 'tiktok.com') {
      return 'https://www.tiktok.com/oembed?url=$target';
    }
    if (host == 'vimeo.com') {
      return 'https://vimeo.com/api/oembed.json?url=$target';
    }
    return null;
  }

  /// Fetches and parses an oEmbed document. Returns null on any failure so
  /// the caller can fall back to plain HTML scraping.
  static Future<LinkMetadata?> _fetchOEmbed(
      String endpoint, Uri pageUrl, String? fallbackImage) async {
    final client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(endpoint),
        headers: const {'User-Agent': _browserUa, 'Accept': 'application/json'},
      ).timeout(_timeout);
      if (response.statusCode != 200) return null;
      if (response.bodyBytes.length > _maxBytes) return null;
      final dynamic data =
          json.decode(utf8.decode(response.bodyBytes, allowMalformed: true));
      if (data is! Map) return null;

      final title = _clean(data['title'] as String?);
      final author = data['author_name'];
      final thumb = data['thumbnail_url'];
      final image =
          (thumb is String ? _resolveImage(thumb, pageUrl) : null) ??
              fallbackImage;
      if (title == null && image == null) return null;
      return LinkMetadata(
        title: title,
        description: author is String ? _clean(author) : null,
        imageUrl: image,
      );
    } on Exception {
      return null;
    } finally {
      client.close();
    }
  }

  /// Returns a content thumbnail derived purely from [url] for platforms
  /// that expose a deterministic preview image, or null otherwise.
  ///
  /// YouTube: `https://img.youtube.com/vi/<id>/hqdefault.jpg` always exists
  /// for a valid video id (unlike maxresdefault), so it is the safe choice.
  static String? thumbnailForKnownPlatform(Uri url) {
    final id = _youTubeId(url);
    if (id != null) return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    return null;
  }

  static final _ytIdRe = RegExp(r'^[A-Za-z0-9_-]{11}$');

  /// Extracts the 11-char video id from the common YouTube URL shapes:
  /// `youtu.be/<id>`, `youtube.com/watch?v=<id>`, `/shorts/<id>`,
  /// `/embed/<id>`, `/live/<id>`. Returns null when not a YouTube video.
  static String? _youTubeId(Uri url) {
    var host = url.host.toLowerCase();
    if (host.startsWith('www.')) host = host.substring(4);
    if (host.startsWith('m.')) host = host.substring(2);

    String? candidate;
    if (host == 'youtu.be') {
      candidate = url.pathSegments.isNotEmpty ? url.pathSegments.first : null;
    } else if (host == 'youtube.com' ||
        host == 'music.youtube.com' ||
        host == 'gaming.youtube.com') {
      final seg = url.pathSegments;
      if (seg.isNotEmpty &&
          (seg.first == 'shorts' || seg.first == 'embed' || seg.first == 'live')) {
        candidate = seg.length > 1 ? seg[1] : null;
      } else {
        candidate = url.queryParameters['v'];
      }
    }
    return candidate != null && _ytIdRe.hasMatch(candidate) ? candidate : null;
  }

  @visibleForTesting
  static LinkMetadata parse(String html, Uri pageUrl) {
    final og = <String, String>{};
    for (final match in _metaTagRe.allMatches(html)) {
      final tag = match.group(0)!;
      String? key;
      String? content;
      for (final attr in _attrRe.allMatches(tag)) {
        final name = attr.group(1)!.toLowerCase();
        final value = attr.group(3) ?? attr.group(4) ?? '';
        if (name == 'content') {
          content = value;
        } else {
          key = value.toLowerCase();
        }
      }
      if (key != null && content != null && !og.containsKey(key)) {
        og[key] = content;
      }
    }

    final rawTitle = og['og:title'] ??
        og['twitter:title'] ??
        _titleRe.firstMatch(html)?.group(1);
    final rawDescription =
        og['og:description'] ?? og['twitter:description'] ?? og['description'];

    return LinkMetadata(
      title: _clean(rawTitle),
      description: _clean(rawDescription),
      imageUrl: _resolveImage(og['og:image'] ?? og['twitter:image'], pageUrl),
    );
  }

  static String? _clean(String? value) {
    if (value == null) return null;
    final text =
        _unescape.convert(value).replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) return null;
    return text.length > _maxFieldLength
        ? text.substring(0, _maxFieldLength)
        : text;
  }

  /// Resolves a possibly-relative image URL against the page URL and
  /// only accepts http/https results.
  static String? _resolveImage(String? value, Uri pageUrl) {
    if (value == null || value.trim().isEmpty) return null;
    final resolved = Uri.tryParse(pageUrl.resolve(value.trim()).toString());
    if (resolved == null) return null;
    return parseWebUrl(resolved.toString())?.toString();
  }
}
