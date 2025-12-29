import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}