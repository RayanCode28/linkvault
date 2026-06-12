import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import 'metadata_service.dart';
import 'models.dart';

/// Free plan: up to this many collections; beyond that the paywall shows.
const int kFreeCollectionLimit = 3;

/// Virtual collection id for links with no real collection. It is not stored
/// in the database — it surfaces the links whose collectionId is null.
const String kUncategorizedId = '__uncategorized__';

/// Ids of the collections seeded on first run. They count as "default", not
/// user-created, so the empty-state shows until the user makes their own.
const Set<String> kDefaultCollectionIds = {'watch-later', 'read-later'};

class ImportResult {
  final int links;
  final int collections;
  const ImportResult({required this.links, required this.collections});
}

class LinksProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<LinkItem> _links = [];
  List<Collection> _collections = [];
  bool _loaded = false;

  List<LinkItem> get links => _links;
  List<Collection> get collections => _collections;
  bool get loaded => _loaded;

  // Driven by the RevenueCat entitlement via PurchaseService (see main.dart).
  bool _isPro = false;
  bool get isPro => _isPro;
  bool get canAddCollection => isPro || _collections.length < kFreeCollectionLimit;

  void setPro(bool value) {
    if (_isPro == value) return;
    _isPro = value;
    notifyListeners();
  }

  Future<void> init() async {
    _links = await _db.getLinks();
    _collections = await _db.getCollections();
    _loaded = true;
    notifyListeners();
    _backfillMetadata();
  }

  /// Links saved before metadata fetching worked (or whose fetch failed)
  /// get another chance each session, a few at a time.
  void _backfillMetadata() {
    final pending = _links.where(_needsEnrich).take(10).toList();
    for (final link in pending) {
      _enrich(link);
    }
  }

  /// A link still needs enriching if it has no thumbnail or its title is
  /// still the bare host (e.g. YouTube links that got a thumbnail but whose
  /// real title only arrives via oEmbed).
  static bool _needsEnrich(LinkItem l) {
    if (l.imageUrl == null) return true;
    final host = Uri.tryParse(l.url)?.host;
    return host != null && l.title == host;
  }

  // ---- Links ----

  LinkItem? linkById(int id) {
    for (final l in _links) {
      if (l.id == id) return l;
    }
    return null;
  }

  /// Saves a link immediately (so the UI responds at once) and enriches
  /// it with Open Graph metadata in the background.
  /// Returns null if [rawUrl] is not a valid web URL.
  Future<LinkItem?> addLink(String rawUrl, {String? collectionId}) async {
    final uri = parseWebUrl(rawUrl);
    if (uri == null) return null;

    final existing = _links.where((l) => l.url == uri.toString());
    if (existing.isNotEmpty) {
      final link = existing.first;
      // Re-adding a link whose metadata never arrived retries the fetch.
      if (link.imageUrl == null) _enrich(link);
      return link;
    }

    var link = LinkItem(
      url: uri.toString(),
      title: uri.host,
      collectionId: collectionId,
      createdAt: DateTime.now(),
    );
    link = await _db.insertLink(link);
    _links.insert(0, link);
    notifyListeners();

    _enrich(link);
    return link;
  }

  Future<void> _enrich(LinkItem link) async {
    final meta = await MetadataService.fetch(Uri.parse(link.url));
    if (meta.title == null && meta.description == null && meta.imageUrl == null) {
      return;
    }
    final current = linkById(link.id!);
    if (current == null) return; // deleted while fetching
    final updated = current.copyWith(
      title: meta.title ?? current.title,
      description: meta.description ?? current.description,
      imageUrl: meta.imageUrl ?? current.imageUrl,
    );
    await _db.updateLink(updated);
    _replace(updated);
  }

  Future<void> updateLink(LinkItem link) async {
    await _db.updateLink(link);
    _replace(link);
  }

  Future<void> toggleFavorite(int id) async {
    final link = linkById(id);
    if (link == null) return;
    await updateLink(link.copyWith(favorite: !link.favorite));
  }

  Future<void> markRead(int id) async {
    final link = linkById(id);
    if (link == null || link.read) return;
    await updateLink(link.copyWith(read: true));
  }

  Future<void> deleteLink(int id) async {
    await _db.deleteLink(id);
    _links.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void _replace(LinkItem link) {
    final idx = _links.indexWhere((l) => l.id == link.id);
    if (idx != -1) {
      _links[idx] = link;
      notifyListeners();
    }
  }

  List<LinkItem> filtered(LinkFilter f) {
    switch (f) {
      case LinkFilter.all:
        return _links;
      case LinkFilter.unread:
        return _links.where((l) => !l.read).toList();
      case LinkFilter.read:
        return _links.where((l) => l.read).toList();
      case LinkFilter.favorites:
        return _links.where((l) => l.favorite).toList();
    }
  }

  List<LinkItem> search(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return [];
    return _links.where((l) {
      return l.title.toLowerCase().contains(query) ||
          l.domain.toLowerCase().contains(query) ||
          l.url.toLowerCase().contains(query) ||
          l.description.toLowerCase().contains(query);
    }).toList();
  }

  List<LinkItem> byCollection(String colId) =>
      _links.where((l) => l.collectionId == colId).toList();

  /// Links that belong to no collection — shown in the virtual
  /// "Uncategorized" collection.
  List<LinkItem> get uncategorizedLinks =>
      _links.where((l) => l.collectionId == null).toList();

  /// True once the user has created at least one collection of their own
  /// (i.e. beyond the seeded defaults).
  bool get hasOwnCollections =>
      _collections.any((c) => !kDefaultCollectionIds.contains(c.id));

  // ---- Collections ----

  Collection? collectionById(String? id) {
    if (id == null) return null;
    for (final c in _collections) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Creates a collection. Returns null when the free limit is reached
  /// (caller should route to the paywall) or the name is empty.
  Future<Collection?> addCollection(String name, String emoji) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || !canAddCollection) return null;
    final collection = Collection(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      name: trimmed,
      emoji: emoji.isEmpty ? '📁' : emoji,
      createdAt: DateTime.now(),
    );
    await _db.insertCollection(collection);
    _collections.add(collection);
    notifyListeners();
    return collection;
  }

  Future<void> renameCollection(String id, String name, String emoji) async {
    final col = collectionById(id);
    final trimmed = name.trim();
    if (col == null || trimmed.isEmpty) return;
    final updated = col.copyWith(name: trimmed, emoji: emoji.isEmpty ? col.emoji : emoji);
    await _db.updateCollection(updated);
    final idx = _collections.indexWhere((c) => c.id == id);
    _collections[idx] = updated;
    notifyListeners();
  }

  Future<void> deleteCollection(String id) async {
    await _db.deleteCollection(id);
    _collections.removeWhere((c) => c.id == id);
    _links = [
      for (final l in _links)
        l.collectionId == id ? l.copyWith(clearCollection: true) : l,
    ];
    notifyListeners();
  }

  // ---- Backup ----

  String exportJson() {
    return const JsonEncoder.withIndent('  ').convert({
      'app': 'linkvault',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'collections': [
        for (final c in _collections)
          {'id': c.id, 'name': c.name, 'emoji': c.emoji},
      ],
      'links': [
        for (final l in _links)
          {
            'url': l.url,
            'title': l.title,
            'description': l.description,
            'imageUrl': l.imageUrl,
            'collectionId': l.collectionId,
            'createdAt': l.createdAt.toIso8601String(),
            'read': l.read,
            'favorite': l.favorite,
          },
      ],
    });
  }

  /// Imports a backup produced by [exportJson]. Every field is
  /// type-checked and URLs are re-validated, so a tampered file cannot
  /// inject anything beyond plain text records. Existing URLs are skipped.
  /// Throws [FormatException] when the file is not a LinkVault backup.
  Future<ImportResult> importJson(String jsonStr) async {
    final dynamic decoded = json.decode(jsonStr);
    if (decoded is! Map<String, dynamic> || decoded['app'] != 'linkvault') {
      throw const FormatException('Not a LinkVault backup file');
    }

    var importedCollections = 0;
    final idMap = <String, String>{};
    final rawCollections = decoded['collections'];
    if (rawCollections is List) {
      for (final raw in rawCollections.take(200)) {
        if (raw is! Map<String, dynamic>) continue;
        final id = raw['id'];
        final name = raw['name'];
        if (id is! String || name is! String || name.trim().isEmpty) continue;
        final existing = collectionById(id);
        if (existing != null) {
          idMap[id] = id;
          continue;
        }
        if (!canAddCollection) continue;
        final emoji = raw['emoji'];
        final collection = Collection(
          id: id,
          name: name.trim(),
          emoji: emoji is String && emoji.isNotEmpty ? emoji : '📁',
          createdAt: DateTime.now(),
        );
        await _db.insertCollection(collection);
        _collections.add(collection);
        idMap[id] = id;
        importedCollections++;
      }
    }

    var importedLinks = 0;
    final existingUrls = _links.map((l) => l.url).toSet();
    final rawLinks = decoded['links'];
    if (rawLinks is List) {
      for (final raw in rawLinks.take(5000)) {
        if (raw is! Map<String, dynamic>) continue;
        final url = raw['url'];
        if (url is! String) continue;
        final uri = parseWebUrl(url);
        if (uri == null || existingUrls.contains(uri.toString())) continue;

        final title = raw['title'];
        final description = raw['description'];
        final imageUrl = raw['imageUrl'];
        final createdAtRaw = raw['createdAt'];
        final createdAt =
            createdAtRaw is String ? DateTime.tryParse(createdAtRaw) : null;
        final collectionId = raw['collectionId'];

        var link = LinkItem(
          url: uri.toString(),
          title: title is String && title.trim().isNotEmpty ? title.trim() : uri.host,
          description: description is String ? description : '',
          imageUrl: imageUrl is String ? parseWebUrl(imageUrl)?.toString() : null,
          collectionId: collectionId is String ? idMap[collectionId] : null,
          createdAt: createdAt ?? DateTime.now(),
          read: raw['read'] == true,
          favorite: raw['favorite'] == true,
        );
        link = await _db.insertLink(link);
        _links.add(link);
        existingUrls.add(link.url);
        importedLinks++;
      }
    }

    _links.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
    return ImportResult(links: importedLinks, collections: importedCollections);
  }
}
