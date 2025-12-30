import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/components/oprganisms/number_field.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/features/group/expenses/providers/group_users_provider.dart';

import '../../groups/model/group_model.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final bool showBack;
  final Group group;

  const AddExpenseScreen ({super.key,
    required this.showBack,
    required this.group});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final TextEditingController _nameController;
  final TextEditingController _amountController;
  String? _whoPayed = null;
  List<AppUser> _whoToCountIn = [];

  void changeWhoPayed(String value){
    setState(() => _whoPayed = value);
  }

  void changeWhoToCountIn(List<AppUser> users){
    setState(() => _whoToCountIn = users);
  }




  @override
  Widget build(BuildContext context) {
    final usersForGroup = ref.watch(usersForGroupProvider(widget.group.id!));

    return Scaffold(
      appBar: AppTitle(showBack: widget.showBack),
      body: AppPage(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //nwm czy to dobra jest xd
          spacing: 10,
          children: [
            Text("Dodaj rozliczenie"),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nazwa"),
                    TextField(
                      controller: _nameController,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Kwota"),
                    NumberField(
                      controller: _nameController,
                    )
                  ],
                )
              ],
            ),
            Text("Kto płacił"),
            usersForGroup.when(
                data: (users) =>
                    DropdownField(
                      value: _whoPayed,
                      onChange: changeWhoPayed,
                      availableOptions: users),
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Błąd: $err'),
              ),
            Text("Kogo wliczyć"),
            usersForGroup.when(
              data: (users) =>
                  SelectionList(
                      value: _whoToCountIn,
                      onChange: changeWhoToCountIn,
                      availableOptions: users),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Błąd: $err'),
            ),
          ],
        )
      ),
    );
  }

}