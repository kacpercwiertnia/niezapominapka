import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/core/db/repositories/UserRepository.dart';
import 'package:niezapominapka/features/group/bills/bill_list_item.dart';
import 'package:niezapominapka/features/group/bills/repositories/group_bills_repository.dart';

final payorsBillsForGroupProivder = FutureProvider.autoDispose
    .family<List<PayorBill>, int>((ref, groupId) async {
      final groupMembersRepo = ref.watch(groupBillsRepositoryProvider);
      final usersRepo = ref.watch(userRepositoryProvider);
      
      var groupMembers = await groupMembersRepo.getGroupMembersForGroup(groupId);
      var groupMembersIds = groupMembers.map((gm) => gm.userId).toList();
      
      var users = await usersRepo.getUsersByIds(groupMembersIds);

      var payorsBiils = users.map((user){
        var groupMember = groupMembers.singleWhere((gm) => gm.userId == user.id);

        return PayorBill(user.username, groupMember.bilans);
      });

      return payorsBiils.toList();
});