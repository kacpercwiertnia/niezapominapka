import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part "UserRepository.g.dart";


class UserRepository {
  final AppDatabase _appDatabase;

  Future<Database> _getDb() async {
    return await _appDatabase.database;
  }
  UserRepository(this._appDatabase);

  Future<AppUser?> getUser(String username) async {
    var db = await _getDb();
    
    var result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username]
    );

    if (result.isNotEmpty){
      return AppUser.fromMap(result.first);
    }

    return null;
  }

  Future<List<AppUser>> getUsersByIds(List<int> users_ids) async{
    final db = await _getDb();

    var placeholders = List.filled(users_ids.length, '?').join(',');

    var results = await db.query('users',
        where: 'id IN ($placeholders)',
        whereArgs: users_ids);

    return results.map((user) => AppUser.fromMap(user)).toList();
  }

  Future<int> addUser(String username) async {
    var user = AppUser(username: username);

    var db = await _getDb();

    var id = db.insert("users", user.toMap());

    return id;
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref){
  final db = AppDatabase.instance;

  return UserRepository(db);
}