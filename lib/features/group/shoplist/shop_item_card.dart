import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_model.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_repository.dart';
import 'package:niezapominapka/features/group/shoplist/providers/shop_item_group_provider.dart';

import '../../../theme.dart';

class ShopItemCard extends ConsumerWidget{
  final ShopItem item;

  ShopItemCard({required this.item});

  Future<void> removeItem(WidgetRef ref, int itemId) async {
    var repo = ref.watch(shopItemRepositoryProvider);

    await repo.removeItem(itemId);
    ref.invalidate(shopItemGroupProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () => removeItem(ref, item.id!),
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