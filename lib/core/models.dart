enum LinkFilter { all, unread, read, favorites }

const List<String> _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime d) => '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';

/// Returns a normalized https URI, or null if the input is not a valid
/// web URL. Only http/https schemes are accepted — this is the single
/// gate for everything that later reaches launchUrl or the network.
Uri? parseWebUrl(String input) {
  var raw = input.trim();
  if (raw.isEmpty) return null;
  if (!raw.contains('://')) raw = 'https://$raw';
  final uri = Uri.tryParse(raw);
  if (uri == null) return null;
  if (uri.scheme != 'http' && uri.scheme != 'https') return null;
  if (uri.host.isEmpty || !uri.host.contains('.')) return null;
  return uri;
}

class LinkItem {
  final int? id;
  final String url;
  final String title;
  final String description;
  final String? imageUrl;
  final String? collectionId;
  final DateTime createdAt;
  final bool read;
  final bool favorite;

  const LinkItem({
    this.id,
    required this.url,
    required this.title,
    this.description = '',
    this.imageUrl,
    this.collectionId,
    required this.createdAt,
    this.read = false,
    this.favorite = false,
  });

  String get domain {
    final host = Uri.tryParse(url)?.host ?? '';
    return host.startsWith('www.') ? host.substring(4) : host;
  }

  String get date => formatDate(createdAt);

  LinkItem copyWith({
    int? id,
    String? url,
    String? title,
    String? description,
    String? imageUrl,
    String? collectionId,
    bool clearCollection = false,
    DateTime? createdAt,
    bool? read,
    bool? favorite,
  }) {
    return LinkItem(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      collectionId: clearCollection ? null : (collectionId ?? this.collectionId),
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'url': url,
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'collection_id': collectionId,
        'created_at': createdAt.millisecondsSinceEpoch,
        'read': read ? 1 : 0,
        'favorite': favorite ? 1 : 0,
      };

  factory LinkItem.fromMap(Map<String, Object?> map) => LinkItem(
        id: map['id'] as int?,
        url: map['url'] as String,
        title: map['title'] as String,
        description: (map['description'] as String?) ?? '',
        imageUrl: map['image_url'] as String?,
        collectionId: map['collection_id'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
        read: map['read'] == 1,
        favorite: map['favorite'] == 1,
      );
}

class Collection {
  final String id;
  final String name;
  final String emoji;
  final DateTime createdAt;

  const Collection({
    required this.id,
    required this.name,
    required this.emoji,
    required this.createdAt,
  });

  Collection copyWith({String? name, String? emoji}) => Collection(
        id: id,
        name: name ?? this.name,
        emoji: emoji ?? this.emoji,
        createdAt: createdAt,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Collection.fromMap(Map<String, Object?> map) => Collection(
        id: map['id'] as String,
        name: map['name'] as String,
        emoji: map['emoji'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );
}
