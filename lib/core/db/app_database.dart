import 'package:mysql1/mysql1.dart' as mysql;

import '../../features/auth/app_user.dart';
import '../../features/groups/model/group_model.dart';

/// Uwaga (ważne): bezpośrednie łączenie się aplikacji mobilnej z bazą MariaDB
/// oznacza trzymanie danych logowania w aplikacji i wystawienie bazy na sieć.
/// W praktyce lepiej użyć backendu (REST/GraphQL) jako pośrednika.
///
/// Jeśli mimo wszystko chcesz iść "direct DB" – ta klasa zastępuje sqflite i
/// udostępnia połączenie mysql1 do MariaDB/MySQL.
class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  mysql.MySqlConnection? _conn;
  Future<mysql.MySqlConnection>? _opening;

  // Najprościej: wstrzyknij przez --dart-define przy build/run.
  // Przykład:
  // flutter run --dart-define=DB_HOST=... --dart-define=DB_USER=... --dart-define=DB_PASS=... --dart-define=DB_NAME=...
  static const String _host = "jchost17.pl";
  static const int _port = 3306;
  static const String _user = "kacper_niezapominapka";
  static const String _password = "h8QTF6hmstPD8gxbkCVw";
  static const String _dbName = "kacper_niezapominapka";
  static const bool _useSSL = false;

  mysql.ConnectionSettings get _settings => mysql.ConnectionSettings(
    host: _host,
    port: _port,
    user: _user,
    password: _password,
    db: _dbName,
    useSSL: _useSSL,
    // UTF8MB4 jest domyślnie w mysql1 0.20.0, ale zostawiam jawnie.
    characterSet: mysql.CharacterSet.UTF8MB4,
  );

  Future<mysql.MySqlConnection> get connection async {
    if (_conn != null) return _conn!;

    _opening ??= mysql.MySqlConnection.connect(_settings);
    _conn = await _opening!;
    _opening = null;
    return _conn!;
  }

  /// Wymusza ponowne zestawienie połączenia (np. po błędzie sieci).
  Future<mysql.MySqlConnection> reconnect() async {
    try {
      await _conn?.close();
    } catch (_) {}
    _conn = null;
    _opening = null;
    return connection;
  }

  Future<void> close() async {
    final c = _conn;
    _conn = null;
    _opening = null;
    if (c != null) {
      await c.close();
    }
  }

  // --- UŻYTKOWNICY ---

  /// Zwraca istniejącego użytkownika albo tworzy nowego.
  Future<AppUser> upsertUser(String username) async {
    final conn = await connection;

    final results = await conn.query(
      'SELECT id, username FROM users WHERE username = ? LIMIT 1',
      [username],
    );

    if (results.isNotEmpty) {
      return AppUser.fromMap(results.first.fields);
    }

    final insert = await conn.query(
      'INSERT INTO users (username) VALUES (?)',
      [username],
    );

    return AppUser(id: insert.insertId, username: username);
  }

  // --- GRUPY ---

  Future<List<Group>> getGroupsForUser(int userId) async {
    final conn = await connection;

    final results = await conn.query('''
      SELECT g.id, g.name
      FROM groups g
      INNER JOIN group_members gm ON gm.group_id = g.id
      WHERE gm.user_id = ?
      ORDER BY g.name;
    ''', [userId]);

    return results.map((row) => Group.fromMap(row.fields)).toList();
  }

  Future<Group> createGroupForUser({
    required int userId,
    required String name,
  }) async {
    final conn = await connection;

    final group = await conn.transaction<Group>((tx) async {
      final insGroup = await tx.query(
        'INSERT INTO groups (name) VALUES (?)',
        [name],
      );
      final groupId = insGroup.insertId!;

      await tx.query(
        'INSERT INTO group_members (user_id, group_id, bilans) VALUES (?, ?, 0)',
        [userId, groupId],
      );

      return Group(id: groupId, name: name);
    });

    if (group == null) {
      throw StateError('createGroupForUser: transaction returned null');
    }
    return group;
  }
}
