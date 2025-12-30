import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/components/oprganisms/dropdown_field.dart';
import 'package:niezapominapka/components/oprganisms/number_field.dart';
import 'package:niezapominapka/components/oprganisms/selection_list.dart';
import 'package:niezapominapka/core/db/repositories/GroupRepository.dart';
import 'package:niezapominapka/core/notifications/error_notification.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/features/group/expenses/model/group_expenses_repository.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  AppUser? _whoPayed = null;
  List<AppUser> _whoToCountIn = [];
  bool _isLoading = false;


  void changeWhoPayed(AppUser user){
    setState(() => _whoPayed = user);
  }

  void changeWhoToCountIn(List<AppUser> users){
    setState(() => _whoToCountIn = users);
  }

  bool areFieldsValid(BuildContext context){
    var nameValue = _nameController.text.trim();
    if (nameValue.isEmpty){
      showError(context, "Musisz podać nazwę wydatku");
      return false;
    }

    var amountStringValue = _amountController.text.trim();
    var amountValue = double.tryParse(amountStringValue);
    if (amountValue == null || amountValue <= 0){
      showError(context, "Kwota wydatku musi być większa od 0");
      return false;
    }

    if (_whoPayed == null){
      showError(context, "Musisz wybrać płatnika");
      return false;
    }

    if (_whoToCountIn.isEmpty){
      showError(context, "Wybierz kogoś kogo wliczasz");
      return false;
    }

    return true;
  }

  Future<void> addExpense(BuildContext context) async {
    setState(() => _isLoading = true);

    if (!areFieldsValid(context)){
      setState(() => _isLoading = false);
      return;
    }

    var amountStringValue = _amountController.text.trim();
    var amountValue = double.tryParse(amountStringValue);
    var nameValue = _nameController.text.trim();

    var groupRepository = ref.watch(groupExpensesRepositoryProvider);
    await groupRepository.addExpense(_whoPayed!, _whoToCountIn, nameValue, amountValue!, widget.group.id!);

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
                      controller: _amountController,
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
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () async => await addExpense(context),
              icon: const Icon(Icons.attach_money_outlined),
              label: const Text("Zaloguj się"),
            )
          ],
        )
      ),
    );
  }

}