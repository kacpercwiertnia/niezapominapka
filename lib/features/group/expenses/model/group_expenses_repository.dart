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

  Future<int> addExpense(String name, double amount, int userId, int groupId) async {
    final db = await _getDb();

    // Używamy transakcji, aby mieć pewność, że albo zapisze się WSZYSTKO, albo NIC
    return await db.transaction((txn) async {

      // 1. Wstawiamy nagłówek wydatku
      final int expenseId = await txn.insert(tableName, {
        'user_id': userId,
        'group_id': groupId,
        'date': DateTime.now().toIso8601String(),
        'name': name,
        'amount': amount
      });

      txn.rawUpdate('''
        UPDATE group_members
        SET amount_spent = amount_spent + ?
        WHERE user_id = ? AND group_id = ?
      ''', [amount, userId, groupId]);

      // Zwracamy ID nowo utworzonego wydatku
      return expenseId;
    });
  }

  Future<List<Expense>> getExpensesByGroupId(int groupId) async {
    final db = await _getDb();

    // 1. Pobierz wszystkie nagłówki wydatków dla danej grupy
    final List<Map<String, dynamic>> expenseMaps = await db.query(
      tableName,
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'date DESC', // Najnowsze wydatki na górze
    );

    final expenses = expenseMaps.map((map) => Expense.fromMap(map)).toList();

    return expenses;
  }
}

@riverpod
GroupExpensesRepository groupExpensesRepository(ref){
  final db = AppDatabase.instance;

  return GroupExpensesRepository(db);
}