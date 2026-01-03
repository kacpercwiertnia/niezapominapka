import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/bills/bill_list_item.dart';
import 'package:niezapominapka/features/group/bills/providers/payors_bills_for_group_provider.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';

class BillsView extends ConsumerWidget{
  final Group group;

  BillsView({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payorsBills = ref.watch(payorsBillsForGroupProivder(group.id!));

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8.0,
        children: [
          Text("Salda"),
          SizedBox(height: 8,),
          Expanded(child:
            payorsBills.when(data: (bills) {
              return ListView.separated(itemBuilder: (context, index){
                final bill = bills[index];
                return BillListItem(payorBill: bill);
              },
                  separatorBuilder: (_, __) => const SizedBox(height: 8,),
                  itemCount: bills.length
              );
            },
                error: (e, st) => Center(child: Text("Błąd: $e")),
                loading: () => const Center(child: CircularProgressIndicator())
            )
          )
        ],
    );
  }

}