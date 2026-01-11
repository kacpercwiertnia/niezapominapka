import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/group/shoplist/models/shop_item_repository.dart';
import 'package:niezapominapka/features/group/shoplist/providers/shop_item_group_provider.dart';
import 'package:niezapominapka/features/group/shoplist/shop_item_card.dart';
import 'package:niezapominapka/core/notifications/error_notification.dart';

import '../../groups/model/group_model.dart';
import '../../../theme.dart';

class AddProductsScreen extends ConsumerStatefulWidget{
  final bool showBack;
  final Group group;

  const AddProductsScreen({super.key, required this.showBack, required this.group});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends ConsumerState<AddProductsScreen>{
  final TextEditingController _nameController = TextEditingController();

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final shopItemsForGroup = ref.watch(shopItemGroupProvider(widget.group.id!));

    Future<void> addItem() async {
      var repo = ref.watch(shopItemRepositoryProvider);
      var productName = _nameController.text.trim();

      if( productName.isEmpty ){
        showError(context, "Musisz podać nazwę produktu");
        return;
      }

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
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: TextField(
                              controller: _nameController,
                              enabled: !_isLoading,
                              autocorrect: false,
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) async {
                                if (_isLoading) return;
                                await addItem();
                              },
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: InputDecoration.collapsed(
                                hintText: "Nazwa produktu",
                                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _isLoading ? null : () async => await addItem(),
                          child: const Center(
                            child: Icon(Icons.add, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
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