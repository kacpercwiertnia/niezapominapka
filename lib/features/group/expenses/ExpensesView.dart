import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/expenses/ExpenseListItem.dart';
import 'package:niezapominapka/features/group/expenses/model/group_expenses_repository.dart';

import '../../groups/model/group_model.dart';
import 'model/expense_model.dart';
import 'model/group_expenses_provider.dart';

class ExpensesView extends ConsumerWidget{
  final Group group;

  ExpensesView({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesForGroupProvider(group.id!));

    return expensesAsync.when(data: (expenses) {
          final groupExpenses = groupBy(expenses,
                  (Expense e) => DateTime(e.date.year, e.date.month, e.date.day));

          final groupedExpensesKeys = groupExpenses.keys.toList();
          groupedExpensesKeys.sort((a, b) => b.compareTo(a));
          
          return ListView.separated(
              itemBuilder: (context, index){
                final key = groupedExpensesKeys[index];
                    return ExpensesForDateListItem(expenses: groupExpenses[key]!, date: key,);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8,),
              itemCount: groupedExpensesKeys.length);
       },
        error: (e, st) => Center(child: Text("Błąd: $e")),
        loading: () => const Center(child: CircularProgressIndicator())
    );
  }
  

}