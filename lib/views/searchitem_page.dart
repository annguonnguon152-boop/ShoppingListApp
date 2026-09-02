import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/searchitem_controller.dart';
import 'package:shoppinglist_app/controller/tags_controller.dart';
import 'package:shoppinglist_app/views/widgets/items_widget.dart';

class SearchitemPage extends ConsumerStatefulWidget {
  const SearchitemPage({super.key});

  @override
  ConsumerState<SearchitemPage> createState() => _SearchitemPageState();
}

class _SearchitemPageState extends ConsumerState<SearchitemPage> {
  final TextEditingController searchController = TextEditingController();

  String search = '';

  String selectedFilter = 'All';
  String selectedTag = 'All';

  final List<String> filters = [
    'All',
    'Favorite',
    'On Sale',
    'Low Price',
    'High Price',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = ref.watch(searchItemProvider);
    final tags = ref.watch(itemTagsProvider);
    final controller = ref.read(searchItemProvider.notifier);
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF7F9FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: isDark ? const Color(0xFF181818) : Colors.white,
        title: Text(
          'Search Items',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181818) : Colors.white,

              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF303030)
                      : const Color(0xFFE4E7EC),
                ),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SEARCH + FILTER
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,

                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF242424)
                              : const Color(0xFFF8FAFC),

                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: search.isNotEmpty
                                ? const Color(0xFF12B76A)
                                : isDark
                                ? const Color(0xFF3A3A3A)
                                : const Color(0xFFD0D5DD),
                          ),
                        ),

                        child: TextField(
                          controller: searchController,

                          onChanged: (value) {
                            setState(() {
                              search = value;
                              selectedFilter = 'All';
                              selectedTag = 'All';
                            });

                            controller.searchItem(value);
                          },

                          decoration: InputDecoration(
                            hintText: 'Search items...',

                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF12B76A),
                            ),

                            suffixIcon: search.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      searchController.clear();

                                      setState(() {
                                        search = '';
                                      });

                                      controller.showAll();
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),

                            border: InputBorder.none,

                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    // FILTER BUTTON
                    InkWell(
                      onTap: () {
                        _showFilter(context, controller);
                      },

                      borderRadius: BorderRadius.circular(15),

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),

                        width: 52,
                        height: 52,

                        decoration: BoxDecoration(
                          color: selectedFilter != 'All'
                              ? const Color(0xFF12B76A)
                              : isDark
                              ? const Color(0xFF242424)
                              : Colors.white,

                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(
                            color: selectedFilter != 'All'
                                ? const Color(0xFF12B76A)
                                : isDark
                                ? const Color(0xFF3A3A3A)
                                : const Color(0xFFD0D5DD),
                          ),

                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),

                        child: Icon(
                          Icons.tune_rounded,

                          color: selectedFilter != 'All'
                              ? Colors.white
                              : const Color(0xFF12B76A),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                // TAG TITLE
                Row(
                  children: [
                    Icon(
                      Icons.sell_outlined,
                      size: 19,
                      color: Color(0xFF12B76A),
                    ),

                    SizedBox(width: 6),

                    Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Spacer(),

                    if (selectedTag != 'All')
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTag = 'All';
                          });

                          controller.showAll();
                        },

                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF12B76A),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 10),
                tags.when(
                  data: (data) {
                    final tagList = ['All', ...data];

                    return SizedBox(
                      height: 40,

                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,

                        itemCount: tagList.length,

                        separatorBuilder: (context, index) {
                          return SizedBox(width: 8);
                        },

                        itemBuilder: (context, index) {
                          final tag = tagList[index];

                          final selected = selectedTag == tag;

                          return InkWell(
                            onTap: () {
                              searchController.clear();
                              setState(() {
                                search = '';
                                selectedFilter = 'All';
                                selectedTag = tag;
                              });
                              if (tag == 'All') {
                                controller.showAll();
                              } else {
                                controller.filterTag(tag);
                              }
                            },

                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF12B76A)
                                    : isDark
                                    ? const Color(0xFF242424)
                                    : const Color(0xFFF8FAFC),

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF12B76A)
                                      : isDark
                                      ? const Color(0xFF3A3A3A)
                                      : const Color(0xFFE4E7EC),
                                ),

                                boxShadow: selected && !isDark
                                    ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF12B76A,
                                          ).withValues(alpha: 0.18),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,

                                  color: selected
                                      ? Colors.white
                                      : isDark
                                      ? Colors.grey.shade300
                                      : const Color(0xFF475467),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },

                  loading: () {
                    return const SizedBox(
                      height: 40,
                      child: Center(child: LinearProgressIndicator()),
                    );
                  },

                  error: (error, stack) {
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),

          // result
          Expanded(
            child: items.when(
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },

              error: (error, stack) {
                return Center(child: Text('$error'));
              },

              data: (data) {
                if (data.isEmpty) {
                  return _emptyResult(context);
                }
                return ListView(
                  padding: const EdgeInsets.all(15),

                  children: [
                    Row(
                      children: [
                        Text(
                          _resultTitle(),

                          style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF242424)
                                : const Color(0xFFE8F8F0),

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Text(
                            '${data.length} items',

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF12B76A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),

                      itemBuilder: (context, index) {
                        final item = data[index];
                        return itemCard(context: context, ref: ref, item: item);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilter(BuildContext context, SearchItemNotifier controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Text(
                'Filter Items',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 5),
              Text(
                'Choose how you want to view your items',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark
                      ? Colors.grey.shade400
                      : const Color(0xFF667085),
                ),
              ),
              SizedBox(height: 18),
              ...filters.map((filter) {
                final selected = selectedFilter == filter;

                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    searchController.clear();
                    setState(() {
                      search = '';
                      selectedTag = 'All';
                      selectedFilter = filter;
                    });

                    if (filter == 'All') {
                      controller.showAll();
                    } else {
                      controller.filterItem(filter);
                    }
                  },

                  borderRadius: BorderRadius.circular(14),

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),

                    decoration: BoxDecoration(
                      color: selected
                          ? isDark
                                ? const Color(0xFF123D2C)
                                : const Color(0xFFE8F8F0)
                          : Colors.transparent,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          _filterIcon(filter),

                          color: selected
                              ? const Color(0xFF12B76A)
                              : isDark
                              ? Colors.grey.shade300
                              : const Color(0xFF475467),
                        ),

                        SizedBox(width: 13),

                        Expanded(
                          child: Text(
                            filter,

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,

                              color: selected ? const Color(0xFF12B76A) : null,
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
                );
              }),
            ],
          ),
        );
      },
    );
  }

  IconData _filterIcon(String filter) {
    if (filter == 'Favorite') {
      return Icons.favorite_outline;
    }

    if (filter == 'On Sale') {
      return Icons.local_offer_outlined;
    }

    if (filter == 'Low Price') {
      return Icons.south_rounded;
    }

    if (filter == 'High Price') {
      return Icons.north_rounded;
    }

    return Icons.apps_rounded;
  }

  String _resultTitle() {
    if (search.isNotEmpty) {
      return 'Search Results';
    }

    if (selectedFilter != 'All') {
      return selectedFilter;
    }

    if (selectedTag != 'All') {
      return selectedTag;
    }

    return 'All Items';
  }

  Widget _emptyResult(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

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
              'No Items Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 7),
            Text(
              'Try another search, filter, or tag.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
