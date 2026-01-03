import 'package:flutter/cupertino.dart';
import 'package:niezapominapka/features/group/expenses/model/payor_model.dart';

import '../../../theme.dart';

class BillListItem extends StatelessWidget {
  final PayorBill payorBill;

  const BillListItem({super.key, required this.payorBill});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8.0,
      children: [
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg, // Twój kolor 0xFF091926
              borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Rozsuwa dzieci na końce
              children: [
                Text(
                  payorBill.username,
                ),
                Text(
                  "${payorBill.amount} PLN",
                ),
              ],
            ),
          )
      ],
    );
  }
}

class PayorBill {
  final String username;
  final double amount;

  PayorBill(this.username, this.amount);
}