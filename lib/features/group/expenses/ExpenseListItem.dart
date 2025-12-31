import 'package:flutter/material.dart';

import '../../../theme.dart';
import 'model/expense_model.dart';

class ExpensesForDateListItem extends StatelessWidget {
  final List<Expense> expenses;
  final DateTime date;

  const ExpensesForDateListItem({super.key, required this.expenses, required this.date});

  String formatCustomDate(DateTime date){
    const months = [
      'sty', 'lut', 'mar', 'kwi', 'maj', 'cze',
      'lip', 'sie', 'wrz', 'paź', 'list', 'gru'
    ];

    return "${date.day} ${months[date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        Text(
          formatCustomDate(date),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ...expenses.map((item) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg, // Twój kolor 0xFF091926
              borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Rozsuwa dzieci na końce
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "${item.amount.toString()} PLN",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        })
      ],
    );
  }

}