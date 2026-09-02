import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppinglist_app/views/widgets/items_widget.dart';

Widget favoriteHeader({
  required BuildContext context,
  required int itemCount,
  required String selectedFilter,
  required VoidCallback onFilter,
  required VoidCallback onClearFilter,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
    color: isDark ? const Color(0xFF181818) : Colors.white,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$itemCount '
                    '${itemCount == 1 ? 'Item' : 'Items'} Favorited',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade300
                          : const Color(0xFF344054),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Items you saved for later',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark
                          ? Colors.grey.shade500
                          : const Color(0xFF98A2B3),
                    ),
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: onFilter,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selectedFilter != 'All'
                      ? const Color(0xFF12B76A)
                      : isDark
                      ? const Color(0xFF252525)
                      : const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selectedFilter != 'All'
                        ? const Color(0xFF12B76A)
                        : const Color(0xFF12B76A).withValues(alpha: 0.20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_alt_outlined,
                      size: 17,
                      color: selectedFilter != 'All'
                          ? Colors.white
                          : const Color(0xFF079455),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      selectedFilter == 'All'
                          ? 'Filter'
                          : favoriteFilterLabel(selectedFilter),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selectedFilter != 'All'
                            ? Colors.white
                            : const Color(0xFF079455),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (selectedFilter != 'All') ...[
          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF123D2C)
                      : const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      favoriteFilterIcon(selectedFilter),
                      size: 16,
                      color: const Color(0xFF079455),
                    ),
                    SizedBox(width: 5),
                    Text(
                      favoriteFilterLabel(selectedFilter),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF079455),
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: onClearFilter,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Color(0xFF079455),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget favoriteGrid({
  required BuildContext context,
  required WidgetRef ref,
  required List items,
}) {
  return GridView.builder(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 25),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 16,
      childAspectRatio: 0.60,
    ),
    itemBuilder: (context, index) {
      final item = items[index];

      return itemCard(context: context, ref: ref, item: item);
    },
  );
}

Widget favoriteEmptyState({
  required BuildContext context,
  required String filter,
  required VoidCallback onClear,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final isFiltered = filter != 'All';

  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: isFiltered
                  ? const Color(0xFF12B76A).withValues(alpha: 0.10)
                  : const Color(0xFFF04438).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered
                  ? Icons.filter_alt_off_outlined
                  : Icons.favorite_border_rounded,
              size: 48,
              color: isFiltered
                  ? const Color(0xFF12B76A)
                  : const Color(0xFFF04438),
            ),
          ),
          SizedBox(height: 22),
          Text(
            isFiltered ? 'No Favorites Found' : 'No Favorites Yet',
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Text(
            isFiltered
                ? 'No favorite items match this filter.\nTry another filter or show all favorites.'
                : 'Tap the heart icon on an item to save it.\nYour favorite items will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
            ),
          ),

          if (isFiltered) ...[
            SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.restart_alt_rounded, size: 20),
              label: const Text('Show All Favorites'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF12B76A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

void showFavoriteFilterSheet({
  required BuildContext context,
  required WidgetRef ref,
  required StateProvider<String> filterProvider,
  required String currentFilter,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final filters = ['All', 'On Sale', 'Low Price', 'High Price'];

  showModalBottomSheet(
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
            Text(
              'Filter Favorites',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 5),

            Text(
              'Choose how you want to view your saved items.',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
              ),
            ),

            SizedBox(height: 18),

            ...filters.map((filter) {
              final selected = currentFilter == filter;

              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: InkWell(
                  onTap: () {
                    ref.read(filterProvider.notifier).state = filter;

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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF12B76A)
                                : isDark
                                ? const Color(0xFF303030)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            favoriteFilterIcon(filter),
                            size: 20,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF12B76A),
                          ),
                        ),

                        SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            favoriteFilterLabel(filter),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selected ? const Color(0xFF079455) : null,
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

String favoriteFilterLabel(String filter) {
  if (filter == 'Low Price') {
    return 'Low to High';
  }

  if (filter == 'High Price') {
    return 'High to Low';
  }

  if (filter == 'On Sale') {
    return 'On Sale';
  }

  return 'All Favorites';
}

IconData favoriteFilterIcon(String filter) {
  if (filter == 'On Sale') {
    return Icons.local_offer_rounded;
  }
  if (filter == 'Low Price') {
    return Icons.arrow_downward_rounded;
  }
  if (filter == 'High Price') {
    return Icons.arrow_upward_rounded;
  }
  return Icons.favorite_rounded;
}
