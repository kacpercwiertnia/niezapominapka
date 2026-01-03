import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/groups/model/group_member_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part "group_bills_repository.g.dart";

class GroupBillsRepository {
  final AppDatabase _appDb;

  Future<Database> _getDb() async {
    return await _appDb.database;
  }

  final String groupMembersTable = "group_members";

  GroupBillsRepository(this._appDb);

  Future<List<GroupMember>> getGroupMembersForGroup(int groupId) async {
    final db = await _getDb();

    var groupMembers = await db.query(
        groupMembersTable,
        where: 'group_id = ?',
        whereArgs: [groupId]
    );

    return groupMembers.map((gm) => GroupMember.fromMap(gm)).toList();
  }
}

@riverpod
GroupBillsRepository groupBillsRepository(ref){
  final db = AppDatabase.instance;

  return GroupBillsRepository(db);
}