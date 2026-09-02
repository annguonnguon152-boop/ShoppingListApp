import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/history_controller.dart';
import 'package:shoppinglist_app/controller/shopping_list_controller.dart';
import 'package:shoppinglist_app/model/shoppinglist_detail_model.dart';
import 'package:shoppinglist_app/model/shoppinglist_model.dart';
import 'package:shoppinglist_app/views/cart_page.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  String search = '';

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final history = ref.watch(historyProvider);

    final historyDetails = ref.watch(historyDetailProvider);

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
          'Purchase History',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF101828),
          ),
        ),
      ),

      body: history.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              searchController.clear();

              setState(() {
                search = '';
              });
              await ref.read(historyProvider.notifier).reloadData();
              await ref.read(historyDetailProvider.notifier).reloadData();
            },

            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                Text(
                  'Review and reorder your past shopping trips.',
                  style: TextStyle(
                    fontSize: 17,
                    color: isDark
                        ? Colors.grey.shade400
                        : const Color(0xFF667085),
                  ),
                ),

                const SizedBox(height: 18),

                historySearchField(
                  context: context,
                  isDark: isDark,
                  controller: searchController,
                  focusNode: searchFocusNode,
                  onChanged: (value) async {
                    setState(() {
                      search = value;
                    });

                    await ref
                        .read(historyProvider.notifier)
                        .searchHistory(value);
                  },
                  onClear: () async {
                    searchController.clear();

                    setState(() {
                      search = '';
                    });

                    await ref.read(historyProvider.notifier).searchHistory('');

                    searchFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: 24),

                if (data.isEmpty)
                  historyEmptyState(
                    isDark: isDark,
                    isSearching: search.trim().isNotEmpty,
                    search: search,
                  )
                else
                  historyDetails.when(
                    data: (detailData) {
                      final grouped = groupHistoryByMonth(data);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF101828),
                                ),
                              ),

                              const SizedBox(height: 10),

                              ...entry.value.map((list) {
                                final details = detailData[list.id!] ?? [];

                                final totalItems = details.fold<int>(0, (
                                  sum,
                                  detail,
                                ) {
                                  return sum + detail.quantity;
                                });

                                final total = details.fold<double>(0.0, (
                                  sum,
                                  detail,
                                ) {
                                  return sum + detail.lineTotal;
                                });

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: historyCard(
                                    context: context,
                                    ref: ref,
                                    isDark: isDark,
                                    list: list,
                                    details: details,
                                    totalItems: totalItems,
                                    total: total,
                                  ),
                                );
                              }),

                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      );
                    },

                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    },

                    error: (error, stack) {
                      return Center(child: Text(error.toString()));
                    },
                  ),
              ],
            ),
          );
        },

        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stack) {
          return Center(child: Text(error.toString()));
        },
      ),
    );
  }
}

Widget historySearchField({
  required BuildContext context,
  required bool isDark,
  required TextEditingController controller,
  required FocusNode focusNode,
  required ValueChanged<String> onChanged,
  required VoidCallback onClear,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: isDark ? const Color(0xFF343434) : const Color(0xFFE4E7EC),
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
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search history...',
        hintStyle: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.grey.shade500 : const Color(0xFF98A2B3),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 20,
          color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, size: 19),
              )
            : Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF12B76A).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: Color(0xFF12B76A),
                ),
              ),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}

Widget historyCard({
  required BuildContext context,
  required WidgetRef ref,
  required bool isDark,
  required ShoppingListModel list,
  required List<ShoppingListDetailModel> details,
  required int totalItems,
  required double total,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? const Color(0xFF343434) : const Color(0xFFE4E7EC),
      ),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.listName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${formatHistoryDate(list.completeDate)}  •  $totalItems ${totalItems == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF101828),
                  ),
                ),

                SizedBox(height: 5),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12B76A).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF079455),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 13),

        Divider(
          height: 1,
          color: isDark ? const Color(0xFF343434) : const Color(0xFFF2F4F7),
        ),

        SizedBox(height: 8),

        Row(
          children: [
            TextButton(
              onPressed: () {
                showHistoryDetails(
                  context: context,
                  isDark: isDark,
                  list: list,
                  details: details,
                  total: total,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: const Color(0xFF027A48),
              ),
              child: Text(
                'View Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),

            const Spacer(),

            OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(
                        'Reuse Shopping List?',
                        style: TextStyle(fontSize: 16),
                      ),
                      content: Text(
                        'Start a new shopping trip using "${list.listName}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('Cancel'),
                        ),

                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF12B76A),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
                          child: const Text('Reuse'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm != true) {
                  return;
                }

                await ref
                    .read(cartProvider.notifier)
                    .reuseShoppingList(list.id!);

                ref.read(editingShoppingListProvider.notifier).state = null;

                if (!context.mounted) {
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CartPage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.replay_rounded, size: 16),
              label: Text('Reuse List', style: TextStyle(fontSize: 15)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF027A48),
                side: const BorderSide(color: Color(0xFFA6F4C5)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showHistoryDetails({
  required BuildContext context,
  required bool isDark,
  required ShoppingListModel list,
  required List<ShoppingListDetailModel> details,
  required double total,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.78,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B76A).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF12B76A),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list.listName,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF101828),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            formatHistoryDate(list.completeDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : const Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Divider(
                  height: 1,
                  color: isDark
                      ? const Color(0xFF343434)
                      : const Color(0xFFE4E7EC),
                ),

                const SizedBox(height: 5),

                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: details.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF343434)
                            : const Color(0xFFF2F4F7),
                      );
                    },
                    itemBuilder: (context, index) {
                      final detail = details[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF12B76A,
                                ).withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 19,
                                color: Color(0xFF12B76A),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.item.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF101828),
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    'Quantity: ${detail.quantity}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : const Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '\$${detail.lineTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF101828),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF292929)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF079455),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget historyEmptyState({
  required bool isDark,
  required bool isSearching,
  required String search,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 70),
    child: Column(
      children: [
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            color: const Color(0xFF12B76A).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSearching ? Icons.search_off_rounded : Icons.history_rounded,
            size: 46,
            color: const Color(0xFF12B76A),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          isSearching ? 'No Results Found' : 'No Purchase History Yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF101828),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          isSearching
              ? 'No completed shopping list matches "$search".'
              : 'Completed shopping trips will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
          ),
        ),
      ],
    ),
  );
}

Map<String, List<ShoppingListModel>> groupHistoryByMonth(
  List<ShoppingListModel> lists,
) {
  final Map<String, List<ShoppingListModel>> grouped = {};

  for (final list in lists) {
    final date = DateTime.tryParse(list.completeDate ?? '');

    if (date == null) {
      continue;
    }

    final key = '${historyMonthName(date.month)} ${date.year}';

    grouped.putIfAbsent(key, () => []);

    grouped[key]!.add(list);
  }

  return grouped;
}

String formatHistoryDate(String? dateString) {
  final date = DateTime.tryParse(dateString ?? '');

  if (date == null) {
    return 'Unknown date';
  }

  return '${historyShortMonth(date.month)} ${date.day}, ${date.year}';
}

String historyMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return months[month - 1];
}

String historyShortMonth(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return months[month - 1];
}
