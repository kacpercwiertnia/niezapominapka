import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mysql1/mysql1.dart' as mysql;

part "shop_item_repository.g.dart";

class ShopItemRepository {
  final AppDatabase _appDatabase;

  Future<mysql.MySqlConnection> _getConn() async {
    return await _appDatabase.connection;
  }

  ShopItemRepository(this._appDatabase);

  final String shopItemTableName = "shop_items";

  Future<void> addItem(String productName, int groupId) async {
    final conn = await _getConn();

    await conn.query(
      'INSERT INTO $shopItemTableName (name, group_id) VALUES (?, ?)',
      [productName, groupId],
    );
  }

  Future<List<ShopItem>> get(int groupId) async {
    final conn = await _getConn();

    final results = await conn.query(
      'SELECT id, name, group_id FROM $shopItemTableName WHERE group_id = ?',
      [groupId],
    );

    return results.map((row) => ShopItem.fromMap(row.fields)).toList();
  }

  Future<void> removeItem(int itemId) async {
    final conn = await _getConn();

    await conn.query(
      'DELETE FROM $shopItemTableName WHERE id = ?',
      [itemId],
    );
  }
}

@riverpod
ShopItemRepository shopItemRepository(ref) {
  final db = AppDatabase.instance;
  return ShopItemRepository(db);
}
