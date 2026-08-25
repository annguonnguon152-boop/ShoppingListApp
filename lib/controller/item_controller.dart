import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/item_model.dart';

class ItemNotifier extends AsyncNotifier<List<ItemModel>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  int totalItems = 0;
  int favItems = 0;

  @override
  FutureOr<List<ItemModel>> build() async {
    await reloadCounter();
    return await helper.getAllItems();
  }

  // save item
  Future<void> insertItem(ItemModel item) async {
    await helper.insertItem(item);

    await reloadCounter();

    state = AsyncData(await helper.getAllItems());
  }

  // reload
  Future<void> reloadData() async {
    state = const AsyncLoading();
    await reloadCounter();

    state = AsyncData(await helper.getAllItems());
  }

  // counter item
  // refresh
  Future<void> reloadCounter() async {
    totalItems = await helper.getTotalItems();
    favItems = await helper.getTotalFavItems();
  }

  // fav
  Future<void> updateFav(int id, bool isFav) async {
    await helper.updateFavorite(id, isFav);

    await reloadCounter();
    state = AsyncData(await helper.getAllItems());
  }

  //
}

final itemProvider = AsyncNotifierProvider<ItemNotifier, List<ItemModel>>(
  ItemNotifier.new,
);

final isOnSaleProvider = StateProvider.autoDispose<bool>((ref) => false);
