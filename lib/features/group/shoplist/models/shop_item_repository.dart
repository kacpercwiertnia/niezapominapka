import 'package:niezapominapka/core/db/app_database.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part "shop_item_repository.g.dart";

class ShopItemRepository {
  final AppDatabase _appDatabase;
  Future<Database> _getDb() async {
    return await _appDatabase.database;
  }

  ShopItemRepository(this._appDatabase);

  final String shopItemTableName = "shop_items";

  Future<List<ShopItem>> get(int groupId) async {
    final db = await _getDb();

    var shopItems = await db.query(shopItemTableName,
      where: 'group_id = ?',
      whereArgs: [groupId]
    );

    var mappedShopItems = shopItems.map((si) => ShopItem.fromMap(si)).toList();
    return mappedShopItems;
  }
}

@riverpod
ShopItemRepository shopItemRepository(ref){
  final db = AppDatabase.instance;

  return ShopItemRepository(db);
}