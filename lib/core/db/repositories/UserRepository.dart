import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mysql1/mysql1.dart' as mysql;

part "UserRepository.g.dart";

class UserRepository {
  final AppDatabase _appDatabase;

  Future<mysql.MySqlConnection> _getConn() async {
    return await _appDatabase.connection;
  }

  UserRepository(this._appDatabase);

  Future<AppUser?> getUser(String username) async {
    final conn = await _getConn();

    final result = await conn.query(
      'SELECT id, username FROM users WHERE username = ? LIMIT 1',
      [username],
    );

    if (result.isNotEmpty) {
      return AppUser.fromMap(result.first.fields);
    }

    return null;
  }

  Future<List<AppUser>> getUsersByIds(List<int> usersIds) async {
    if (usersIds.isEmpty) return [];

    final conn = await _getConn();

    final placeholders = List.filled(usersIds.length, '?').join(',');

    final result = await conn.query(
      'SELECT id, username FROM users WHERE id IN ($placeholders)',
      usersIds,
    );

    return result.map((row) => AppUser.fromMap(row.fields)).toList();
  }

  Future<int> addUser(String username) async {
    final conn = await _getConn();

    final result = await conn.query(
      'INSERT INTO users (username) VALUES (?)',
      [username],
    );

    return result.insertId!;
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final db = AppDatabase.instance;
  return UserRepository(db);
}
