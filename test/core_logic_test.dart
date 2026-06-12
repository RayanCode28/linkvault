import 'package:flutter_test/flutter_test.dart';
import 'package:linkvault/core/metadata_service.dart';
import 'package:linkvault/core/models.dart';
import 'package:linkvault/core/share_intent_service.dart';

void main() {
  group('parseWebUrl', () {
    test('accepts plain domains and adds https', () {
      expect(parseWebUrl('example.com').toString(), 'https://example.com');
      expect(parseWebUrl('  www.example.com/path?q=1  ').toString(),
          'https://www.example.com/path?q=1');
    });

    test('accepts http and https URLs', () {
      expect(parseWebUrl('http://example.com')!.scheme, 'http');
      expect(parseWebUrl('https://example.com')!.scheme, 'https');
    });

    test('rejects dangerous or malformed input', () {
      expect(parseWebUrl('javascript:alert(1)'), isNull);
      expect(parseWebUrl('intent://scan/#Intent;end'), isNull);
      expect(parseWebUrl('file:///etc/passwd'), isNull);
      expect(parseWebUrl('data:text/html,<b>x</b>'), isNull);
      expect(parseWebUrl(''), isNull);
      expect(parseWebUrl('not a url'), isNull);
      expect(parseWebUrl('localhost'), isNull);
    });
  });

  group('ShareIntentService.extractUrl', () {
    test('pulls the first URL out of shared text', () {
      final uri = ShareIntentService.extractUrl(
          'Check this out! https://youtu.be/abc123 so good');
      expect(uri.toString(), 'https://youtu.be/abc123');
    });

    test('falls back to treating the whole text as a URL', () {
      expect(ShareIntentService.extractUrl('example.com').toString(),
          'https://example.com');
    });

    test('returns null for plain text', () {
      expect(ShareIntentService.extractUrl('just some words'), isNull);
    });
  });

  group('MetadataService.parse', () {
    final pageUrl = Uri.parse('https://example.com/article');

    test('reads Open Graph tags and unescapes entities', () {
      const html = '''
        <html><head>
          <meta property="og:title" content="Hello &amp; welcome"/>
          <meta property="og:description" content="A   description"/>
          <meta property="og:image" content="/img/cover.jpg"/>
          <title>Fallback title</title>
        </head></html>
      ''';
      final meta = MetadataService.parse(html, pageUrl);
      expect(meta.title, 'Hello & welcome');
      expect(meta.description, 'A description');
      expect(meta.imageUrl, 'https://example.com/img/cover.jpg');
    });

    test('falls back to <title> when no og:title exists', () {
      const html = '<html><head><title>Page title</title></head></html>';
      expect(MetadataService.parse(html, pageUrl).title, 'Page title');
    });

    test('rejects non-http image URLs', () {
      const html =
          '<meta property="og:image" content="javascript:alert(1)"/>';
      expect(MetadataService.parse(html, pageUrl).imageUrl, isNull);
    });
  });

  group('MetadataService.thumbnailForKnownPlatform', () {
    String? thumb(String url) =>
        MetadataService.thumbnailForKnownPlatform(Uri.parse(url));

    test('derives the content thumbnail from YouTube URLs', () {
      const expected = 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg';
      expect(thumb('https://www.youtube.com/watch?v=dQw4w9WgXcQ'), expected);
      expect(thumb('https://youtu.be/dQw4w9WgXcQ'), expected);
      expect(thumb('https://m.youtube.com/watch?v=dQw4w9WgXcQ&t=10s'), expected);
      expect(thumb('https://www.youtube.com/shorts/dQw4w9WgXcQ'), expected);
      expect(thumb('https://www.youtube.com/embed/dQw4w9WgXcQ'), expected);
    });

    test('returns null for non-video or malformed YouTube URLs', () {
      expect(thumb('https://www.youtube.com/'), isNull);
      expect(thumb('https://www.youtube.com/watch?v=short'), isNull);
      expect(thumb('https://example.com/watch?v=dQw4w9WgXcQ'), isNull);
    });
  });

  group('LinkItem', () {
    test('domain strips www and date formats correctly', () {
      final link = LinkItem(
        url: 'https://www.example.com/post',
        title: 'Post',
        createdAt: DateTime(2026, 4, 11),
      );
      expect(link.domain, 'example.com');
      expect(link.date, 'Apr 11, 2026');
    });

    test('round-trips through map', () {
      final link = LinkItem(
        id: 7,
        url: 'https://example.com',
        title: 'Title',
        description: 'Desc',
        imageUrl: 'https://example.com/i.png',
        collectionId: 'watch-later',
        createdAt: DateTime(2026, 1, 2, 3, 4),
        read: true,
        favorite: true,
      );
      final restored = LinkItem.fromMap(link.toMap());
      expect(restored.id, link.id);
      expect(restored.url, link.url);
      expect(restored.title, link.title);
      expect(restored.description, link.description);
      expect(restored.imageUrl, link.imageUrl);
      expect(restored.collectionId, link.collectionId);
      expect(restored.createdAt, link.createdAt);
      expect(restored.read, isTrue);
      expect(restored.favorite, isTrue);
    });
  });
}
