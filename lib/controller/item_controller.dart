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
  Future<void> reloadCounter() async {
    totalItems = await helper.getTotalItems();

    favItems = await helper.getTotalFavItems();
  }

  // favorite
  Future<void> updateFav(int id, bool isFav) async {
    await helper.updateFavorite(id, isFav);

    await reloadCounter();

    state = AsyncData(await helper.getAllItems());
  }

  // item count by category
  Future<Map<int, int>> getItemCountsByCategory() async {
    return await helper.getItemCountsByCategory();
  }

  // get item by category
  Future<List<ItemModel>> getItemByCategory(int categoryId) async {
    return await helper.getItemByCategory(categoryId);
  }

  // update item
  Future<void> updateItem(ItemModel item) async {
    await helper.updateItem(item);

    await reloadCounter();

    state = AsyncData(await helper.getAllItems());
  }

  // delete item
  Future<void> deleteItem(int id) async {
    await helper.deleteItem(id);

    await reloadCounter();

    state = AsyncData(await helper.getAllItems());
  }

  // filter item by category
  Future<List<ItemModel>> filterItem(int categoryId, String filter) async {
    return await helper.filterItemsCategory(categoryId, filter);
  }
}

// MAIN ITEM PROVIDER
final itemProvider = AsyncNotifierProvider<ItemNotifier, List<ItemModel>>(
  ItemNotifier.new,
);

// ON SALE

final isOnSaleProvider = StateProvider.autoDispose<bool?>((ref) => null);

// ITEM COUNT BY CATEGORY

final itemCountsByCategoryProvider = FutureProvider<Map<int, int>>((ref) async {
  // Reload count when item data changes
  ref.watch(itemProvider);

  return await ref.read(itemProvider.notifier).getItemCountsByCategory();
});

// CATEGORY FILTER
// Each category has its own filter
final itemFilterProvider = StateProvider.autoDispose.family<String, int>(
  (ref, categoryId) => 'All',
);

final itemByCategoryProvider = FutureProvider.autoDispose
    .family<List<ItemModel>, int>((ref, categoryId) async {
      // Get filter only for this category
      final filter = ref.watch(itemFilterProvider(categoryId));

      // Reload when main item data changes
      ref.watch(itemProvider);

      return await ref
          .read(itemProvider.notifier)
          .filterItem(categoryId, filter);
    });

// ITEM FORM CATEGORY
final itemFilterByCategory = StateProvider.autoDispose<int?>((ref) => null);
final itemFormCategoryProvider = StateProvider.autoDispose<int?>((ref) => null);

// ITEM DETAIL FAVORITE

final itemDetailFavProvider = StateProvider.autoDispose.family<bool, ItemModel>(
  (ref, item) => item.isFav,
);

// ITEM DETAIL
final itemDetailProvider = Provider.family<ItemModel?, int>((ref, itemId) {
  final itemsAsync = ref.watch(itemProvider);

  return itemsAsync.maybeWhen(
    data: (items) {
      for (final item in items) {
        if (item.id == itemId) {
          return item;
        }
      }

      return null;
    },

    orElse: () => null,
  );
});
