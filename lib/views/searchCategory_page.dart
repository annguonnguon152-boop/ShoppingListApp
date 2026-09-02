import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/views/categoryitem_page.dart';
import 'package:shoppinglist_app/views/widgets/category_widgets.dart';

class SearchcategoryPage extends ConsumerWidget {
  const SearchcategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final itemCounts = ref.watch(itemCountsByCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Search Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Balance back button
                  const SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                autofocus: true,
                onChanged: (value) {
                  ref.read(categoryProvider.notifier).searchCategory(value);
                },

                decoration: InputDecoration(
                  hintText: 'Search your category...',

                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 21,
                    color: Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),

                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF343434)
                          : const Color(0xFFCECCCC),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),

                    borderSide: const BorderSide(
                      color: Color(0xFF12B76A),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // CATEGORY RESULT
              Expanded(
                child: categories.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return _noCategoryFound(context);
                    }

                    return GridView.builder(
                      itemCount: data.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.95,
                          ),

                      itemBuilder: (context, index) {
                        // NO index - 1
                        final category = data[index];

                        final count = itemCounts.value?[category.id] ?? 0;

                        return categoryCard(
                          category: category,
                          itemCount: count,

                          onTap: () {
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12B76A),
                      ),
                    );
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

Widget _noCategoryFound(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF12B76A).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.search_off_rounded,
            size: 46,
            color: Color(0xFF12B76A),
          ),
        ),

        SizedBox(height: 20),

        Text(
          'No Category Found',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),

        SizedBox(height: 8),

        Text(
          'Try searching with another category name.',
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
          ),
        ),
      ],
    ),
  );
}
