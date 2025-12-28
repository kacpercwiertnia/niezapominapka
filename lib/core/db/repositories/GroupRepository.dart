import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part "GroupRepository.g.dart";

class GroupRepository {
  final AppDatabase _appDatabase;

  Future<Database> _getDb() async {
    return await _appDatabase.database;
  }
  GroupRepository(this._appDatabase);

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
      return result.map((group) => Group.fromMap(group)).toList();
    }

    return [];
  }
}

@riverpod
GroupRepository groupRepository(GroupRepositoryRef ref){
  final db = AppDatabase.instance;

  return GroupRepository(db);
}