import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/model/category_model.dart';
import 'package:shoppinglist_app/views/widgets/categoryitem_widget.dart';
import 'package:shoppinglist_app/views/widgets/items_widget.dart';

class CategoryitemPage extends ConsumerWidget {
  final CategoryModel category;
  const CategoryitemPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryId = category.id!;
    final filter = ref.watch(itemFilterProvider(categoryId));
    final data = ref.watch(itemByCategoryProvider(categoryId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 21,
            color: isDark ? Colors.white : const Color(0xFF475467),
          ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF079455),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE4E7EC),
          ),
        ),
      ),
      body: data.when(
        data: (data) {
          if (data.isEmpty && filter == "All") {
            return categoryItemEmpty(context: context, category: category);
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 17, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Showing ${data.length} '
                                  '${data.length == 1 ? 'item' : 'items'} in ',
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : const Color(0xFF667085),
                              ),
                            ),

                            TextSpan(
                              text: category.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF079455),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    InkWell(
                      onTap: () {
                        showCategoryFilterSheet(
                          context: context,
                          ref: ref,
                          categoryId: categoryId,
                          currentFilter: filter,
                        );
                      },
                      borderRadius: BorderRadius.circular(22),

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),

                        decoration: BoxDecoration(
                          color: filter != 'All'
                              ? const Color(0xFF12B76A)
                              : isDark
                              ? const Color(0xFF252525)
                              : Colors.white,

                          borderRadius: BorderRadius.circular(22),

                          border: Border.all(
                            color: filter != 'All'
                                ? const Color(0xFF12B76A)
                                : isDark
                                ? const Color(0xFF3A3A3C)
                                : const Color(0xFFD0D5DD),
                          ),

                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryFilterIcon(filter),
                              size: 17,
                              color: filter != 'All'
                                  ? Colors.white
                                  : isDark
                                  ? Colors.grey.shade300
                                  : const Color(0xFF667085),
                            ),
                            SizedBox(width: 6),
                            Text(
                              filter == 'All'
                                  ? 'Filter'
                                  : categoryFilterShortLabel(filter),

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: filter != 'All'
                                    ? Colors.white
                                    : isDark
                                    ? Colors.grey.shade300
                                    : const Color(0xFF475467),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (data.isEmpty && filter != 'All')
                Expanded(
                  child: categoryFilterEmpty(
                    context: context,
                    category: category,
                    filter: filter,

                    onClear: () {
                      ref.read(itemFilterProvider(categoryId).notifier).state =
                          'All';
                    },
                  ),
                )
              // ITEMS
              else
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),

                    itemCount: data.length,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.60,
                    ),

                    itemBuilder: (context, index) {
                      final item = data[index];

                      return itemCard(context: context, ref: ref, item: item);
                    },
                  ),
                ),
            ],
          );
        },

        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF079455)),
          );
        },
      ),
    );
  }
}
