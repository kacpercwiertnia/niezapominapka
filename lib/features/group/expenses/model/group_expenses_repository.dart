import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import '../../../../core/db/app_database.dart';
import '../../../auth/app_user.dart';
import 'expense_model.dart';

part "group_expenses_repository.g.dart";

class GroupExpensesRepository {
  final AppDatabase _appDatabase;

  Future<mysql.MySqlConnection> _getConn() async {
    return await _appDatabase.connection;
  }

  GroupExpensesRepository(this._appDatabase);

  final String tableName = "expenses";
  final String payorsTable = "payors";

  Future<int> addExpense(
      AppUser owner,
      List<AppUser> payors,
      String expenseName,
      double amount,
      int groupId,
      ) async {
    final conn = await _getConn();

    final expenseId = await conn.transaction<int>((tx) async {
      // 1) Nagłówek wydatku
      final insExpense = await tx.query(
        'INSERT INTO $tableName (group_id, user_id, date, name, amount) VALUES (?, ?, ?, ?, ?)',
        [
          groupId,
          owner.id!,
          DateTime.now().toIso8601String(), // trzymamy jako VARCHAR/TEXT
          expenseName,
          amount,
        ],
      );
      final expenseId = insExpense.insertId!;

      // 2) Owner +amount do bilansu
      await tx.query('''
        UPDATE group_members
        SET bilans = bilans + ?
        WHERE user_id = ? AND group_id = ?
      ''', [amount, owner.id!, groupId]);

      // 3) Payors -amount/len + wpisy do payors
      final amountToPayPerPayor = amount / payors.length;

      for (final payor in payors) {
        await tx.query('''
          UPDATE group_members
          SET bilans = bilans - ?
          WHERE user_id = ? AND group_id = ?
        ''', [amountToPayPerPayor, payor.id, groupId]);

        await tx.query(
          'INSERT INTO $payorsTable (user_id, expense_id, username, amount) VALUES (?, ?, ?, ?)',
          [payor.id, expenseId, payor.username, amountToPayPerPayor],
        );
      }

      return expenseId;
    });

    if (expenseId == null) {
      throw StateError('addExpense: transaction returned null');
    }
    return expenseId;
  }

  Future<List<Expense>> getExpensesByGroupId(int groupId) async {
    final conn = await _getConn();

    final results = await conn.query(
      'SELECT id, group_id, user_id, date, name, amount FROM $tableName WHERE group_id = ? ORDER BY date DESC',
      [groupId],
    );

    return results.map((row) => Expense.fromMap(row.fields)).toList();
  }
}

@riverpod
GroupExpensesRepository groupExpensesRepository(ref) {
  final db = AppDatabase.instance;
  return GroupExpensesRepository(db);
}
