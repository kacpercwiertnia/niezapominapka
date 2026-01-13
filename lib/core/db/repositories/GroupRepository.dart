import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/features/groups/model/group_member_model.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mysql1/mysql1.dart' as mysql;

part "GroupRepository.g.dart";

class GroupRepository {
  final AppDatabase _appDatabase;

  final String tableName = "groups";
  final String relationTableName = "group_members";

  Future<mysql.MySqlConnection> _getConn() async {
    return await _appDatabase.connection;
  }

  GroupRepository(this._appDatabase);

  Future<List<AppUser>> getUsersForGroup(int groupId) async {
    final conn = await _getConn();

    final result = await conn.query('''
      SELECT u.id, u.username
      FROM users u
      INNER JOIN group_members gm ON gm.user_id = u.id
      WHERE gm.group_id = ?
    ''', [groupId]);

    return result.map((row) => AppUser.fromMap(row.fields)).toList();
  }

  Future<Group?> getGroupByName(String name) async {
    final conn = await _getConn();

    final result = await conn.query(
      'SELECT id, name FROM $tableName WHERE name = ? LIMIT 1',
      [name.trim()],
    );

    return result.isNotEmpty ? Group.fromMap(result.first.fields) : null;
  }

  Future<List<Group>> getGroupsForUserId(int userId) async {
    final conn = await _getConn();

    final result = await conn.query('''
      SELECT g.id, g.name
      FROM groups g
      INNER JOIN group_members gm ON gm.group_id = g.id
      WHERE gm.user_id = ?
      ORDER BY g.name;
    ''', [userId]);

    return result.map((row) => Group.fromMap(row.fields)).toList();
  }

  Future<int> addGroup(String name, int userId) async {
    final conn = await _getConn();

    final groupId = await conn.transaction<int>((tx) async {
      final groupInsert = await tx.query(
        'INSERT INTO $tableName (name) VALUES (?)',
        [name.trim()],
      );
      final groupId = groupInsert.insertId!;

      await tx.query(
        'INSERT INTO $relationTableName (user_id, group_id, bilans) VALUES (?, ?, 0)',
        [userId, groupId],
      );

      return groupId;
    });

    if (groupId == null) {
      throw StateError('addGroup: transaction returned null');
    }
    return groupId;
  }

  Future<int?> addUserToGroup(int userId, int groupId) async {
    final conn = await _getConn();

    try {
      final res = await conn.query(
        'INSERT INTO $relationTableName (user_id, group_id, bilans) VALUES (?, ?, 0)',
        [userId, groupId],
      );
      // UWAGA: dla tabeli z PK złożonym MySQL może zwrócić insertId = 0.
      // Zwracamy 1 jako "ok" jeśli affectedRows == 1.
      if ((res.affectedRows ?? 0) == 1) return 1;
      return null;
    } catch (_) {
      return null;
    }
  }
}

@riverpod
GroupRepository groupRepository(GroupRepositoryRef ref) {
  final db = AppDatabase.instance;
  return GroupRepository(db);
}
