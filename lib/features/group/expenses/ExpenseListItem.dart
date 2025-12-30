import 'package:flutter/cupertino.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text(formatCustomDate(date)),
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
                ),
                Text(
                  "${item.amount.toString()} PLN",
                ),
              ],
            ),
          );
        })
      ],
    );
  }

}