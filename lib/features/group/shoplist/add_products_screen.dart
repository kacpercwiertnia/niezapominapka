import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_repository.dart';
import 'package:niezapominapka/features/group/shoplist/providers/shop_item_group_provider.dart';
import 'package:niezapominapka/features/group/shoplist/shop_item_card.dart';

import '../../groups/model/group_model.dart';

class AddProductsScreen extends ConsumerStatefulWidget{
  final bool showBack;
  final Group group;

  AddProductsScreen({required this.showBack, required this.group});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends ConsumerState<AddProductsScreen>{
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {

    final shopItemsForGroup = ref.watch(shopItemGroupProvider(widget.group.id!));

    Future<void> addItem() async {
      var repo = ref.watch(shopItemRepositoryProvider);
      var productName = _nameController.text.trim();

      await repo.addItem(productName, widget.group.id!);

      _nameController.clear();
      ref.invalidate(shopItemGroupProvider);
    }

    return Scaffold(
      appBar: AppTitle(showBack: true),
      body: AppPage(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Dodaj brakujące produkty",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14,),
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Nazwa produktu",
                suffixIcon: IconButton(
                    onPressed: _isLoading ? null : () async => await addItem(),
                    icon: Icon(Icons.add))
              ),
            ),
            Expanded(
                child: shopItemsForGroup.when(
                  data: (shopItems) {
                    return ListView.separated(
                        itemBuilder: (context, index){
                          final item = shopItems[index];
                          return ShopItemCard(item: item);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemCount: shopItems.length);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text("Błąd: $e")),),
            )
          ],
        )
      ),
    );
  }

}