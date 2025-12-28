import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/shoplist/ShopListView.dart';

import '../groups/model/group_model.dart';
import 'GroupSection.dart';
import 'bills/BillsView.dart';
import 'expenses/ExpensesView.dart';

class GroupSectionRenderer extends ConsumerWidget {
  final GroupSection selectedSection;
  final Group currentGroup;

  const GroupSectionRenderer({super.key, required this.selectedSection, required this.currentGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedSection == GroupSection.Expenses){
      return ExpensesView(group: currentGroup);
    }
    if (selectedSection == GroupSection.ShopList){
      return ShopListView(group: currentGroup);
    }
    if (selectedSection == GroupSection.Bills){
      return BillsView(group: currentGroup);
    }

    return const Center(child: Text("Nie ma takiej sekcji"));
  }
}