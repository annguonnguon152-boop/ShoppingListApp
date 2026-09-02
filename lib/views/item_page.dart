import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/views/cart_page.dart';
import 'package:shoppinglist_app/views/searchitem_page.dart';
import 'package:shoppinglist_app/views/widgets/items_widget.dart';

class ItemPage extends ConsumerWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = ref.watch(itemProvider);
    final categories = ref.watch(categoryProvider);
    ref.watch(cartProvider);
    final cartCount = ref.read(cartProvider.notifier).cartCounter;
    final selectCategoryId = ref.watch(itemFilterByCategory);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Items',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
                icon: Icon(Icons.shopping_cart_outlined, size: 27),
              ),

              // Number badge
              if (cartCount > 0)
                Positioned(
                  right: 5,
                  top: 3,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cartCount > 99 ? '99+' : cartCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: Column(
            children: [
              // SEARCH
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextField(
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchitemPage(),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for groceries...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.tune),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // CATEGORY
              categories.when(
                data: (data) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return categoryItem(
                            context: context,
                            icon: Icons.grid_view_rounded,
                            name: 'All',
                            selected: selectCategoryId == null,
                            onTap: () {
                              ref.read(itemFilterByCategory.notifier).state =
                                  null;
                            },
                          );
                        }

                        final category = data[index - 1];
                        return categoryItem(
                          context: context,
                          icon: category.iconData,
                          name: category.name,
                          selected: selectCategoryId == category.id,
                          onTap: () {
                            ref.read(itemFilterByCategory.notifier).state =
                                category.id;
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () {
                  return SizedBox(
                    height: 82,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12B76A),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return SizedBox(
                    height: 82,
                    child: Center(child: Text('Cannot load categories')),
                  );
                },
              ),

              SizedBox(height: 15),

              // ITEMS
              Expanded(
                child: items.when(
                  data: (data) {
                    final filteredItems = data.where((item) {
                      if (selectCategoryId == null) {
                        return true;
                      }
                      return item.categoryId == selectCategoryId;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITLE
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Explore Catalog',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),

                            Text(
                              '${filteredItems.length} '
                              '${filteredItems.length == 1 ? 'item' : 'items'}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        if (filteredItems.isEmpty)
                          Expanded(
                            child: Center(
                              child: Text(
                                'No items found',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: filteredItems.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.60,
                                  ),
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return itemCard(
                                  context: context,
                                  ref: ref,
                                  item: item,
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },

                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12B76A),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return const Center(child: Text('Cannot load items'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
