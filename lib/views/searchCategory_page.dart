import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/views/widgets/category_widgets.dart';

class SearchcategoryPage extends ConsumerWidget {
  const SearchcategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFF8F9FB),

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
                  SizedBox(width: 45),

                  Text(
                    'Search Category',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
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
                  fillColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 206, 204, 204),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 72, 227, 77),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: categories.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(
                            fontSize: 20,
                            color: isDark ? Colors.grey.shade400 :Colors.grey.shade700,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final category = data[index];
                        return categoryCard(category: category, itemCount: 0);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(child: Text('Error: $error'));
                  },
                  loading: () {
                    return Center(child: CircularProgressIndicator());
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
