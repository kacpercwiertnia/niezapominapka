import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_model.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_repository.dart';

final shopItemGroupProvider = FutureProvider.autoDispose
    .family<List<ShopItem>, int>((ref, groupId) async {
  final repo = ref.watch(shopItemRepositoryProvider);

  var shopItemList = await repo.get(groupId);
  return shopItemList;
});