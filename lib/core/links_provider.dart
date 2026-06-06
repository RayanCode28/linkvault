import 'package:flutter/material.dart';
import 'models.dart';
import 'mock_data.dart';

class LinksProvider extends ChangeNotifier {
  List<LinkItem> _links = List.from(mockLinks);
  List<LinkItem> get links => _links;

  void toggleFavorite(int id) {
    final idx = _links.indexWhere((l) => l.id == id);
    if (idx != -1) {
      _links[idx].favorite = !_links[idx].favorite;
      notifyListeners();
    }
  }

  void markRead(int id) {
    final idx = _links.indexWhere((l) => l.id == id);
    if (idx != -1) {
      _links[idx].read = true;
      notifyListeners();
    }
  }

  void deleteLink(int id) {
    _links.removeWhere((l) => l.id == id);
    notifyListeners();
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

  List<LinkItem> search(String q) => q.isEmpty
      ? []
      : _links.where((l) =>
          l.title.toLowerCase().contains(q.toLowerCase()) ||
          l.domain.toLowerCase().contains(q.toLowerCase())).toList();

  List<LinkItem> byCollection(String colId) =>
      _links.where((l) => l.collectionId == colId).toList();
}
