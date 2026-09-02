import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/item_model.dart';

class SearchItemNotifier extends AsyncNotifier<List<ItemModel>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  @override
  Future<List<ItemModel>> build() async {
    return await helper.getAllItems();
  }

  // 1. SEARCH
  Future<void> searchItem(String search) async {
    state = AsyncData(await helper.searchItem(search));
  }

  // 2. FILTER
  Future<void> filterItem(String filter) async {
    state = AsyncData(await helper.filterSearchItem(filter));
  }

  // 3. TAG FILTER
  Future<void> filterTag(String tag) async {
    state = AsyncData(await helper.filterItemByTag(tag));
  }

  // RESET
  Future<void> showAll() async {
    state = AsyncData(await helper.getAllItems());
  }

  
}

final searchItemProvider =
    AsyncNotifierProvider<SearchItemNotifier, List<ItemModel>>(
      SearchItemNotifier.new,
    );
