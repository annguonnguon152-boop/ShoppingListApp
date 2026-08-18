import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/views/widgets/category_widgets.dart';

import '../controller/category_controller.dart';
import '../model/category_model.dart';

class AddCategoryPage extends ConsumerStatefulWidget {
  const AddCategoryPage({super.key});

  @override
  ConsumerState<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final TextEditingController nameController = TextEditingController();

  String selectedIcon = 'food';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFF8F9FB),
        foregroundColor: isDark
            ? Colors.white
            : const Color.fromARGB(255, 21, 22, 21),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'New Category',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.grey.shade300
                      : Color.fromARGB(255, 19, 176, 106),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,

                style: TextStyle(color: isDark ? Colors.white : Colors.black),

                decoration: InputDecoration(
                  hintText: 'Food',
                  hintStyle: TextStyle(
                    color: isDark ? Color(0xFF8E8E8E) : Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Color.fromARGB(255, 27, 26, 26)
                          : Color(0xFFD0D5DD),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF12B76A),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25),

              Text(
                'Choose Icon',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.grey.shade300
                      : Color.fromARGB(255, 19, 176, 106),
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  itemCount: categoryIcons.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),

                  itemBuilder: (context, index) {
                    final entry = categoryIcons.entries.elementAt(index);

                    final isSelected = selectedIcon == entry.key;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIcon = entry.key;
                        });
                      },

                      borderRadius: BorderRadius.circular(15),

                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? isDark
                                    ? Color(0xFF123D2C)
                                    : Color(0xFFE8F8EF)
                              : isDark
                              ? Color(0xFF1E1E1E)
                              : Colors.white,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF12B76A)
                                : isDark
                                ? Color(0xFF333333)
                                : Color(0xFFE4E7EC),

                            width: isSelected ? 3 : 2,
                          ),
                        ),

                        child: Icon(
                          entry.value,
                          size: 25,

                          color: isSelected
                              ? Color(0xFF12B76A)
                              : isDark
                              ? Color(0xFFA3A3A3)
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF12B76A),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter category name'),
                        ),
                      );
                      return;
                    }

                    final category = CategoryModel(
                      name: name,
                      icon: selectedIcon,
                    );

                    await ref
                        .read(categoryProvider.notifier)
                        .insertCategory(category);

                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },

                  child: Text(
                    'Add Category',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
