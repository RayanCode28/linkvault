import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../core/models.dart';

/// Single access point to the local SQLite database.
/// All queries use parameterized arguments (whereArgs / conflict-safe
/// inserts) — never string interpolation — to prevent SQL injection.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'linkvault.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE collections(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE links(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        image_url TEXT,
        collection_id TEXT,
        created_at INTEGER NOT NULL,
        read INTEGER NOT NULL DEFAULT 0,
        favorite INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(collection_id) REFERENCES collections(id) ON DELETE SET NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_links_collection ON links(collection_id)');

    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('collections',
        {'id': 'watch-later', 'name': 'Watch later', 'emoji': '🎬', 'created_at': now});
    await db.insert('collections',
        {'id': 'read-later', 'name': 'Read later', 'emoji': '📚', 'created_at': now});
  }

  // ---- Links ----

  Future<List<LinkItem>> getLinks() async {
    final db = await database;
    final rows = await db.query('links', orderBy: 'created_at DESC, id DESC');
    return rows.map(LinkItem.fromMap).toList();
  }

  Future<LinkItem> insertLink(LinkItem link) async {
    final db = await database;
    final map = link.toMap()..remove('id');
    final id = await db.insert('links', map);
    return link.copyWith(id: id);
  }

  Future<void> updateLink(LinkItem link) async {
    final db = await database;
    await db.update('links', link.toMap()..remove('id'),
        where: 'id = ?', whereArgs: [link.id]);
  }

  Future<void> deleteLink(int id) async {
    final db = await database;
    await db.delete('links', where: 'id = ?', whereArgs: [id]);
  }

  // ---- Collections ----

  Future<List<Collection>> getCollections() async {
    final db = await database;
    final rows = await db.query('collections', orderBy: 'created_at ASC');
    return rows.map(Collection.fromMap).toList();
  }

  Future<void> insertCollection(Collection collection) async {
    final db = await database;
    await db.insert('collections', collection.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> updateCollection(Collection collection) async {
    final db = await database;
    await db.update('collections', collection.toMap()..remove('id'),
        where: 'id = ?', whereArgs: [collection.id]);
  }

  /// Deletes a collection; its links are kept and unfiled via the
  /// ON DELETE SET NULL foreign key.
  Future<void> deleteCollection(String id) async {
    final db = await database;
    await db.delete('collections', where: 'id = ?', whereArgs: [id]);
  }
}
