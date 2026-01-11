import 'package:flutter/material.dart';

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
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                Text(
                  "${payorBill.amount} PLN",
                  style: Theme.of(context).textTheme.bodyLarge
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