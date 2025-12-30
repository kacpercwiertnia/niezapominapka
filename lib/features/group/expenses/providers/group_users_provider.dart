import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/core/db/repositories/GroupRepository.dart';
import 'package:niezapominapka/features/auth/app_user.dart';

final usersForGroupProvider = FutureProvider.autoDispose.family<List<AppUser>, int>((ref, groupId) async {
  final groupRepo = ref.watch(groupRepositoryProvider);

  var usersForGroup = await groupRepo.getUsersForGroup(groupId);
  return usersForGroup;
});