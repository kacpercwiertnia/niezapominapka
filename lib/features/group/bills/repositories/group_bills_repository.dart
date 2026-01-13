import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/groups/model/group_member_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mysql1/mysql1.dart' as mysql;

part "group_bills_repository.g.dart";

class GroupBillsRepository {
  final AppDatabase _appDb;

  Future<mysql.MySqlConnection> _getConn() async {
    return await _appDb.connection;
  }

  final String groupMembersTable = "group_members";

  GroupBillsRepository(this._appDb);

  Future<List<GroupMember>> getGroupMembersForGroup(int groupId) async {
    final conn = await _getConn();

    final results = await conn.query(
      'SELECT user_id, group_id, bilans FROM $groupMembersTable WHERE group_id = ?',
      [groupId],
    );

    return results.map((row) => GroupMember.fromMap(row.fields)).toList();
  }
}

@riverpod
GroupBillsRepository groupBillsRepository(ref) {
  final db = AppDatabase.instance;
  return GroupBillsRepository(db);
}
