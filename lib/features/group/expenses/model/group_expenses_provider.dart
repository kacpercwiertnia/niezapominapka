import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/expenses/model/expense_model.dart';
import 'package:niezapominapka/features/group/expenses/model/group_expenses_repository.dart';

final expensesForGroupProvider = FutureProvider.autoDispose.family<List<Expense>, int>((ref, groupId) async {
  final repo = ref.watch(groupExpensesRepositoryProvider);

  var expensesForGroup = await repo.getExpensesByGroupId(groupId);
  return expensesForGroup;
});