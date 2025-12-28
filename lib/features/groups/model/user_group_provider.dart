import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/repositories/GroupRepository.dart';
import '../../auth/CurrentUser.dart';
import 'group_model.dart';

final userGroupsProvider = FutureProvider.autoDispose<List<Group>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    debugPrint("NIE MA USERA");
    return [];
  }


  final repo = ref.watch(groupRepositoryProvider);
  var groupsForUser = await repo.getGroupsForUserId(user.id!);
  // debugPrint("Z tego providera grup magicznego");
  // debugPrint(groupsForUser.toString());
  return groupsForUser;
});