import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/model/category_model.dart';

Widget categoryItemEmpty({
  required BuildContext context,
  required CategoryModel category,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: category.colorData.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(category.iconData, size: 44, color: category.colorData),
          ),
          SizedBox(height: 18),
          Text(
            'No items in ${category.name}',

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF101828),
            ),
          ),

          SizedBox(height: 7),
          Text(
            'Items added to this category will appear here.',
            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
          ),
        ],
      ),
    ),
  );
}

void showCategoryFilterSheet({
  required BuildContext context,
  required WidgetRef ref,
  required int categoryId,
  required String currentFilter,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final filters = ['All', 'Favorite', 'On Sale', 'Low Price', 'High Price'];
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),

        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,

          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF475467)
                      : const Color(0xFFD0D5DD),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 25, color: Color(0xFF12B76A)),

                SizedBox(width: 9),

                Text(
                  'Filter Items',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            SizedBox(height: 6),

            Text(
              'Choose how you want to view items in this category.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
              ),
            ),

            SizedBox(height: 20),
            ...filters.map((filter) {
              final selected = currentFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: InkWell(
                  onTap: () {
                    ref.read(itemFilterProvider(categoryId).notifier).state =
                        filter;

                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(13),

                    decoration: BoxDecoration(
                      color: selected
                          ? isDark
                                ? const Color(0xFF123D2C)
                                : const Color(0xFFE8F8F0)
                          : isDark
                          ? const Color(0xFF252525)
                          : const Color(0xFFF9FAFB),

                      borderRadius: BorderRadius.circular(14),

                      border: Border.all(
                        color: selected
                            ? const Color(0xFF12B76A)
                            : isDark
                            ? const Color(0xFF343434)
                            : const Color(0xFFE4E7EC),
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF12B76A)
                                : isDark
                                ? const Color(0xFF303030)
                                : Colors.white,

                            borderRadius: BorderRadius.circular(11),
                          ),

                          child: Icon(
                            categoryFilterIcon(filter),
                            size: 21,

                            color: selected
                                ? Colors.white
                                : const Color(0xFF12B76A),
                          ),
                        ),

                        SizedBox(width: 13),

                        Expanded(
                          child: Text(
                            categoryFilterLabel(filter),

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,

                              color: selected
                                  ? const Color(0xFF079455)
                                  : isDark
                                  ? Colors.grey.shade200
                                  : const Color(0xFF344054),
                            ),
                          ),
                        ),

                        if (selected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF12B76A),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}

Widget categoryFilterEmpty({
  required BuildContext context,
  required CategoryModel category,
  required String filter,
  required VoidCallback onClear,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: const Color(0xFF12B76A).withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              categoryFilterIcon(filter),
              size: 47,
              color: const Color(0xFF12B76A),
            ),
          ),
          SizedBox(height: 22),
          Text(
            categoryFilterEmptyTitle(filter, category.name),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF101828),
            ),
          ),

          SizedBox(height: 9),

          Text(
            categoryFilterEmptyDescription(filter, category.name),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
            ),
          ),

          SizedBox(height: 24),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: onClear,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF12B76A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Show All Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(width: 7),

                  Icon(Icons.restart_alt_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String categoryFilterLabel(String filter) {
  switch (filter) {
    case 'Favorite':
      return 'Favorites';

    case 'On Sale':
      return 'On Sale';

    case 'Low Price':
      return 'Price: Low to High';

    case 'High Price':
      return 'Price: High to Low';

    default:
      return 'All Items';
  }
}

String categoryFilterShortLabel(String filter) {
  switch (filter) {
    case 'Favorite':
      return 'Favorites';

    case 'On Sale':
      return 'On Sale';

    case 'Low Price':
      return 'Low Price';

    case 'High Price':
      return 'High Price';

    default:
      return 'Filter';
  }
}

IconData categoryFilterIcon(String filter) {
  switch (filter) {
    case 'Favorite':
      return Icons.favorite_rounded;

    case 'On Sale':
      return Icons.local_offer_rounded;

    case 'Low Price':
      return Icons.arrow_downward_rounded;

    case 'High Price':
      return Icons.arrow_upward_rounded;

    default:
      return Icons.grid_view_rounded;
  }
}

String categoryFilterEmptyTitle(String filter, String categoryName) {
  switch (filter) {
    case 'Favorite':
      return 'No Favorites in $categoryName';

    case 'On Sale':
      return 'No Sale Items in $categoryName';

    case 'Low Price':
    case 'High Price':
      return 'No Items to Sort';

    default:
      return 'No Items Found';
  }
}

String categoryFilterEmptyDescription(String filter, String categoryName) {
  switch (filter) {
    case 'Favorite':
      return 'You don\'t have any favorite items in $categoryName yet.\n'
          'Tap the heart icon on an item to save it.';

    case 'On Sale':
      return 'There are currently no discounted items in $categoryName.\n'
          'Try showing all items instead.';

    case 'Low Price':
    case 'High Price':
      return 'There are no items available in $categoryName to sort by price.';

    default:
      return 'No items match the selected filter.';
  }
}
