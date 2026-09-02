import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/shoppinglist_detail_model.dart';
import 'package:shoppinglist_app/model/shoppinglist_model.dart';

class HistoryNotifier extends AsyncNotifier<List<ShoppingListModel>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  double totalSpent = 0.0;

  @override
  FutureOr<List<ShoppingListModel>> build() async {
    totalSpent = await helper.getCompletedPurchaseTotal();

    return await helper.getCompletedShoppingList();
  }

  // reload
  Future<void> reloadData() async {
    state = const AsyncLoading();

    totalSpent = await helper.getCompletedPurchaseTotal();

    state = AsyncData(await helper.getCompletedShoppingList());
  }

  // search
  Future<void> searchHistory(String search) async {
    final data = await helper.searchCompletedShoppingList(search);

    state = AsyncData(data);
  }
}

final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<ShoppingListModel>>(
      HistoryNotifier.new,
    );

class HistoryDetailNotifier
    extends AsyncNotifier<Map<int, List<ShoppingListDetailModel>>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  @override
  Future<Map<int, List<ShoppingListDetailModel>>> build() async {
    return await getAllDetails();
  }

  Future<Map<int, List<ShoppingListDetailModel>>> getAllDetails() async {
    final lists = await helper.getCompletedShoppingList();

    final Map<int, List<ShoppingListDetailModel>> data = {};

    for (final list in lists) {
      if (list.id != null) {
        data[list.id!] = await helper.getShoppingListDetails(list.id!);
      }
    }

    return data;
  }

  // reload
  Future<void> reloadData() async {
    state = const AsyncLoading();

    state = AsyncData(await getAllDetails());
  }
}

final historyDetailProvider =
    AsyncNotifierProvider<
      HistoryDetailNotifier,
      Map<int, List<ShoppingListDetailModel>>
    >(HistoryDetailNotifier.new);
