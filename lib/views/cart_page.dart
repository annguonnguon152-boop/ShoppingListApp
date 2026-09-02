import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/shopping_list_controller.dart';
import 'package:shoppinglist_app/controller/shoppinglistdetail_controller.dart';
import 'package:shoppinglist_app/views/dialog/savelist_dialogForm.dart';
import 'package:shoppinglist_app/views/item_page.dart';
import 'package:shoppinglist_app/views/widgets/cart_widget.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // editing shopping list
    final editingList = ref.watch(editingShoppingListProvider);
    final isEditingList = editingList != null;
    // cart
    final cartItems = ref.watch(cartProvider);
    final cartController = ref.read(cartProvider.notifier);
    final subTotal = cartController.subTotal;
    final finalPrice = cartController.finalPrice;
    final discount = cartController.discount;
    final totalItems = cartController.totalItems;
    final purchased = cartController.purchasedItems;
    final remaining = totalItems - purchased;
    final progress = totalItems == 0 ? 0.0 : purchased / totalItems;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF181818) : Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          isEditingList ? editingList.listName : 'Checkout',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: cartItems.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B76A).withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 52,
                        color: Color(0xFF12B76A),
                      ),
                    ),

                    SizedBox(height: 22),

                    Text(
                      isEditingList
                          ? 'Shopping List is Empty'
                          : 'Your Cart is Empty',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      isEditingList
                          ? 'Add more items to continue this shopping list.'
                          : 'Add some items from the catalog\nto start your shopping list.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark
                            ? Colors.grey.shade400
                            : const Color(0xFF667085),
                      ),
                    ),

                    SizedBox(height: 24),

                    SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isEditingList) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ItemPage();
                                },
                              ),
                            );

                            return;
                          }

                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 20,
                        ),
                        label: const Text('Continue Shopping'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF12B76A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(15),
            children: [
              cartSummaryCard(
                context: context,
                totalItems: totalItems,
                purchased: purchased,
                remaining: remaining,
                progress: progress,
              ),
              SizedBox(height: 20),
              cartPriceSummary(
                context: context,
                subTotal: subTotal,
                discount: discount,
              ),

              SizedBox(height: 20),
              cartTotalEstimatedCost(context: context, finalPrice: finalPrice),

              SizedBox(height: 25),

              Row(
                children: [
                  Text(
                    'Currently Selected',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),

                  Spacer(),

                  Text(
                    '${data.length} ${data.length == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF667085),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              ...data.map(
                (e) => cartItemTile(
                  context: context,
                  item: e.item,
                  quantity: e.quantity,
                  isPurchased: e.isPurchased,

                  onPurchased: () async {
                    await cartController.isPurchasedItem(
                      e.item.id!,
                      !e.isPurchased,
                    );
                  },
                  onIncrement: () async {
                    await cartController.increment(e.item.id!);
                  },
                  onDecrement: () async {
                    await cartController.decrement(e.item.id!);
                  },
                  onDelete: () async {
                    await cartController.removeItem(e.item.id!);
                  },
                ),
              ),
            ],
          );
        },

        error: (error, stack) {
          return Center(child: Text('$error'));
        },

        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),

      bottomNavigationBar: cartItems.maybeWhen(
        data: (data) {
          if (data.isEmpty && !isEditingList) {
            return null;
          }

          return cartBottomNavigation(
            context: context,

            // complete purchase
            onComplete: () async {
              if (data.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add at least one item first')),
                );

                return;
              }

              // complete normal cart
              if (!isEditingList) {
                final result = await showSaveCartToListDialog(
                  context,
                  ref,
                  completeAfterSave: true,
                );
                if (result == null) {
                  return;
                }
                if (!context.mounted) {
                  return;
                }
                Navigator.pop(context);
                return;
              }

              // complete saved shopping list
              final message = remaining > 0
                  ? 'You still have $remaining ${remaining == 1 ? 'item' : 'items'} remaining. Completing will mark all items as purchased.'
                  : 'All items are purchased. Complete this shopping list?';

              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Text('Complete Shopping?'),
                    content: Text(message),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        child: Text('Cancel'),
                      ),

                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF12B76A),
                        ),
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        child: Text('Complete'),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true) {
                return;
              }

              // save latest cart items
              await ref
                  .read(shoppingListProvider.notifier)
                  .syncShoppingListItemsFromCart(editingList.id!);

              // complete list
              await ref
                  .read(shoppingListProvider.notifier)
                  .completeShoppingList(editingList.id!);

              // clear working cart
              await cartController.clearCart();

              // stop editing list
              ref.read(editingShoppingListProvider.notifier).state = null;

              // reload card details
              await ref.read(shoppingListDetailProvider.notifier).reloadData();

              if (!context.mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    '"${editingList.listName}" completed successfully',
                  ),
                ),
              );

              Navigator.pop(context);
            },

            // save or update shopping list
            onSave: () async {
              if (data.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add at least one item first')),
                );

                return;
              }

              await showSaveCartToListDialog(
                context,
                ref,
                editingList: editingList,
              );
            },

            // continue shopping
            onContinue: () {
              if (isEditingList) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ItemPage();
                    },
                  ),
                );

                return;
              }

              Navigator.pop(context);
            },

            // clear cart or delete saved list
            onClear: () async {
              if (!isEditingList) {
                await cartController.clearCart();

                return;
              }

              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Text('Delete Shopping List?'),
                    content: Text(
                      'Clearing this cart will delete "${editingList.listName}". Are you sure?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        child: const Text('Cancel'),
                      ),

                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF04438),
                        ),
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true) {
                return;
              }
              // delete saved list
              await ref
                  .read(shoppingListProvider.notifier)
                  .deleteShoppingList(editingList.id!);
              // clear cart
              await cartController.clearCart();

              // stop editing
              ref.read(editingShoppingListProvider.notifier).state = null;
              // reload list details
              await ref.read(shoppingListDetailProvider.notifier).reloadData();
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
            },
          );
        },
        orElse: () => null,
      ),
    );
  }
}
