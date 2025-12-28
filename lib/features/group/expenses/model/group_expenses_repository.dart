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

  Future<int> addExpense(List<ShoppingItem> items, int userId, int groupId) async {
    final db = await _getDb();

    final double expenseSum = items.fold(0, (acc, item) => acc + item.amount);

    // Używamy transakcji, aby mieć pewność, że albo zapisze się WSZYSTKO, albo NIC
    return await db.transaction((txn) async {

      // 1. Wstawiamy nagłówek wydatku
      final int expenseId = await txn.insert(tableName, {
        'user_id': userId,
        'group_id': groupId,
        'date': DateTime.now().toIso8601String(),
      });

      // 2. Wstawiamy wszystkie przedmioty, przypisując im ID wydatku jako list_id
      for (var item in items) {
        await txn.insert(shoppingItemsTableName, {
          'list_id': expenseId, // To jest klucz obcy łączący produkt z wydatkiem
          'name': item.name,
          'amount': item.amount,
        });
      }

      txn.rawUpdate('''
        UPDATE group_members
        SET amount_spent = amount_spent + ?
        WHERE user_id = ? AND group_id = ?
      ''', [expenseSum, userId, groupId]);

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
          groupId: expenseMap['group_id'] as int,
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