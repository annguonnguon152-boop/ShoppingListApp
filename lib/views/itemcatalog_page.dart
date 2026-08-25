import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/views/searchitem_page.dart';
import 'package:shoppinglist_app/views/widgets/catalogitem_widget.dart';

class ItemcatalogPage extends ConsumerWidget {
  const ItemcatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = ref.watch(itemProvider);
    final categories = ref.watch(categoryProvider);
    final selectCategoryId = ref.watch(selectedCategoryProvider);
    return Scaffold(
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
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
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
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
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
                            ref.read(selectedCategoryProvider.notifier).state =
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
                              '${filteredItems.length} items',
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
                                    childAspectRatio: 0.66,
                                  ),
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return catalogItemCard(
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
