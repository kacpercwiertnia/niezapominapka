import 'package:niezapominapka/features/group/expenses/model/shopping_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/db/app_database.dart';
import 'expense_model.dart';

part "group_expenses_repository.g.dart";

class GroupExpensesRepository {
  final AppDatabase _appDatabase;
  Future<Database> _getDb() async {
    return await _appDatabase.database;
  }

  GroupExpensesRepository(this._appDatabase);

  final String tableName = "expenses";
  final String shoppingItemsTableName = "shopping_items";

  Future<List<Expense>> getExpensesByGroupId(int groupId) async {
    final db = await _getDb();

    // 1. Pobierz wszystkie nagłówki wydatków dla danej grupy
    final List<Map<String, dynamic>> expenseMaps = await db.query(
      tableName,
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'date DESC', // Najnowsze wydatki na górze
    );

    List<Expense> expenses = [];

    // 2. Dla każdego wydatku dociągnij jego produkty
    for (var expenseMap in expenseMaps) {
      final int expenseId = expenseMap['id'] as int;

      final List<Map<String, dynamic>> itemMaps = await db.query(
        shoppingItemsTableName,
        where: 'list_id = ?', // Klucz obcy łączący produkt z wydatkiem
        whereArgs: [expenseId],
      );

      // Mapujemy produkty na listę obiektów ShoppingItem
      final items = itemMaps.map((m) => ShoppingItem.fromMap(m)).toList();

      // 3. Budujemy pełny obiekt Expense
      // Używamy konstruktora, ponieważ produkty pobraliśmy osobnym zapytaniem
      expenses.add(
        Expense(
          id: expenseId,
          userId: expenseMap['user_id'] as int,
          date: DateTime.parse(expenseMap['date'] as String),
          items: items,
        ),
      );
    }

    return expenses;
  }
}

@riverpod
GroupExpensesRepository groupExpensesRepository(ref){
  final db = AppDatabase.instance;

  return GroupExpensesRepository(db);
}