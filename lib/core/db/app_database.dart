import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/auth/app_user.dart';
import '../../features/groups/model/group_model.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'niezapominapka.db');

    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE
      );
    ''');

    await db.execute('''
      CREATE TABLE groups (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE group_members (
        user_id INTEGER NOT NULL,
        group_id INTEGER NOT NULL,
        amount_spent REAL NOT NULL,
        PRIMARY KEY (user_id, group_id),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
      );
    ''');

    // Tabela nagłówkowa dla listy zakupów / wydatku
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE payors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        expense_id INTEGER NOT NULL,
        username TEXT NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE
      );
    ''');
  }

  // --- UŻYTKOWNICY ---

  /// Zwraca istniejącego użytkownika albo tworzy nowego.
  Future<AppUser> upsertUser(String username) async {
    final db = await database;

    final existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return AppUser.fromMap(existing.first);
    }

    final id = await db.insert('users', {
      'username': username,
    });

    return AppUser(id: id, username: username);
  }

  // --- GRUPY ---

  Future<List<Group>> getGroupsForUser(int userId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT g.id, g.name
      FROM groups g
      INNER JOIN group_members gm ON gm.group_id = g.id
      WHERE gm.user_id = ?
      ORDER BY g.name;
    ''', [userId]);

    return result.map((row) => Group.fromMap(row)).toList();
  }

  Future<Group> createGroupForUser({
    required int userId,
    required String name,
  }) async {
    final db = await database;

    final groupId = await db.insert('groups', {
      'name': name,
    });

    await db.insert('group_members', {
      'user_id': userId,
      'group_id': groupId,
    });

    return Group(id: groupId, name: name);
  }
}
