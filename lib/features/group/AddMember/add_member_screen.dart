import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../groups/model/group_model.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  final bool showBack;
  final Group group;

  const AddMemberScreen ({super.key,
    required this.showBack,
    required this.group});

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}