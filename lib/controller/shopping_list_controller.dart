import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppinglist_app/controller/notification_controller.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/shoppinglist_model.dart';

class ShoppingListNotifier extends AsyncNotifier<List<ShoppingListModel>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  int totalItems = 0;
  int remainingItems = 0;
  int purchasedItems = 0;
  double estimateCost = 0.0;

  @override
  FutureOr<List<ShoppingListModel>> build() async {
    await refreshStats();

    return await helper.getAllShoppingList();
  }

  // refresh home statistics
  Future<void> refreshStats() async {
    totalItems = await helper.getActiveShoppingTotalItems();

    remainingItems = await helper.getActiveShoppingRemainingItems();

    purchasedItems = await helper.getActiveShoppingPurchasedItems();

    estimateCost = await helper.getActiveShoppingEstimateCost();
  }

  // reload
  Future<void> reloadData() async {
    state = const AsyncLoading();

    await refreshStats();

    state = AsyncData(await helper.getAllShoppingList());
  }

  // save new shopping list
  Future<int> saveCartToShoppingList({
    required String listName,
    DateTime? reminderDate,
  }) async {
    final listId = await helper.saveCartToShoppingList(
      listName: listName,
      reminderDate: reminderDate,
    );

    if (reminderDate != null) {
      await NotificationController.scheduleShoppingReminder(
        id: listId,
        listName: listName,
        dateTime: reminderDate,
      );

      final notificationId =
          NotificationController.shoppingReminderBaseId + listId;

      await helper.updateShoppingListNotificationId(listId, notificationId);
    }

    await refreshStats();

    state = AsyncData(await helper.getAllShoppingList());

    return listId;
  }

  // update existing shopping list
  Future<void> updateShoppingListFromCart({
    required int listId,
    required String listName,
    DateTime? reminderDate,
  }) async {
    final oldNotificationId = await helper.getShoppingListNotificationId(
      listId,
    );

    await helper.updateShoppingListFromCart(
      listId: listId,
      listName: listName,
      reminderDate: reminderDate,
    );

    if (oldNotificationId != null) {
      await NotificationController.cancelNotification(oldNotificationId);
    }

    if (reminderDate != null) {
      await NotificationController.scheduleShoppingReminder(
        id: listId,
        listName: listName,
        dateTime: reminderDate,
      );

      final notificationId =
          NotificationController.shoppingReminderBaseId + listId;

      await helper.updateShoppingListNotificationId(listId, notificationId);
    } else {
      await helper.updateShoppingListNotificationId(listId, null);
    }

    await refreshStats();

    state = AsyncData(await helper.getAllShoppingList());
  }

  // sync cart items to saved list
  Future<void> syncShoppingListItemsFromCart(int listId) async {
    await helper.syncShoppingListItemsFromCart(listId);

    await refreshStats();

    state = AsyncData(await helper.getAllShoppingList());
  }

  // complete shopping
  Future<void> completeShoppingList(int listId) async {
    final notificationId = await helper.getShoppingListNotificationId(listId);

    await helper.completeShoppingList(listId);

    if (notificationId != null) {
      await NotificationController.cancelNotification(notificationId);
    }

    await refreshStats();

    state = AsyncData(await helper.getAllShoppingList());
  }

  // delete shopping list
  Future<void> deleteShoppingList(int listId) async {
    final notificationId = await helper.getShoppingListNotificationId(listId);

    if (notificationId != null) {
      await NotificationController.cancelNotification(notificationId);
    }

    await helper.deleteShoppingList(listId);

    await refreshStats();

    state = AsyncData(await helper.getAllShoppingList());
  }

  // search
  Future<void> searchShoppingList(String search) async {
    final data = await helper.searchShoppingList(search);

    state = AsyncData(data);
  }
}

final shoppingListProvider =
    AsyncNotifierProvider<ShoppingListNotifier, List<ShoppingListModel>>(
      ShoppingListNotifier.new,
    );

// editing shopping list
final editingShoppingListProvider = StateProvider<ShoppingListModel?>(
  (ref) => null,
);
