import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/repositories/GroupRepository.dart';
import '../../auth/CurrentUser.dart';
import 'group_model.dart';

final userGroupsProvider = FutureProvider.autoDispose<List<Group>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repo = ref.watch(groupRepositoryProvider);
  return repo.getGroupsForUserId(user.id!);
});