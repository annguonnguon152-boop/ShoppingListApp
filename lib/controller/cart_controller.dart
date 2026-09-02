import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/cart_model.dart';
import 'package:shoppinglist_app/model/item_model.dart';

class CartNotifier extends AsyncNotifier<List<CartModel>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  int totalItems = 0;
  double subTotal = 0.0;
  double discount = 0.0;
  double finalPrice = 0.0;
  int cartCounter = 0;
  int purchasedItems = 0;
  @override
  Future<List<CartModel>> build() async {
    await refresh();

    return await helper.getCartItems();
  }

  // refresh cart summary
  Future<void> refresh() async {
    totalItems = await helper.getCartTotalItems();
    subTotal = await helper.getCartSubTotal();
    discount = await helper.getCartDiscount();
    finalPrice = await helper.getCartFinalPrice();
    cartCounter = await helper.getCartCount();
    purchasedItems = await helper.getCartPurchasedItems();
  }

  // add item to cart
  Future<void> addToCart(ItemModel item, int qty) async {
    final cartItems = state.value ?? [];

    final index = cartItems.indexWhere((e) => e.item.id == item.id);

    if (index != -1) {
      final newQty = cartItems[index].quantity + qty;

      await helper.updateCartQuantity(item.id!, newQty);
    } else {
      await helper.saveCartItem(item.id!, qty);
    }

    await refresh();

    state = AsyncData(await helper.getCartItems());
  }

  // increment
  Future<void> increment(int itemId) async {
    final cartItems = state.value ?? [];

    final index = cartItems.indexWhere((e) => e.item.id == itemId);

    if (index == -1) return;

    final newQty = cartItems[index].quantity + 1;

    await helper.updateCartQuantity(itemId, newQty);

    await refresh();

    state = AsyncData(await helper.getCartItems());
  }

  // decrement
  Future<void> decrement(int itemId) async {
    final cartItems = state.value ?? [];

    final index = cartItems.indexWhere((e) => e.item.id == itemId);

    if (index == -1) return;

    final currentQty = cartItems[index].quantity;

    if (currentQty == 1) {
      await helper.deleteCartItem(itemId);
    } else {
      await helper.updateCartQuantity(itemId, currentQty - 1);
    }

    await refresh();

    state = AsyncData(await helper.getCartItems());
  }

  // remove item
  Future<void> removeItem(int itemId) async {
    await helper.deleteCartItem(itemId);

    await refresh();

    state = AsyncData(await helper.getCartItems());
  }

  // clear cart
  Future<void> clearCart() async {
    await helper.clearCart();

    await refresh();

    state = const AsyncData([]);
  }

  // purchase
  Future<void> isPurchasedItem(int itemId, bool isPurchase) async {
    await helper.updateCartPurchased(itemId, isPurchase);
    await refresh();

    state = AsyncData(await helper.getCartItems());
  }

  // load saved shopping list
  Future<void> loadShoppingList(int listId) async {
    state = const AsyncLoading();

    await helper.loadShoppingListToCart(listId);

    await refresh();

    state = AsyncData(await helper.getCartItems());
  }

  // reuse completed shopping list
  Future<void> reuseShoppingList(int listId) async {
    state = const AsyncLoading();

    await helper.reuseShoppingListToCart(listId);

    await refresh();

    state = AsyncData(await helper.getCartItems());
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartModel>>(
  CartNotifier.new,
);
