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
    final client = http.Client();
    try {
      final request = http.Request('GET', url)
        ..followRedirects = true
        ..maxRedirects = 4
        // Browser-like UA: many sites (Instagram, X, Amazon, news sites)
        // refuse or strip Open Graph tags for unknown clients.
        ..headers['User-Agent'] =
            'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
                '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36'
        ..headers['Accept'] =
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        ..headers['Accept-Language'] = 'en-US,en;q=0.9';
      final response = await client.send(request).timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const LinkMetadata();
      }

      final contentType = response.headers['content-type'] ?? '';
      if (contentType.isNotEmpty &&
          !contentType.contains('text/html') &&
          !contentType.contains('application/xhtml')) {
        return const LinkMetadata();
      }

      final bytes = <int>[];
      await for (final chunk in response.stream.timeout(_timeout)) {
        bytes.addAll(chunk);
        if (bytes.length >= _maxBytes) break;
      }
      final html = utf8.decode(bytes, allowMalformed: true);
      return parse(html, url);
    } on Exception {
      // Network errors, timeouts and malformed responses are not fatal:
      // the link is simply saved without enriched metadata.
      return const LinkMetadata();
    } finally {
      client.close();
    }
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
