import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/shoppinglist_detail_model.dart';

class ShoppingListDetailNotifier
    extends AsyncNotifier<Map<int, List<ShoppingListDetailModel>>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  @override
  Future<Map<int, List<ShoppingListDetailModel>>> build() async {
    return await getAllDetails();
  }

  // GET ALL SHOPPING LIST DETAILS
  Future<Map<int, List<ShoppingListDetailModel>>> getAllDetails() async {
    final lists = await helper.getAllShoppingList();

    final Map<int, List<ShoppingListDetailModel>> data = {};

    for (final list in lists) {
      if (list.id != null) {
        data[list.id!] = await helper.getShoppingListDetails(list.id!);
      }
    }

    return data;
  }

  // GET DETAIL BY LIST ID
  List<ShoppingListDetailModel> getDetails(int listId) {
    return state.value?[listId] ?? [];
  }

  // TOTAL QUANTITY
  int getTotalItems(int listId) {
    final details = getDetails(listId);

    return details.fold<int>(0, (sum, detail) => sum + detail.quantity);
  }

  // TOTAL PRICE
  double getTotal(int listId) {
    final details = getDetails(listId);

    return details.fold<double>(0.0, (sum, detail) => sum + detail.lineTotal);
  }

  // RELOAD
  Future<void> reloadData() async {
    state = const AsyncLoading();

    state = AsyncData(await getAllDetails());
  }

  Future<void> isPurchasedItem(int listId, int itemId, bool isPurchased) async {
    await helper.updateShoppingListDetailPurchased(listId, itemId, isPurchased);

    await reloadData();
  }

  Future<void> increment(int listId, int itemId) async {
    await helper.incrementShoppingListDetail(listId, itemId);

    await reloadData();
  }

  Future<void> decrement(int listId, int itemId) async {
    await helper.decrementShoppingListDetail(listId, itemId);

    await reloadData();
  }

  Future<void> removeItem(int listId, int itemId) async {
    await helper.removeShoppingListDetail(listId, itemId);

    await reloadData();
  }
}

final shoppingListDetailProvider =
    AsyncNotifierProvider<
      ShoppingListDetailNotifier,
      Map<int, List<ShoppingListDetailModel>>
    >(ShoppingListDetailNotifier.new);
