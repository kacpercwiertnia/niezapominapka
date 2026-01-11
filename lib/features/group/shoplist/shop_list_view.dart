import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/group/shoplist/providers/shop_item_group_provider.dart';
import 'package:niezapominapka/features/group/shoplist/shop_item_card.dart';

import '../../groups/model/group_model.dart';

class ShopListView extends ConsumerWidget{
  final Group group;

  const ShopListView({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopItemsAsync = ref.watch(shopItemGroupProvider(group.id!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        Text(
            "Brakujące produkty",
            style: Theme.of(context).textTheme.titleLarge
        ),
        Expanded(
            child: shopItemsAsync.when(
                data: (shopItems){
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final shopItem = shopItems[index];
                        return ShopItemCard(item: shopItem);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8,),
                      itemCount: shopItems.length);
                },
                error: (e, st) => Center(child: Text("Błąd: $e")),
                loading: () => const Center(child: CircularProgressIndicator())
            )
        )
      ],
    );
  }
  
}