import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/views/addcategory_page.dart';
import 'package:shoppinglist_app/views/categoryitem_page.dart';
import 'package:shoppinglist_app/views/searchCategory_page.dart';
import 'package:shoppinglist_app/views/widgets/category_widgets.dart';
import 'package:shoppinglist_app/views/widgets/new_category_widget.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final itemCounts = ref.watch(itemCountsByCategoryProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Organise your shopping items.',
                style: TextStyle(fontSize: 17, color: Colors.grey.shade500),
              ),

              SizedBox(height: 20),
              TextField(
                readOnly: true,
                showCursor: false,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchcategoryPage(),
                    ),
                  );

                  ref.read(categoryProvider.notifier).loading();
                },
                decoration: InputDecoration(
                  hintText: 'Search your category...',
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF98A2B3)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF98A2B3)),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Color(0xFFE4E7EC)),
                  ),
                ),
              ),

              SizedBox(height: 25),

              Expanded(
                child: categories.when(
                  data: (data) {
                    return GridView.builder(
                      itemCount: data.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.95,
                      ),

                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return newCategory(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCategoryPage(),
                                ),
                              );
                              ref.read(categoryProvider.notifier).loading();
                            },
                          );
                        }
                        final category = data[index - 1];
                        final count = itemCounts.value?[category.id] ?? 0;
                        return categoryCard(
                          category: category,
                          itemCount: count,
                          onTap: () {
                            ref.read(selectedCategoryProvider.notifier).state =
                                category.id;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryitemPage(category: category),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(child: Text('Error: $error'));
                  },
                  loading: () {
                    return CircularProgressIndicator();
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
