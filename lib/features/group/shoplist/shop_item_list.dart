import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_model.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_repository.dart';
import 'package:niezapominapka/features/group/shoplist/providers/shop_item_group_provider.dart';

import '../../../theme.dart';

class ShopItemList extends ConsumerWidget {
  final List<ShopItem> shopItems;
  final String? listTitle;

  const ShopItemList({super.key, required this.shopItems, required this.listTitle});
  
  Future<void> removeItem(WidgetRef ref, int itemId) async {
    var repo = ref.watch(shopItemRepositoryProvider);

    await repo.removeItem(itemId);
    ref.invalidate(shopItemGroupProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        ...shopItems.map((item) {
          return ShopItemListItem(item: item, onTap: (itemId) => removeItem(ref, itemId));
        })
      ],
    );
  }
}

class ShopItemListItem extends StatelessWidget{
  final ShopItem item;
  final Function(int) onTap;

  ShopItemListItem({required this.item, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(item.id!),
        splashColor: Colors.white.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Icon(Icons.remove, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}