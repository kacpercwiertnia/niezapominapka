import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

import '../../features/auth/app_user.dart';
import '../../features/groups/group_model.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

final currentUserProvider = StateProvider<AppUser?>((ref) => null);

final userGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final db = ref.watch(databaseProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return [];
  }

  return db.getGroupsForUser(user.id);
});
