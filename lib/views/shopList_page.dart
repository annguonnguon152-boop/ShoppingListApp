import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/shopping_list_controller.dart';
import 'package:shoppinglist_app/controller/shoppinglistdetail_controller.dart';
import 'package:shoppinglist_app/views/cart_page.dart';
import 'package:shoppinglist_app/views/item_page.dart';
import 'package:shoppinglist_app/views/widgets/shoppinglist_widget.dart';

class ShoplistPage extends ConsumerWidget {
  const ShoplistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final shoppingLists = ref.watch(shoppingListProvider);

    final shoppingListDetails = ref.watch(shoppingListDetailProvider);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF7F9FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Shopping List',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF101828),
          ),
        ),
      ),

      body: shoppingLists.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(shoppingListProvider.notifier).reloadData();

              await ref.read(shoppingListDetailProvider.notifier).reloadData();
            },

            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
              children: [
                const SizedBox(height: 5),

                // search design
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF343434)
                          : const Color(0xFFE4E7EC),
                    ),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),

                  child: TextField(
                    onChanged: (value) async {
                      await ref
                          .read(shoppingListProvider.notifier)
                          .searchShoppingList(value);
                    },

                    decoration: InputDecoration(
                      hintText: 'Search shopping list name...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey.shade500
                            : const Color(0xFF98A2B3),
                      ),

                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark
                            ? Colors.grey.shade400
                            : const Color(0xFF667085),
                      ),

                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF12B76A,
                          ).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          size: 19,
                          color: Color(0xFF12B76A),
                        ),
                      ),

                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF12B76A),
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Lists',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF101828),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Your shopping plans in one place',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : const Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B76A).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${data.length} ${data.length == 1 ? 'List' : 'Lists'}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF079455),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                if (data.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF12B76A,
                            ).withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.playlist_add_rounded,
                            size: 45,
                            color: Color(0xFF12B76A),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'No Shopping Lists Yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF101828),
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Save your cart to create your first shopping list.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.grey.shade400
                                : const Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  shoppingListDetails.when(
                    data: (detailData) {
                      final detailController = ref.read(
                        shoppingListDetailProvider.notifier,
                      );

                      return Column(
                        children: data.map((list) {
                          final details = detailData[list.id!] ?? [];

                          // item preview
                          final items = details
                              .take(3)
                              .map(
                                (detail) => [
                                  detail.item.name,
                                  detail.quantity.toString(),
                                  '\$${detail.lineTotal.toStringAsFixed(2)}',
                                ],
                              )
                              .toList();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: shoppingListCard(
                              context: context,
                              isDark: isDark,
                              list: list,
                              items: items,
                              itemCount: detailController.getTotalItems(
                                list.id!,
                              ),
                              total: detailController.getTotal(list.id!),

                              onTap: () async {
                                final editingList = ref.read(
                                  editingShoppingListProvider,
                                );

                                // same list already editing
                                if (editingList?.id == list.id) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const CartPage();
                                      },
                                    ),
                                  );
                                } else {
                                  // replace current cart
                                  await ref
                                      .read(cartProvider.notifier)
                                      .loadShoppingList(list.id!);

                                  // remember editing list
                                  ref
                                          .read(
                                            editingShoppingListProvider
                                                .notifier,
                                          )
                                          .state =
                                      list;

                                  if (!context.mounted) {
                                    return;
                                  }

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const CartPage();
                                      },
                                    ),
                                  );
                                }

                                if (!context.mounted) {
                                  return;
                                }

                                // refresh after return
                                await ref
                                    .read(shoppingListProvider.notifier)
                                    .reloadData();

                                await ref
                                    .read(shoppingListDetailProvider.notifier)
                                    .reloadData();
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },

                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    },

                    error: (error, stack) {
                      return Text(error.toString());
                    },
                  ),
              ],
            ),
          );
        },

        error: (error, stack) {
          return Center(child: Text(error.toString()));
        },

        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark
            ? const Color(0xFF12B76A)
            : const Color(0xFF00873E),
        foregroundColor: Colors.white,
        elevation: isDark ? 2 : 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ItemPage();
              },
            ),
          );
        },
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
