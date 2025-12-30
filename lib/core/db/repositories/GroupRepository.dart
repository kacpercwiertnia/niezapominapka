import 'package:flutter/cupertino.dart';
import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/groups/model/group_member_model.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part "GroupRepository.g.dart";

class GroupRepository {
  final AppDatabase _appDatabase;

  final String tableName = "groups";
  final String relationTableName = "group_members";

  Future<Database> _getDb() async {
    return await _appDatabase.database;
  }
  GroupRepository(this._appDatabase);

  Future<Group?> getGroupByName(String name) async {
    var db = await _getDb();

    var group = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name.trim()]
    );

    return group.isNotEmpty ? Group.fromMap(group.first) : null;
  }

  Future<List<Group>> getGroupsForUserId(int userId) async {
    var db = await _getDb();

    var result = await db.rawQuery('''
      SELECT g.id, g.name
      FROM groups g
      INNER JOIN group_members gm ON gm.group_id = g.id
      WHERE gm.user_id = ?
      ORDER BY g.name;
    ''', [userId]);

    if (result.isNotEmpty){
      var groups = result.map((group) => Group.fromMap(group)).toList();
      // debugPrint("Z repozytorium przy fetchu");
      // debugPrint(groups.toString());
      return groups;
    }

    return [];
  }

  Future<int> addGroup(String name, int userId) async {
    var group = Group(name: name.trim());

    var db = await _getDb();

    var id = await db.insert(tableName, group.toMap());
    db.insert(relationTableName, GroupMember(userId: userId, groupId: id).toMap());

    return id;
  }

  Future<int?> addUserToGroup(int userId, int groupId) async {
    var db = await _getDb();

    try {
      final id = await db.insert(
        relationTableName,
        GroupMember(userId: userId, groupId: groupId).toMap(),
      );
      return id; // id wstawionego wiersza
    } catch (e) {
      return null;
    }
  }
}

@riverpod
GroupRepository groupRepository(GroupRepositoryRef ref){
  final db = AppDatabase.instance;

  return GroupRepository(db);
}